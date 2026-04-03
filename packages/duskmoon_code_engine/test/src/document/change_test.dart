import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ---------------------------------------------------------------------------
  // ChangeSpec
  // ---------------------------------------------------------------------------
  group('ChangeSpec', () {
    test('insert constructor sets from==to and stores text', () {
      const spec = ChangeSpec.insert(5, 'hello');
      expect(spec.from, 5);
      expect(spec.to, 5);
      expect(spec.insert, 'hello');
      expect(spec.deleteLen, 0);
    });

    test('delete: from < to, empty insert', () {
      const spec = ChangeSpec(from: 3, to: 8, insert: '');
      expect(spec.from, 3);
      expect(spec.to, 8);
      expect(spec.insert, '');
      expect(spec.deleteLen, 5);
    });

    test('replace: from < to, non-empty insert', () {
      const spec = ChangeSpec(from: 2, to: 6, insert: 'XYZ');
      expect(spec.from, 2);
      expect(spec.to, 6);
      expect(spec.insert, 'XYZ');
      expect(spec.deleteLen, 4);
    });

    test('default to equals from when omitted', () {
      const spec = ChangeSpec(from: 7, insert: 'A');
      expect(spec.to, 7);
      expect(spec.deleteLen, 0);
    });
  });

  // ---------------------------------------------------------------------------
  // ChangeSet.of
  // ---------------------------------------------------------------------------
  group('ChangeSet.of', () {
    test('identity (no changes)', () {
      final cs = ChangeSet.of(10, []);
      expect(cs.oldLength, 10);
      expect(cs.newLength, 10);
      expect(cs.docChanged, isFalse);
    });

    test('single insertion', () {
      final cs = ChangeSet.of(5, [const ChangeSpec.insert(2, 'XY')]);
      expect(cs.oldLength, 5);
      expect(cs.newLength, 7);
      expect(cs.docChanged, isTrue);
    });

    test('single deletion', () {
      final cs = ChangeSet.of(10, [const ChangeSpec(from: 3, to: 6, insert: '')]);
      expect(cs.oldLength, 10);
      expect(cs.newLength, 7);
      expect(cs.docChanged, isTrue);
    });

    test('replacement (same length)', () {
      final cs = ChangeSet.of(
        10,
        [const ChangeSpec(from: 0, to: 3, insert: 'abc')],
      );
      expect(cs.oldLength, 10);
      expect(cs.newLength, 10);
      expect(cs.docChanged, isTrue);
    });

    test('multiple non-overlapping changes', () {
      // Delete 2 chars at pos 1, insert 3 chars at pos 7 (original)
      final cs = ChangeSet.of(10, [
        const ChangeSpec(from: 1, to: 3, insert: ''),
        const ChangeSpec.insert(7, 'XYZ'),
      ]);
      // oldLength=10, newLength=10-2+3=11
      expect(cs.oldLength, 10);
      expect(cs.newLength, 11);
    });
  });

  // ---------------------------------------------------------------------------
  // ChangeSet.apply
  // ---------------------------------------------------------------------------
  group('ChangeSet.apply', () {
    test('insertion into rope', () {
      final rope = Rope.fromString('hello world');
      final cs = ChangeSet.of(
        rope.length,
        [const ChangeSpec.insert(5, ', dear')],
      );
      final result = cs.apply(rope);
      expect(result.sliceString(0), 'hello, dear world');
    });

    test('deletion from rope', () {
      final rope = Rope.fromString('hello world');
      final cs = ChangeSet.of(
        rope.length,
        [const ChangeSpec(from: 5, to: 11, insert: '')],
      );
      final result = cs.apply(rope);
      expect(result.sliceString(0), 'hello');
    });

    test('replacement in rope', () {
      final rope = Rope.fromString('hello world');
      final cs = ChangeSet.of(
        rope.length,
        [const ChangeSpec(from: 6, to: 11, insert: 'Dart')],
      );
      final result = cs.apply(rope);
      expect(result.sliceString(0), 'hello Dart');
    });

    test('identity changeset leaves rope unchanged', () {
      final rope = Rope.fromString('hello');
      final cs = ChangeSet.of(rope.length, []);
      final result = cs.apply(rope);
      expect(result.sliceString(0), 'hello');
    });

    test('multiple changes applied correctly', () {
      final rope = Rope.fromString('abcdefghij'); // length 10
      final cs = ChangeSet.of(10, [
        const ChangeSpec(from: 0, to: 1, insert: 'XX'), // replace 'a' with 'XX'
        const ChangeSpec.insert(5, '-'), // insert '-' after 'e'
      ]);
      // original: a b c d e f g h i j
      // after:   XX b c d e - f g h i j
      expect(cs.apply(rope).sliceString(0), 'XXbcde-fghij');
    });
  });

  // ---------------------------------------------------------------------------
  // ChangeSet.mapPos
  // ---------------------------------------------------------------------------
  group('ChangeSet.mapPos', () {
    test('position before insertion is unchanged', () {
      final cs = ChangeSet.of(10, [const ChangeSpec.insert(5, 'XY')]);
      expect(cs.mapPos(3), 3);
    });

    test('position after insertion is shifted by insert length', () {
      final cs = ChangeSet.of(10, [const ChangeSpec.insert(5, 'XY')]);
      expect(cs.mapPos(7), 9); // shifted by 2
    });

    test('position at insertion point, assoc=1 (after)', () {
      final cs = ChangeSet.of(10, [const ChangeSpec.insert(5, 'XY')]);
      expect(cs.mapPos(5, assoc: 1), 7); // mapped to after the inserted text
    });

    test('position at insertion point, assoc=-1 (before)', () {
      final cs = ChangeSet.of(10, [const ChangeSpec.insert(5, 'XY')]);
      expect(cs.mapPos(5, assoc: -1), 5); // mapped to before the inserted text
    });

    test('position after deletion is shifted back', () {
      final cs = ChangeSet.of(
        10,
        [const ChangeSpec(from: 2, to: 5, insert: '')],
      );
      expect(cs.mapPos(7), 4); // shifted back by 3
    });

    test('position inside deleted range maps to deletion start', () {
      final cs = ChangeSet.of(
        10,
        [const ChangeSpec(from: 2, to: 5, insert: '')],
      );
      expect(cs.mapPos(3), 2);
    });

    test('position before deletion is unchanged', () {
      final cs = ChangeSet.of(
        10,
        [const ChangeSpec(from: 5, to: 8, insert: '')],
      );
      expect(cs.mapPos(3), 3);
    });
  });

  // ---------------------------------------------------------------------------
  // ChangeSet.compose
  // ---------------------------------------------------------------------------
  group('ChangeSet.compose', () {
    test('two sequential insertions compose correctly', () {
      final rope = Rope.fromString('hello');
      // First: insert ' world' at end -> 'hello world'
      final cs1 = ChangeSet.of(5, [const ChangeSpec.insert(5, ' world')]);
      // Second: insert '!' at end of new doc -> 'hello world!'
      final cs2 = ChangeSet.of(11, [const ChangeSpec.insert(11, '!')]);
      final composed = cs1.compose(cs2);
      expect(composed.apply(rope).sliceString(0), 'hello world!');
    });

    test('insertion then deletion compose correctly', () {
      final rope = Rope.fromString('hello world');
      // First: insert 'X' at pos 5 -> 'helloX world'
      final cs1 = ChangeSet.of(11, [const ChangeSpec.insert(5, 'X')]);
      // Second: delete 'X world' (positions 5..12 in new doc) -> 'hello'
      final cs2 = ChangeSet.of(
        12,
        [const ChangeSpec(from: 5, to: 12, insert: '')],
      );
      final composed = cs1.compose(cs2);
      expect(composed.apply(rope).sliceString(0), 'hello');
    });
  });

  // ---------------------------------------------------------------------------
  // ChangeSet.invert
  // ---------------------------------------------------------------------------
  group('ChangeSet.invert', () {
    test('invert insertion becomes deletion (round-trip)', () {
      final original = Rope.fromString('hello');
      final cs = ChangeSet.of(5, [const ChangeSpec.insert(2, 'XY')]);
      final modified = cs.apply(original); // 'heXYllo'
      final inv = cs.invert(original);
      final restored = inv.apply(modified);
      expect(restored.sliceString(0), 'hello');
    });

    test('invert deletion becomes insertion (round-trip)', () {
      final original = Rope.fromString('hello world');
      final cs = ChangeSet.of(
        11,
        [const ChangeSpec(from: 5, to: 11, insert: '')],
      );
      final modified = cs.apply(original); // 'hello'
      final inv = cs.invert(original);
      final restored = inv.apply(modified);
      expect(restored.sliceString(0), 'hello world');
    });

    test('invert replacement (round-trip)', () {
      final original = Rope.fromString('hello world');
      final cs = ChangeSet.of(
        11,
        [const ChangeSpec(from: 6, to: 11, insert: 'Dart')],
      );
      final modified = cs.apply(original); // 'hello Dart'
      final inv = cs.invert(original);
      final restored = inv.apply(modified);
      expect(restored.sliceString(0), 'hello world');
    });

    test('invert of multiple changes (round-trip)', () {
      final original = Rope.fromString('abcdefghij');
      final cs = ChangeSet.of(10, [
        const ChangeSpec(from: 0, to: 3, insert: 'XYZ'),
        const ChangeSpec(from: 7, to: 10, insert: ''),
      ]);
      final modified = cs.apply(original);
      final inv = cs.invert(original);
      final restored = inv.apply(modified);
      expect(restored.sliceString(0), 'abcdefghij');
    });
  });
}
