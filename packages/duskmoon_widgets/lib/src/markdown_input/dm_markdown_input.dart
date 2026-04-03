import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import '../markdown/dm_markdown_config.dart';
import '_editor_pane.dart';
import '_keyboard_shortcut_handler.dart';
import '_preview_pane.dart';
import 'dm_markdown_input_controller.dart';
import 'dm_markdown_tab.dart';

/// A markdown editor with write/preview tabs, syntax highlighting,
/// and keyboard shortcuts.
///
/// Mirrors `<el-dm-markdown-input>` from the DuskMoon web elements library.
///
/// ```dart
/// DmMarkdownInput(
///   controller: myController,
///   onChanged: (text) => print('Updated: $text'),
/// )
/// ```
class DmMarkdownInput extends StatefulWidget {
  /// Creates a markdown input widget.
  const DmMarkdownInput({
    super.key,
    this.controller,
    this.initialValue,
    this.config = const DmMarkdownConfig(),
    this.initialTab = DmMarkdownTab.write,
    this.onChanged,
    this.onTabChanged,
    this.showLineNumbers = false,
    this.maxLines,
    this.minLines = 10,
    this.readOnly = false,
    this.enabled = true,
    this.tabLabelWrite = 'Write',
    this.tabLabelPreview = 'Preview',
    this.onLinkTap,
    this.decoration,
  });

  /// External controller. If null, creates an internal one.
  final DmMarkdownInputController? controller;

  /// Initial text value (used only when [controller] is null).
  final String? initialValue;

  /// Rendering configuration for the preview.
  final DmMarkdownConfig config;

  /// The initial active tab.
  final DmMarkdownTab initialTab;

  /// Called when the text content changes.
  final ValueChanged<String>? onChanged;

  /// Called when the active tab changes.
  final ValueChanged<DmMarkdownTab>? onTabChanged;

  /// Whether to show line numbers in the editor.
  final bool showLineNumbers;

  /// Maximum number of visible lines in the editor.
  final int? maxLines;

  /// Minimum number of visible lines in the editor.
  final int minLines;

  /// Whether the editor is read-only (shows preview only).
  final bool readOnly;

  /// Whether the widget is enabled.
  final bool enabled;

  /// Label for the write tab.
  final String tabLabelWrite;

  /// Label for the preview tab.
  final String tabLabelPreview;

  /// Link tap callback in preview mode.
  final void Function(String url, String? title)? onLinkTap;

  /// Custom input decoration for the editor field.
  final InputDecoration? decoration;

  @override
  State<DmMarkdownInput> createState() => _DmMarkdownInputState();
}

class _DmMarkdownInputState extends State<DmMarkdownInput>
    with SingleTickerProviderStateMixin {
  late DmMarkdownInputController _controller;
  late TabController _tabController;
  late FocusNode _focusNode;
  bool _ownsController = false;
  List<md.Node> _previewNodes = [];

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = DmMarkdownInputController(
        text: widget.initialValue ?? '',
        enableGfm: widget.config.enableGfm,
        enableKatex: widget.config.enableKatex,
      );
      _ownsController = true;
    }

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.readOnly ? 1 : widget.initialTab.index,
    );
    _tabController.addListener(_onTabChanged);
    _focusNode = FocusNode();

    _controller.addListener(_onTextChanged);
    _previewNodes = _controller.cachedNodes;
  }

  @override
  void didUpdateWidget(DmMarkdownInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      if (_ownsController) {
        _controller.removeListener(_onTextChanged);
        _controller.dispose();
        _ownsController = false;
      }
      _controller = widget.controller!;
      _controller.addListener(_onTextChanged);
    }
    if (widget.readOnly && !oldWidget.readOnly) {
      _tabController.animateTo(1);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.onChanged?.call(_controller.text);
    if (_tabController.index == 1) {
      setState(() => _previewNodes = _controller.cachedNodes);
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final tab =
        _tabController.index == 0 ? DmMarkdownTab.write : DmMarkdownTab.preview;
    widget.onTabChanged?.call(tab);
    if (tab == DmMarkdownTab.preview) {
      setState(() => _previewNodes = _controller.cachedNodes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tab bar.
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.onSurface,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_note, size: 18, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(widget.tabLabelWrite),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility, size: 18, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(widget.tabLabelPreview),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Content.
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                // Write tab.
                KeyboardShortcutHandler(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled && !widget.readOnly,
                  child: EditorPane(
                    controller: _controller,
                    focusNode: _focusNode,
                    showLineNumbers: widget.showLineNumbers,
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                    readOnly: widget.readOnly || !widget.enabled,
                    decoration: widget.decoration,
                  ),
                ),
                // Preview tab.
                SingleChildScrollView(
                  child: PreviewPane(
                    nodes: _previewNodes,
                    config: widget.config,
                    onLinkTap: widget.onLinkTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
