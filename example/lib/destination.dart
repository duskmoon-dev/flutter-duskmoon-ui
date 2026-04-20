import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'platform_style_state.dart' show PlatformSwitchAction;

import 'screens/chat/chat_screen.dart';
import 'screens/form/form_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/theme/theme_screen.dart';
import 'screens/visualization/visualization_screen.dart';
import 'screens/widgets/widgets_screen.dart';

class Destinations {
  static const List<String> routeNames = [
    ThemeScreen.name,
    WidgetsScreen.name,
    FormScreen.name,
    ChatScreen.name,
    SettingsScreen.name,
    VisualizationScreen.name,
  ];

  static const List<NavigationDestination> navs = [
    NavigationDestination(
      key: Key(ThemeScreen.name),
      icon: Icon(Icons.palette),
      label: 'Theme',
    ),
    NavigationDestination(
      key: Key(WidgetsScreen.name),
      icon: Icon(Icons.widgets_outlined),
      label: 'Widgets',
    ),
    NavigationDestination(
      key: Key(FormScreen.name),
      icon: Icon(Icons.dynamic_form_outlined),
      label: 'Form',
    ),
    NavigationDestination(
      key: Key(ChatScreen.name),
      icon: Icon(Icons.chat_outlined),
      label: 'Chat',
    ),
    NavigationDestination(
      key: Key(SettingsScreen.name),
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
    NavigationDestination(
      key: Key(VisualizationScreen.name),
      icon: Icon(Icons.show_chart),
      label: 'Visualization',
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
