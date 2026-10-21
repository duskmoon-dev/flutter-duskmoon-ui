import 'dart:ui' show PointerDeviceKind, Tristate;

import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:duskmoon_widgets/src/chat/view/_message_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _marker(String id) => find.byKey(ValueKey('chat-navigation-$id'));

Finder get _rail => find.descendant(
      of: find.byType(ChatMessageNavigation),
      matching: find.byType(ListView),
    );

Finder get _chatList => find.ancestor(
      of: find.byType(DmChatBubble).first,
      matching: find.byType(ListView),
    );

List<DmChatMessage> _users(int count) => [
      for (var i = 0; i < count; i++)
        DmChatMessage(
          id: 'u$i',
          role: DmChatRole.user,
          blocks: [DmChatTextBlock(text: 'Question $i')],
        ),
    ];

Future<void> _pumpRail(
  WidgetTester tester,
  List<DmChatMessage> messages,
  List<String> selections, {
  String active = 'u7',
}) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 48,
          height: 240,
          child: ChatMessageNavigation(
            messages: messages,
            activeMessageId: active,
            onSelected: selections.add,
          ),
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

Finder _tick(String id) => find.descendant(
      of: _marker(id),
      matching: find.byType(AnimatedContainer),
    );

double _tickWidth(WidgetTester tester, String id) =>
    tester.widget<AnimatedContainer>(_tick(id)).constraints!.maxWidth;

Rect _touchBounds(WidgetTester tester) {
  final region = find.byKey(const ValueKey('chat-navigation-touch-region'));
  return tester.getRect(region.evaluate().isEmpty ? _rail : region);
}

