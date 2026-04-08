import 'package:fluent_ui/fluent_ui.dart' as fluent;
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
      testWidgets('filled renders CupertinoButton.filled', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.filled,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(CupertinoButton), findsOneWidget);
      });

      testWidgets('outlined renders CupertinoButton with border',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.outlined,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(CupertinoButton), findsOneWidget);
        // Our DecoratedBox wraps the CupertinoButton with a border
        final borderBox = find.ancestor(
          of: find.byType(CupertinoButton),
          matching: find.byWidgetPredicate(
            (w) =>
                w is DecoratedBox &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).border != null,
          ),
        );
        expect(borderBox, findsOneWidget);
      });

      testWidgets('text renders plain CupertinoButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.text,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(CupertinoButton), findsOneWidget);
      });

      testWidgets('tonal renders CupertinoButton.tinted', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.tonal,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(CupertinoButton), findsOneWidget);
      });
    });

    group('Fluent', () {
      testWidgets('filled variant renders fluent.FilledButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.filled,
                platformOverride: DmPlatformStyle.fluent,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(fluent.FilledButton), findsOneWidget);
      });

      testWidgets('outlined variant renders fluent.OutlinedButton',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.outlined,
                platformOverride: DmPlatformStyle.fluent,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(fluent.OutlinedButton), findsOneWidget);
      });

      testWidgets('text variant renders fluent.HyperlinkButton',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.text,
                platformOverride: DmPlatformStyle.fluent,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(fluent.HyperlinkButton), findsOneWidget);
      });

      testWidgets('tonal variant renders fluent.Button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.tonal,
                platformOverride: DmPlatformStyle.fluent,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(fluent.Button), findsOneWidget);
      });
    });
  });
}
