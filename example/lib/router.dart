import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/button/button_screen.dart';
import 'screens/code_editor/code_editor_screen.dart';
import 'screens/feedback/feedback_screen.dart';
import 'screens/form/form_screen.dart';
import 'screens/markdown/markdown_screen.dart';
import 'screens/scaffold/scaffold_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/theme/theme_screen.dart';
import 'screens/visualization/visualization_screen.dart';
import 'screens/widgets/widgets_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>(
    debugLabel: 'routerKey',
  );

  static GoRouter router = GoRouter(
    navigatorKey: key,
    initialLocation: ThemeScreen.path,
    routes: routes,
  );

  static List<GoRoute> routes = [
    GoRoute(
      name: ThemeScreen.name,
      path: ThemeScreen.path,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const ThemeScreen(),
      ),
    ),
    GoRoute(
      name: WidgetsScreen.name,
      path: WidgetsScreen.path,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const WidgetsScreen(),
      ),
    ),
    GoRoute(
      name: FormScreen.name,
      path: FormScreen.path,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const FormScreen(),
      ),
    ),
    GoRoute(
      name: SettingsScreen.name,
      path: SettingsScreen.path,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      name: VisualizationScreen.name,
      path: VisualizationScreen.path,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const VisualizationScreen(),
      ),
    ),
    // Widget sub-screens (pushed from WidgetsScreen)
    GoRoute(
      name: ButtonScreen.name,
      path: ButtonScreen.path,
      pageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: const ButtonScreen(),
      ),
    ),
    GoRoute(
      name: FeedbackScreen.name,
      path: FeedbackScreen.path,
      pageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: const FeedbackScreen(),
      ),
    ),
    GoRoute(
      name: ScaffoldScreen.name,
      path: ScaffoldScreen.path,
      pageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: const ScaffoldScreen(),
      ),
    ),
    GoRoute(
      name: MarkdownScreen.name,
      path: MarkdownScreen.path,
      pageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: const MarkdownScreen(),
      ),
    ),
    GoRoute(
      name: CodeEditorScreen.name,
      path: CodeEditorScreen.path,
      pageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: const CodeEditorScreen(),
      ),
    ),
  ];
}
