import 'package:flutter/material.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:presentation_displays/display.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart';

void main() {
  runApp(const DuoScreenExampleApp());
}

@pragma('vm:entry-point')
void secondaryDisplayMain() {
  runApp(const SecondaryDisplayApp());
}

class DuoScreenExampleApp extends StatelessWidget {
  const DuoScreenExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duo Screen App',
      theme: DmThemeData.sunshine(),
      darkTheme: DmThemeData.moonlight(),
      home: const MainScreen(),
    );
  }
}

class SecondaryDisplayApp extends StatelessWidget {
  const SecondaryDisplayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secondary Display',
      theme: DmThemeData.sunshine(),
      darkTheme: DmThemeData.moonlight(),
      home: Scaffold(
        body: Container(
          color: Colors.blue.withValues(alpha: 0.1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.devices_fold,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Secondary Screen',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Running on a separate Flutter Engine via Presentation API',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _presentationDisplays = DisplayManager();
  List<Display> _displays = [];
  Display? _selectedDisplay;

  @override
  void initState() {
    super.initState();
    _checkDisplays();
    _presentationDisplays.connectedDisplaysChangedStream?.listen((event) {
      _checkDisplays();
    });
  }

  Future<void> _checkDisplays() async {
    final displays = await _presentationDisplays.getDisplays();
    print("DEBUG: Detected displays: ${displays?.map((d) => 'ID: ${d.displayId}, Name: ${d.name}').toList()}");
    setState(() {
      _displays = displays ?? [];
      if (_displays.length > 1) {
        // Find the display with the highest ID, as newly added overlays get higher IDs
        final secondaryDisplays = _displays.where((d) => d.displayId != 0).toList();
        if (secondaryDisplays.isNotEmpty) {
          secondaryDisplays.sort((a, b) => b.displayId!.compareTo(a.displayId!));
          _selectedDisplay = secondaryDisplays.first;
        }
        print("DEBUG: Selected secondary display ID: ${_selectedDisplay?.displayId}");
      } else {
        _selectedDisplay = null;
        print("DEBUG: No secondary display selected");
      }
    });
  }

  Future<void> _showOnSecondary() async {
    if (_selectedDisplay != null) {
      print("DEBUG: Showing presentation on display ID: ${_selectedDisplay!.displayId}");
      await _presentationDisplays.showSecondaryDisplay(
        displayId: _selectedDisplay!.displayId!,
        routerName: "secondaryDisplayMain", // The Dart entry point for the new engine
      );
    }
  }

  Future<void> _hideFromSecondary() async {
    if (_selectedDisplay != null) {
      await _presentationDisplays.hideSecondaryDisplay(
        displayId: _selectedDisplay!.displayId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      appBar: DmAppBar(
        title: const Text('Primary Display'),
      ),
      body: (_) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Displays Found: ${_displays.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (_selectedDisplay != null) ...[
              Text('Secondary Display ID: ${_selectedDisplay!.displayId}'),
              const SizedBox(height: 16),
              DmButton(
                onPressed: _showOnSecondary,
                child: const Text('Show on Secondary Display'),
              ),
              const SizedBox(height: 8),
              DmButton(
                onPressed: _hideFromSecondary,
                child: const Text('Hide from Secondary Display'),
              ),
            ] else
              const Text(
                'No secondary display detected.\nConnect a monitor or run on a true dual-screen device.',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.devices), label: 'Displays'),
      ],
      selectedIndex: 0,
      onSelectedIndexChange: (_) {},
    );
  }
}
