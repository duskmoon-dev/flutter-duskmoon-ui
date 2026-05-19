import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart';

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
  final TextEditingController _textController =
      TextEditingController(text: 'Hello from Controller!');

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
    _displayManager.connectedDisplaysChangedStream?.listen((event) {
      if (widget.displayId == 0) _checkDisplays();
    });

    const bridge = MethodChannel('dev.duskmoon.duo_screen/bridge');
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
    const bridge = MethodChannel('dev.duskmoon.duo_screen/bridge');
    bridge
        .invokeMethod('updateConfig', jsonEncode(config.toJson()))
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      displayId: widget.displayId,
      duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
      useDrawer: false,
      appBar: widget.displayId == 0
          ? DmAppBar(
              title: const Text('Main Viewer'),
              backgroundColor: _currentColor.withValues(alpha: 0.2),
            )
          : DmAppBar(
              title: const Text('Controller Panel'),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
            ),
      body: (_) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Display: ${widget.displayId} | ${MediaQuery.sizeOf(context).width.toInt()}x${MediaQuery.sizeOf(context).height.toInt()}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 24),
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
                size: 80,
                color: _currentColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _selectedIndex == 0 ? "HOME MODE" : "SETTINGS MODE",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (widget.displayId == 0)
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(_statusText),
                ),
              ),
          ],
        ),
      ),
      secondaryBody: (_) => SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Config',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Screen Text',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _syncToOther(),
            ),
            const SizedBox(height: 24),
            Text('Theme Colors:',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ColorButton(
                    color: Colors.blue,
                    onTap: () {
                      setState(() => _currentColor = Colors.blue);
                      _syncToOther();
                    }),
                _ColorButton(
                    color: Colors.red,
                    onTap: () {
                      setState(() => _currentColor = Colors.red);
                      _syncToOther();
                    }),
                _ColorButton(
                    color: Colors.green,
                    onTap: () {
                      setState(() => _currentColor = Colors.green);
                      _syncToOther();
                    }),
                _ColorButton(
                    color: Colors.orange,
                    onTap: () {
                      setState(() => _currentColor = Colors.orange);
                      _syncToOther();
                    }),
              ],
            ),
          ],
        ),
      ),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        NavigationDestination(icon: Icon(Icons.tune), label: 'Config'),
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
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
