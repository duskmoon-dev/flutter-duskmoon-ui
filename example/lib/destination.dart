import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'platform_style_state.dart' show PlatformSwitchAction;

import 'screens/button/button_screen.dart';
import 'screens/code_editor/code_editor_screen.dart';
import 'screens/feedback/feedback_screen.dart';
import 'screens/form/form_screen.dart';
import 'screens/markdown/markdown_screen.dart';
import 'screens/scaffold/scaffold_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/theme/theme_screen.dart';
import 'screens/visualization/visualization_screen.dart';

class Destinations {
  static const List<String> routeNames = [
    ThemeScreen.name,
    FormScreen.name,
    ButtonScreen.name,
    SettingsScreen.name,
    FeedbackScreen.name,
    ScaffoldScreen.name,
    VisualizationScreen.name,
    MarkdownScreen.name,
    CodeEditorScreen.name,
  ];

  static const List<NavigationDestination> navs = [
    NavigationDestination(
      key: Key(ThemeScreen.name),
      icon: Icon(Icons.palette),
      label: 'Theme',
    ),
    NavigationDestination(
      key: Key(FormScreen.name),
      icon: Icon(Icons.dynamic_form_outlined),
      label: 'Form',
    ),
    NavigationDestination(
      key: Key(ButtonScreen.name),
      icon: Icon(Icons.smart_button),
      label: 'Buttons',
    ),
    NavigationDestination(
      key: Key(SettingsScreen.name),
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
    NavigationDestination(
      key: Key(FeedbackScreen.name),
      icon: Icon(Icons.feedback),
      label: 'Feedback',
    ),
    NavigationDestination(
      key: Key(ScaffoldScreen.name),
      icon: Icon(Icons.dashboard),
      label: 'Scaffold',
    ),
    NavigationDestination(
      key: Key(VisualizationScreen.name),
      icon: Icon(Icons.show_chart),
      label: 'Visualization',
    ),
    NavigationDestination(
      key: Key(MarkdownScreen.name),
      icon: Icon(Icons.edit_document),
      label: 'Markdown',
    ),
    NavigationDestination(
      key: Key(CodeEditorScreen.name),
      icon: Icon(Icons.code),
      label: 'Code Editor',
    ),
  ];

  static int indexOf(Key key) {
    return navs.indexWhere((element) => element.key == key);
  }

  static void changeHandler(int idx, BuildContext context) {
    if (idx >= 0 && idx < routeNames.length) {
      context.goNamed(routeNames[idx]);
    }
  }
}
