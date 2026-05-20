import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:presentation_displays/display.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart';

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

  AppState({required this.selectedIndex, required this.message});

  Map<String, dynamic> toJson() => {
        'selectedIndex': selectedIndex,
        'message': message,
      };

  factory AppState.fromJson(Map<String, dynamic> json) => AppState(
        selectedIndex: json['selectedIndex'] as int,
        message: json['message'] as String,
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

  void _updateAndSync(int index, {String? message}) {
    setState(() {
      _selectedIndex = index;
      if (message != null) _message = message;
    });
    _syncToOther();
  }

  void _syncToOther() {
    final state = AppState(selectedIndex: _selectedIndex, message: _message);
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
          ? DmAppBar(title: const Text('DuskMoon Viewer'))
          : DmAppBar(
              title: const Text('Controller Panel'),
              automaticallyImplyLeading: false,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
      // --- THE MAIN VIEW (Renders only on Display 0) ---
      body: (_) => _buildMainContent(context),
      // --- THE CONTROLLER VIEW (Renders only on Display 1+) ---
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

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Display: ${widget.displayId} | ${MediaQuery.sizeOf(context).width.toInt()}x${MediaQuery.sizeOf(context).height.toInt()}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 24),
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
          Text(
            'Category: ${['Widgets', 'Forms', 'Charts', 'Editor'][_selectedIndex]}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Interaction engine for display ${widget.displayId}',
            style: Theme.of(context).textTheme.labelSmall,
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
                  Text('Action Shortcuts:',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      DmButton(
                        onPressed: () => showDmSuccessToast(
                          context: context,
                          message: 'Sent from secondary display!',
                          title: 'Action Triggered',
                        ),
                        child: const Text('Send Toast'),
                      ),
                    ],
                  ),
                ],
              ),
              // Forms Controller
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DmCard(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                          'In a real app, this screen would hold the form labels, instructions, or validation errors while the primary screen holds the fields.'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  DmButton(
                    onPressed: () => showDmDialog(
                      context: context,
                      title: const Text('Form Submitted'),
                      content: const Text(
                          'The data from the primary screen has been processed.'),
                    ),
                    child: const Text('Process Form Content'),
                  ),
                ],
              ),
              // Charts Controller
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter Data View:',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 16),
                  const DmCard(
                    child: ListTile(
                      leading: Icon(Icons.show_chart),
                      title: Text('Toggle Trend Lines'),
                      trailing: Switch(value: true, onChanged: null),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const DmCard(
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Time Range: Last 7 Days'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
              // Editor Controller
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Editor Settings:',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 16),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      DmChip(label: Text('Dart')),
                      DmChip(label: Text('Python')),
                      DmChip(label: Text('JavaScript')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const DmCard(
                    child: ListTile(
                      leading: Icon(Icons.color_lens),
                      title: Text('Theme: Monokai Dark'),
                    ),
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

// --- SUB-PAGES FOR SHOWCASE ---

class _WidgetsShowcase extends StatelessWidget {
  final String message;
  const _WidgetsShowcase({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            const DmBadge(
              label: 'Live',
              child: Icon(Icons.sensors, size: 40, color: Colors.red),
            ),
            DmButton(onPressed: () {}, child: const Text('Primary')),
            DmButton(
              variant: DmButtonVariant.tonal,
              onPressed: () {},
              child: const Text('Tonal'),
            ),
            DmButton(
              variant: DmButtonVariant.outlined,
              onPressed: () {},
              child: const Text('Outline'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(),
      ],
    );
  }
}

class _FormsShowcase extends StatelessWidget {
  const _FormsShowcase();
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Active Form Context',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 24),
        DmCard(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Remote Data Field',
                    hintText: 'Controlled by Display 1',
                    prefixIcon: Icon(Icons.storage),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Status Label',
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                ),
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
        const Text('Real-time Metrics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
          ),
          child: const Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bar_chart, size: 64, color: Colors.blue),
              Text('Rendering High-Performance DmViz...'),
            ],
          )),
        ),
      ],
    );
  }
}

class _EditorShowcase extends StatelessWidget {
  const _EditorShowcase();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Distributed Code Editor',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Container(
          height: 350,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5), blurRadius: 10)
            ],
          ),
          child: const Text(
            '// DuskMoon Code Engine\n// Multi-Display Sync Active\n\nvoid main() {\n  var display = getActiveDisplay();\n  print("Running on \$display");\n}',
            style: TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'monospace',
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
