import 'change.dart';
import 'rope.dart';
import 'text.dart';

/// Immutable document backed by a [Rope].
/// Every edit produces a new Document via [replace].
class Document {
  Document._(this._rope, [this.version = 0, this._cachedText]);
  final Rope _rope;
  String? _cachedText;

  /// Monotonically increasing revision number for document edits.
  final int version;

  factory Document.fromString(String text) =>
      Document._(Rope.fromString(text), 0, text);
  static final Document empty = Document.fromString('');

  /// Access to the underlying [Rope] data structure.
  Rope get rope => _rope;

  int get length => _rope.length;
  int get lineCount => _rope.lineCount;
  int get maxLineLength => _rope.maxLineLength;
  Line lineAt(int lineNumber) => _rope.lineAt(lineNumber);
  Line lineAtOffset(int offset) => _rope.lineAtOffset(offset);
  String sliceString(int from, [int? to]) => _rope.sliceString(from, to);

  Document replace(ChangeSet changes) {
    if (!changes.docChanged) return this;
    return Document._(changes.apply(_rope), version + 1);
  }

  Iterable<Line> get lines => _rope.linesInRange(1, lineCount);
  Iterable<Line> linesInRange(int fromLine, int toLine) =>
      _rope.linesInRange(fromLine, toLine);

  @override
  String toString() => _cachedText ??= _rope.sliceString(0);
}
