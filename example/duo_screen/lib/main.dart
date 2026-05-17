import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presentation_displays/displays_manager.dart';
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

class DuoScreenApp extends StatelessWidget {
  final int displayId;
  const DuoScreenApp({super.key, required this.displayId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: displayId == 0 ? 'Viewer' : 'Controller',
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
  final TextEditingController _textController = TextEditingController(
    text: 'Hello from Controller!',
  );

  // Current State
  int _selectedIndex = 0;
  Color _currentColor = Colors.blue;
  String _statusText = 'Waiting for interaction...';

  @override
  void initState() {
    super.initState();
    _setupBridge();
    if (widget.displayId == 0) {
      _checkDisplays();
    }
  }

  void _setupBridge() {
    bridge.setMethodCallHandler((call) async {
      if (call.method == 'updateConfig') {
        final json = jsonDecode(call.arguments as String);
        final config = AppConfig.fromJson(json);
        setState(() {
          _selectedIndex = config.selectedIndex;
          _currentColor = config.themeColor;
          _statusText = config.statusText;
          _textController.text = config.statusText;
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
        await _displayManager.showSecondaryDisplay(
          displayId: secondary.first.displayId!,
          routerName: "secondaryDisplayMain",
        );
      }
    }
  }

  void _syncToOther() {
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
      displayId: widget.displayId,
      duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
      appBar: DmAppBar(
        title: Text(widget.displayId == 0 ? 'Main Viewer' : 'Controller'),
        backgroundColor: _currentColor.withValues(alpha: 0.2),
        automaticallyImplyLeading: false,
      ),
      // --- THE MAIN VIEW (Renders only on Display 0) ---
      body: (_) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: _currentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: _currentColor, width: 4),
              ),
              child: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.settings,
                size: 120,
                color: _currentColor,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Current Mode: ${_selectedIndex == 0 ? "Home" : "Settings"}',
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
                  _statusText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
      // --- THE CONTROLLER VIEW (Renders only on Display 1+) ---
      secondaryBody: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive Menu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Update Main Screen Text',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _syncToOther(),
            ),
            const SizedBox(height: 32),
            Text(
              'Quick Theme Colors:',
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
                    _syncToOther();
                  },
                ),
                _ColorButton(
                  color: Colors.red,
                  onTap: () {
                    setState(() => _currentColor = Colors.red);
                    _syncToOther();
                  },
                ),
                _ColorButton(
                  color: Colors.green,
                  onTap: () {
                    setState(() => _currentColor = Colors.green);
                    _syncToOther();
                  },
                ),
                _ColorButton(
                  color: Colors.orange,
                  onTap: () {
                    setState(() => _currentColor = Colors.orange);
                    _syncToOther();
                  },
                ),
              ],
            ),
            const Spacer(),
            const Opacity(
              opacity: 0.5,
              child: Text(
                'This Controller UI is only visible on the second screen.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        NavigationDestination(icon: Icon(Icons.tune), label: 'Settings'),
      ],
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (index) {
        setState(() {
          _selectedIndex = index;
        });
        _syncToOther();
      },
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
