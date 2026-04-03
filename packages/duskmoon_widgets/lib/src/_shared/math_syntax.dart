import 'package:markdown/markdown.dart';

/// Custom [InlineSyntax] for inline math: `$...$`.
///
/// Produces an [Element] with tag `math` containing the TeX source.
/// Does not match `$$` (display math) — that is handled by
/// [DisplayMathBlockSyntax].
class InlineMathSyntax extends InlineSyntax {
  /// Creates an inline math syntax matcher.
  InlineMathSyntax() : super(r'\$([^\$\n]+?)\$(?!\$)');

  @override
  bool onMatch(InlineParser parser, Match match) {
    final tex = match[1]!;
    final element = Element.text('math', tex);
    parser.addNode(element);
    return true;
  }
}

/// Custom [BlockSyntax] for display math: `$$...$$`.
///
/// Produces an [Element] with tag `mathBlock` containing the TeX source.
/// The opening `$$` must be on its own line. The block ends at the next
/// `$$` line.
class DisplayMathBlockSyntax extends BlockSyntax {
  /// Creates a display math block syntax matcher.
  const DisplayMathBlockSyntax();

  /// Pattern matching the opening `$$` line.
  static final _openPattern = RegExp(r'^\$\$\s*$');

  /// Pattern matching the closing `$$` line.
  static final _closePattern = RegExp(r'^\$\$\s*$');

  @override
  RegExp get pattern => _openPattern;

  @override
  Node? parse(BlockParser parser) {
    // Skip opening $$
    parser.advance();

    final buffer = StringBuffer();
    while (!parser.isDone) {
      final line = parser.current.content;
      if (_closePattern.hasMatch(line)) {
        parser.advance();
        break;
      }
      if (buffer.isNotEmpty) buffer.writeln();
      buffer.write(line);
      parser.advance();
    }

    final element = Element.text('mathBlock', buffer.toString());
    return element;
  }
}

/// Returns the standard list of custom block syntaxes for DuskMoon markdown.
List<BlockSyntax> dmBlockSyntaxes() => [
      const DisplayMathBlockSyntax(),
    ];

/// Returns the standard list of custom inline syntaxes for DuskMoon markdown.
List<InlineSyntax> dmInlineSyntaxes() => [
      InlineMathSyntax(),
    ];
