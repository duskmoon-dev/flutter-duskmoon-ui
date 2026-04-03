import 'change.dart';
import 'rope.dart';
import 'text.dart';

/// Immutable document backed by a [Rope].
/// Every edit produces a new Document via [replace].
class Document {
  const Document._(this._rope);
  final Rope _rope;

  factory Document.fromString(String text) => Document._(Rope.fromString(text));
  static final Document empty = Document.fromString('');

  int get length => _rope.length;
  int get lineCount => _rope.lineCount;
  Line lineAt(int lineNumber) => _rope.lineAt(lineNumber);
  Line lineAtOffset(int offset) => _rope.lineAtOffset(offset);
  String sliceString(int from, [int? to]) => _rope.sliceString(from, to);
  Document replace(ChangeSet changes) => Document._(changes.apply(_rope));
  Iterable<Line> linesInRange(int fromLine, int toLine) =>
      _rope.linesInRange(fromLine, toLine);

  @override
  String toString() => _rope.sliceString(0);
}
