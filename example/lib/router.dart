import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/button/button_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/code_editor/code_editor_screen.dart';
import 'screens/feedback/feedback_screen.dart';
import 'screens/form/form_screen.dart';
import 'screens/markdown/markdown_screen.dart';
import 'screens/scaffold/scaffold_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/theme/theme_screen.dart';
import 'screens/visualization/chart_gallery_page.dart';
import 'screens/visualization/geo_gallery_page.dart';
import 'screens/visualization/geo_map_page.dart';
import 'screens/visualization/interactive_chart_page.dart';
import 'screens/visualization/interactions_page.dart';
import 'screens/visualization/lines_bars_page.dart';
import 'screens/visualization/radial_page.dart';
import 'screens/visualization/scatter_network_page.dart';
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
      routes: [
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
        GoRoute(
          name: ChatScreen.name,
          path: ChatScreen.path,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const ChatScreen(),
          ),
        ),
      ],
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
      routes: [
        GoRoute(
          name: ChartGalleryPage.name,
          path: ChartGalleryPage.path,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const ChartGalleryPage(),
          ),
        ),
        GoRoute(
          name: LinesBarsPage.name,
          path: LinesBarsPage.path,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const LinesBarsPage(),
          ),
        ),
        GoRoute(
          name: RadialPage.name,
          path: RadialPage.path,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const RadialPage(),
          ),
        ),
        GoRoute(
          name: ScatterNetworkPage.name,
          path: ScatterNetworkPage.path,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const ScatterNetworkPage(),
          ),
        ),
        GoRoute(
          name: GeoGalleryPage.name,
          path: GeoGalleryPage.path,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const GeoGalleryPage(),
          ),
        ),
        GoRoute(
          name: GeoMapPage.name,
          path: GeoMapPage.path,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const GeoMapPage(),
          ),
        ),
        GoRoute(
          name: InteractionsPage.name,
          path: InteractionsPage.path,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const InteractionsPage(),
          ),
        ),
        GoRoute(
          name: InteractiveChartPage.name,
          path: InteractiveChartPage.path,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const InteractiveChartPage(),
          ),
        ),
      ],
    ),
  ];
}
