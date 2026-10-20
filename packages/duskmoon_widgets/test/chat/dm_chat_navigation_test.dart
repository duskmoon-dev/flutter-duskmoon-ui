import 'dart:ui' show PointerDeviceKind, Tristate;

import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:duskmoon_widgets/src/chat/view/_message_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _marker(String id) => find.byKey(ValueKey('chat-navigation-$id'));

Finder get _chatList => find.ancestor(
      of: find.byType(DmChatBubble).first,
      matching: find.byType(ListView),
    );

Finder get _markers => find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey<String> &&
          (widget.key! as ValueKey<String>)
              .value
              .startsWith('chat-navigation-'),
    );

Finder _previewText(String text) =>
    find.byWidgetPredicate((widget) => widget is Text && widget.data == text);

Future<TestGesture> _hoverMarker(WidgetTester tester, String id) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(mouse.removePointer);
  await mouse.addPointer(location: Offset.zero);
  await mouse.moveTo(tester.getCenter(_marker(id)));
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pumpAndSettle();
  return mouse;
}

DmChatMessage _text(String id, DmChatRole role, String text) => DmChatMessage(
      id: id,
      role: role,
      blocks: [DmChatTextBlock(text: text)],
    );

List<DmChatMessage> _turns(int count, {bool tallReply = false}) => [
      for (var i = 0; i < count; i++) ...[
        _text('u$i', DmChatRole.user, 'Question $i'),
        DmChatMessage(
          id: 'a$i',
          role: DmChatRole.assistant,
          blocks: [
            DmChatCustomBlock(
              kind: 'height',
              data: tallReply && i == count ~/ 2 ? 4000.0 : 180.0,
            ),
          ],
        ),
      ],
    ];

