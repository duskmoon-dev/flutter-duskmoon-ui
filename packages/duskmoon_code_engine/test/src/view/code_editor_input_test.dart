import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> showEditor(
    WidgetTester tester,
    EditorViewController controller,
    FocusNode focus, {
    bool readOnly = false,
  }) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CodeEditorWidget(
          controller: controller,
          focusNode: focus,
          readOnly: readOnly,
        ),
      ),
    ));
    await tester.pump();
  }

  Future<void> tapEditor(WidgetTester tester) async {
    await tester.tapAt(
      tester.getTopLeft(find.byType(CodeEditorWidget)) + const Offset(120, 10),
    );
    await tester.pump();
  }

  void disposeEditor(
    WidgetTester tester,
    EditorViewController controller,
    FocusNode focus,
  ) {
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      focus.dispose();
      controller.dispose();
    });
  }

  testWidgets('focused readOnly transition rejects IME edits and retains focus',
      (tester) async {
    final controller = EditorViewController(text: 'original');
    final focus = FocusNode();
    disposeEditor(tester, controller, focus);
    await showEditor(tester, controller, focus);
    focus.requestFocus();
    await tester.pump();
    expect(tester.testTextInput.hasAnyClients, isTrue);

    await showEditor(tester, controller, focus, readOnly: true);
    tester.testTextInput.updateEditingValue(const TextEditingValue(
      text: 'injected',
      selection: TextSelection.collapsed(offset: 8),
      composing: TextRange(start: 0, end: 8),
    ));
    await tester.pump();
    expect(controller.text, 'original');
    expect(focus.hasFocus, isTrue);
    expect(tester.testTextInput.hasAnyClients, isFalse);
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('editable transition reconnects the current save snapshot',
      (tester) async {
    final controller = EditorViewController(text: 'original');
    final focus = FocusNode();
    disposeEditor(tester, controller, focus);
    await showEditor(tester, controller, focus, readOnly: true);
    focus.requestFocus();
    await tester.pump();
    expect(tester.testTextInput.hasAnyClients, isFalse);
    controller.text = 'saved';
    await showEditor(tester, controller, focus);
    expect(focus.hasFocus, isTrue);
    expect(tester.testTextInput.hasAnyClients, isTrue);
    expect(tester.testTextInput.editingState!['text'], 'saved');
    tester.testTextInput.enterText('saved\nnext');
    await tester.pump();
    expect(controller.text, 'saved\nnext');
  });

  testWidgets('readOnly toggles do not duplicate input connections',
      (tester) async {
    final controller = EditorViewController(text: 'original');
    final focus = FocusNode();
    disposeEditor(tester, controller, focus);
    await showEditor(tester, controller, focus);
    focus.requestFocus();
    await tester.pump();
    for (var i = 0; i < 3; i++) {
      await showEditor(tester, controller, focus, readOnly: true);
      expect(tester.testTextInput.hasAnyClients, isFalse);
      await showEditor(tester, controller, focus);
      tester.testTextInput.enterText('edit $i');
      await tester.pump();
      expect(controller.text, 'edit $i');
    }
    expect(
      tester.testTextInput.log
          .where((call) => call.method == 'TextInput.setClient'),
      hasLength(4),
    );
  });

  testWidgets('swapping the focused controller routes IME to the new document',
      (tester) async {
    final first = EditorViewController(text: 'first');
    final second = EditorViewController(text: 'second');
    final focus = FocusNode();
    disposeEditor(tester, first, focus);
    addTearDown(second.dispose);
    await showEditor(tester, first, focus);
    focus.requestFocus();
    await tester.pump();
    await showEditor(tester, second, focus);
    expect(tester.testTextInput.editingState!['text'], 'second');
    tester.testTextInput.enterText('updated');
    await tester.pump();
    expect(first.text, 'first');
    expect(second.text, 'updated');
  });

  testWidgets('controller swap into readOnly disconnects IME', (tester) async {
    final first = EditorViewController(text: 'first');
    final second = EditorViewController(text: 'snapshot');
    final focus = FocusNode();
    disposeEditor(tester, first, focus);
    addTearDown(second.dispose);
    await showEditor(tester, first, focus);
    focus.requestFocus();
    await tester.pump();
    await showEditor(tester, second, focus, readOnly: true);
    tester.testTextInput.enterText('injected');
    await tester.pump();
    expect(first.text, 'first');
    expect(second.text, 'snapshot');
    expect(tester.testTextInput.hasAnyClients, isFalse);
  });

  testWidgets('swapping to an unfocused node disconnects the previous client',
      (tester) async {
    final controller = EditorViewController(text: 'original');
    final first = FocusNode();
    final second = FocusNode();
    disposeEditor(tester, controller, first);
    addTearDown(second.dispose);
    await showEditor(tester, controller, first);
    first.requestFocus();
    await tester.pump();
    await showEditor(tester, controller, second);
    expect(second.hasFocus, isFalse);
    expect(tester.testTextInput.hasAnyClients, isFalse);
    tester.testTextInput.enterText('stale');
    await tester.pump();
    expect(controller.text, 'original');
    second.requestFocus();
    await tester.pump();
    tester.testTextInput.enterText('new focus');
    await tester.pump();
    expect(controller.text, 'new focus');
  });

  testWidgets('losing focus and disposal disconnect the IME', (tester) async {
    final controller = EditorViewController(text: 'original');
    final focus = FocusNode();
    disposeEditor(tester, controller, focus);
    await showEditor(tester, controller, focus);
    focus.requestFocus();
    await tester.pump();
    focus.unfocus();
    await tester.pump();
    expect(tester.testTextInput.hasAnyClients, isFalse);
    focus.requestFocus();
    await tester.pump();
    expect(tester.testTextInput.hasAnyClients, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.testTextInput.hasAnyClients, isFalse);
  });

  testWidgets('editable touch shows the soft keyboard', (tester) async {
    final controller = EditorViewController(text: 'hello\n');
    final focus = FocusNode();
    disposeEditor(tester, controller, focus);
    await showEditor(tester, controller, focus);
    await tapEditor(tester);
    expect(focus.hasFocus, isTrue);
    expect(tester.testTextInput.hasAnyClients, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
    tester.testTextInput.enterText('hello\nmobile');
    await tester.pump();
    expect(controller.text, 'hello\nmobile');
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('retapping the focused editor reopens the dismissed keyboard',
      (tester) async {
    final controller = EditorViewController(text: 'hello');
    final focus = FocusNode();
    disposeEditor(tester, controller, focus);
    await showEditor(tester, controller, focus);
    await tapEditor(tester);
    tester.testTextInput.hide();
    expect(focus.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isFalse);
    await tapEditor(tester);
    expect(tester.testTextInput.isVisible, isTrue);
    expect(
      tester.testTextInput.log
          .where((call) => call.method == 'TextInput.setClient'),
      hasLength(1),
    );
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('retapping reconnects after the platform closes input',
      (tester) async {
    final controller = EditorViewController(text: 'hello');
    final focus = FocusNode();
    disposeEditor(tester, controller, focus);
    await showEditor(tester, controller, focus);
    await tapEditor(tester);
    tester.testTextInput.hide();
    tester.testTextInput.closeConnection();
    await tester.pump();
    expect(focus.hasFocus, isTrue);
    await tapEditor(tester);
    expect(tester.testTextInput.hasAnyClients, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
    tester.testTextInput.enterText('reconnected');
    await tester.pump();
    expect(controller.text, 'reconnected');
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('readOnly touch preserves focus without opening a keyboard',
      (tester) async {
    final controller = EditorViewController(text: 'original');
    final focus = FocusNode();
    disposeEditor(tester, controller, focus);
    await showEditor(tester, controller, focus, readOnly: true);
    await tapEditor(tester);
    await tapEditor(tester);
    expect(focus.hasFocus, isTrue);
    expect(tester.testTextInput.hasAnyClients, isFalse);
    expect(tester.testTextInput.isVisible, isFalse);
    expect(controller.text, 'original');
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));
}
