import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_theme/duskmoon_theme.dart';

void main() {
  group('DmPlatformOverride', () {
    testWidgets('maybeOf returns null when no override in context',
        (tester) async {
      DmPlatformStyle? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                result = DmPlatformOverride.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(result, isNull);
    });

    testWidgets('maybeOf returns style when override present', (tester) async {
      DmPlatformStyle? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmPlatformOverride(
              style: DmPlatformStyle.cupertino,
              child: Builder(
                builder: (context) {
                  result = DmPlatformOverride.maybeOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );
      expect(result, DmPlatformStyle.cupertino);
    });

    testWidgets(
        'override forces resolvePlatformStyle to return overridden style',
        (tester) async {
      // Use an Android theme but override to cupertino.
      DmPlatformStyle? resolved;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmPlatformOverride(
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
  });
}
