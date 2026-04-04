import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ---------------------------------------------------------------------------
  // SelectionRange
  // ---------------------------------------------------------------------------
  group('SelectionRange', () {
    test('cursor creates collapsed range', () {
      const r = SelectionRange.cursor(5);
      expect(r.anchor, 5);
      expect(r.head, 5);
      expect(r.from, 5);
      expect(r.to, 5);
      expect(r.isEmpty, isTrue);
    });

    test('range with anchor before head', () {
      const r = SelectionRange(anchor: 2, head: 8);
      expect(r.from, 2);
      expect(r.to, 8);
      expect(r.isEmpty, isFalse);
    });

    test('range with head before anchor: from/to still correct', () {
      const r = SelectionRange(anchor: 10, head: 3);
      expect(r.from, 3);
      expect(r.to, 10);
      expect(r.isEmpty, isFalse);
    });

    test('equality and hashCode', () {
      const a = SelectionRange(anchor: 1, head: 4);
      const b = SelectionRange(anchor: 1, head: 4);
      const c = SelectionRange(anchor: 1, head: 5);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('toString: cursor', () {
      const r = SelectionRange.cursor(7);
      expect(r.toString(), 'Cursor(7)');
    });

    test('toString: selection', () {
      const r = SelectionRange(anchor: 2, head: 6);
      expect(r.toString(), 'Selection(2→6)');
    });

    test('map through insertion changeset', () {
      // doc "hello" (len=5), insert "XY" at pos 2 → "heXYllo" (len=7)
      final cs = ChangeSet.of(5, [const ChangeSpec.insert(2, 'XY')]);
      // anchor at 3, head at 5 → after mapping:
      // pos 3 (after insert point, assoc=-1) → 3+2=5
      // pos 5 (after insert point, assoc=1)  → 5+2=7
      const r = SelectionRange(anchor: 3, head: 5);
      final mapped = r.map(cs);
      expect(mapped.anchor, 5);
      expect(mapped.head, 7);
    });

    test('map cursor sitting at insertion point uses assoc', () {
      // doc "abc" (len=3), insert "X" at pos 1 → "aXbc" (len=4)
      final cs = ChangeSet.of(3, [const ChangeSpec.insert(1, 'X')]);
      // anchor mapped with assoc=-1 stays before inserted text → 1
      // head mapped with assoc=1 goes after inserted text → 2
      const r = SelectionRange(anchor: 1, head: 1);
      final mapped = r.map(cs);
      expect(mapped.anchor, 1);
      expect(mapped.head, 2);
    });
  });

  // ---------------------------------------------------------------------------
  // EditorSelection
  // ---------------------------------------------------------------------------
  group('EditorSelection', () {
    test('single cursor factory', () {
      final sel = EditorSelection.cursor(4);
      expect(sel.ranges.length, 1);
      expect(sel.main.isEmpty, isTrue);
      expect(sel.main.head, 4);
      expect(sel.mainIndex, 0);
    });

    test('single range factory', () {
      final sel = EditorSelection.single(anchor: 2, head: 9);
      expect(sel.ranges.length, 1);
      expect(sel.main.anchor, 2);
      expect(sel.main.head, 9);
    });

    test('multiple ranges with main index', () {
      const sel = EditorSelection(
        ranges: [
          SelectionRange.cursor(0),
          SelectionRange(anchor: 5, head: 10),
          SelectionRange.cursor(15),
        ],
        mainIndex: 1,
      );
      expect(sel.ranges.length, 3);
      expect(sel.main, equals(const SelectionRange(anchor: 5, head: 10)));
      expect(sel.mainIndex, 1);
    });

    test('equality and hashCode', () {
      final a = EditorSelection.cursor(3);
      final b = EditorSelection.cursor(3);
      final c = EditorSelection.cursor(4);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('map through changeset updates all ranges', () {
      // doc "hello world" (len=11), insert "XX" at pos 5 → "helloXX world" (len=13)
      final cs = ChangeSet.of(11, [const ChangeSpec.insert(5, 'XX')]);
      const sel = EditorSelection(
        ranges: [
          SelectionRange.cursor(2), // before insert
          SelectionRange(anchor: 6, head: 10), // after insert
        ],
        mainIndex: 1,
      );
      final mapped = sel.map(cs);
      expect(mapped.ranges.length, 2);
      // pos 2 is before the insertion at 5, unchanged
      expect(mapped.ranges[0].anchor, 2);
      expect(mapped.ranges[0].head, 2);
      // anchor 6 (after pos 5, assoc=-1) → 6+2=8
      // head 10 (after pos 5, assoc=1) → 10+2=12
      expect(mapped.ranges[1].anchor, 8);
      expect(mapped.ranges[1].head, 12);
      expect(mapped.mainIndex, 1);
    });

    test('toString includes mainIndex and ranges', () {
      final sel = EditorSelection.cursor(0);
      expect(sel.toString(), contains('main=0'));
      expect(sel.toString(), contains('Cursor(0)'));
    });
  });
}
