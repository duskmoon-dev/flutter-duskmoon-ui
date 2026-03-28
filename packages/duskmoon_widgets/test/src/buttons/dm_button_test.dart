import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmButton', () {
    group('Material', () {
      testWidgets('filled variant renders FilledButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.filled,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(FilledButton), findsOneWidget);
      });

      testWidgets('outlined variant renders OutlinedButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.outlined,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(OutlinedButton), findsOneWidget);
      });
    });

    group('Cupertino', () {
      testWidgets('renders CupertinoButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(CupertinoButton), findsOneWidget);
      });
    });
  });
}
