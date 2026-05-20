import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:presentation_displays/display.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart';

// --- Shared Communication Bridge ---
const String channelId = 'dev.duskmoon.duo_screen/bridge';
const MethodChannel bridge = MethodChannel(channelId);

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

  // Shared State
  int _selectedIndex = 0;
  String _message = "Welcome to DuskMoon Duo!";

  @override
  void initState() {
    super.initState();
    _setupBridge();
    if (widget.displayId == 0) {
      _checkDisplays();
    }
  }

  void _setupBridge() {
    _displayManager.connectedDisplaysChangedStream?.listen((event) {
      if (widget.displayId == 0) _checkDisplays();
    });

    bridge.setMethodCallHandler((call) async {
      if (call.method == 'syncState') {
        final json = jsonDecode(call.arguments as String);
        final newState = AppState.fromJson(json);
        setState(() {
          _selectedIndex = newState.selectedIndex;
          _message = newState.message;
        });
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
    final state = AppState(selectedIndex: _selectedIndex, message: _message);
    bridge
        .invokeMethod('syncState', jsonEncode(state.toJson()))
        .catchError((_) {});
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
              title: const Text('Controller'),
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
            ),
      // --- CONTENT ENGINE (Body) ---
      body: (_) => _buildMainContent(context),
      // --- CONTROL ENGINE (Secondary Body) ---
      secondaryBody: (_) => _buildControllerContent(context),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.palette), label: 'Widgets'),
        NavigationDestination(icon: Icon(Icons.edit_note), label: 'Forms'),
        NavigationDestination(icon: Icon(Icons.insights), label: 'Charts'),
        NavigationDestination(icon: Icon(Icons.code), label: 'Editor'),
      ],
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (val) => _updateAndSync(val),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Active Display: ${widget.displayId}',
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
            'Interactive Controls',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const DmCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This panel controls the main display content using DuskMoon components.',
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Update Viewer Text:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Type something...',
            ),
            onChanged: (val) => _updateAndSync(_selectedIndex, message: val),
          ),
          const SizedBox(height: 32),
          Text(
            'Action Shortcuts:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              DmButton(
                onPressed: () => showDmSuccessToast(
                  context: context,
                  message: 'Action completed on primary display',
                  title: 'Success',
                ),
                child: const Text('Toast'),
              ),
              DmButton(
                variant: DmButtonVariant.outlined,
                onPressed: () => showDmDialog(
                  context: context,
                  title: const Text('Duo Dialog'),
                  content: const Text('Interactive dialog from controller'),
                ),
                child: const Text('Dialog'),
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
              label: 'New',
              child: Icon(Icons.notifications, size: 40),
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
            DmButton(
              variant: DmButtonVariant.text,
              onPressed: () {},
              child: const Text('Ghost'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 24),
            CircularProgressIndicator.adaptive(),
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
    return const Column(
      children: [
        Text(
          'BLoC Forms',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24),
        DmCard(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 24),
                DmButton(onPressed: null, child: Text('Submit Form')),
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
        const Text(
          'Data Visualization',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: const Center(child: Text('DmVizLineChart Placeholder')),
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
        const Text(
          'Code Engine',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '// DuskMoon Code Engine\nvoid main() {\n  print("Hello Duo Display!");\n}',
            style: TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}
