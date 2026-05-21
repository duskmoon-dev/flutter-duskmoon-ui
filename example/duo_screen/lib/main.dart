import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:presentation_displays/display.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart' hide DmCodeEditor;
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

// --- Shared Communication Bridge ---
const String channelId = 'dev.duskmoon.duo_screen/bridge';

void main() {
  runApp(const DuoScreenApp(displayId: 0));
}

@pragma('vm:entry-point')
void secondaryDisplayMain() {
  runApp(const DuoScreenApp(displayId: 1));
}

// --- Data Model for Synchronization ---
class AppState {
  final int selectedIndex;
  final String message;
  final bool isViewerOnly;

  AppState({
    required this.selectedIndex,
    required this.message,
    required this.isViewerOnly,
  });

  Map<String, dynamic> toJson() => {
        'selectedIndex': selectedIndex,
        'message': message,
        'isViewerOnly': isViewerOnly,
      };

  factory AppState.fromJson(Map<String, dynamic> json) => AppState(
        selectedIndex: json['selectedIndex'] as int,
        message: json['message'] as String,
        isViewerOnly: json['isViewerOnly'] as bool,
      );
}

class DuoScreenApp extends StatelessWidget {
  final int displayId;
  const DuoScreenApp({super.key, required this.displayId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DuskMoon Duo',
      theme: DmThemeData.sunshine(),
      darkTheme: DmThemeData.moonlight(),
      home: SharedDuoScaffold(displayId: displayId),
    );
  }
}

class SharedDuoScaffold extends StatefulWidget {
  final int displayId;
  const SharedDuoScaffold({super.key, required this.displayId});

  @override
  State<SharedDuoScaffold> createState() => _SharedDuoScaffoldState();
}

class _SharedDuoScaffoldState extends State<SharedDuoScaffold> {
  final _displayManager = DisplayManager();
  List<Display> _displays = [];

  // Isolate Communication
  final ReceivePort _receivePort = ReceivePort();
  SendPort? _otherPort;

  // Shared State
  int _selectedIndex = 0;
  String _message = "Welcome to DuskMoon Duo!";
  bool _isViewerOnly = false;
  final TextEditingController _textController =
      TextEditingController(text: 'Welcome to DuskMoon Duo!');

  @override
  void initState() {
    super.initState();
    _setupBridge();
    if (widget.displayId == 0) {
      _checkDisplays();
    }
  }

  @override
  void dispose() {
    _receivePort.close();
    _textController.dispose();
    super.dispose();
  }

  void _setupBridge() {
    if (widget.displayId == 0) {
      IsolateNameServer.removePortNameMapping('primary_display_port');
      IsolateNameServer.registerPortWithName(
          _receivePort.sendPort, 'primary_display_port');

      _receivePort.listen((message) {
        if (message is SendPort) {
          _otherPort = message;
          _syncToOther();
        } else if (message is String) {
          _applySync(message);
        }
      });

      _displayManager.connectedDisplaysChangedStream?.listen((event) {
        _checkDisplays();
      });
    } else {
      _otherPort = IsolateNameServer.lookupPortByName('primary_display_port');
      _otherPort?.send(_receivePort.sendPort);

      _receivePort.listen((message) {
        if (message is String) {
          _applySync(message);
        }
      });
    }
  }

  void _applySync(String message) {
    final json = jsonDecode(message);
    final newState = AppState.fromJson(json);
    setState(() {
      _selectedIndex = newState.selectedIndex;
      _message = newState.message;
      _isViewerOnly = newState.isViewerOnly;
      if (_textController.text != newState.message) {
        _textController.text = newState.message;
      }
    });
  }

  Future<void> _checkDisplays() async {
    final displays = await _displayManager.getDisplays();
    setState(() {
      _displays = displays ?? [];
    });

    if (_displays.length > 1) {
      final secondary = _displays.where((d) => d.displayId != 0).toList();
      if (secondary.isNotEmpty) {
        secondary.sort((a, b) => b.displayId!.compareTo(a.displayId!));
        await _displayManager.showSecondaryDisplay(
          displayId: secondary.first.displayId!,
          routerName: "secondaryDisplayMain",
        );
      }
    }
  }

  void _updateAndSync(int index, {String? message, bool? isViewerOnly}) {
    setState(() {
      _selectedIndex = index;
      if (message != null) _message = message;
      if (isViewerOnly != null) _isViewerOnly = isViewerOnly;
    });
    _syncToOther();
  }

