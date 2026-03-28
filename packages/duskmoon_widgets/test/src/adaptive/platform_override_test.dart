import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

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

    testWidgets('override forces child widgets to use specified platform',
        (tester) async {
      // Use an Android theme but override to cupertino.
      // DmButton on cupertino should render CupertinoButton.
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmPlatformOverride(
              style: DmPlatformStyle.cupertino,
              child: DmButton(
                onPressed: () {},
                child: const Text('Tap'),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
    });
  });
}
