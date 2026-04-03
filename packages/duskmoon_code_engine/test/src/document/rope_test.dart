import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Line', () {
    test('length is to - from', () {
      const line = Line(number: 1, from: 0, to: 5, text: 'hello');
      expect(line.length, 5);
    });

    test('toString includes fields', () {
      const line = Line(number: 2, from: 6, to: 10, text: 'test');
      expect(line.toString(), 'Line(2, 6..10, "test")');
    });
  });

  group('RopeLeaf', () {
    test('stores text and reports length', () {
      final leaf = RopeLeaf('hello');
      expect(leaf.text, 'hello');
      expect(leaf.length, 5);
    });

    test('empty leaf has length 0 and lineCount 1', () {
      final leaf = RopeLeaf('');
      expect(leaf.length, 0);
      expect(leaf.lineCount, 1);
    });

    test('single line has lineCount 1', () {
      final leaf = RopeLeaf('hello world');
      expect(leaf.lineCount, 1);
    });

    test('text with one newline has lineCount 2', () {
      final leaf = RopeLeaf('hello\nworld');
      expect(leaf.lineCount, 2);
    });

    test('trailing newline adds a line', () {
      final leaf = RopeLeaf('hello\n');
      expect(leaf.lineCount, 2);
    });

    test('multiple newlines count correctly', () {
      final leaf = RopeLeaf('a\nb\nc');
      expect(leaf.lineCount, 3);
    });
  });

  group('RopeBranch', () {
    test('combines length of children', () {
      final left = RopeLeaf('hello');
      final right = RopeLeaf(' world');
      final branch = RopeBranch(left, right);
      expect(branch.length, 11);
    });

    test('single-line children produce correct lineCount', () {
      final left = RopeLeaf('hello');
      final right = RopeLeaf(' world');
      final branch = RopeBranch(left, right);
      // left=1, right=1, combined = 1+1-1 = 1
      expect(branch.lineCount, 1);
    });

    test('multi-line children subtract overlap correctly', () {
      final left = RopeLeaf('hello\nworld');
      final right = RopeLeaf('\nfoo');
      final branch = RopeBranch(left, right);
      // left=2, right=2, combined = 2+2-1 = 3
      expect(branch.lineCount, 3);
    });

    test('both children have trailing/leading newlines', () {
      final left = RopeLeaf('line1\n');
      final right = RopeLeaf('line2\n');
      final branch = RopeBranch(left, right);
      // left=2, right=2, combined = 2+2-1 = 3
      expect(branch.lineCount, 3);
    });
  });

  group('Rope.fromString', () {
    test('short text creates single leaf', () {
      final rope = Rope.fromString('hello');
      expect(rope.length, 5);
      expect(rope.root, isA<RopeLeaf>());
    });

    test('empty string', () {
      final rope = Rope.fromString('');
      expect(rope.length, 0);
      expect(rope.lineCount, 1);
    });

    test('long text splits into branch', () {
      final text = 'a' * 2048;
      final rope = Rope.fromString(text);
      expect(rope.length, 2048);
      expect(rope.root, isA<RopeBranch>());
    });

    test('text exactly at leaf max stays as leaf', () {
      final text = 'x' * 1024;
      final rope = Rope.fromString(text);
      expect(rope.length, 1024);
      expect(rope.root, isA<RopeLeaf>());
    });

    test('text just over leaf max splits', () {
      final text = 'x' * 1025;
      final rope = Rope.fromString(text);
      expect(rope.length, 1025);
      expect(rope.root, isA<RopeBranch>());
    });

    test('line count from string with newlines', () {
      final rope = Rope.fromString('a\nb\nc');
      expect(rope.lineCount, 3);
    });
  });

  group('charAt', () {
    test('returns character at offset', () {
      final rope = Rope.fromString('hello');
      expect(rope.charAt(0), 'h');
      expect(rope.charAt(4), 'o');
    });

    test('accesses character across branch boundary', () {
      final text = '${'a' * 1024}b';
      final rope = Rope.fromString(text);
      expect(rope.charAt(1024), 'b');
      expect(rope.charAt(0), 'a');
    });
  });

  group('sliceString', () {
    test('basic substring', () {
      final rope = Rope.fromString('hello world');
      expect(rope.sliceString(0, 5), 'hello');
      expect(rope.sliceString(6, 11), 'world');
    });

    test('to-end when to omitted', () {
      final rope = Rope.fromString('hello world');
      expect(rope.sliceString(6), 'world');
    });

    test('full string when from=0 and to omitted', () {
      final rope = Rope.fromString('hello');
      expect(rope.sliceString(0), 'hello');
    });

    test('across branch boundary', () {
      final text = '${'a' * 512}hello${'b' * 512}';
      final rope = Rope.fromString(text);
      expect(rope.sliceString(510, 519), 'aahellobb');
    });
  });

  group('splice', () {
    test('insert at offset', () {
      final rope = Rope.fromString('hello world');
      final result = rope.splice(5, 5, ',');
      expect(result.sliceString(0), 'hello, world');
    });

    test('delete range', () {
      final rope = Rope.fromString('hello world');
      final result = rope.splice(5, 6, '');
      expect(result.sliceString(0), 'helloworld');
    });

    test('replace range', () {
      final rope = Rope.fromString('hello world');
      final result = rope.splice(6, 11, 'Dart');
      expect(result.sliceString(0), 'hello Dart');
    });

    test('insert at start', () {
      final rope = Rope.fromString('world');
      final result = rope.splice(0, 0, 'hello ');
      expect(result.sliceString(0), 'hello world');
    });

    test('insert at end', () {
      final rope = Rope.fromString('hello');
      final result = rope.splice(5, 5, ' world');
      expect(result.sliceString(0), 'hello world');
    });

    test('line count updates when inserting newlines', () {
      final rope = Rope.fromString('hello world');
      expect(rope.lineCount, 1);
      final result = rope.splice(5, 5, '\n');
      expect(result.lineCount, 2);
    });

    test('line count updates when deleting newlines', () {
      final rope = Rope.fromString('hello\nworld');
      expect(rope.lineCount, 2);
      final result = rope.splice(5, 6, '');
      expect(result.lineCount, 1);
    });

    test('original rope is unchanged (immutable)', () {
      final rope = Rope.fromString('hello');
      rope.splice(0, 0, 'X');
      expect(rope.sliceString(0), 'hello');
    });
  });

  group('lineAt', () {
    late Rope multiLine;

    setUp(() {
      multiLine = Rope.fromString('hello\nworld\nfoo');
    });

    test('single-line doc returns line 1', () {
      final rope = Rope.fromString('hello');
      final line = rope.lineAt(1);
      expect(line.number, 1);
      expect(line.from, 0);
      expect(line.to, 5);
      expect(line.text, 'hello');
    });

    test('first line of multi-line doc', () {
      final line = multiLine.lineAt(1);
      expect(line.number, 1);
      expect(line.from, 0);
      expect(line.to, 5);
      expect(line.text, 'hello');
    });

    test('second line of multi-line doc', () {
      final line = multiLine.lineAt(2);
      expect(line.number, 2);
      expect(line.from, 6);
      expect(line.to, 11);
      expect(line.text, 'world');
    });

    test('last line of multi-line doc', () {
      final line = multiLine.lineAt(3);
      expect(line.number, 3);
      expect(line.from, 12);
      expect(line.to, 15);
      expect(line.text, 'foo');
    });

    test('trailing newline creates empty last line', () {
      final rope = Rope.fromString('hello\n');
      final line = rope.lineAt(2);
      expect(line.number, 2);
      expect(line.from, 6);
      expect(line.to, 6);
      expect(line.text, '');
    });
  });

  group('lineAtOffset', () {
    late Rope multiLine;

    setUp(() {
      multiLine = Rope.fromString('hello\nworld\nfoo');
    });

    test('offset 0 is line 1', () {
      final line = multiLine.lineAtOffset(0);
      expect(line.number, 1);
    });

    test('offset at end of first line content', () {
      final line = multiLine.lineAtOffset(4);
      expect(line.number, 1);
    });

    test('offset on newline character stays in current line', () {
      // offset 5 is '\n' — belongs to line 1
      final line = multiLine.lineAtOffset(5);
      expect(line.number, 1);
    });

    test('offset at start of second line', () {
      final line = multiLine.lineAtOffset(6);
      expect(line.number, 2);
    });

    test('offset in middle of last line', () {
      final line = multiLine.lineAtOffset(13);
      expect(line.number, 3);
    });

    test('offset at last character', () {
      final line = multiLine.lineAtOffset(14);
      expect(line.number, 3);
    });
  });

  group('linesInRange', () {
    test('returns correct lines for range', () {
      final rope = Rope.fromString('a\nb\nc\nd');
      final lines = rope.linesInRange(2, 3).toList();
      expect(lines.length, 2);
      expect(lines[0].number, 2);
      expect(lines[0].text, 'b');
      expect(lines[1].number, 3);
      expect(lines[1].text, 'c');
    });

    test('single line range', () {
      final rope = Rope.fromString('a\nb\nc');
      final lines = rope.linesInRange(2, 2).toList();
      expect(lines.length, 1);
      expect(lines[0].text, 'b');
    });
  });
}
