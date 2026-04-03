import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import '../_shared/slug_utils.dart';
import '_code_block_widget.dart';
import '_inline_span_builder.dart';
import '_math_widget.dart';
import '_mermaid_widget.dart';
import 'dm_markdown_config.dart';
import 'dm_markdown_scroll_controller.dart';

/// Builds block-level widgets from AST [md.Node]s.
///
/// Handles headings, paragraphs, lists, blockquotes, tables, code blocks,
/// horizontal rules, images, math blocks, and mermaid diagrams.
class BlockWidgetBuilder {
  /// Creates a block widget builder.
  BlockWidgetBuilder({
    required this.config,
    required this.colorScheme,
    required this.textTheme,
    required this.slugs,
    this.scrollController,
    this.onLinkTap,
    this.onImageTap,
    this.imageErrorBuilder,
  });

  /// Rendering configuration.
  final DmMarkdownConfig config;

  /// The current color scheme.
  final ColorScheme colorScheme;

  /// The current text theme.
  final TextTheme textTheme;

  /// Set of used slug IDs for collision detection.
  final Set<String> slugs;

  /// Optional scroll controller for anchor registration.
  final DmMarkdownScrollController? scrollController;

  /// Link tap callback.
  final void Function(String url, String? title)? onLinkTap;

  /// Image tap callback.
  final void Function(String src, String? alt)? onImageTap;

  /// Custom image error builder.
  final Widget Function(String src, String? alt)? imageErrorBuilder;

  late final InlineSpanBuilder _inlineBuilder = InlineSpanBuilder(
    config: config,
    colorScheme: colorScheme,
    textTheme: textTheme,
    onLinkTap: onLinkTap,
  );

  /// Builds a list of widgets from top-level AST [nodes].
  List<Widget> buildAll(List<md.Node> nodes) {
    return nodes.map(_buildBlock).toList();
  }

  Widget _buildBlock(md.Node node) {
    if (node is md.Element) {
      // Check for custom builder override.
      final customBuilder = config.blockBuilders?[node.tag];
      if (customBuilder != null) {
        return Builder(builder: (context) => customBuilder(node, context));
      }
      return _buildElement(node);
    }

    // Plain text node at block level (rare).
    if (node is md.Text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(node.text, style: textTheme.bodyMedium),
      );
    }

    // Fallback for unknown node types.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        node.textContent,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildElement(md.Element element) {
    switch (element.tag) {
      case 'h1':
        return _buildHeading(element, textTheme.headlineLarge);
      case 'h2':
        return _buildHeading(element, textTheme.headlineMedium);
      case 'h3':
        return _buildHeading(element, textTheme.headlineSmall);
      case 'h4':
        return _buildHeading(element, textTheme.titleLarge);
      case 'h5':
        return _buildHeading(element, textTheme.titleMedium);
      case 'h6':
        return _buildHeading(element, textTheme.titleSmall);

      case 'p':
        return _buildParagraph(element);

      case 'ul':
        return _buildUnorderedList(element);

      case 'ol':
        return _buildOrderedList(element);

      case 'blockquote':
        return _buildBlockquote(element);

      case 'table':
        return _buildTable(element);

      case 'pre':
        return _buildCodeBlock(element);

      case 'hr':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Divider(color: colorScheme.outlineVariant),
        );

      case 'img':
        return _buildImage(element);

      case 'mathBlock':
        return MathWidget(tex: element.textContent, displayMode: true);

