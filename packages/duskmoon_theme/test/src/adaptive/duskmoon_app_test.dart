import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';

void main() {
  group('DuskmoonApp', () {
    testWidgets('maybeStyleOf returns null when no DuskmoonApp in tree',
        (tester) async {
      late DmPlatformStyle? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = DuskmoonApp.maybeStyleOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(result, isNull);
    });

    testWidgets('maybeStyleOf returns platformStyle when DuskmoonApp present',
        (tester) async {
      late DmPlatformStyle? result;
      await tester.pumpWidget(
        DuskmoonApp(
          platformStyle: DmPlatformStyle.cupertino,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = DuskmoonApp.maybeStyleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(result, DmPlatformStyle.cupertino);
    });

    testWidgets('maybeStyleOf returns null when platformStyle is null',
        (tester) async {
      late DmPlatformStyle? result;
      await tester.pumpWidget(
        DuskmoonApp(
          platformStyle: null,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = DuskmoonApp.maybeStyleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(result, isNull);
    });

    testWidgets('updateShouldNotify: rebuilds when platformStyle changes',
        (tester) async {
      Widget buildApp(DmPlatformStyle? style) {
        return DuskmoonApp(
          platformStyle: style,
          child: MaterialApp(
            home: Builder(
              builder: (context) => const SizedBox.shrink(),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildApp(DmPlatformStyle.material));
      await tester.pumpWidget(buildApp(DmPlatformStyle.cupertino));
      expect(find.byType(DuskmoonApp), findsOneWidget);
    });
  });
}
