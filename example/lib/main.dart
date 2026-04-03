import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/button_page.dart';
import 'pages/feedback_page.dart';
import 'pages/form_page.dart';
import 'pages/markdown_page.dart';
import 'pages/scaffold_page.dart';
import 'pages/settings_page.dart';
import 'pages/theme_page.dart';
import 'pages/visualization_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(DuskmoonShowcaseApp(prefs: prefs));
}

class DuskmoonShowcaseApp extends StatelessWidget {
  const DuskmoonShowcaseApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return DuskmoonApp(
      child: BlocProvider(
        create: (_) => DmThemeBloc(prefs: prefs),
        child: BlocBuilder<DmThemeBloc, DmThemeState>(
          builder: (context, state) {
            final entry = state.entry;
            return MaterialApp(
              title: 'DuskMoon UI Showcase',
              theme: entry.light,
              darkTheme: entry.dark,
              themeMode: state.themeMode,
              scaffoldMessengerKey: dmScaffoldMessengerKey,
              home: const ShowcaseHome(),
            );
          },
        ),
      ),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({super.key});

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    ThemePage(),
    FormPage(),
    ButtonPage(),
    SettingsPage(),
    FeedbackPage(),
    ScaffoldPage(),
    VisualizationPage(),
    MarkdownPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: DmBottomNav(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          DmNavDestination(icon: Icon(Icons.palette), label: 'Theme'),
          DmNavDestination(
              icon: Icon(Icons.dynamic_form_outlined), label: 'Form'),
          DmNavDestination(icon: Icon(Icons.smart_button), label: 'Buttons'),
          DmNavDestination(icon: Icon(Icons.settings), label: 'Settings'),
          DmNavDestination(icon: Icon(Icons.feedback), label: 'Feedback'),
          DmNavDestination(icon: Icon(Icons.dashboard), label: 'Scaffold'),
          DmNavDestination(
              icon: Icon(Icons.show_chart), label: 'Visualization'),
          DmNavDestination(icon: Icon(Icons.edit_document), label: 'Markdown'),
        ],
      ),
    );
  }
}
