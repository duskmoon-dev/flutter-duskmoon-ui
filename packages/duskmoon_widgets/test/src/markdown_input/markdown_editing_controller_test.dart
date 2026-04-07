import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmMarkdownInputController', () {
    test('wrapSelection wraps text with marker', () {
      final controller = DmMarkdownInputController(text: 'hello world');
      controller.selection =
          const TextSelection(baseOffset: 6, extentOffset: 11);
      controller.wrapSelection('**');

      expect(controller.text, 'hello **world**');
    });

    test('wrapSelection unwraps when already wrapped', () {
      final controller = DmMarkdownInputController(text: 'hello **world**');
      controller.selection =
          const TextSelection(baseOffset: 6, extentOffset: 15);
      controller.wrapSelection('**');

      expect(controller.text, 'hello world');
    });

    test('insertAtCursor inserts content', () {
      final controller = DmMarkdownInputController(text: 'hello world');
      controller.selection = const TextSelection.collapsed(offset: 5);
      controller.insertAtCursor(' beautiful');

      expect(controller.text, 'hello beautiful world');
    });

    test('insertCodeFence wraps selection', () {
      final controller = DmMarkdownInputController(text: 'some code');
      controller.selection =
          const TextSelection(baseOffset: 0, extentOffset: 9);
      controller.insertCodeFence(language: 'dart');

      expect(controller.text, contains('```dart'));
      expect(controller.text, contains('some code'));
      expect(controller.text, endsWith('```'));
    });

    test('insertLink creates markdown link', () {
      final controller = DmMarkdownInputController(text: 'click here');
      controller.selection =
          const TextSelection(baseOffset: 0, extentOffset: 10);
      controller.insertLink(url: 'https://example.com');

      expect(controller.text, '[click here](https://example.com)');
    });

    test('appendMarkdown adds at end', () {
      final controller = DmMarkdownInputController(text: 'Hello');
      controller.appendMarkdown('World');

      expect(controller.text, 'Hello\nWorld');
    });

    test('toggleLinePrefix adds prefix', () {
      final controller = DmMarkdownInputController(text: 'Item 1\nItem 2');
      controller.selection =
          const TextSelection(baseOffset: 0, extentOffset: 13);
      controller.toggleLinePrefix('- ');

      expect(controller.text, '- Item 1\n- Item 2');
    });

    test('toggleLinePrefix removes prefix if already present', () {
      final controller = DmMarkdownInputController(text: '- Item 1\n- Item 2');
      controller.selection =
          const TextSelection(baseOffset: 0, extentOffset: 17);
      controller.toggleLinePrefix('- ');

      expect(controller.text, 'Item 1\nItem 2');
    });

    test('cachedNodes is populated after text set', () {
      final controller = DmMarkdownInputController(text: '# Title');

      expect(controller.cachedNodes, isNotEmpty);
    });

    test('empty text produces empty nodes', () {
      final controller = DmMarkdownInputController();

      expect(controller.cachedNodes, isEmpty);
    });

    test('controller mutations clear stale composing ranges', () {
      final controller = DmMarkdownInputController(text: 'hello **world**');
      controller.value = controller.value.copyWith(
        selection: const TextSelection(baseOffset: 6, extentOffset: 15),
        composing: const TextRange(start: 6, end: 15),
      );

      controller.wrapSelection('**');

      expect(controller.text, 'hello world');
      expect(controller.value.composing, TextRange.empty);
      expect(controller.selection,
          const TextSelection(baseOffset: 6, extentOffset: 11));
    });

    test('value setter clamps invalid selection and composing ranges', () {
      final controller = DmMarkdownInputController(text: 'hello');

      controller.value = const TextEditingValue(
        text: 'abc',
        selection: TextSelection(baseOffset: 0, extentOffset: 8),
        composing: TextRange(start: 1, end: 8),
      );

      expect(controller.text, 'abc');
      expect(controller.selection,
          const TextSelection(baseOffset: 0, extentOffset: 3));
      expect(controller.value.composing, TextRange.empty);
    });
  });
}
