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

    testWidgets('returns material for Windows', (tester) async {
      late DmPlatformStyle resolved;
      await tester.pumpWidget(buildApp(
        platform: TargetPlatform.windows,
        onResolved: (s) => resolved = s,
      ));
      expect(resolved, DmPlatformStyle.material);
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
  });
}
