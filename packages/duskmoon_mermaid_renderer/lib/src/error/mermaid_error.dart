sealed class MermaidError implements Exception {
  const MermaidError(this.message);

  final String message;

  @override
  String toString() => message;
}

final class MermaidParseError extends MermaidError {
  const MermaidParseError(super.message, {this.line, this.column});

  final int? line;
  final int? column;

  @override
  String toString() {
    final location = line == null ? '' : ' at $line:${column ?? 1}';
    return 'Mermaid parse error$location: $message';
  }
}

final class UnsupportedDiagramError extends MermaidError {
  const UnsupportedDiagramError(this.kind)
      : super('Unsupported diagram: $kind');

  final Object kind;
}

final class MermaidRenderError extends MermaidError {
  const MermaidRenderError(super.message);
}

final class MermaidDiagnostic {
  const MermaidDiagnostic(this.message, {this.line, this.column});

  final String message;
  final int? line;
  final int? column;
}
