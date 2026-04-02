import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:example/main.dart';
import 'package:example/pages/visualization/chart_gallery_page.dart';
import 'package:example/pages/visualization/geo_map_page.dart';
import 'package:example/pages/visualization/interactive_chart_page.dart';
import 'package:example/pages/visualization_page.dart';

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

      expect(find.text('Curated Charts'), findsOneWidget);
      expect(find.text('Geo Projection Lab'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Interactive Hover Demo'),
        300,
      );
      expect(find.text('Interactive Hover Demo'), findsOneWidget);
    });

    testWidgets('visualization module page renders migrated cards', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: VisualizationPage()));
      await tester.pumpAndSettle();

      expect(find.text('Curated Charts'), findsOneWidget);
      expect(find.text('Geo Projection Lab'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Interactive Hover Demo'),
        300,
      );
      expect(find.text('Interactive Hover Demo'), findsOneWidget);
    });

    testWidgets('chart gallery screen builds', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ChartGalleryPage()));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Curated Charts'), findsOneWidget);
      expect(find.text('Line chart'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Network graph'), 300);
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