Future<void> _pumpChat(
  WidgetTester tester,
  List<DmChatMessage> messages, {
  bool reverse = true,
  bool showNavigation = true,
  DmPlatformStyle style = DmPlatformStyle.material,
  double textScale = 1,
}) async {
  await tester.pumpWidget(
    DuskmoonApp(
      platformStyle: style,
      child: MaterialApp(
        theme: DmThemeData.sunshine(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
          ),
          child: child!,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => DmChatView(
              messages: messages,
              reverse: reverse,
              showMessageNavigation: showNavigation,
              theme: DmChatTheme.withContext(context).copyWith(
                customBuilders: {
                  'height': (_, block) =>
                      SizedBox(height: block.data! as double),
                },
              ),
              onSend: (_, _) {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void _expectVisible(WidgetTester tester, String id, {bool nearTop = false}) {
  final bubble = find.byKey(ValueKey(id));
  expect(bubble, findsOneWidget);
  final viewport = tester.getRect(_chatList);
  final bounds = tester.getRect(bubble);
  expect(
    bounds.overlaps(viewport),
    isTrue,
    reason: '$id must be inside the chat viewport',
  );
  if (nearTop) {
    expect(bounds.top - viewport.top, inInclusiveRange(-1, 20));
  }
}

void main() {
  group('DmChatView message navigation', () {
    for (final style in DmPlatformStyle.values) {
      testWidgets('$style provides a labeled marker for each user message', (
        tester,
      ) async {
        await _pumpChat(
            tester,
            [
              _text('system', DmChatRole.system, 'Instructions'),
              _text('u0', DmChatRole.user, 'First question'),
              _text('a0', DmChatRole.assistant, 'First answer'),
              _text('u1', DmChatRole.user, 'Second question'),
            ],
            style: style);

        expect(_marker('u0'), findsOneWidget);
        expect(_marker('u1'), findsOneWidget);
        expect(_marker('system'), findsNothing);
        expect(_marker('a0'), findsNothing);
        final first = tester.getSemantics(_marker('u0')).getSemanticsData();
        expect(first.label, 'Jump to user message 1: First question');
        expect(first.flagsCollection.isButton, isTrue);
        expect(
          tester
              .getSemantics(_marker('u1'))
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          Tristate.isTrue,
        );
        expect(find.byType(DmChatInput), findsOneWidget);
      });
    }

    testWidgets('can be disabled and is absent without user messages', (
      tester,
    ) async {
      final user = _text('u0', DmChatRole.user, 'Question');
      await _pumpChat(tester, [user], showNavigation: false);
      expect(_marker('u0'), findsNothing);
      expect(_markers, findsNothing);
      await _pumpChat(tester, const []);
      expect(_markers, findsNothing);
      await _pumpChat(tester, [_text('a0', DmChatRole.assistant, 'Hello')]);
      expect(_markers, findsNothing);
    });

    testWidgets('hover previews the prompt and its first assistant reply', (
      tester,
    ) async {
      await _pumpChat(tester, [
        _text('u0', DmChatRole.user, 'How does navigation work?'),
        _text('a0', DmChatRole.assistant, 'Choose a question marker.'),
        _text('a1', DmChatRole.assistant, 'Another answer.'),
        _text('u1', DmChatRole.user, 'Next question'),
      ]);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(_marker('u0')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(_previewText('How does navigation work?'), findsOneWidget);
      expect(_previewText('Choose a question marker.'), findsOneWidget);
      expect(_previewText('Another answer.'), findsNothing);
    });

    testWidgets('hover preview sits beside its marker in a narrow viewport', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 500));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pumpChat(tester, [
        _text('u0', DmChatRole.user, 'Where can I find previous questions?'),
        _text('a0', DmChatRole.assistant, 'Use the markers beside the chat.'),
      ]);
      await _hoverMarker(tester, 'u0');

      final marker = tester.getRect(_marker('u0'));
      final preview = tester.getRect(
        find.byKey(const ValueKey('chat-navigation-preview-u0')),
      );
      expect(preview.left, greaterThan(marker.right));
      expect(preview.right, lessThanOrEqualTo(320));
      expect(preview.top, greaterThanOrEqualTo(0));
      expect(preview.bottom, lessThanOrEqualTo(500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('hover and focus previews preserve the marker semantic label', (
      tester,
    ) async {
      await _pumpChat(tester, [
        _text('u0', DmChatRole.user, 'Question preview'),
        _text('a0', DmChatRole.assistant, 'Assistant preview'),
      ]);
      final mouse = await _hoverMarker(tester, 'u0');
      expect(_previewText('Assistant preview'), findsOneWidget);
      expect(tester.getSemantics(_marker('u0')).label,
          'Jump to user message 1: Question preview');

      await mouse.moveTo(Offset.zero);
      final gesture = find.descendant(
        of: _marker('u0'),
        matching: find.byType(GestureDetector),
      );
      Focus.of(tester.element(gesture)).requestFocus();
      await tester.pumpAndSettle();

      expect(_previewText('Assistant preview'), findsOneWidget);
      expect(tester.getSemantics(_marker('u0')).label,
          'Jump to user message 1: Question preview');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(_previewText('Assistant preview'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('large text preview remains bounded without overflow', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 500));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pumpChat(
          tester,
          [
            _text(
                'u0',
                DmChatRole.user,
                List.filled(5, 'A long question with several words.')
                    .join(' ')),
            _text(
                'a0',
                DmChatRole.assistant,
                List.filled(8, 'A detailed response with several words.')
                    .join(' ')),
          ],
          textScale: 2.5);
      await _hoverMarker(tester, 'u0');

      final preview = tester.getRect(
        find.byKey(const ValueKey('chat-navigation-preview-u0')),
      );
      expect(preview.left, greaterThanOrEqualTo(0));
      expect(preview.right, lessThanOrEqualTo(320));
      expect(preview.top, greaterThanOrEqualTo(0));
      expect(preview.bottom, lessThanOrEqualTo(500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('attachment-only prompts have a useful accessible preview', (
      tester,
    ) async {
      await _pumpChat(tester, const [
        DmChatMessage(
          id: 'file',
          role: DmChatRole.user,
          blocks: [
            DmChatAttachmentBlock(
              attachments: [
                DmChatAttachment(id: 'document', name: 'requirements.pdf'),
              ],
            ),
          ],
        ),
        DmChatMessage(id: 'empty', role: DmChatRole.user, blocks: []),
      ]);
      expect(
        tester.getSemantics(_marker('file')).label,
        'Jump to user message 1: requirements.pdf',
      );
      expect(
        tester.getSemantics(_marker('empty')).label,
        'Jump to user message 2: User message 2',
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(_marker('file')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(_previewText('requirements.pdf'), findsNWidgets(2));
    });

    for (final reverse in [true, false]) {
      testWidgets(
        'reverse=$reverse reaches unbuilt turns across a very tall reply',
        (tester) async {
          await _pumpChat(
            tester,
            _turns(15, tallReply: true),
            reverse: reverse,
          );
          expect(
            find.byType(DmChatBubble).evaluate().length,
            lessThan(30),
            reason: 'Chat messages must retain lazy construction',
          );
          final unbuiltId = reverse ? 'u0' : 'u14';
          expect(find.byKey(ValueKey(unbuiltId)), findsNothing);

          for (final id in ['u7', 'u0', 'u14']) {
            await tester.tap(_marker(id));
            await tester.pumpAndSettle();
            _expectVisible(tester, id, nearTop: id != 'u14');
            expect(tester.takeException(), isNull);
          }
        },
      );
    }

    testWidgets('manual scrolling changes the selected user turn', (
      tester,
    ) async {
      await _pumpChat(tester, _turns(8));
      expect(
        tester
            .getSemantics(_marker('u7'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );

      await tester.drag(_chatList, const Offset(0, 3000));
      await tester.pumpAndSettle();
      _expectVisible(tester, 'u0', nearTop: true);
      expect(
        tester
            .getSemantics(_marker('u0'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      expect(
        tester
            .getSemantics(_marker('u7'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isFalse,
      );
    });

    testWidgets('normal marker spacing is compact and the rail is centered', (
      tester,
    ) async {
      await _pumpChat(tester, _turns(10));
      final first = tester.getCenter(_marker('u0'));
      final second = tester.getCenter(_marker('u1'));
      expect(second.dy - first.dy, inInclusiveRange(4, 10));

      final rail = tester.getRect(find.ancestor(
        of: _marker('u0'),
        matching: find.byType(ListView),
      ));
      final viewport = tester.getRect(_chatList);
      expect(rail.center.dy, closeTo(viewport.center.dy, 1));
      expect(rail.height, lessThanOrEqualTo(256));
      expect(rail.height, lessThanOrEqualTo(viewport.height * 0.6));
    });

    testWidgets('50 user markers fit a narrow viewport without rail scrolling',
        (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 500));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pumpChat(tester, _turns(50));
      final railFinder = find.ancestor(
        of: _marker('u49'),
        matching: find.byType(ListView),
      );
      final rail = tester.getRect(railFinder);
      final controller = tester.widget<ListView>(railFinder).controller!;
      expect(controller.position.maxScrollExtent, 0);
      for (var i = 0; i < 50; i++) {
        expect(_marker('u$i').hitTestable(), findsOneWidget);
        expect(rail.contains(tester.getCenter(_marker('u$i'))), isTrue);
      }
      expect(
          tester.getCenter(_marker('u1')).dy -
              tester.getCenter(_marker('u0')).dy,
          inInclusiveRange(4, 10));

      await tester.tap(_marker('u0'));
      await tester.pumpAndSettle();
      _expectVisible(tester, 'u0', nearTop: true);
      await tester.tap(_marker('u49'));
      await tester.pumpAndSettle();
      _expectVisible(tester, 'u49');
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        '200 user markers remain individually scrollable and selectable', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 500));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pumpChat(tester, _turns(200));
      final rail = find.ancestor(
        of: _marker('u199'),
        matching: find.byType(ListView),
      );
      final controller = tester.widget<ListView>(rail).controller!;
      expect(controller.position.maxScrollExtent, greaterThan(0));
      final railScrollable = find.byWidgetPredicate(
        (widget) => widget is Scrollable && widget.controller == controller,
      );
      for (final id in ['u100', 'u0']) {
        await tester.scrollUntilVisible(
          _marker(id),
          -100,
          scrollable: railScrollable,
        );
        await tester.tap(_marker(id));
        await tester.pumpAndSettle();
        _expectVisible(tester, id, nearTop: true);
        expect(
            tester
                .getSemantics(_marker(id))
                .getSemanticsData()
                .flagsCollection
                .isSelected,
            Tristate.isTrue);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('resizing the rail preserves active tracking as pitch changes',
        (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 500));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pumpChat(tester, _turns(50));
      final initialPitch = tester.getCenter(_marker('u49')).dy -
          tester.getCenter(_marker('u48')).dy;
      final rail = find.ancestor(
        of: _marker('u49'),
        matching: find.byType(ListView),
      );
      final controller = tester.widget<ListView>(rail).controller!;

      await tester.binding.setSurfaceSize(const Size(320, 300));
      await tester.pumpAndSettle();
      expect(_marker('u49').hitTestable(), findsOneWidget);
      final resizedPitch = tester.getCenter(_marker('u49')).dy -
          tester.getCenter(_marker('u48')).dy;
      expect(resizedPitch, lessThan(initialPitch));
      expect(resizedPitch, greaterThanOrEqualTo(4));
      expect(
          tester
              .getSemantics(_marker('u49'))
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          Tristate.isTrue);

      final railScrollable = find.byWidgetPredicate(
        (widget) => widget is Scrollable && widget.controller == controller,
      );
      await tester.scrollUntilVisible(_marker('u20'), -40,
          scrollable: railScrollable);
      await tester.tap(_marker('u20'));
      await tester.pumpAndSettle();
      _expectVisible(tester, 'u20', nearTop: true);
      expect(
          tester
              .getSemantics(_marker('u20'))
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          Tristate.isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('reveals the active marker when unchanged turns are reordered',
        (tester) async {
      Future<void> pumpRail(List<DmChatMessage> messages) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 40,
                height: 240,
                child: ChatMessageNavigation(
                  messages: messages,
                  activeMessageId: 'u0',
                  onSelected: (_) {},
                ),
              ),
            ),
          ),
        ));
        await tester.pumpAndSettle();
      }

      final messages = _turns(100);
      await pumpRail(messages);
      expect(_marker('u0').hitTestable(), findsOneWidget);
      expect(_marker('u99').hitTestable(), findsNothing);

      await pumpRail([...messages.skip(2), ...messages.take(2)]);

      expect(_marker('u0').hitTestable(), findsOneWidget);
      expect(
        tester
            .getSemantics(_marker('u0'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      expect(tester.getCenter(_marker('u0')).dy,
          greaterThan(tester.getCenter(_marker('u99')).dy));
      expect(tester.takeException(), isNull);
    });

    testWidgets('reconciles removed and appended user turns', (tester) async {
      await _pumpChat(tester, _turns(4));
      await tester.tap(_marker('u1'));
      await tester.pumpAndSettle();
      final updated = _turns(
        5,
      ).where((message) => message.id != 'u1' && message.id != 'a1').toList();
      await _pumpChat(tester, updated);
      expect(_marker('u1'), findsNothing);
      expect(_marker('u4'), findsOneWidget);
      await tester.tap(_marker('u4'));
      await tester.pumpAndSettle();
      _expectVisible(tester, 'u4');
      expect(tester.takeException(), isNull);
    });

    for (final reverse in [true, false]) {
      for (final mutateInPlace in [true, false]) {
        testWidgets(
            'reverse=$reverse preserves history on assistant append '
            '(in-place=$mutateInPlace)', (tester) async {
          var messages = _turns(8);
          await _pumpChat(tester, messages, reverse: reverse);
          await tester.tap(_marker('u1'));
          await tester.pumpAndSettle();
          _expectVisible(tester, 'u1', nearTop: true);

          final latest = _text('latest', DmChatRole.assistant, 'New answer');
          if (mutateInPlace) {
            messages.add(latest);
          } else {
            messages = [...messages, latest];
          }
          await _pumpChat(tester, messages, reverse: reverse);

          _expectVisible(tester, 'a1');
          expect(
            tester
                .getSemantics(_marker('u1'))
                .getSemanticsData()
                .flagsCollection
                .isSelected,
            Tristate.isTrue,
          );
          expect(
            find.descendant(of: find.byType(Badge), matching: find.text('1')),
            findsOneWidget,
          );

          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();
          _expectVisible(tester, 'latest');
          expect(find.byType(FloatingActionButton), findsNothing);
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('opted-out forward list preserves initial history on append', (
      tester,
    ) async {
      final messages = _turns(8);
      await _pumpChat(tester, messages, reverse: false, showNavigation: false);
      _expectVisible(tester, 'u0', nearTop: true);

      await _pumpChat(
        tester,
        [...messages, _text('latest', DmChatRole.assistant, 'New answer')],
        reverse: false,
        showNavigation: false,
      );

      _expectVisible(tester, 'u0', nearTop: true);
      expect(_markers, findsNothing);
      expect(
        find.descendant(of: find.byType(Badge), matching: find.text('1')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('pinned reverse list follows an in-place assistant append', (
      tester,
    ) async {
      final messages = _turns(8);
      await _pumpChat(tester, messages);
      _expectVisible(tester, 'a7');

      messages.add(_text('latest', DmChatRole.assistant, 'New answer'));
      await _pumpChat(tester, messages);

      _expectVisible(tester, 'latest');
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Enter and Space activate a focused marker', (tester) async {
      await _pumpChat(tester, _turns(8));
      final gesture = find.descendant(
        of: _marker('u0'),
        matching: find.byType(GestureDetector),
      );
      Focus.of(tester.element(gesture)).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      _expectVisible(tester, 'u0', nearTop: true);

      final controller = tester.widget<ListView>(_chatList).controller!;
      controller.jumpTo(0);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      _expectVisible(tester, 'u0', nearTop: true);
      expect(tester.takeException(), isNull);
    });

    testWidgets('can be disposed while a distant turn is being located', (
      tester,
    ) async {
      await _pumpChat(tester, _turns(15, tallReply: true));
      await tester.tap(_marker('u0'));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