  void _syncToOther() {
    final state = AppState(
      selectedIndex: _selectedIndex,
      message: _message,
      isViewerOnly: _isViewerOnly,
    );
    if (widget.displayId == 1) {
      _otherPort ??= IsolateNameServer.lookupPortByName('primary_display_port');
    }
    _otherPort?.send(jsonEncode(state.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    final bool isDuoModeActive = _displays.length > 1 || widget.displayId > 0;

    return DmAdaptiveScaffold(
      displayId: widget.displayId,
      duoScreenPolicy: isDuoModeActive
          ? DuoScreenPolicy.navigationOnSecondary
          : DuoScreenPolicy.splitBody,
      useDrawer: false,
      appBar: widget.displayId == 0
          ? DmAppBar(
              title: Text(_isViewerOnly ? 'Viewer Console' : 'DuskMoon Viewer'),
            )
          : DmAppBar(
              title: const Text('Controller Panel'),
              automaticallyImplyLeading: false,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
      body: (_) =>
          _isViewerOnly ? _buildViewerMode(context) : _buildMainContent(context),
      secondaryBody: (_) => _buildControllerContent(context),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.palette), label: 'Widgets'),
        NavigationDestination(icon: Icon(Icons.edit_note), label: 'Forms'),
        NavigationDestination(icon: Icon(Icons.insights), label: 'Charts'),
        NavigationDestination(icon: Icon(Icons.code), label: 'Editor'),
      ],
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (index) => _updateAndSync(index),
    );
  }

  Widget _buildViewerMode(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.dashboard_customize, size: 80, color: Colors.blue),
          const SizedBox(height: 24),
          Text('System Dashboard',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(
              'Navigation: ${['Widgets', 'Forms', 'Charts', 'Editor'][_selectedIndex]}',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 32),
          DmCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child:
                  Text(_message, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IndexedStack(
            index: _selectedIndex,
            alignment: Alignment.topCenter,
            children: [
              _WidgetsShowcase(message: _message),
              const _FormsShowcase(),
              const _ChartsShowcase(),
              const _EditorShowcase(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControllerContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category: ${['Widgets', 'Forms', 'Charts', 'Editor'][_selectedIndex]}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Switch(
                value: _isViewerOnly,
                onChanged: (val) =>
                    _updateAndSync(_selectedIndex, isViewerOnly: val),
              ),
            ],
          ),
          const Divider(height: 48),
          IndexedStack(
            index: _selectedIndex,
            children: [
              // Widgets Controller
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Update Viewer Text:',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type something...',
                    ),
                    onChanged: (val) =>
                        _updateAndSync(_selectedIndex, message: val),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 8,
                    children: [
                      DmButton(
                        onPressed: () => showDmSuccessToast(
                          context: context,
                          message: 'Action completed!',
                          title: 'Controller Input',
                        ),
                        child: const Text('Fire Toast'),
                      ),
                    ],
                  ),
                ],
              ),
              // Forms Controller
              const Column(
                children: [
                  DmCard(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                          'DuskMoon Form components are now active on the primary display.'),
                    ),
                  ),
                ],
              ),
              // Charts Controller
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visual Config:',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 16),
                  const DmCard(
                    child: ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text('Randomize Data'),
                    ),
                  ),
                ],
              ),
              // Editor Controller
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Language Selection:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      DmChip(label: Text('Dart')),
                      DmChip(label: Text('Flutter')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WidgetsShowcase extends StatelessWidget {
  final String message;
  const _WidgetsShowcase({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center),
        const SizedBox(height: 48),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            const DmBadge(label: 'Duo', child: Icon(Icons.devices, size: 40)),
            DmButton(onPressed: () {}, child: const Text('Primary')),
            DmButton(
                variant: DmButtonVariant.tonal,
                onPressed: () {},
                child: const Text('Tonal')),
            DmButton(
                variant: DmButtonVariant.outlined,
                onPressed: () {},
                child: const Text('Outline')),
          ],
        ),
      ],
    );
  }
}

class _FormsShowcase extends StatelessWidget {
  const _FormsShowcase();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('DuskMoon Form', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        DmCard(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const DmTextField(
                  placeholder: 'Project Name',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Text('Enable Synchronization')),
                    DmSwitch(value: true, onChanged: (_) {}),
                  ],
                ),
                const SizedBox(height: 24),
                DmButton(
                    onPressed: () {}, child: const Text('Save Configuration')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartsShowcase extends StatelessWidget {
  const _ChartsShowcase();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Visualization', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        SizedBox(
          height: 250,
          child: DmVizLineChart(
            data: const [
              DmVizPoint(x: 0, y: 10),
              DmVizPoint(x: 1, y: 25),
              DmVizPoint(x: 2, y: 18),
              DmVizPoint(x: 3, y: 40),
              DmVizPoint(x: 4, y: 32),
            ],
            xAxisLabel: 'Time',
            yAxisLabel: 'Value',
          ),
        ),
      ],
    );
  }
}

class _EditorShowcase extends StatelessWidget {
  const _EditorShowcase();
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Distributed Editor',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 24),
        SizedBox(
          height: 400,
          child: DmCodeEditor(
            initialDoc: """void main() {
  print("Hello from DuskMoon Duo!");
  // The secondary screen acts as your
  // command center while this display
  // renders the code and execution.
}""",
          ),
        ),
      ],
    );
  }
}
