import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';

/// Controls how YAML front matter at the start of a Markdown document is shown.
enum DmFrontMatterMode {
  /// Render the YAML as a syntax-highlighted code block before the document.
  render,

  /// Remove the YAML front matter and render only the document body.
  hidden,

  /// Treat the complete source as ordinary Markdown.
  disabled,
}

/// Configuration for [DmMarkdown] rendering features.
@immutable
class DmMarkdownConfig {
  /// Creates a markdown configuration with optional feature toggles.
  const DmMarkdownConfig({
    this.enableGfm = true,
    this.enableKatex = true,
    this.enableColorChips = true,
    this.frontMatter = DmFrontMatterMode.render,
    this.breaks = true,
    this.enableMermaid = false,
    this.mermaidOptions = const MermaidRenderOptions(),
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

  /// Add a visual swatch to inline code containing a complete CSS color.
  final bool enableColorChips;

  /// Controls extraction and presentation of initial YAML front matter.
  final DmFrontMatterMode frontMatter;

  /// Convert soft line breaks to visible line breaks. Defaults to `true`.
  final bool breaks;

  /// Enable Mermaid diagram rendering for ` ```mermaid ` code blocks.
  /// Defaults to `false` — when disabled, mermaid blocks render as
  /// syntax-highlighted code.
  final bool enableMermaid;

  /// Mermaid render options used when [enableMermaid] is true.
  final MermaidRenderOptions mermaidOptions;

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
