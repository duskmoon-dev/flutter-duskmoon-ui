import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

/// Configuration for [DmMarkdown] rendering features.
@immutable
class DmMarkdownConfig {
  /// Creates a markdown configuration with optional feature toggles.
  const DmMarkdownConfig({
    this.enableGfm = true,
    this.enableKatex = true,
    this.enableMermaid = false,
    this.enableCodeHighlight = true,
    this.codeTheme,
    this.blockBuilders,
    this.inlineBuilders,
  });

  /// Enable GitHub Flavored Markdown extensions (tables, strikethrough,
  /// task lists, autolinks).
  final bool enableGfm;

  /// Enable KaTeX math rendering for `$...$` and `$$...$$`.
  final bool enableKatex;

  /// Enable Mermaid diagram rendering for ` ```mermaid ` code blocks.
  /// Defaults to `false` — when disabled, mermaid blocks render as
  /// syntax-highlighted code.
  final bool enableMermaid;

  /// Enable syntax highlighting in fenced code blocks.
  final bool enableCodeHighlight;

  /// Code highlight theme name (maps to `highlighting` package themes).
  /// If `null`, automatically selected based on ambient brightness:
  /// dark → `monokai-sublime`, light → `github`.
  final String? codeTheme;

  /// Custom block-level widget builders keyed by element tag.
  ///
  /// Overrides the default builder for that tag. For example:
  /// ```dart
  /// blockBuilders: {
  ///   'table': (element, context) => MyCustomTable(element),
  /// }
  /// ```
  final Map<String, Widget Function(md.Element node, BuildContext context)>?
      blockBuilders;

  /// Custom inline span builders keyed by element tag.
  ///
  /// Overrides the default builder for that tag. For example:
  /// ```dart
  /// inlineBuilders: {
  ///   'a': (element, context) => WidgetSpan(child: MyLink(element)),
  /// }
  /// ```
  final Map<String, InlineSpan Function(md.Element node, BuildContext context)>?
      inlineBuilders;
}
