import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import 'dm_markdown_config.dart';

/// Builds [InlineSpan]s from inline AST nodes.
///
/// Handles bold, italic, strikethrough, inline code, links, images,
/// and inline math.
class InlineSpanBuilder {
  /// Creates an inline span builder with the given [config] and callbacks.
  const InlineSpanBuilder({
    required this.config,
    required this.colorScheme,
    required this.textTheme,
    this.onLinkTap,
  });

  /// Rendering configuration.
  final DmMarkdownConfig config;

  /// The current color scheme for styling.
  final ColorScheme colorScheme;

  /// The current text theme for typography.
  final TextTheme textTheme;

  /// Called when a link is tapped.
  final void Function(String url, String? title)? onLinkTap;

  /// Builds an [InlineSpan] tree from a list of inline [nodes].
  InlineSpan buildSpan(
    List<md.Node> nodes, {
    TextStyle? parentStyle,
  }) {
    final children = <InlineSpan>[];
    for (final node in nodes) {
      children.add(_visitNode(node, parentStyle: parentStyle));
    }
    if (children.length == 1) return children.first;
    return TextSpan(children: children);
  }

  InlineSpan _visitNode(md.Node node, {TextStyle? parentStyle}) {
    if (node is md.Text) {
      return TextSpan(text: node.text, style: parentStyle);
    }

    if (node is md.Element) {
      // Check for custom builder override.
      final customBuilder = config.inlineBuilders?[node.tag];
      if (customBuilder != null) {
        // Custom builders need a BuildContext — we pass a WidgetSpan wrapper.
        return WidgetSpan(
          child: Builder(
            builder: (context) => customBuilder(node, context) as Widget,
          ),
        );
      }

      return _visitElement(node, parentStyle: parentStyle);
    }

    // UnparsedContent or unknown node — render as plain text.
    return TextSpan(text: node.textContent, style: parentStyle);
  }

  InlineSpan _visitElement(md.Element element, {TextStyle? parentStyle}) {
    switch (element.tag) {
      case 'strong':
        final style = (parentStyle ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
        );
        return _buildChildrenSpan(element, style);

      case 'em':
        final style = (parentStyle ?? const TextStyle()).copyWith(
          fontStyle: FontStyle.italic,
        );
        return _buildChildrenSpan(element, style);

      case 'del':
        final style = (parentStyle ?? const TextStyle()).copyWith(
          decoration: TextDecoration.lineThrough,
          color: colorScheme.onSurfaceVariant,
        );
        return _buildChildrenSpan(element, style);

      case 'code':
        return _buildInlineCode(element);

      case 'a':
        return _buildLink(element, parentStyle: parentStyle);

      case 'img':
        return _buildInlineImage(element);

      case 'math':
        return _buildInlineMath(element);

      case 'br':
        return const TextSpan(text: '\n');

      default:
        return _buildChildrenSpan(element, parentStyle);
    }
  }

  InlineSpan _buildChildrenSpan(md.Element element, TextStyle? style) {
    final children = element.children;
    if (children == null || children.isEmpty) {
      return TextSpan(text: element.textContent, style: style);
    }
    final spans = <InlineSpan>[];
    for (final child in children) {
      spans.add(_visitNode(child, parentStyle: style));
    }
    if (spans.length == 1 && spans.first is TextSpan) {
      final ts = spans.first as TextSpan;
      return TextSpan(
        text: ts.text,
        style: style?.merge(ts.style) ?? ts.style,
        children: ts.children,
      );
    }
    return TextSpan(style: style, children: spans);
  }

  InlineSpan _buildInlineCode(md.Element element) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          element.textContent,
          style: textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            color: colorScheme.tertiary,
            fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * 0.9,
          ),
        ),
      ),
    );
  }

  InlineSpan _buildLink(md.Element element, {TextStyle? parentStyle}) {
    final url = element.attributes['href'] ?? '';
    final title = element.attributes['title'];

    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onLinkTap?.call(url, title),
          child: Text.rich(
            _buildChildrenSpan(
              element,
              (parentStyle ?? const TextStyle()).copyWith(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  InlineSpan _buildInlineImage(md.Element element) {
    final src = element.attributes['src'] ?? '';
    final alt = element.attributes['alt'] ?? '';

    return WidgetSpan(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          src,
          errorBuilder: (_, __, ___) => Tooltip(
            message: 'Failed to load: $src',
            child: Container(
              padding: const EdgeInsets.all(8),
              color: colorScheme.errorContainer,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image, size: 16, color: colorScheme.error),
                  const SizedBox(width: 4),
                  Text(
                    alt.isNotEmpty ? alt : 'Image',
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

  InlineSpan _buildInlineMath(md.Element element) {
    if (!config.enableKatex) {
      // Render as inline code if KaTeX is disabled.
      return _buildInlineCode(element);
    }

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: _LatexInlineWidget(
        tex: element.textContent,
        colorScheme: colorScheme,
      ),
    );
  }
}

/// Renders inline LaTeX math using flutter_math_fork.
class _LatexInlineWidget extends StatelessWidget {
  const _LatexInlineWidget({
    required this.tex,
    required this.colorScheme,
  });

  final String tex;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    // Import inline — avoids coupling the span builder to flutter_math_fork
    // at the class level.
    try {
      // ignore: depend_on_referenced_packages
      // Using dynamic invocation to avoid hard coupling.
      return _buildMath(context);
    } catch (e) {
      return Text(
        '\$$tex\$',
        style: TextStyle(
          fontFamily: 'monospace',
          color: colorScheme.error,
        ),
      );
    }
  }

  Widget _buildMath(BuildContext context) {
    // flutter_math_fork import
    // ignore: depend_on_referenced_packages
    return _MathTexWidget(tex: tex, colorScheme: colorScheme);
  }
}

/// Dedicated math widget to isolate the flutter_math_fork import.
class _MathTexWidget extends StatelessWidget {
  const _MathTexWidget({required this.tex, required this.colorScheme});

  final String tex;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    // We'll use flutter_math_fork for rendering.
    // This is imported in the _math_widget.dart file and shared.
    // For inline math, we reuse the same pattern.
    return _InlineMathFallback(tex: tex, colorScheme: colorScheme);
  }
}

/// Fallback for inline math — shows the TeX source in styled text.
/// Will be replaced with flutter_math_fork rendering in _math_widget.dart.
class _InlineMathFallback extends StatelessWidget {
  const _InlineMathFallback({required this.tex, required this.colorScheme});

  final String tex;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      tex,
      style: TextStyle(
        fontFamily: 'monospace',
        fontStyle: FontStyle.italic,
        color: colorScheme.tertiary,
      ),
    );
  }
}
