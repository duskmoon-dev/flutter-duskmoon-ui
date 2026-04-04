import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;

import 'package:duskmoon_widgets/src/_shared/math_syntax.dart';

void main() {
  group('MathSyntax', () {
    md.Document createDoc() {
      return md.Document(
        extensionSet: md.ExtensionSet.gitHubFlavored,
        inlineSyntaxes: dmInlineSyntaxes(),
        blockSyntaxes: dmBlockSyntaxes(),
      );
    }

    group('InlineMathSyntax', () {
      test(r'$...$ is parsed as inline math element', () {
        final doc = createDoc();
        final nodes = doc.parseLines([r'Text $E = mc^2$ more text']);

        expect(nodes, isNotEmpty);
        final p = nodes.first as md.Element;
        final mathElements = _findElements(p, 'math');
        expect(mathElements, isNotEmpty);
        expect(mathElements.first.textContent, 'E = mc^2');
      });

      test(r'unmatched $ treated as literal text', () {
        final doc = createDoc();
        final nodes = doc.parseLines([r'Price is $5']);

        expect(nodes, isNotEmpty);
        final text = nodes.first.textContent;
        expect(text, contains(r'$'));
      });

      test('multiple inline math in same line', () {
        final doc = createDoc();
        final nodes = doc.parseLines([r'$a$ and $b$']);

        expect(nodes, isNotEmpty);
        final p = nodes.first as md.Element;
        final mathElements = _findElements(p, 'math');
        expect(mathElements, hasLength(2));
      });
    });

    group('DisplayMathBlockSyntax', () {
      test(r'$$...$$ parsed as display math block', () {
        final doc = createDoc();
        final nodes = doc.parseLines([
          r'$$',
          r'E = mc^2',
          r'$$',
        ]);

        expect(nodes, isNotEmpty);
        final mathBlock = nodes.firstWhere(
          (n) => n is md.Element && n.tag == 'mathBlock',
          orElse: () => md.Text(''),
        );
        expect(mathBlock, isA<md.Element>());
        expect((mathBlock as md.Element).textContent, 'E = mc^2');
      });

      test('display math block with multiple lines', () {
        final doc = createDoc();
        final nodes = doc.parseLines([
          r'$$',
          r'x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}',
          r'$$',
        ]);

        expect(nodes, isNotEmpty);
        final mathBlock = nodes.firstWhere(
          (n) => n is md.Element && n.tag == 'mathBlock',
          orElse: () => md.Text(''),
        );
        expect(mathBlock, isA<md.Element>());
      });
    });
  });
}

/// Recursively finds all [md.Element]s with the given [tag].
List<md.Element> _findElements(md.Node node, String tag) {
  final results = <md.Element>[];
  if (node is md.Element) {
    if (node.tag == tag) results.add(node);
    for (final child in node.children ?? <md.Node>[]) {
      results.addAll(_findElements(child, tag));
    }
  }
  return results;
}
