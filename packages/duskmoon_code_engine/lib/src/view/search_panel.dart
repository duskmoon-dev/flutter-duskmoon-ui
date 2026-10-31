import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/services.dart';

import '../commands/search.dart';
import '../document/document.dart';
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
    this.readOnly = false,
  });

  /// The editor view to search within and dispatch transactions to.
  final EditorView view;

  /// Called when the user closes the panel.
  final VoidCallback onClose;

  /// Whether to show the replace row initially.
  final bool showReplace;

  /// When true, replace controls are disabled.
  final bool readOnly;

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
  Document? _lastDoc;

  bool get _isReadOnly => widget.readOnly || widget.view.readOnly;

  @override
  void initState() {
    super.initState();
    _showReplace = widget.showReplace;
    _lastDoc = widget.view.document;
    widget.view.addListener(_onViewChanged);
    // Auto-focus the search field on open.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void didUpdateWidget(SearchPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showReplace != oldWidget.showReplace) {
      _showReplace = widget.showReplace;
    }
    if (widget.view != oldWidget.view) {
      oldWidget.view.removeListener(_onViewChanged);
      _lastDoc = widget.view.document;
      widget.view.addListener(_onViewChanged);
      if (_searchController.text.isNotEmpty) {
        final matches = SearchState.findMatches(
          widget.view.document,
          _searchController.text,
          caseSensitive: _caseSensitive,
        );
        _matches = matches;
        _currentIndex = matches.isEmpty ? -1 : 0;
      } else {
        _matches = const [];
        _currentIndex = -1;
      }
    }
  }

  @override
  void dispose() {
    widget.view.removeListener(_onViewChanged);
    _searchController.dispose();
    _replaceController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onViewChanged() {
    if (!identical(widget.view.document, _lastDoc)) {
      _lastDoc = widget.view.document;
      if (_searchController.text.isNotEmpty) {
        final matches = SearchState.findMatches(
          widget.view.document,
          _searchController.text,
          caseSensitive: _caseSensitive,
        );
        setState(() {
          _matches = matches;
          if (_currentIndex >= matches.length) {
            _currentIndex = matches.isEmpty ? -1 : matches.length - 1;
          }
        });
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Search logic
  // ---------------------------------------------------------------------------

  void _runSearch() {
    final query = _searchController.text;
    _lastDoc = widget.view.document;
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
    if (_isReadOnly) return;
    final query = _searchController.text;
    if (query.isEmpty) return;
    final currentMatches = SearchState.findMatches(
      widget.view.document,
      query,
      caseSensitive: _caseSensitive,
    );
    if (currentMatches.isEmpty) {
      setState(() {
        _matches = const [];
        _currentIndex = -1;
      });
      return;
    }
    final idx = (_currentIndex >= 0 && _currentIndex < currentMatches.length)
        ? _currentIndex
        : 0;
    final m = currentMatches[idx];
    final replacement = _replaceController.text;
    widget.view.dispatch(
      SearchCommands.replaceOne(widget.view.state, m.from, m.to, replacement),
    );
    _runSearch();
  }

  void _replaceAll() {
    if (_isReadOnly) return;
    final query = _searchController.text;
    if (query.isEmpty) return;
    final freshMatches = SearchState.findMatches(
      widget.view.document,
      query,
      caseSensitive: _caseSensitive,
    );
    if (freshMatches.isEmpty) return;
    final replacement = _replaceController.text;
    widget.view.dispatch(
      SearchCommands.replaceAll(widget.view.state, freshMatches, replacement),
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
          onPressed: _isReadOnly
              ? null
              : () => setState(() => _showReplace = !_showReplace),
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
            enabled: !_isReadOnly,
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
          onPressed: (_isReadOnly || _matches.isEmpty) ? null : _replaceOne,
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
          onPressed: (_isReadOnly || _matches.isEmpty) ? null : _replaceAll,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('All', style: TextStyle(fontSize: 12)),
        ),
      ],
    );

    return Focus(
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
          return KeyEventResult.ignored;
        }
        final ctrl = HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed;
        if (event.logicalKey == LogicalKeyboardKey.escape ||
            (ctrl && event.logicalKey == LogicalKeyboardKey.keyF)) {
          widget.onClose();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Material(
        elevation: 2,
        color: colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              searchRow,
              if (_showReplace) ...[const SizedBox(height: 4), replaceRow],
            ],
          ),
        ),
      ),
    );
  }
}
