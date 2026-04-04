import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Document', () {
    group('creation', () {
      test('fromString reports correct length', () {
        final doc = Document.fromString('hello');
        expect(doc.length, 5);
      });

      test('fromString single line has lineCount 1', () {
        final doc = Document.fromString('hello');
        expect(doc.lineCount, 1);
      });

      test('empty document has length 0 and lineCount 1', () {
        expect(Document.empty.length, 0);
        expect(Document.empty.lineCount, 1);
      });

      test('empty static field returns empty document', () {
        expect(Document.empty.toString(), '');
      });

      test('multi-line document reports correct lineCount', () {
        final doc = Document.fromString('line1\nline2\nline3');
        expect(doc.lineCount, 3);
      });

      test('multi-line document reports correct length', () {
        final doc = Document.fromString('line1\nline2\nline3');
        expect(doc.length, 17);
      });
    });

    group('sliceString', () {
      test('extracts a substring', () {
        final doc = Document.fromString('hello world');
        expect(doc.sliceString(6, 11), 'world');
      });

      test('extracts from start to end when to is omitted', () {
        final doc = Document.fromString('hello world');
        expect(doc.sliceString(6), 'world');
      });

      test('full document slice from 0', () {
        final doc = Document.fromString('hello');
        expect(doc.sliceString(0), 'hello');
      });

      test('zero-length slice returns empty string', () {
        final doc = Document.fromString('hello');
        expect(doc.sliceString(2, 2), '');
      });
    });

    group('lineAt', () {
      test('returns correct Line for line 1', () {
        final doc = Document.fromString('hello\nworld');
        final line = doc.lineAt(1);
        expect(line.number, 1);
        expect(line.text, 'hello');
        expect(line.from, 0);
        expect(line.to, 5);
      });

      test('returns correct Line for line 2', () {
        final doc = Document.fromString('hello\nworld');
        final line = doc.lineAt(2);
        expect(line.number, 2);
        expect(line.text, 'world');
        expect(line.from, 6);
        expect(line.to, 11);
      });

      test('single line document returns line 1', () {
        final doc = Document.fromString('only line');
        final line = doc.lineAt(1);
        expect(line.number, 1);
        expect(line.text, 'only line');
      });
    });

    group('lineAtOffset', () {
      test('offset 0 returns line 1', () {
        final doc = Document.fromString('hello\nworld');
        final line = doc.lineAtOffset(0);
        expect(line.number, 1);
      });

      test('offset within second line returns line 2', () {
        final doc = Document.fromString('hello\nworld');
        final line = doc.lineAtOffset(7);
        expect(line.number, 2);
        expect(line.text, 'world');
      });

      test('offset at end of document returns last line', () {
        final doc = Document.fromString('hello\nworld');
        final line = doc.lineAtOffset(11);
        expect(line.number, 2);
      });
    });

    group('replace', () {
      test('applies changeset and returns new document', () {
        final doc = Document.fromString('hello world');
        final changes = ChangeSet.of(
          doc.length,
          [const ChangeSpec(from: 0, to: 5, insert: 'goodbye')],
        );
        final newDoc = doc.replace(changes);
        expect(newDoc.toString(), 'goodbye world');
      });

      test('original document is unchanged after replace (immutability)', () {
        final doc = Document.fromString('hello world');
        final changes = ChangeSet.of(
          doc.length,
          [const ChangeSpec(from: 0, to: 5, insert: 'goodbye')],
        );
        doc.replace(changes);
        expect(doc.toString(), 'hello world');
      });

      test('pure insertion returns new document with inserted text', () {
        final doc = Document.fromString('hello');
        final changes = ChangeSet.of(
          doc.length,
          [const ChangeSpec.insert(5, ' world')],
        );
        final newDoc = doc.replace(changes);
        expect(newDoc.toString(), 'hello world');
      });

      test('pure deletion returns new document without deleted text', () {
        final doc = Document.fromString('hello world');
        final changes = ChangeSet.of(
          doc.length,
          [const ChangeSpec(from: 5, to: 11)],
        );
        final newDoc = doc.replace(changes);
        expect(newDoc.toString(), 'hello');
      });
    });

    group('linesInRange', () {
      test('iterates correct lines in range', () {
        final doc = Document.fromString('line1\nline2\nline3\nline4');
        final lines = doc.linesInRange(2, 3).toList();
        expect(lines.length, 2);
        expect(lines[0].text, 'line2');
        expect(lines[1].text, 'line3');
      });

      test('single-line range returns one line', () {
        final doc = Document.fromString('line1\nline2\nline3');
        final lines = doc.linesInRange(2, 2).toList();
        expect(lines.length, 1);
        expect(lines[0].text, 'line2');
      });

      test('full range iterates all lines', () {
        final doc = Document.fromString('a\nb\nc');
        final lines = doc.linesInRange(1, 3).toList();
        expect(lines.length, 3);
        expect(lines.map((l) => l.text).toList(), ['a', 'b', 'c']);
      });
    });

    group('toString', () {
      test('returns full document text', () {
        final doc = Document.fromString('hello world');
        expect(doc.toString(), 'hello world');
      });

      test('returns empty string for empty document', () {
        expect(Document.empty.toString(), '');
      });

      test('returns full multi-line text', () {
        const text = 'line1\nline2\nline3';
        final doc = Document.fromString(text);
        expect(doc.toString(), text);
      });
    });
  });
}
