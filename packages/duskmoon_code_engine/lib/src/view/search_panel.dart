import 'package:flutter/material.dart' hide SearchBar;

import '../commands/search.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';
import 'editor_view.dart';

/// A compact find/replace bar displayed at the top of the code editor.
///
/// Activated via Ctrl-F and closed with Escape or the close button.
/// Manages its own state for query, matches, case sensitivity, and replace text.
class SearchPanel extends StatefulWidget {
  const SearchPanel({
    super.key,
    required this.view,
    required this.onClose,
    this.showReplace = false,
  });

  /// The editor view to search within and dispatch transactions to.
  final EditorView view;

  /// Called when the user closes the panel.
  final VoidCallback onClose;

  /// Whether to show the replace row initially.
  final bool showReplace;

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _replaceController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<SearchMatch> _matches = const [];
  int _currentIndex = -1;
  bool _caseSensitive = false;
  bool _showReplace = false;

  @override
  void initState() {
    super.initState();
    _showReplace = widget.showReplace;
    // Auto-focus the search field on open.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _replaceController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Search logic
  // ---------------------------------------------------------------------------

  void _runSearch() {
    final query = _searchController.text;
    final matches = SearchState.findMatches(
      widget.view.document,
      query,
      caseSensitive: _caseSensitive,
    );
    setState(() {
      _matches = matches;
      _currentIndex = matches.isEmpty ? -1 : 0;
    });
    if (matches.isNotEmpty) {
      _selectMatch(0);
    }
  }

  void _selectMatch(int index) {
    if (_matches.isEmpty) return;
    final m = _matches[index];
    widget.view.dispatch(
      TransactionSpec(
        selection: EditorSelection.single(anchor: m.from, head: m.to),
        scrollIntoView: true,
      ),
    );
    setState(() => _currentIndex = index);
  }

  void _findNext() {
    if (_matches.isEmpty) return;
    final next = (_currentIndex + 1) % _matches.length;
    _selectMatch(next);
  }

  void _findPrevious() {
    if (_matches.isEmpty) return;
    final prev = (_currentIndex - 1 + _matches.length) % _matches.length;
    _selectMatch(prev);
  }

  void _replaceOne() {
    if (_matches.isEmpty || _currentIndex < 0) return;
    final m = _matches[_currentIndex];
    final replacement = _replaceController.text;
    widget.view.dispatch(
      SearchCommands.replaceOne(widget.view.state, m.from, m.to, replacement),
    );
    _runSearch();
  }

  void _replaceAll() {
    if (_matches.isEmpty) return;
    final replacement = _replaceController.text;
    widget.view.dispatch(
      SearchCommands.replaceAll(widget.view.state, _matches, replacement),
    );
    _runSearch();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final matchLabel = _searchController.text.isEmpty
        ? ''
        : _matches.isEmpty
            ? 'No matches'
            : '${_currentIndex + 1} of ${_matches.length}';

    Widget searchRow = Row(
      children: [
        // Search field
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Find',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _runSearch(),
            onSubmitted: (_) => _findNext(),
          ),
        ),
        const SizedBox(width: 4),
        // Match count label
        SizedBox(
          width: 72,
          child: Text(
            matchLabel,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Previous match
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up, size: 18),
          tooltip: 'Previous match',
          onPressed: _matches.isEmpty ? null : _findPrevious,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        // Next match
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          tooltip: 'Next match',
          onPressed: _matches.isEmpty ? null : _findNext,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        // Case-sensitivity toggle
        IconButton(
          icon: Icon(
            Icons.text_fields,
            size: 18,
            color: _caseSensitive ? colorScheme.primary : null,
          ),
          tooltip: 'Match case',
          onPressed: () {
            setState(() => _caseSensitive = !_caseSensitive);
            _runSearch();
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        // Replace toggle
        IconButton(
          icon: Icon(
            Icons.find_replace,
            size: 18,
            color: _showReplace ? colorScheme.primary : null,
          ),
          tooltip: 'Toggle replace',
          onPressed: () => setState(() => _showReplace = !_showReplace),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        // Close
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          tooltip: 'Close (Escape)',
          onPressed: widget.onClose,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ],
    );

    Widget replaceRow = Row(
      children: [
        // Replace field
        Expanded(
          child: TextField(
            controller: _replaceController,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Replace',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _replaceOne(),
          ),
        ),
        const SizedBox(width: 4),
        // Replace one
        TextButton(
          onPressed: _matches.isEmpty ? null : _replaceOne,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Replace', style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(width: 4),
        // Replace all
        TextButton(
          onPressed: _matches.isEmpty ? null : _replaceAll,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('All', style: TextStyle(fontSize: 12)),
        ),
      ],
    );

    return Material(
      elevation: 2,
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            searchRow,
            if (_showReplace) ...[
              const SizedBox(height: 4),
              replaceRow,
            ],
          ],
        ),
      ),
    );
  }
}