void main() {
  group('Chat navigation touch selection', () {
    testWidgets('down and movement highlight immediately; only up commits once',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(8), selected);
      final controller = tester.widget<ListView>(_rail).controller!;
      final initialOffset = controller.offset;

      final touch = await tester.startGesture(tester.getCenter(_marker('u2')));
      await tester.pump();
      expect(_tickWidth(tester, 'u2'), 20);
      expect(tester.getSize(_tick('u2')).width, 20);
      expect(selected, isEmpty);

      await touch.moveTo(tester.getCenter(_marker('u5')));
      await tester.pump();
      expect(_tickWidth(tester, 'u5'), 20);
      expect(tester.getSize(_tick('u5')).width, 20);
      expect(_tickWidth(tester, 'u2'), 8);
      expect(controller.offset, initialOffset);
      await tester.pump(const Duration(seconds: 2));
      expect(selected, isEmpty, reason: 'Holding a candidate must not commit.');

      await touch.up();
      await tester.pumpAndSettle();
      expect(selected, ['u5']);
      await tester.pump(const Duration(seconds: 1));
      expect(selected, ['u5'],
          reason: 'Child tap/long-press must not duplicate.');
      expect(tester.takeException(), isNull);
    });

    testWidgets('a single tick has a generous horizontal and vertical hit area',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(1), selected, active: 'u0');
      final bounds = _touchBounds(tester);
      expect(bounds.width, greaterThanOrEqualTo(48));
      expect(bounds.height, greaterThanOrEqualTo(48));
      final touch =
          await tester.startGesture(bounds.topLeft + const Offset(1, 1));
      await tester.pump();
      expect(selected, isEmpty);
      await touch.up();
      await tester.pumpAndSettle();
      expect(selected, ['u0']);
    });

    testWidgets('cancel restores selected indication without selecting',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(8), selected);
      final touch = await tester.startGesture(tester.getCenter(_marker('u2')));
      await tester.pump();
      expect(_tickWidth(tester, 'u2'), 20);
      await touch.cancel();
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(_tickWidth(tester, 'u2'), 8);
      expect(_tickWidth(tester, 'u7'), 20);
      expect(
        tester
            .getSemantics(_marker('u7'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      expect(
        tester
            .getSemantics(_marker('u2'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isFalse,
      );
    });

    testWidgets('tracked movement clamps above and below the rail',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(8), selected);
      final bounds = tester.getRect(_rail);
      final touch = await tester.startGesture(tester.getCenter(_marker('u3')));
      await touch.moveTo(Offset(bounds.center.dx, bounds.top - 100));
      await tester.pump();
      expect(_tickWidth(tester, 'u0'), 20);
      expect(selected, isEmpty);
      await touch.moveTo(Offset(bounds.center.dx, bounds.bottom + 100));
      await tester.pump();
      expect(_tickWidth(tester, 'u7'), 20);
      expect(selected, isEmpty);
      await touch.up();
      await tester.pumpAndSettle();
      expect(selected, ['u7']);
    });

    testWidgets(
        'secondary pointers cannot move or commit the tracked candidate',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(8), selected);
      final first = await tester.startGesture(
        tester.getCenter(_marker('u1')),
        pointer: 11,
      );
      final second = await tester.startGesture(
        tester.getCenter(_marker('u6')),
        pointer: 12,
      );
      await second.moveTo(tester.getCenter(_marker('u7')));
      await second.up();
      await tester.pump();
      expect(_tickWidth(tester, 'u1'), 20);
      expect(_tickWidth(tester, 'u6'), 8);
      expect(selected, isEmpty);
      await first.moveTo(tester.getCenter(_marker('u3')));
      await tester.pump();
      await first.up();
      await tester.pumpAndSettle();
      expect(selected, ['u3']);
    });

    testWidgets('overflow edge selection reaches both ends without committing',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(100), selected, active: 'u0');
      final bounds = tester.getRect(_rail);
      final controller = tester.widget<ListView>(_rail).controller!;
      expect(controller.position.maxScrollExtent, greaterThan(0));

      final touch =
          await tester.startGesture(bounds.bottomCenter - const Offset(0, 1));
      for (var i = 0;
          i < 40 && controller.offset < controller.position.maxScrollExtent;
          i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(controller.offset, controller.position.maxScrollExtent);
      expect(_marker('u99').hitTestable(), findsOneWidget);
      expect(_tickWidth(tester, 'u99'), 20);
      expect(selected, isEmpty, reason: 'Autoscroll must never commit.');
      await touch.up();
      await tester.pumpAndSettle();
      expect(selected, ['u99']);

      await _pumpRail(tester, _users(100), selected, active: 'u99');
      expect(controller.offset, controller.position.maxScrollExtent);

      final back =
          await tester.startGesture(bounds.topCenter + const Offset(0, 1));
      for (var i = 0; i < 40 && controller.offset > 0; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(controller.offset, 0);
      expect(_marker('u0').hitTestable(), findsOneWidget);
      expect(_tickWidth(tester, 'u0'), 20);
      expect(selected, ['u99']);
      await back.up();
      await tester.pumpAndSettle();
      expect(selected, ['u99', 'u0']);
      expect(tester.takeException(), isNull);
    });

    testWidgets('an overflowed middle marker can be held and selected',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(100), selected, active: 'u0');
      final bounds = tester.getRect(_rail);
      final controller = tester.widget<ListView>(_rail).controller!;
      final touch = await tester.startGesture(
        bounds.bottomCenter - const Offset(0, 1),
      );
      var reachedMiddle = false;
      for (var i = 0; i < 40; i++) {
        if (_marker('u50').hitTestable().evaluate().isNotEmpty) {
          final point = tester.getCenter(_marker('u50'));
          if (point.dy > bounds.top + 32 && point.dy < bounds.bottom - 32) {
            reachedMiddle = true;
            await touch.moveTo(point);
            break;
          }
        }
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(reachedMiddle, isTrue);
      await tester.pump();
      final heldOffset = controller.offset;
      expect(_tickWidth(tester, 'u50'), 20);
      await tester.pump(const Duration(seconds: 1));
      expect(controller.offset, heldOffset);
      expect(selected, isEmpty);
      await touch.up();
      await tester.pumpAndSettle();
      expect(selected, ['u50']);
      expect(tester.takeException(), isNull);
    });

    for (final top in [true, false]) {
      testWidgets(
          'fractional offset selects a painted tick at the '
          '${top ? 'top' : 'bottom'} edge', (tester) async {
        final selected = <String>[];
        await _pumpRail(tester, _users(100), selected, active: 'u0');
        final controller = tester.widget<ListView>(_rail).controller!;
        controller.jumpTo(top ? 3.5 : 0.5);
        await tester.pumpAndSettle();
        final bounds = tester.getRect(_rail);
        final touch = await tester.startGesture(Offset(
          bounds.center.dx,
          top ? bounds.top + 0.1 : bounds.bottom - 0.1,
        ));
        await tester.pump();
        final expected = top ? 'u1' : 'u35';
        expect(_tickWidth(tester, expected), 20);
        expect(tester.getSize(_tick(expected)).width, 20);
        expect(selected, isEmpty);
        await touch.up();
        await tester.pumpAndSettle();
        expect(selected, [expected]);
        expect(tester.takeException(), isNull);
      });
    }

    for (final focused in [false, true]) {
      testWidgets(
          'touch safely hides an open '
          '${focused ? 'focus' : 'hover'} preview', (tester) async {
        final selected = <String>[];
        await _pumpRail(tester, _users(8), selected);
        if (focused) {
          final gesture = find.descendant(
            of: _marker('u2'),
            matching: find.byType(GestureDetector),
          );
          Focus.of(tester.element(gesture)).requestFocus();
        } else {
          final mouse =
              await tester.createGesture(kind: PointerDeviceKind.mouse);
          addTearDown(mouse.removePointer);
          await mouse.addPointer(location: Offset.zero);
          await mouse.moveTo(tester.getCenter(_marker('u2')));
          await tester.pump(const Duration(milliseconds: 300));
        }
        await tester.pumpAndSettle();
        final preview = find.byKey(
          const ValueKey('chat-navigation-preview-u2'),
        );
        expect(preview, findsOneWidget);
        final touch =
            await tester.startGesture(tester.getCenter(_marker('u3')));
        await tester.pump();
        expect(tester.takeException(), isNull);
        await tester.pumpAndSettle();
        expect(preview, findsNothing);
        expect(_tickWidth(tester, 'u3'), 20);
        expect(selected, isEmpty);
        await touch.cancel();
        await tester.pumpAndSettle();
        expect(selected, isEmpty);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('cancelling an overflow gesture stops its autoscroll timer',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(100), selected, active: 'u0');
      final bounds = tester.getRect(_rail);
      final controller = tester.widget<ListView>(_rail).controller!;
      final touch =
          await tester.startGesture(bounds.bottomCenter - const Offset(0, 1));
      await tester.pump(const Duration(milliseconds: 150));
      expect(controller.offset, greaterThan(0));
      await touch.cancel();
      await tester.pumpAndSettle();
      final cancelledOffset = controller.offset;
      await tester.pump(const Duration(seconds: 2));
      expect(controller.offset, cancelledOffset);
      expect(selected, isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a removed candidate cannot commit a different message',
        (tester) async {
      final selected = <String>[];
      final messages = _users(8);
      await _pumpRail(tester, messages, selected);
      final touch = await tester.startGesture(tester.getCenter(_marker('u2')));
      await tester.pump();
      await _pumpRail(
        tester,
        messages.where((message) => message.id != 'u2').toList(),
        selected,
      );
      await touch.up();
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('disposing a selecting rail clears its autoscroll timer',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(100), selected, active: 'u0');
      final bounds = tester.getRect(_rail);
      final touch = await tester.startGesture(
        bounds.bottomCenter - const Offset(0, 1),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(const SizedBox.shrink());
      await touch.up();
      await tester.pump(const Duration(seconds: 1));
      expect(selected, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'mouse click and keyboard still activate after touch cancellation',
        (tester) async {
      final selected = <String>[];
      await _pumpRail(tester, _users(8), selected);
      final touch = await tester.startGesture(tester.getCenter(_marker('u2')));
      await touch.cancel();
      await tester.pumpAndSettle();
      await tester.tap(_marker('u3'), kind: PointerDeviceKind.mouse);
      await tester.pumpAndSettle();
      expect(selected, ['u3']);
      final gesture = find.descendant(
        of: _marker('u1'),
        matching: find.byType(GestureDetector),
      );
      Focus.of(tester.element(gesture)).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selected, ['u3', 'u1']);
      expect(tester.getSemantics(_marker('u1')).label,
          'Jump to user message 2: Question 1');
      expect(tester.takeException(), isNull);
    });
  });

  for (final reverse in [true, false]) {
    testWidgets(
        'reverse=$reverse chat jumps to an unbuilt turn only on release',
        (tester) async {
      final messages = <DmChatMessage>[
        for (var i = 0; i < 10; i++) ...[
          _users(10)[i],
          DmChatMessage(
            id: 'a$i',
            role: DmChatRole.assistant,
            blocks: const [DmChatCustomBlock(kind: 'height', data: 180.0)],
          ),
        ],
      ];
      await tester.pumpWidget(DuskmoonApp(
        platformStyle: DmPlatformStyle.material,
        child: MaterialApp(
          theme: DmThemeData.sunshine(),
          home: Scaffold(
            body: Builder(
              builder: (context) => DmChatView(
                messages: messages,
                reverse: reverse,
                showInput: false,
                theme: DmChatTheme.withContext(context).copyWith(
                  customBuilders: {
                    'height': (_, block) =>
                        SizedBox(height: block.data! as double),
                  },
                ),
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.getSize(_rail).width, greaterThanOrEqualTo(48));
      final target = reverse ? 'u0' : 'u9';
      expect(find.byKey(ValueKey(target)), findsNothing);
      final controller = tester.widget<ListView>(_chatList).controller!;
      final before = controller.offset;
      final touch = await tester.startGesture(tester.getCenter(_marker('u4')));
      await touch.moveTo(tester.getCenter(_marker(target)));
      await tester.pump(const Duration(seconds: 1));
      expect(controller.offset, before);
      expect(find.byKey(ValueKey(target)), findsNothing);
      await touch.up();
      await tester.pumpAndSettle();
      final bubble = find.byKey(ValueKey(target));
      expect(bubble, findsOneWidget);
      expect(
          tester.getRect(bubble).overlaps(tester.getRect(_chatList)), isTrue);
      expect(find.byType(DmChatInput), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
