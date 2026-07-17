import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;

import 'package:duskmoon_widgets/src/_shared/incremental_parser.dart';
import 'package:duskmoon_widgets/src/markdown/dm_markdown_config.dart';

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

    test('breaks defaults to br elements and can be disabled', () {
      final withBreaks = IncrementalParser().fullParse('First\nSecond');
      final withoutBreaks = IncrementalParser(
        breaks: false,
      ).fullParse('First\nSecond');

      final paragraph = withBreaks.nodes.single as md.Element;
      expect(
        paragraph.children!.whereType<md.Element>().map((node) => node.tag),
        contains('br'),
      );
      expect(withoutBreaks.nodes.single.textContent, 'First Second');
    });

    test('front matter renders by default and supports hidden and disabled',
        () {
      const source = '---\ntitle: Example\n---\n# Document';
      final rendered = IncrementalParser().fullParse(source);
      final hidden = IncrementalParser(
        frontMatter: DmFrontMatterMode.hidden,
      ).fullParse(source);
      final disabled = IncrementalParser(
        frontMatter: DmFrontMatterMode.disabled,
      ).fullParse(source);

      expect((rendered.nodes.first as md.Element).tag, 'frontMatter');
      expect(rendered.nodes.first.textContent, 'title: Example');
      expect(hidden.nodes, hasLength(1));
      expect(hidden.nodes.single.textContent, 'Document');
      expect(
        disabled.nodes.whereType<md.Element>().map((node) => node.tag),
        isNot(contains('frontMatter')),
      );
      expect(
        disabled.nodes.map((node) => node.textContent).join(' '),
        contains('title: Example'),
      );
    });

    test('front matter accepts a BOM, CRLF, and dot delimiter', () {
      final result = IncrementalParser().fullParse(
        '\u{feff}---\r\ntitle: Example\r\n...\r\n# Document',
      );

      expect((result.nodes.first as md.Element).tag, 'frontMatter');
      expect(result.nodes.first.textContent, 'title: Example\r');
      expect(result.nodes.last.textContent, 'Document');
    });
  });
}
