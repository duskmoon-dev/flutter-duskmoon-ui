import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter/material.dart';

import 'dm_code_editor_theme.dart';

/// Resolves a language name string to a [LanguageSupport] instance.
///
/// Returns `null` for unknown language identifiers (no syntax highlighting,
/// no error thrown). Matching is case-insensitive.
LanguageSupport? _resolveLanguage(String? language) {
  if (language == null) return null;
  return switch (language.toLowerCase()) {
    'dart' => dartLanguageSupport(),
    'javascript' || 'js' => javascriptLanguageSupport(),
    'typescript' || 'ts' => javascriptLanguageSupport(),
    'python' || 'py' => pythonLanguageSupport(),
    'html' => htmlLanguageSupport(),
    'css' => cssLanguageSupport(),
    'json' => jsonLanguageSupport(),
    'markdown' || 'md' => markdownLanguageSupport(),
    'rust' || 'rs' => rustLanguageSupport(),
    'go' => goLanguageSupport(),
    'yaml' || 'yml' => yamlLanguageSupport(),
    'c' || 'cpp' || 'c++' => cLanguageSupport(),
    'elixir' || 'ex' || 'exs' => elixirLanguageSupport(),
    'java' => javaLanguageSupport(),
    'kotlin' || 'kt' => kotlinLanguageSupport(),
    'php' => phpLanguageSupport(),
    'ruby' || 'rb' => rubyLanguageSupport(),
    'erlang' || 'erl' => erlangLanguageSupport(),
    'swift' => swiftLanguageSupport(),
    'zig' => zigLanguageSupport(),
    _ => null,
  };
}

/// A code editor widget that integrates with the DuskMoon design system.
///
/// Wraps [CodeEditorWidget] with automatic theme derivation from the ambient
/// DuskMoon theme tree. Supply a [language] string (e.g. `'dart'`, `'python'`)
/// for syntax highlighting — no engine imports required by the caller.
///
/// When no [controller] is provided, an internal [EditorViewController] is
/// created and disposed automatically. When a controller is provided, the
/// caller owns its lifecycle.
///
/// ## Example
///
/// ```dart
/// DmCodeEditor(
///   initialDoc: 'void main() {}',
///   language: 'dart',
///   onChanged: (text) => print(text),
/// )
/// ```
class DmCodeEditor extends StatefulWidget {
  /// Creates a [DmCodeEditor].
  const DmCodeEditor({
    super.key,
    this.initialDoc,
    this.language,
    this.theme,
    this.readOnly = false,
    this.lineNumbers = true,
    this.highlightActiveLine = true,
    this.onChanged,
    this.onStateChanged,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.scrollPhysics,
  });

  /// Initial document text. Ignored when [controller] is provided.
  final String? initialDoc;

  /// Language identifier for syntax highlighting (e.g. `'dart'`, `'python'`).
  /// Case-insensitive. Unknown values are silently ignored (no highlighting).
  final String? language;

  /// Custom editor theme. When `null`, the theme is derived automatically from
  /// the ambient DuskMoon theme via [DmCodeEditorTheme.fromContext].
  final EditorTheme? theme;

  /// Whether the editor is read-only.
  final bool readOnly;

  /// Whether to show line numbers in the gutter.
  final bool lineNumbers;

  /// Whether to highlight the line containing the cursor.
  final bool highlightActiveLine;

  /// Called with the full document text whenever the editor content changes.
  final ValueChanged<String>? onChanged;

  /// Called with the full [EditorState] whenever the editor state changes.
  final void Function(EditorState state)? onStateChanged;

  /// External controller for programmatic access. When `null`, an internal
  /// controller is created and disposed by this widget.
  final EditorViewController? controller;

  /// Optional external [FocusNode].
  final FocusNode? focusNode;

  /// Whether to focus the editor on mount.
  final bool autofocus;

  /// Minimum height of the editor.
  final double? minHeight;

  /// Maximum height of the editor.
  final double? maxHeight;

  /// Padding around the editor content area.
  final EdgeInsets? padding;

  /// Scroll physics for the editor's internal list.
  final ScrollPhysics? scrollPhysics;

  @override
  State<DmCodeEditor> createState() => _DmCodeEditorState();
}

class _DmCodeEditorState extends State<DmCodeEditor> {
  EditorViewController? _internalController;

  EditorViewController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = EditorViewController(
        text: widget.initialDoc,
        language: _resolveLanguage(widget.language),
      );
    } else if (widget.language != null) {
      widget.controller!.language = _resolveLanguage(widget.language);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.theme =
        widget.theme ?? DmCodeEditorTheme.fromContext(context);
  }

  @override
  void didUpdateWidget(DmCodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller swap
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _internalController?.dispose();
        _internalController = null;
      }
      if (widget.controller == null) {
        _internalController = EditorViewController(
          text: widget.initialDoc,
          language: _resolveLanguage(widget.language),
        );
      }
      _controller.theme =
          widget.theme ?? DmCodeEditorTheme.fromContext(context);
      _controller.language = _resolveLanguage(widget.language);
      return;
    }

    if (widget.language != oldWidget.language) {
      _controller.language = _resolveLanguage(widget.language);
    }
    // Always refresh theme: covers explicit override changes AND ambient theme
    // changes that arrive via didUpdateWidget (e.g. MaterialApp theme prop swap).
    _controller.theme =
        widget.theme ?? DmCodeEditorTheme.fromContext(context);
  }

  void _handleStateChanged(EditorState state) {
    widget.onChanged?.call(state.doc.toString());
    widget.onStateChanged?.call(state);
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update theme on every build to pick up ambient theme changes.
    // Only applies when no explicit override is provided.
    if (widget.theme == null) {
      _controller.theme = DmCodeEditorTheme.fromContext(context);
    }
    return CodeEditorWidget(
      controller: _controller,
      readOnly: widget.readOnly,
      lineNumbers: widget.lineNumbers,
      highlightActiveLine: widget.highlightActiveLine,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      minHeight: widget.minHeight,
      maxHeight: widget.maxHeight,
      padding: widget.padding,
      scrollPhysics: widget.scrollPhysics,
      onStateChanged: _handleStateChanged,
    );
  }
}
