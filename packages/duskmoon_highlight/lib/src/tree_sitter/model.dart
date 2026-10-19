/// A copied syntax tree, independent of the parser's native tree lifetime.
final class SyntaxSnapshot {
  final String language;
  final String source;
  final SyntaxNode rootNode;
  final List<SyntaxCapture> captures;
  final bool incremental;

  SyntaxSnapshot({
    required this.language,
    required this.source,
    required this.rootNode,
    required Iterable<SyntaxCapture> captures,
    required this.incremental,
  }) : captures = List.unmodifiable(captures);
}

/// A syntax node. All offsets count UTF-16 code units, as Dart strings do.
final class SyntaxNode {
  final String type;
  final int from;
  final int to;
  final List<SyntaxNode> children;
  final bool isNamed;
  final bool hasError;

  SyntaxNode({
    required this.type,
    required this.from,
    required this.to,
    required Iterable<SyntaxNode> children,
    required this.isNamed,
    required this.hasError,
  }) : children = List.unmodifiable(children);
}

/// A highlight query capture, including explicit query priority when supplied.
final class SyntaxCapture {
  final String name;
  final int from;
  final int to;
  final int priority;
  final int patternIndex;

  const SyntaxCapture({
    required this.name,
    required this.from,
    required this.to,
    this.priority = 0,
    this.patternIndex = 0,
  });
}
