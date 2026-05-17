import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:example/main.dart';
import 'package:example/router.dart';
import 'package:example/screens/button/button_screen.dart';
import 'package:example/screens/chat/chat_screen.dart';
import 'package:example/screens/code_editor/code_editor_screen.dart';
import 'package:example/screens/feedback/feedback_screen.dart';
import 'package:example/screens/markdown/markdown_screen.dart';
import 'package:example/screens/scaffold/scaffold_screen.dart';
import 'package:example/screens/visualization/chart_gallery_page.dart';
import 'package:example/screens/visualization/geo_map_page.dart';
import 'package:example/screens/visualization/interactive_chart_page.dart';
import 'package:example/screens/visualization/visualization_screen.dart';
import 'package:example/screens/widgets/widgets_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  GoRouter buildRouter(String initialLocation) => GoRouter(
        initialLocation: initialLocation,
        routes: AppRouter.routes,
      );

  group('widgets module', () {
    testWidgets('widgets screen renders menu items', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: buildRouter(WidgetsScreen.path)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Buttons & Inputs'), findsOneWidget);
      expect(find.text('Feedback'), findsOneWidget);
      expect(find.text('Scaffold & Layout'), findsOneWidget);
      expect(find.text('Markdown'), findsOneWidget);
      expect(find.text('Code Editor'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
    });

    testWidgets('buttons screen builds via GoRouter', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(
            '${WidgetsScreen.path}/${ButtonScreen.path}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(AppBar, 'Buttons & Inputs'),
        findsOneWidget,
      );
    });

    testWidgets('feedback screen builds via GoRouter', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(
            '${WidgetsScreen.path}/${FeedbackScreen.path}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Feedback'), findsOneWidget);
    });

    testWidgets('scaffold screen builds via GoRouter', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(
            '${WidgetsScreen.path}/${ScaffoldScreen.path}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(AppBar, 'Scaffold & Layout'),
        findsOneWidget,
      );
    });

    testWidgets('markdown screen builds via GoRouter', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(
            '${WidgetsScreen.path}/${MarkdownScreen.path}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Markdown'), findsOneWidget);
    });

    testWidgets('code editor screen builds via GoRouter', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(
            '${WidgetsScreen.path}/${CodeEditorScreen.path}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Code Editor'), findsOneWidget);
    });

    testWidgets('chat screen builds via GoRouter', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(
            '${WidgetsScreen.path}/${ChatScreen.path}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Chat'), findsOneWidget);
      expect(find.text('Model not ready'), findsOneWidget);
      expect(find.text('Demo: Mixed blocks'), findsOneWidget);
      expect(find.byTooltip('Attach'), findsOneWidget);
      expect(find.text('User'), findsWidgets);
      expect(find.text('Assistant'), findsWidgets);

      await tester.tap(find.text('Demo: Mixed blocks'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('50-round history').last);
      await tester.pumpAndSettle();

      expect(find.text('Demo: 50-round history'), findsOneWidget);
      expect(find.text('round-50-summary.csv'), findsOneWidget);
      expect(find.text('search_docs'), findsOneWidget);
    });
  });

  group('visualization module', () {
    testWidgets('showcase nav reaches visualization module', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(DuskmoonShowcaseApp(prefs: prefs));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Visualization'));
      await tester.pumpAndSettle();

      expect(find.text('DmViz Charts'), findsOneWidget);

      final listScrollable = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(
        find.text('Geographic'),
        300,
        scrollable: listScrollable,
      );
      expect(find.text('Geographic'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Interactions & Utilities'),
        300,
        scrollable: listScrollable,
      );
      expect(find.text('Interactions & Utilities'), findsOneWidget);
    });

    testWidgets('visualization module page renders migrated cards', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(VisualizationScreen.path),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('DmViz Charts'), findsOneWidget);

      final listScrollable = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(
        find.text('Geographic'),
        300,
        scrollable: listScrollable,
      );
      expect(find.text('Geographic'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Interactions & Utilities'),
        300,
        scrollable: listScrollable,
      );
      expect(find.text('Interactions & Utilities'), findsOneWidget);
    });

    testWidgets('card navigates to chart gallery via GoRouter', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(VisualizationScreen.path),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open module').first);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Curated Charts'), findsOneWidget);
    });

    testWidgets('chart gallery screen builds', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(
            '${VisualizationScreen.path}/${ChartGalleryPage.path}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Curated Charts'), findsOneWidget);
      expect(find.text('Line chart'), findsOneWidget);
      final listScrollable = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(
        find.text('Network graph'),
        300,
        scrollable: listScrollable,
      );
      expect(find.text('Network graph'), findsOneWidget);
    });

    testWidgets('geo map screen builds', (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(
            '${VisualizationScreen.path}/${GeoMapPage.path}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Geo Projection Lab'), findsOneWidget);
      expect(find.text('Projection'), findsOneWidget);
      expect(find.textContaining('Tap a country'), findsOneWidget);
    });

    testWidgets('interactive chart screen builds', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(
            '${VisualizationScreen.path}/${InteractiveChartPage.path}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(AppBar, 'Interactive Hover Demo'),
        findsOneWidget,
      );
      expect(find.text('Demand signal explorer'), findsOneWidget);
      expect(
          find.textContaining('Hover or drag across the plot'), findsOneWidget);
    });
  });
}
