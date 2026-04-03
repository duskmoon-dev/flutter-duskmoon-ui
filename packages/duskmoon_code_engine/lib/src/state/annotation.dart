/// Typed key for attaching metadata to transactions.
class AnnotationType<T> {
  const AnnotationType();
}

/// An annotation instance carrying a typed value.
class Annotation<T> {
  const Annotation(this.type, this.value);
  final AnnotationType<T> type;
  final T value;
}

/// Well-known annotations used by the core system.
abstract final class Annotations {
  static const userEvent = AnnotationType<String>();
  static const addToHistory = AnnotationType<bool>();
  static const remote = AnnotationType<bool>();
}
