import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:example/main.dart';
import 'package:example/screens/visualization/chart_gallery_page.dart';
import 'package:example/screens/visualization/geo_map_page.dart';
import 'package:example/screens/visualization/interactive_chart_page.dart';
import 'package:example/screens/visualization/visualization_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const VisualizationScreen(),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
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

    testWidgets('chart gallery screen builds', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ChartGalleryPage()));
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

      await tester.pumpWidget(const MaterialApp(home: GeoMapPage()));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Geo Projection Lab'), findsOneWidget);
      expect(find.text('Projection'), findsOneWidget);
      expect(find.textContaining('Tap a country'), findsOneWidget);
    });

    testWidgets('interactive chart screen builds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: InteractiveChartPage()),
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
