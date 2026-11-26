import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show FontLoader;

import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Exercise the workspace preview renderer without a package dependency cycle.
// ignore: avoid_relative_lib_imports
import '../../../example/design_preview/lib/screens/visualization/contract_fixture_chart.dart';

void main() {
  var root = Directory.current;
  while (!Directory('${root.path}/specs/visualization/v1').existsSync()) {
    if (root.parent.path == root.path) {
      throw StateError('Missing contract snapshot');
    }
    root = root.parent;
  }
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final bytes = File(
      '${root.path}/example/design_preview/fonts/NotoSansMath-Regular.ttf',
    ).readAsBytesSync();
    final loader = FontLoader('ChartGolden')
      ..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
    final cjk = File(
      '${root.path}/packages/duskmoon_visualization/test/goldens/fonts/chart-cjk.otf',
    ).readAsBytesSync();
    final fallback = FontLoader('ChartGoldenCjk')
      ..addFont(Future.value(ByteData.sublistView(cjk)));
    await fallback.load();
  });
  for (final (name, theme, size, columns) in [
    ('sunshine-wide', DmTheme.sunshine, const Size(1000, 1260), 2),
    ('moonlight-narrow', DmTheme.moonlight, const Size(390, 2410), 1),
  ]) {
    testWidgets(name, (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final json = File(
        '${root.path}/example/design_preview/assets/visualization/charts.json',
      ).readAsStringSync();
      final charts = (jsonDecode(json) as Map<String, dynamic>).values.toList();
      final colors = theme.colors.colorScheme;
      const golden = Key('fixture-chart-goldens');
      await tester.pumpWidget(
        MaterialApp(
          theme: DmThemeData.fromDmTheme(theme).copyWith(
            textTheme: DmThemeData.fromDmTheme(theme).textTheme.apply(
              fontFamily: 'ChartGolden',
              fontFamilyFallback: ['ChartGoldenCjk'],
            ),
          ),
          home: RepaintBoundary(
            key: golden,
            child: ColoredBox(
              color: colors.surface,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final chart in charts)
                      SizedBox(
                        width: (size.width - 16 - (columns - 1) * 8) / columns,
                        height: 384,
                        child: contractFixtureChart(
                          chart as Map<String, dynamic>,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(golden),
        matchesGoldenFile('goldens/$name.png'),
      );
    });
  }
}
