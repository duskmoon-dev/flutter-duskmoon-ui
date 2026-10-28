import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final style in DmControllerStyle.values) {
    testWidgets('${style.name} renders and sends press/release', (
      tester,
    ) async {
      final changes = <(DmControllerButton, bool)>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DmControllerView(
                style: style,
                onPressedChanged: (id, pressed) => changes.add((id, pressed)),
              ),
            ),
          ),
        ),
      );
      final target = find.byKey(ValueKey('${style.name}-south'));
      expect(target, findsOneWidget);
      final gesture = await tester.startGesture(tester.getCenter(target));
      await tester.pump();
      expect(changes.last, (DmControllerButton.south, true));
      await gesture.up();
      await tester.pump();
      expect(changes.last, (DmControllerButton.south, false));
    });
  }

  for (final style in DmControllerStyle.values) {
    testWidgets('${style.name} controls fit and have independent hit targets', (
      tester,
    ) async {
      final changes = <(DmControllerButton, bool)>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DmControllerView(
                style: style,
                onPressedChanged: (id, down) => changes.add((id, down)),
              ),
            ),
          ),
        ),
      );
      final bounds = tester.getRect(find.byType(DmControllerView));
      for (final button in DmControllerButton.values) {
        final target = find.byKey(ValueKey('${style.name}-${button.name}'));
        if (target.evaluate().isEmpty) continue;
        final rect = tester.getRect(target);
        expect(
          bounds.contains(rect.topLeft),
          isTrue,
          reason: '${button.name} top edge',
        );
        expect(
          bounds.contains(rect.bottomRight - const Offset(.01, .01)),
          isTrue,
          reason: '${button.name} bottom edge',
        );
        changes.clear();
        await tester.tap(target);
        await tester.pumpAndSettle();
        expect(changes, [(button, true), (button, false)], reason: button.name);
      }
    });
  }

  testWidgets('cancel releases a held control', (tester) async {
    final changes = <(DmControllerButton, bool)>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: DmControllerView(
            style: DmControllerStyle.xbox,
            onPressedChanged: (button, pressed) =>
                changes.add((button, pressed)),
          ),
        ),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const ValueKey('xbox-south'))),
    );
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(changes, [
      (DmControllerButton.south, true),
      (DmControllerButton.south, false),
    ]);
  });

  testWidgets('externally pressed controls render', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DmControllerView(
            style: DmControllerStyle.xbox,
            pressedButtons: {DmControllerButton.north},
          ),
        ),
      ),
    );
    final target = find.byKey(const ValueKey('xbox-north'));
    final control = find.descendant(
      of: target,
      matching: find.byType(AnimatedContainer),
    );
    Color? color() =>
        (tester.widget<AnimatedContainer>(control).decoration as BoxDecoration)
            .color;
    final pressedColor = color();
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: DmControllerView(style: DmControllerStyle.xbox)),
      ),
    );
    await tester.pumpAndSettle();
    expect(color(), isNot(pressedColor));
  });
  for (final width in [300.0, 600.0]) {
    testWidgets('continuous input, independent pointers and reset at $width', (
      tester,
    ) async {
      final left = <Offset>[];
      final right = <Offset>[];
      final trigger = <double>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DmControllerView(
                style: DmControllerStyle.xbox,
                width: width,
                onLeftStickChanged: left.add,
                onRightStickChanged: right.add,
                onLeftTriggerChanged: trigger.add,
              ),
            ),
          ),
        ),
      );
      final scale = width / 600;
      final l = await tester.startGesture(
        tester.getCenter(find.byKey(const ValueKey('xbox-leftStick'))),
        pointer: 1,
      );
      final r = await tester.startGesture(
        tester.getCenter(find.byKey(const ValueKey('xbox-rightStick'))),
        pointer: 2,
      );
      final t = await tester.startGesture(
        tester.getCenter(find.byKey(const ValueKey('xbox-leftTrigger'))),
        pointer: 3,
      );
      await l.moveBy(Offset(12 * scale, -12 * scale));
      await r.moveBy(Offset(-24 * scale, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(left.last.dx, closeTo(.5, .001));
      expect(left.last.dy, closeTo(-.5, .001));
      expect(right.last, const Offset(-1, 0));
      expect(trigger.last, closeTo(.5, .001));
      final transform = tester.widget<Transform>(
        find.byKey(const ValueKey('xbox-leftStick-cap')),
      );
      expect(transform.transform.storage[12], closeTo(9, .001));
      expect(transform.transform.storage[13], closeTo(-9, .001));
      await l.moveBy(Offset(100 * scale, 100 * scale));
      await tester.pump(const Duration(milliseconds: 500));
      expect(left.last.distance, closeTo(1, .001));
      expect(trigger.last, 1);
      await l.cancel();
      expect(left.last, Offset.zero);
      expect(right.last, const Offset(-1, 0));
      await r.up();
      await t.cancel();
      await tester.pumpAndSettle();
      expect(right.last, Offset.zero);
      expect(trigger.last, 0);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('external analog values are clamped and update visuals', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DmControllerView(
            style: DmControllerStyle.dualSense,
            leftStick: Offset(3, 4),
            rightStick: Offset(-.5, .25),
            leftTrigger: 2,
            rightTrigger: -.5,
          ),
        ),
      ),
    );
    final cap = tester.widget<Transform>(
      find.byKey(const ValueKey('dualSense-leftStick-cap')),
    );
    expect(cap.transform.storage[12], closeTo(10.8, .001));
    expect(cap.transform.storage[13], closeTo(14.4, .001));
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.label == 'dualSense leftTrigger' &&
            w.properties.value == '100%',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.label == 'dualSense rightTrigger' &&
            w.properties.value == '0%',
      ),
      findsOneWidget,
    );
  });
  testWidgets('analog drag owns the gesture inside a scrolling form', (
    tester,
  ) async {
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    final values = <Offset>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            controller: scroll,
            children: [
              DmControllerView(
                style: DmControllerStyle.xbox,
                onLeftStickChanged: values.add,
              ),
              const SizedBox(height: 1600),
            ],
          ),
        ),
      ),
    );
    // Start at the socket edge, not just the cap, to cover the whole hit target.
    final rect = tester.getRect(find.byKey(const ValueKey('xbox-leftStick')));
    final first = await tester.startGesture(
      rect.centerLeft + const Offset(2, 0),
      pointer: 1,
    );
    await first.moveBy(const Offset(0, -40));
    await tester.pump();
    expect(values.last, const Offset(0, -1));
    expect(scroll.offset, 0);
    final second = await tester.startGesture(rect.center, pointer: 2);
    await second.moveBy(const Offset(40, 0));
    await second.up();
    expect(values.last, const Offset(0, -1));
    await first.up();
    expect(values.last, Offset.zero);
    await tester.pumpAndSettle();
  });
  for (final style in DmControllerStyle.values) {
    testWidgets(
      '${style.name} trigger meters reflect values and can be hidden',
      (tester) async {
        Widget view({bool visible = true}) => MaterialApp(
              home: Scaffold(
                body: Center(
                  child: DmControllerView(
                    style: style,
                    showTriggerIndicators: visible,
                    leftTrigger: .25,
                    rightTrigger: .75,
                  ),
                ),
              ),
            );
        await tester.pumpWidget(view());
        final left = find.byKey(
          ValueKey('${style.name}-leftTrigger-indicator-fill'),
        );
        final right = find.byKey(
          ValueKey('${style.name}-rightTrigger-indicator-fill'),
        );
        if (style == DmControllerStyle.switchPro) {
          expect(left, findsNothing);
          expect(right, findsNothing);
          return;
        }
        expect(tester.widget<FractionallySizedBox>(left).heightFactor, .25);
        expect(tester.widget<FractionallySizedBox>(right).heightFactor, .75);
        final bounds = tester.getRect(find.byType(DmControllerView));
        for (final meter in [left, right]) {
          final rect = tester.getRect(meter);
          expect(bounds.contains(rect.topLeft), isTrue);
          expect(bounds.contains(rect.bottomRight), isTrue);
        }
        final trigger = await tester.startGesture(
          tester.getCenter(find.byKey(ValueKey('${style.name}-leftTrigger'))),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));
        expect(
          tester.widget<FractionallySizedBox>(left).heightFactor,
          closeTo(.5, .001),
        );
        await trigger.up();
        await tester.pumpAndSettle();
        expect(tester.widget<FractionallySizedBox>(left).heightFactor, .25);
        await tester.pumpWidget(view(visible: false));
        expect(left, findsNothing);
        expect(right, findsNothing);
        expect(tester.getRect(find.byType(DmControllerView)), bounds);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final style in [DmControllerStyle.xbox, DmControllerStyle.dualSense]) {
    testWidgets('${style.name} hold and release ramp at one unit per second', (
      tester,
    ) async {
      final left = <double>[];
      final right = <double>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmControllerView(
              style: style,
              onLeftTriggerChanged: left.add,
              onRightTriggerChanged: right.add,
            ),
          ),
        ),
      );
      Future<TestGesture> press(bool isLeft, int pointer) =>
          tester.startGesture(
            tester.getCenter(
              find.byKey(
                ValueKey(
                  '${style.name}-${isLeft ? "leftTrigger" : "rightTrigger"}',
                ),
              ),
            ),
            pointer: pointer,
          );
      final l = await press(true, 1);
      final r = await press(false, 2);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(left.last, closeTo(.5, .001));
      expect(right.last, closeTo(.5, .001));
      await l.up();
      expect(left.last, closeTo(.5, .001));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(left.last, closeTo(.25, .001));
      expect(right.last, closeTo(.75, .001));
      final again = await press(true, 3);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));
      expect(left.last, 1);
      expect(right.last, 1);
      await tester.pump(const Duration(seconds: 1));
      expect(left.last, 1);
      await again.cancel();
      await r.up();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(left.last, closeTo(.5, .001));
      expect(right.last, closeTo(.5, .001));
      await tester.pump(const Duration(milliseconds: 500));
      expect(left.last, 0);
      expect(right.last, 0);
      await tester.pump(const Duration(seconds: 1));
      expect(left.last, 0);
      // Disposing an active ramp must stop its ticker without further callbacks.
      await press(true, 4);
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
      final count = left.length;
      await tester.pump(const Duration(seconds: 2));
      expect(left.length, count);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Switch Pro trigger touch stays digital', (tester) async {
    final values = <double>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmControllerView(
            style: DmControllerStyle.switchPro,
            onLeftTriggerChanged: values.add,
          ),
        ),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const ValueKey('switchPro-leftTrigger'))),
    );
    expect(values.last, 1);
    await gesture.up();
    expect(values.last, 0);
    await tester.pumpAndSettle();
  });
}
