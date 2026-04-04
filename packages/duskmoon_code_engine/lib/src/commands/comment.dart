import '../document/change.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';

abstract final class CommentCommands {
  /// Toggles a line comment on the line at the cursor position.
  ///
  /// [lineCommentToken] is the language-specific prefix, e.g. `"//"` or `"#"`.
  /// Returns null when [lineCommentToken] is null.
  ///
  /// - If the line (after trimming leading whitespace) starts with
  ///   `"<token> "` or `"<token>"`, the prefix is removed.
  /// - Otherwise, `"<token> "` is inserted at the beginning of the line
  ///   content (after leading whitespace).
  ///
  /// The cursor is adjusted by the number of characters inserted or removed.
  static TransactionSpec? toggleLineComment(
    EditorState state,
    String? lineCommentToken,
  ) {
    if (lineCommentToken == null) return null;

    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    final lineText = line.text;

    // Measure leading whitespace.
    var indent = 0;
    while (indent < lineText.length && lineText[indent] == ' ') {
      indent++;
    }

    final afterIndent = lineText.substring(indent);
    final prefixWithSpace = '$lineCommentToken ';

    late ChangeSet changes;
    late int newHead;

    if (afterIndent.startsWith(prefixWithSpace)) {
      // Remove "<token> "
      final removeFrom = line.from + indent;
      final removeTo = removeFrom + prefixWithSpace.length;
      changes = ChangeSet.of(state.doc.length, [
        ChangeSpec(from: removeFrom, to: removeTo),
      ]);
      newHead = (head - prefixWithSpace.length).clamp(line.from, line.to);
    } else if (afterIndent.startsWith(lineCommentToken)) {
      // Remove "<token>" (no trailing space)
      final removeFrom = line.from + indent;
      final removeTo = removeFrom + lineCommentToken.length;
      changes = ChangeSet.of(state.doc.length, [
        ChangeSpec(from: removeFrom, to: removeTo),
      ]);
      newHead = (head - lineCommentToken.length).clamp(line.from, line.to);
    } else {
      // Insert "<token> " after leading whitespace.
      final insertAt = line.from + indent;
      changes = ChangeSet.of(state.doc.length, [
        ChangeSpec.insert(insertAt, prefixWithSpace),
      ]);
      newHead = head + prefixWithSpace.length;
    }

    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(newHead),
    );
  }
}
