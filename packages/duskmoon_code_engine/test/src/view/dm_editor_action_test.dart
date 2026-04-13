import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('DmEditorAction', () {
    test('stores icon, tooltip, and onPressed', () {
      var called = false;
      final action = DmEditorAction(
        icon: Icons.undo,
        tooltip: 'Undo',
        onPressed: () => called = true,
      );
      expect(action.icon, Icons.undo);
      expect(action.tooltip, 'Undo');
      expect(action.onPressed, isNotNull);
      action.onPressed!();
      expect(called, isTrue);
    });

    test('onPressed defaults to null (disabled)', () {
      const action = DmEditorAction(
        icon: Icons.undo,
        tooltip: 'Undo',
      );
      expect(action.onPressed, isNull);
    });

    test('undo factory produces correct icon and tooltip', () {
      final ctrl = EditorViewController(text: 'hello');
      final action = DmEditorAction.undo(ctrl);
      expect(action.icon, Icons.undo);
      expect(action.tooltip, 'Undo');
      expect(action.onPressed, isNotNull);
      ctrl.dispose();
    });

    test('redo factory produces correct icon and tooltip', () {
      final ctrl = EditorViewController(text: 'hello');
      final action = DmEditorAction.redo(ctrl);
      expect(action.icon, Icons.redo);
      expect(action.tooltip, 'Redo');
      expect(action.onPressed, isNotNull);
      ctrl.dispose();
    });

    test('search factory produces correct icon and tooltip', () {
      final ctrl = EditorViewController(text: 'hello');
      final action = DmEditorAction.search(ctrl);
      expect(action.icon, Icons.search);
      expect(action.tooltip, 'Search');
      expect(action.onPressed, isNotNull);
      ctrl.dispose();
    });

    test('copy factory produces correct icon and tooltip', () {
      final ctrl = EditorViewController(text: 'hello');
      final action = DmEditorAction.copy(ctrl);
      expect(action.icon, Icons.copy);
      expect(action.tooltip, 'Copy');
      expect(action.onPressed, isNotNull);
      ctrl.dispose();
    });
  });
}
