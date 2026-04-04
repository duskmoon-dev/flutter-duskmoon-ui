import '../document/change.dart';
import '../document/document.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';

/// A single match found by a search query: the half-open range [from, to).
class SearchMatch {
  const SearchMatch(this.from, this.to);

  /// Start offset of the match (inclusive).
  final int from;

  /// End offset of the match (exclusive).
  final int to;

  @override
  bool operator ==(Object other) =>
      other is SearchMatch && from == other.from && to == other.to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() => 'SearchMatch($from, $to)';
}

/// Pure search logic over a [Document].
abstract final class SearchState {
  /// Returns all occurrences of [query] in [doc].
  ///
  /// - [caseSensitive] — when `false` (default) comparisons are case-folded.
  /// - [useRegex] — when `true` [query] is interpreted as a [RegExp]. Invalid
  ///   patterns are silently ignored and return an empty list.
  /// - Zero-length matches are skipped to avoid infinite loops.
  static List<SearchMatch> findMatches(
    Document doc,
    String query, {
    bool caseSensitive = false,
    bool useRegex = false,
  }) {
    if (query.isEmpty) return const [];
    final text = doc.toString();
    final matches = <SearchMatch>[];

    if (useRegex) {
      try {
        final regex = RegExp(query, caseSensitive: caseSensitive);
        for (final m in regex.allMatches(text)) {
          // Skip zero-length matches to avoid infinite loops.
          if (m.end > m.start) matches.add(SearchMatch(m.start, m.end));
        }
      } catch (_) {
        // Invalid regex — return empty list.
      }
    } else {
      final searchIn = caseSensitive ? text : text.toLowerCase();
      final searchFor = caseSensitive ? query : query.toLowerCase();
      var pos = 0;
      while (true) {
        final idx = searchIn.indexOf(searchFor, pos);
        if (idx < 0) break;
        matches.add(SearchMatch(idx, idx + searchFor.length));
        pos = idx + 1;
      }
    }
    return matches;
  }
}

/// Commands that operate on a pre-computed list of [SearchMatch]es.
abstract final class SearchCommands {
  /// Returns a [TransactionSpec] that selects the match after [currentIndex],
  /// wrapping around to the first match when past the end.
  ///
  /// Returns an empty spec when [matches] is empty.
  static TransactionSpec findNext(
    EditorState state,
    List<SearchMatch> matches,
    int currentIndex,
  ) {
    if (matches.isEmpty) return const TransactionSpec();
    final next = (currentIndex + 1) % matches.length;
    final m = matches[next];
    return TransactionSpec(
      selection: EditorSelection.single(anchor: m.from, head: m.to),
      scrollIntoView: true,
    );
  }

  /// Returns a [TransactionSpec] that selects the match before [currentIndex],
  /// wrapping around to the last match when before the start.
  ///
  /// Returns an empty spec when [matches] is empty.
  static TransactionSpec findPrevious(
    EditorState state,
    List<SearchMatch> matches,
    int currentIndex,
  ) {
    if (matches.isEmpty) return const TransactionSpec();
    final prev = (currentIndex - 1 + matches.length) % matches.length;
    final m = matches[prev];
    return TransactionSpec(
      selection: EditorSelection.single(anchor: m.from, head: m.to),
      scrollIntoView: true,
    );
  }

  /// Returns a [TransactionSpec] that replaces the range [from]..[to] with
  /// [replacement] and places the cursor after the inserted text.
  static TransactionSpec replaceOne(
    EditorState state,
    int from,
    int to,
    String replacement,
  ) {
    return TransactionSpec(
      changes: ChangeSet.of(state.doc.length, [
        ChangeSpec(from: from, to: to, insert: replacement),
      ]),
      selection: EditorSelection.cursor(from + replacement.length),
    );
  }

  /// Returns a [TransactionSpec] that replaces every match in [matches] with
  /// [replacement] in a single atomic operation.
  ///
  /// Matches are applied in document order (left to right). Returns an empty
  /// spec when [matches] is empty.
  static TransactionSpec replaceAll(
    EditorState state,
    List<SearchMatch> matches,
    String replacement,
  ) {
    if (matches.isEmpty) return const TransactionSpec();
    // ChangeSet.of requires specs sorted by from position.
    final specs = matches
        .map((m) => ChangeSpec(from: m.from, to: m.to, insert: replacement))
        .toList();
    return TransactionSpec(
      changes: ChangeSet.of(state.doc.length, specs),
    );
  }
}
