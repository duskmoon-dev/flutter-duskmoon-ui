import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart';

// --- Shared Communication Bridge ---
const String channelId = 'dev.duskmoon.duo_screen/bridge';
const MethodChannel bridge = MethodChannel(channelId);

void main() {
  runApp(const DuoScreenExampleApp());
}

@pragma('vm:entry-point')
void secondaryDisplayMain() {
  runApp(const SecondaryDisplayControllerApp());
}

// --- Data Model ---
class AppConfig {
  final int selectedIndex;
  final Color themeColor;
  final String statusText;

  AppConfig({
    required this.selectedIndex,
    required this.themeColor,
    required this.statusText,
  });

  Map<String, dynamic> toJson() => {
    'selectedIndex': selectedIndex,
    'themeColor': themeColor.toARGB32(),
    'statusText': statusText,
  };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    selectedIndex: json['selectedIndex'] as int,
    themeColor: Color(json['themeColor'] as int),
    statusText: json['statusText'] as String,
  );
}

// --- Primary Display: THE VIEWER ---
class DuoScreenExampleApp extends StatelessWidget {
  const DuoScreenExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Viewer (Primary)',
      theme: DmThemeData.sunshine(),
      darkTheme: DmThemeData.moonlight(),
      home: const MainViewerScreen(),
    );
  }
}

class MainViewerScreen extends StatefulWidget {
  const MainViewerScreen({super.key});

  @override
  State<MainViewerScreen> createState() => _MainViewerScreenState();
}

class _MainViewerScreenState extends State<MainViewerScreen> {
  final _displayManager = DisplayManager();
  AppConfig _config = AppConfig(
    selectedIndex: 0,
    themeColor: Colors.blue,
    statusText: 'Waiting for Controller...',
  );

  @override
  void initState() {
    super.initState();
    _setupBridge();
    _checkDisplays();
  }

  void _setupBridge() {
    bridge.setMethodCallHandler((call) async {
      if (call.method == 'updateConfig') {
        final json = jsonDecode(call.arguments as String);
        setState(() {
          _config = AppConfig.fromJson(json);
        });
      }
    });
  }

  Future<void> _checkDisplays() async {
    final displays = await _displayManager.getDisplays();
    if (displays != null && displays.length > 1) {
      final secondary = displays.where((d) => d.displayId != 0).toList();
      if (secondary.isNotEmpty) {
        secondary.sort((a, b) => b.displayId!.compareTo(a.displayId!));
        // Auto-launch controller on secondary display
        await _displayManager.showSecondaryDisplay(
          displayId: secondary.first.displayId!,
          routerName: "secondaryDisplayMain",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DmAppBar(
        title: const Text('Viewer (Main Screen)'),
        backgroundColor: _config.themeColor.withValues(alpha: 0.2),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: _config.themeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: _config.themeColor, width: 4),
              ),
              child: Icon(
                _config.selectedIndex == 0 ? Icons.home : Icons.settings,
                size: 120,
                color: _config.themeColor,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Current Mode: ${_config.selectedIndex == 0 ? "Home" : "Settings"}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Text(
                  _config.statusText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Secondary Display: THE CONTROLLER (has Nav Rail) ---
class SecondaryDisplayControllerApp extends StatelessWidget {
  const SecondaryDisplayControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controller (Secondary)',
      theme: DmThemeData.sunshine(),
      darkTheme: DmThemeData.moonlight(),
      home: const ControllerScreen(),
    );
  }
}

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  int _selectedIndex = 0;
  Color _currentColor = Colors.blue;
  final TextEditingController _textController = TextEditingController(
    text: 'Hello from Controller!',
  );

  void _syncToViewer() {
    final config = AppConfig(
      selectedIndex: _selectedIndex,
      themeColor: _currentColor,
      statusText: _textController.text,
    );
    bridge.invokeMethod('updateConfig', jsonEncode(config.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      // We force NavRail on this screen by providing destinations
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard), label: 'Control'),
        NavigationDestination(icon: Icon(Icons.palette), label: 'Appearance'),
      ],
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (index) {
        setState(() {
          _selectedIndex = index;
        });
        _syncToViewer();
      },
      appBar: DmAppBar(
        title: const Text('Controller (Second Screen)'),
        automaticallyImplyLeading: false,
      ),
      body: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menu & Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Message to Main Screen',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _syncToViewer(),
            ),
            const SizedBox(height: 32),
            Text(
              'Quick Theme Actions:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                _ColorButton(
                  color: Colors.blue,
                  onTap: () {
                    setState(() => _currentColor = Colors.blue);
                    _syncToViewer();
                  },
                ),
                _ColorButton(
                  color: Colors.red,
                  onTap: () {
                    setState(() => _currentColor = Colors.red);
                    _syncToViewer();
                  },
                ),
                _ColorButton(
                  color: Colors.green,
                  onTap: () {
                    setState(() => _currentColor = Colors.green);
                    _syncToViewer();
                  },
                ),
                _ColorButton(
                  color: Colors.orange,
                  onTap: () {
                    setState(() => _currentColor = Colors.orange);
                    _syncToViewer();
                  },
                ),
              ],
            ),
            const Spacer(),
            const Center(
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  'Interacting here updates the Main Screen instantly',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _ColorButton({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}
