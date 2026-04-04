import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PositionUtils', () {
    group('lineForY', () {
      test('y=0 returns line 0', () {
        expect(PositionUtils.lineForY(0, lineHeight: 20), 0);
      });

      test('y in middle of line 2 returns line 2', () {
        // lineHeight=20, line 2 spans y=40..60, midpoint y=50
        expect(PositionUtils.lineForY(50, lineHeight: 20), 2);
      });

      test('negative y clamps to 0', () {
        expect(PositionUtils.lineForY(-10, lineHeight: 20), 0);
      });

      test('clamps to maxLine', () {
        expect(PositionUtils.lineForY(1000, lineHeight: 20, maxLine: 3), 3);
      });

      test('y exactly on line boundary returns that line', () {
        expect(PositionUtils.lineForY(40, lineHeight: 20), 2);
      });
    });

    group('yForLine', () {
      test('line 0 returns y=0', () {
        expect(PositionUtils.yForLine(0, lineHeight: 20), 0.0);
      });

      test('line 3 returns 3*lineHeight', () {
        expect(PositionUtils.yForLine(3, lineHeight: 20), 60.0);
      });

      test('line 1 returns lineHeight', () {
        expect(PositionUtils.yForLine(1, lineHeight: 16), 16.0);
      });
    });

    group('offsetInLine', () {
      // "line1\nline2\nline3"
      // line 1 (number=1): from=0 to=5  length=5
      // line 2 (number=2): from=6 to=11 length=5
      // line 3 (number=3): from=12 to=17 length=5
      late Document doc;

      setUp(() {
        doc = Document.fromString('line1\nline2\nline3');
      });

      test('offset in first line gives lineIndex=0, correct column', () {
        final lc = PositionUtils.offsetInLine(3, doc);
        expect(lc.lineIndex, 0);
        expect(lc.column, 3);
      });

      test('offset at start of line 2 gives lineIndex=1, column=0', () {
        final lc = PositionUtils.offsetInLine(6, doc);
        expect(lc.lineIndex, 1);
        expect(lc.column, 0);
      });

      test('offset in middle of line 2 gives correct lineIndex and column', () {
        final lc = PositionUtils.offsetInLine(8, doc);
        expect(lc.lineIndex, 1);
        expect(lc.column, 2);
      });

      test('offset at start of document gives lineIndex=0, column=0', () {
        final lc = PositionUtils.offsetInLine(0, doc);
        expect(lc.lineIndex, 0);
        expect(lc.column, 0);
      });
    });

    group('offsetFromLineCol', () {
      late Document doc;

      setUp(() {
        doc = Document.fromString('line1\nline2\nline3');
      });

      test('converts lineIndex=0, column=0 to offset 0', () {
        expect(PositionUtils.offsetFromLineCol(0, 0, doc), 0);
      });

      test('converts lineIndex=1, column=0 to start of line 2', () {
        expect(PositionUtils.offsetFromLineCol(1, 0, doc), 6);
      });

      test('converts lineIndex=1, column=3 correctly', () {
        expect(PositionUtils.offsetFromLineCol(1, 3, doc), 9);
      });

      test('clamps column to line length', () {
        // line 1 has length 5; clamping column=100 gives from+5=5
        expect(PositionUtils.offsetFromLineCol(0, 100, doc), 5);
      });

      test('lineIndex beyond lineCount returns doc.length', () {
        expect(PositionUtils.offsetFromLineCol(99, 0, doc), doc.length);
      });

      test('round-trips with offsetInLine', () {
        const offset = 9;
        final lc = PositionUtils.offsetInLine(offset, doc);
        final back =
            PositionUtils.offsetFromLineCol(lc.lineIndex, lc.column, doc);
        expect(back, offset);
      });
    });
  });
}
