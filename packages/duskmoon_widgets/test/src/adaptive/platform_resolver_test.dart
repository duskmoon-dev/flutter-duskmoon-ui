import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('resolvePlatformStyle', () {
    Widget buildApp({
      required TargetPlatform platform,
      required ValueSetter<DmPlatformStyle> onResolved,
      DmPlatformStyle? widgetOverride,
    }) {
      return MaterialApp(
        theme: ThemeData(platform: platform),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final style = resolvePlatformStyle(
                context,
                widgetOverride: widgetOverride,
              );
              onResolved(style);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    }

    testWidgets('returns material for Android', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(buildApp(
        platform: TargetPlatform.android,
        onResolved: (s) => resolved = s,
      ));
      expect(resolved, DmPlatformStyle.material);
    });

    testWidgets('returns cupertino for iOS', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(buildApp(
        platform: TargetPlatform.iOS,
        onResolved: (s) => resolved = s,
      ));
      expect(resolved, DmPlatformStyle.cupertino);
    });

    testWidgets('returns cupertino for macOS', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(buildApp(
        platform: TargetPlatform.macOS,
        onResolved: (s) => resolved = s,
      ));
      expect(resolved, DmPlatformStyle.cupertino);
    });

    testWidgets('returns fluent for Windows', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(buildApp(
        platform: TargetPlatform.windows,
        onResolved: (s) => resolved = s,
      ));
      expect(resolved, DmPlatformStyle.fluent);
    });

    testWidgets('widget override takes precedence over theme', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(buildApp(
        platform: TargetPlatform.android,
        widgetOverride: DmPlatformStyle.cupertino,
        onResolved: (s) => resolved = s,
      ));
      expect(resolved, DmPlatformStyle.cupertino);
    });

    testWidgets('DmPlatformOverride beats theme platform', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: DmPlatformOverride(
            style: DmPlatformStyle.cupertino,
            child: Builder(
              builder: (context) {
                resolved = resolvePlatformStyle(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(resolved, DmPlatformStyle.cupertino);
    });

    testWidgets('DuskmoonApp L3 beats theme platform default', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(
        DuskmoonApp(
          platformStyle: DmPlatformStyle.fluent,
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Builder(
              builder: (context) {
                resolved = resolvePlatformStyle(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(resolved, DmPlatformStyle.fluent);
    });

    testWidgets('DmPlatformOverride beats DuskmoonApp', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(
        DuskmoonApp(
          platformStyle: DmPlatformStyle.fluent,
          child: MaterialApp(
            home: DmPlatformOverride(
              style: DmPlatformStyle.cupertino,
              child: Builder(
                builder: (context) {
                  resolved = resolvePlatformStyle(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );
      expect(resolved, DmPlatformStyle.cupertino);
    });

    testWidgets('widget override beats DuskmoonApp', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(
        DuskmoonApp(
          platformStyle: DmPlatformStyle.fluent,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = resolvePlatformStyle(
                  context,
                  widgetOverride: DmPlatformStyle.material,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(resolved, DmPlatformStyle.material);
    });

    testWidgets(
        'DuskmoonApp with null platformStyle falls through to platform default',
        (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(
        DuskmoonApp(
          platformStyle: null,
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                resolved = resolvePlatformStyle(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(resolved, DmPlatformStyle.cupertino);
    });
  });
}
