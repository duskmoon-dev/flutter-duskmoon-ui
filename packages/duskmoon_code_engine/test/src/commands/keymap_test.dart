import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('KeyBinding', () {
    test('creates with key and command', () {
      bool called = false;
      final binding = KeyBinding(
        key: 'Ctrl-z',
        run: (_) {
          called = true;
          return true;
        },
      );
      expect(binding.key, 'Ctrl-z');
      expect(binding.run, isNotNull);
      expect(binding.shift, isNull);
      expect(binding.preventDefault, isTrue);

      binding.run!(null);
      expect(called, isTrue);
    });

    test('matches simple key (no modifiers)', () {
      final binding = KeyBinding(key: 'Enter', run: (_) => true);
      expect(
        binding.matches(LogicalKeyboardKey.enter, false, false, false),
        isTrue,
      );
      expect(
        binding.matches(LogicalKeyboardKey.tab, false, false, false),
        isFalse,
      );
    });

    test('matches Ctrl modifier', () {
      final binding = KeyBinding(key: 'Ctrl-z', run: (_) => true);
      expect(
        binding.matches(LogicalKeyboardKey.keyZ, true, false, false),
        isTrue,
      );
      // Without Ctrl should not match.
      expect(
        binding.matches(LogicalKeyboardKey.keyZ, false, false, false),
        isFalse,
      );
    });

    test('matches Shift modifier', () {
      final binding = KeyBinding(key: 'Shift-Enter', run: (_) => true);
      expect(
        binding.matches(LogicalKeyboardKey.enter, false, true, false),
        isTrue,
      );
      // Without Shift should not match.
      expect(
        binding.matches(LogicalKeyboardKey.enter, false, false, false),
        isFalse,
      );
    });

    test('matches Alt modifier', () {
      final binding = KeyBinding(key: 'Alt-f', run: (_) => true);
      expect(
        binding.matches(LogicalKeyboardKey.keyF, false, false, true),
        isTrue,
      );
      expect(
        binding.matches(LogicalKeyboardKey.keyF, false, false, false),
        isFalse,
      );
    });

    test('matches compound Ctrl-Shift-z', () {
      final binding = KeyBinding(key: 'Ctrl-Shift-z', run: (_) => true);
      expect(
        binding.matches(LogicalKeyboardKey.keyZ, true, true, false),
        isTrue,
      );
      // Missing Shift.
      expect(
        binding.matches(LogicalKeyboardKey.keyZ, true, false, false),
        isFalse,
      );
      // Missing Ctrl.
      expect(
        binding.matches(LogicalKeyboardKey.keyZ, false, true, false),
        isFalse,
      );
    });

    test('supports special keys: ArrowUp, Tab, Escape, Backspace, Delete', () {
      final keys = {
        'ArrowUp': LogicalKeyboardKey.arrowUp,
        'ArrowDown': LogicalKeyboardKey.arrowDown,
        'ArrowLeft': LogicalKeyboardKey.arrowLeft,
        'ArrowRight': LogicalKeyboardKey.arrowRight,
        'Tab': LogicalKeyboardKey.tab,
        'Escape': LogicalKeyboardKey.escape,
        'Backspace': LogicalKeyboardKey.backspace,
        'Delete': LogicalKeyboardKey.delete,
        'Home': LogicalKeyboardKey.home,
        'End': LogicalKeyboardKey.end,
        'PageUp': LogicalKeyboardKey.pageUp,
        'PageDown': LogicalKeyboardKey.pageDown,
      };
      for (final entry in keys.entries) {
        final binding = KeyBinding(key: entry.key, run: (_) => true);
        expect(
          binding.matches(entry.value, false, false, false),
          isTrue,
          reason: '${entry.key} should match ${entry.value}',
        );
      }
    });

    test('does not match wrong logical key', () {
      final binding = KeyBinding(key: 'Ctrl-z', run: (_) => true);
      expect(
        binding.matches(LogicalKeyboardKey.keyX, true, false, false),
        isFalse,
      );
    });

    test('preventDefault defaults to true', () {
      final binding = KeyBinding(key: 'a', run: (_) => true);
      expect(binding.preventDefault, isTrue);
    });

    test('preventDefault can be set to false', () {
      final binding =
          KeyBinding(key: 'a', run: (_) => true, preventDefault: false);
      expect(binding.preventDefault, isFalse);
    });
  });

  group('Keymap', () {
    test('resolves first matching binding', () {
      bool firstCalled = false;
      bool secondCalled = false;
      final first = KeyBinding(
        key: 'Ctrl-z',
        run: (_) {
          firstCalled = true;
          return true;
        },
      );
      final second = KeyBinding(
        key: 'Ctrl-z',
        run: (_) {
          secondCalled = true;
          return true;
        },
      );
      final keymap = Keymap([first, second]);
      final resolved =
          keymap.resolve(LogicalKeyboardKey.keyZ, true, false, false);
      expect(resolved, same(first));

      resolved!.run!(null);
      expect(firstCalled, isTrue);
      expect(secondCalled, isFalse);
    });

    test('returns null for unbound key', () {
      final keymap = Keymap([
        KeyBinding(key: 'Ctrl-z', run: (_) => true),
      ]);
      final resolved =
          keymap.resolve(LogicalKeyboardKey.keyX, true, false, false);
      expect(resolved, isNull);
    });

    test('resolves binding with no modifiers', () {
      final binding = KeyBinding(key: 'Enter', run: (_) => true);
      final keymap = Keymap([binding]);
      expect(
        keymap.resolve(LogicalKeyboardKey.enter, false, false, false),
        same(binding),
      );
    });

    test('compose merges multiple keymaps, earlier takes priority', () {
      final a = KeyBinding(key: 'Ctrl-z', run: (_) => true);
      final b = KeyBinding(key: 'Ctrl-z', run: (_) => false);
      final c = KeyBinding(key: 'Ctrl-y', run: (_) => true);

      final km1 = Keymap([a]);
      final km2 = Keymap([b, c]);
      final composed = Keymap.compose([km1, km2]);

      // km1's 'Ctrl-z' should win.
      expect(
        composed.resolve(LogicalKeyboardKey.keyZ, true, false, false),
        same(a),
      );
      // 'Ctrl-y' only in km2.
      expect(
        composed.resolve(LogicalKeyboardKey.keyY, true, false, false),
        same(c),
      );
      // Total binding count = km1 + km2.
      expect(composed.bindings.length, 3);
    });

    test('compose of empty list returns empty keymap', () {
      final composed = Keymap.compose([]);
      expect(composed.bindings, isEmpty);
      expect(
        composed.resolve(LogicalKeyboardKey.enter, false, false, false),
        isNull,
      );
    });

    test('keymap with shift binding on base key', () {
      // A binding without Shift in key string but with a shift: command.
      bool shiftHandled = false;
      final binding = KeyBinding(
        key: 'Ctrl-z',
        run: (_) => true,
        shift: (_) {
          shiftHandled = true;
          return true;
        },
      );
      final keymap = Keymap([binding]);
      // The base binding matches even when shift is held (shift modifier not in key string).
      final resolved =
          keymap.resolve(LogicalKeyboardKey.keyZ, true, true, false);
      expect(resolved, same(binding));
      resolved!.shift!(null);
      expect(shiftHandled, isTrue);
    });
  });
}
