import 'dart:ui' show SemanticsAction, Tristate;

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmIconButton', () {
    for (final style in DmPlatformStyle.values) {
      for (final enabled in [true, false]) {
        testWidgets(
            '$style tooltip labels ${enabled ? "enabled" : "disabled"} '
            'button and displays on long press', (tester) async {
          var pressed = false;

          await tester.pumpWidget(
            DuskmoonApp(
              platformStyle: style,
              child: MaterialApp(
                home: Scaffold(
                  body: DmIconButton(
                    icon: const Icon(Icons.help_outline),
                    tooltip: 'Compass help',
                    onPressed: enabled ? () => pressed = true : null,
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          final button = tester
              .getSemantics(style == DmPlatformStyle.material
                  ? find.byType(IconButton)
                  : find.bySemanticsLabel('Compass help'))
              .getSemanticsData();
          expect(
            style == DmPlatformStyle.material ? button.tooltip : button.label,
            'Compass help',
          );
          expect(button.flagsCollection.isButton, isTrue);
          expect(button.flagsCollection.isEnabled,
              enabled ? Tristate.isTrue : Tristate.isFalse);
          if (enabled) {
            expect(button.hasAction(SemanticsAction.tap), isTrue);
          }

          await tester.tap(find.byType(DmIconButton));
          await tester.pumpAndSettle();
          expect(pressed, enabled);
          pressed = false;

          await tester.longPress(find.byType(DmIconButton));
          await tester.pumpAndSettle();
          expect(find.text('Compass help'), findsOneWidget);
          expect(pressed, isFalse);
          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
        });
      }
    }

    group('Material', () {
      testWidgets('renders IconButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmIconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ),
        );
        expect(find.byType(IconButton), findsOneWidget);
      });
    });

    group('Cupertino', () {
      testWidgets('renders CupertinoButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmIconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ),
        );
        expect(find.byType(CupertinoButton), findsOneWidget);
      });
    });

    group('Fluent', () {
      testWidgets('renders fluent.IconButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmIconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
                platformOverride: DmPlatformStyle.fluent,
              ),
            ),
          ),
        );
        expect(find.byType(fluent.IconButton), findsOneWidget);
      });
    });
  });
}
