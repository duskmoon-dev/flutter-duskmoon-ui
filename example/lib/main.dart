import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/button_page.dart';
import 'pages/code_editor_page.dart';
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

  static const _destinations = <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.palette), label: 'Theme'),
    NavigationDestination(
        icon: Icon(Icons.dynamic_form_outlined), label: 'Form'),
    NavigationDestination(icon: Icon(Icons.smart_button), label: 'Buttons'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
    NavigationDestination(icon: Icon(Icons.feedback), label: 'Feedback'),
    NavigationDestination(icon: Icon(Icons.dashboard), label: 'Scaffold'),
    NavigationDestination(icon: Icon(Icons.show_chart), label: 'Visualization'),
    NavigationDestination(
        icon: Icon(Icons.edit_document), label: 'Markdown'),
    NavigationDestination(icon: Icon(Icons.code), label: 'Code Editor'),
  ];

  static const _pages = <Widget>[
    ThemePage(),
    FormPage(),
    ButtonPage(),
    SettingsPage(),
    FeedbackPage(),
    ScaffoldPage(),
    VisualizationPage(),
    MarkdownPage(),
    CodeEditorPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DmScaffold(
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),
      destinations: _destinations,
      useDrawer: true,
      appBar: const DmAppBar(title: Text('DuskMoon UI Showcase')),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => _pages[_selectedIndex],
    );
  }
}