      default:
        // Unknown element — try to render children.
        return _buildParagraph(element);
    }
  }

  Widget _buildHeading(md.Element element, TextStyle? style) {
    final text = _extractText(element);
    final slug = uniqueSlug(text, slugs);
    final key = GlobalKey();

    scrollController?.registerAnchor(slug, key);

    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text.rich(
        _inlineBuilder.buildSpan(
          element.children ?? [],
          parentStyle: style?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(md.Element element) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text.rich(
        _inlineBuilder.buildSpan(
          element.children ?? [],
          parentStyle: textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildUnorderedList(md.Element element) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (element.children ?? []).map((child) {
          if (child is md.Element && child.tag == 'li') {
            return _buildListItem(child, bullet: '•');
          }
          return _buildBlock(child);
        }).toList(),
      ),
    );
  }

  Widget _buildOrderedList(md.Element element) {
    var index = int.tryParse(element.attributes['start'] ?? '1') ?? 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (element.children ?? []).map((child) {
          if (child is md.Element && child.tag == 'li') {
            return _buildListItem(child, bullet: '${index++}.');
          }
          return _buildBlock(child);
        }).toList(),
      ),
    );
  }

  Widget _buildListItem(md.Element element, {required String bullet}) {
    // Check for task list item (checkbox).
    final isTask = _isTaskListItem(element);
    final isChecked = _isTaskChecked(element);

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTask)
            Padding(
              padding: const EdgeInsets.only(right: 6, top: 2),
              child: Icon(
                isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                size: 18,
                color: colorScheme.primary,
              ),
            )
          else
            SizedBox(
              width: 20,
              child: Text(
                bullet,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildListItemChildren(element),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildListItemChildren(md.Element element) {
    final children = element.children ?? [];
    final widgets = <Widget>[];
    final inlineNodes = <md.Node>[];

    for (final child in children) {
      if (child is md.Element &&
          (child.tag == 'ul' ||
              child.tag == 'ol' ||
              child.tag == 'p' ||
              child.tag == 'pre' ||
              child.tag == 'blockquote')) {
        // Flush any accumulated inline nodes.
        if (inlineNodes.isNotEmpty) {
          widgets.add(Text.rich(
            _inlineBuilder.buildSpan(
              List.from(inlineNodes),
              parentStyle: textTheme.bodyMedium,
            ),
          ));
          inlineNodes.clear();
        }
        widgets.add(_buildBlock(child));
      } else {
        inlineNodes.add(child);
      }
    }

    if (inlineNodes.isNotEmpty) {
      widgets.add(Text.rich(
        _inlineBuilder.buildSpan(inlineNodes,
            parentStyle: textTheme.bodyMedium),
      ));
    }

    return widgets;
  }

  bool _isTaskListItem(md.Element element) {
    final children = element.children ?? [];
    if (children.isEmpty) return false;
    final first = children.first;
    if (first is md.Element && first.tag == 'p') {
      final pChildren = first.children ?? [];
      if (pChildren.isNotEmpty && pChildren.first is md.Element) {
        return (pChildren.first as md.Element).tag == 'input';
      }
    }
    return false;
  }

  bool _isTaskChecked(md.Element element) {
    final children = element.children ?? [];
    if (children.isEmpty) return false;
    final first = children.first;
    if (first is md.Element && first.tag == 'p') {
      final pChildren = first.children ?? [];
      if (pChildren.isNotEmpty && pChildren.first is md.Element) {
        final input = pChildren.first as md.Element;
        return input.attributes['checked'] != null;
      }
    }
    return false;
  }

  Widget _buildBlockquote(md.Element element) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: colorScheme.outlineVariant,
            width: 3,
          ),
        ),
        color: colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (element.children ?? []).map(_buildBlock).toList(),
      ),
    );
  }

  Widget _buildTable(md.Element element) {
    final children = element.children ?? [];
    final headerRows = <md.Element>[];
    final bodyRows = <md.Element>[];

    for (final child in children) {
      if (child is md.Element) {
        if (child.tag == 'thead') {
          for (final row in child.children ?? []) {
            if (row is md.Element) headerRows.add(row);
          }
        } else if (child.tag == 'tbody') {
          for (final row in child.children ?? []) {
            if (row is md.Element) bodyRows.add(row);
          }
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: [
            ...headerRows.map((row) => _buildTableRow(row, isHeader: true)),
            ...bodyRows.map((row) => _buildTableRow(row, isHeader: false)),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(md.Element row, {required bool isHeader}) {
    final cells = (row.children ?? [])
        .whereType<md.Element>()
        .map((cell) => _buildTableCell(cell, isHeader: isHeader))
        .toList();
    return TableRow(
      decoration: isHeader
          ? BoxDecoration(color: colorScheme.surfaceContainerHigh)
          : null,
      children: cells,
    );
  }

  Widget _buildTableCell(md.Element cell, {required bool isHeader}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text.rich(
        _inlineBuilder.buildSpan(
          cell.children ?? [],
          parentStyle: isHeader
              ? textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
              : textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildCodeBlock(md.Element element) {
    // A <pre> element typically contains a single <code> child.
    final codeElement =
        (element.children ?? []).whereType<md.Element>().firstOrNull;
    final code = codeElement?.textContent ?? element.textContent;

    // Extract language from class attribute (e.g. "language-dart").
    String? language;
    final className = codeElement?.attributes['class'] ?? '';
    if (className.startsWith('language-')) {
      language = className.substring('language-'.length);
    }

    // Check for mermaid.
    if (language == 'mermaid') {
      return MermaidWidget(
        source: code,
        enabled: config.enableMermaid,
      );
    }

    if (!config.enableCodeHighlight) {
      // Plain code block without highlighting.
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            code,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

    return CodeBlockWidget(
      code: code,
      language: language,
      codeTheme: config.codeTheme,
    );
  }

  Widget _buildImage(md.Element element) {
    final src = element.attributes['src'] ?? '';
    final alt = element.attributes['alt'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onImageTap != null ? () => onImageTap!(src, alt) : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            src,
            errorBuilder: (_, __, ___) =>
                imageErrorBuilder?.call(src, alt) ??
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        alt.isNotEmpty ? alt : 'Image failed to load',
                        style: TextStyle(color: colorScheme.onErrorContainer),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  /// Extracts plain text from an element node (recursively).
  String _extractText(md.Node node) {
    if (node is md.Text) return node.text;
    if (node is md.Element) {
      return (node.children ?? []).map(_extractText).join();
    }
    return node.textContent;
  }
}
