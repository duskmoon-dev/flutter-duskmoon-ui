import 'dart:async';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:duskmoon_widgets/src/_shared/incremental_parser.dart';
import 'package:duskmoon_widgets/src/_shared/math_syntax.dart';
import 'package:duskmoon_widgets/src/markdown/_stream_handler.dart';
import 'package:duskmoon_widgets/src/vendor/markdown/markdown.dart' as patched;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as hosted;

void main() {
  group('patched Markdown parser', () {
    for (final source in [
      r'[\',
      '[a]: <',
      r'[a]: <\',
      r'[a]: \',
      r'[a]: /url "\',
    ]) {
      test('accepts incomplete link input ${source.codeUnits}', () {
        expect(() => IncrementalParser().fullParse(source), returnsNormally);
      });
    }

    test('retreating table and reference rules fall back to a paragraph', () {
      final nodes =
          IncrementalParser().fullParse('[a]: /b (c\n| :--- | ---: |\n').nodes;
      expect(nodes, hasLength(1));
      expect((nodes.single as hosted.Element).tag, 'p');
      expect(nodes.single.textContent, contains('[a]: /b (c'));
      expect(nodes.single.textContent, contains('| :--- | ---: |'));
    });

    test('reference destinations require balanced parentheses', () {
      final invalid = IncrementalParser().fullParse('[a]: /url)\n\n[a]');
      expect(invalid.nodes.last.textContent, '[a]');
      final valid = IncrementalParser().fullParse('[a]: /url(a)b\n\n[a]');
      final link = (valid.nodes.single as hosted.Element).children!.single
          as hosted.Element;
      expect(link.tag, 'a');
      expect(link.attributes['href'], '/url(a)b');
    });

    test('consecutive references read each line a bounded number of times', () {
      const count = 100;
      final lines = [
        for (var i = 1; i <= count; i++)
          _CountingLine('[#$i]: https://example.com/pull/$i'),
        _CountingLine(''),
        _CountingLine('See [#1] and [#$count].'),
      ];
      final nodes = patched.Document(
        extensionSet: patched.ExtensionSet.gitHubFlavored,
      ).parseLineList(lines);
      final links = (nodes.single as hosted.Element)
          .children!
          .whereType<hosted.Element>()
          .where((node) => node.tag == 'a');
      expect(links.map((node) => node.attributes['href']), [
        'https://example.com/pull/1',
        'https://example.com/pull/$count',
      ]);
      for (final line in lines) {
        expect(line.reads, lessThan(20));
      }
    });

    for (final customSyntax in [false, true]) {
      test('long words advance in bounded steps (custom=$customSyntax)', () {
        final source = 'a' * 4096;
        final parser = _CountingInlineParser(
          source,
          patched.Document(
            inlineSyntaxes: customSyntax ? dmInlineSyntaxes() : [],
          ),
        );
        expect(parser.parse().single.textContent, source);
        expect(parser.advances, lessThan(10));
        expect(
          IncrementalParser().fullParse(source).nodes.single.textContent,
          source,
        );
      });
    }

    test('footnotes ending in a list use the shared mutable AST', () {
      final nodes = patched.Document(
        extensionSet: patched.ExtensionSet.gitHubWeb,
      ).parseLines(['[^1]', '', '[^1]: - note']);
      expect(nodes.last, isA<hosted.Element>());
      expect(nodes.last.textContent, contains('note'));
      expect(nodes.last.textContent, contains('↩'));
    });

    test(
      'streaming incomplete link input completes without parser errors',
      () async {
        final controller = StreamController<String>(sync: true);
        final updates = <List<hosted.Node>>[];
        final handler = StreamHandler(
          stream: controller.stream,
          parser: IncrementalParser(),
          onNodesChanged: updates.add,
        );
        addTearDown(handler.dispose);
        controller.add('[a]: <');
        controller.add('https://example.com>');
        controller.add('\n\n[a]');
        await controller.close();
        expect(updates, hasLength(4));
        final link = (updates.last.single as hosted.Element).children!.single
            as hosted.Element;
        expect(link.attributes['href'], 'https://example.com');
      },
    );

    test('parsed values accept a visitor from the hosted public AST', () {
      final List<hosted.Node> nodes =
          IncrementalParser().fullParse('Hello **world**').nodes;
      final visitor = _HostedVisitor();
      for (final node in nodes) {
        node.accept(visitor);
      }
      expect(visitor.tags, ['p', 'strong']);
      expect(visitor.text, ['Hello ', 'world']);
    });
  });

  for (final widgetSpan in [false, true]) {
    testWidgets(
        'public inline builders accept hosted AST and render context '
        '(WidgetSpan=$widgetSpan)', (tester) async {
      final strong = hosted.Element.text('strong', 'caller value');
      final paragraph = hosted.Element('p', [strong]);
      final theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      );
      hosted.Element? received;
      ThemeData? receivedTheme;
      DmMarkdown? ancestor;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmMarkdown(
              nodes: [paragraph],
              themeData: theme,
              config: DmMarkdownConfig(
                inlineBuilders: {
                  'strong': (hosted.Element element, BuildContext context) {
                    received = element;
                    receivedTheme = Theme.of(context);
                    ancestor =
                        context.findAncestorWidgetOfExactType<DmMarkdown>();
                    return widgetSpan
                        ? WidgetSpan(child: Text(element.textContent))
                        : TextSpan(text: element.textContent);
                  },
                },
              ),
            ),
          ),
        ),
      );
      expect(received, same(strong));
      expect(receivedTheme?.colorScheme, theme.colorScheme);
      expect(ancestor, isNotNull);
      expect(find.text('caller value'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('patched parsed nodes reach public hosted-AST block builders', (
    tester,
  ) async {
    hosted.Element? received;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmMarkdown(
            data: '[a]: <',
            config: DmMarkdownConfig(
              blockBuilders: {
                'p': (hosted.Element element, BuildContext context) {
                  received = element;
                  return Text(element.textContent);
                },
              },
            ),
          ),
        ),
      ),
    );
    expect(received, isA<hosted.Element>());
    expect(find.text('[a]: <'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _CountingLine extends patched.Line {
  int reads = 0;
  _CountingLine(super.content);

  @override
  String get content {
    reads++;
    return super.content;
  }
}

class _CountingInlineParser extends patched.InlineParser {
  int advances = 0;
  _CountingInlineParser(super.source, super.document);

  @override
  void advanceBy(int length) {
    advances++;
    super.advanceBy(length);
  }
}

class _HostedVisitor implements hosted.NodeVisitor {
  final tags = <String>[];
  final text = <String>[];

  @override
  bool visitElementBefore(hosted.Element element) {
    tags.add(element.tag);
    return true;
  }

  @override
  void visitElementAfter(hosted.Element element) {}

  @override
  void visitText(hosted.Text node) => text.add(node.text);
}
