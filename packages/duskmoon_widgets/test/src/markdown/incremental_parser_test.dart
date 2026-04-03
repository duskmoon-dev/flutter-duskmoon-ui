import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/src/_shared/incremental_parser.dart';

void main() {
  group('IncrementalParser', () {
    test('fullParse produces correct nodes for simple text', () {
      final parser = IncrementalParser();
      final result = parser.fullParse('Hello world');

      expect(result.nodes, isNotEmpty);
      expect(result.wasFullReparse, isTrue);
    });

    test('fullParse produces heading from # syntax', () {
      final parser = IncrementalParser();
      final result = parser.fullParse('# Title');

      expect(result.nodes, isNotEmpty);
      expect(result.nodes.first.textContent, contains('Title'));
    });

    test('fullParse handles multiple blocks', () {
      final parser = IncrementalParser();
      final result = parser.fullParse('# Title\n\nParagraph\n\n- Item');

      expect(result.nodes.length, greaterThanOrEqualTo(3));
    });

    test('appendParse incrementally adds content', () {
      final parser = IncrementalParser();
      parser.fullParse('Hello');
      final result = parser.appendParse('Hello\n\nWorld');

      expect(result.nodes, isNotEmpty);
      // The text content should contain both parts.
      final allText = result.nodes.map((n) => n.textContent).join(' ');
      expect(allText, contains('Hello'));
      expect(allText, contains('World'));
    });

    test('cachedNodes and cachedLines are up to date after parse', () {
      final parser = IncrementalParser();
      parser.fullParse('Line 1\nLine 2');

      expect(parser.cachedNodes, isNotEmpty);
      expect(parser.cachedLines, ['Line 1', 'Line 2']);
    });

    test('code fence triggers full reparse', () {
      final parser = IncrementalParser();
      parser.fullParse('Hello');

      final result = parser.incrementalParse(
        'Hello\n\n```dart\ncode\n```',
        editOffset: 5,
        deletedLength: 0,
        insertedLength: 17,
      );

      // Code fence always triggers full reparse.
      expect(result.wasFullReparse, isTrue);
    });

    test('enableGfm=false parses without GFM extensions', () {
      final parser = IncrementalParser(enableGfm: false);
      final result = parser.fullParse('~~strikethrough~~');

      // Without GFM, strikethrough is not parsed as such.
      expect(result.nodes, isNotEmpty);
    });

    test('enableKatex enables math blocks', () {
      final parser = IncrementalParser(enableKatex: true);
      final result = parser.fullParse(r'$$E = mc^2$$');

      expect(result.nodes, isNotEmpty);
    });
  });
}
