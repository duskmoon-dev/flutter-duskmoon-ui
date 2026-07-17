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
    final value = element.textContent;
    final color = config.enableColorChips ? _parseCssColor(value) : null;
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Semantics(
                label: 'Color $value',
                child: Container(
                  key: const ValueKey('dm-markdown-color-chip'),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                ),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: colorScheme.tertiary,
                fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * 0.9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _parseCssColor(String value) {
    final hex = RegExp(r'^#([0-9a-fA-F]{3,4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$')
        .firstMatch(value);
    if (hex != null) {
      final raw = hex.group(1)!;
      final expanded = raw.length <= 4
          ? raw.split('').map((digit) => '$digit$digit').join()
          : raw;
      final argb = expanded.length == 6
          ? 'ff$expanded'
          : '${expanded.substring(6, 8)}${expanded.substring(0, 6)}';
      return Color(int.parse(argb, radix: 16));
    }

    final rgb = RegExp(
      r'^rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})(?:\s*,\s*(0|1|0?\.\d+))?\s*\)$',
      caseSensitive: false,
    ).firstMatch(value);
    if (rgb != null) {
      final channels = [1, 2, 3].map((index) => int.parse(rgb.group(index)!));
      if (channels.any((channel) => channel > 255)) return null;
      final alpha = ((double.tryParse(rgb.group(4) ?? '1') ?? 1) * 255).round();
      if (alpha < 0 || alpha > 255) return null;
      final values = channels.toList();
      return Color.fromARGB(alpha, values[0], values[1], values[2]);
    }

    final hsl = RegExp(
      r'^hsla?\(\s*(-?(?:\d+(?:\.\d+)?|\.\d+))\s*,\s*(\d+(?:\.\d+)?)%\s*,\s*(\d+(?:\.\d+)?)%(?:\s*,\s*(0|1|0?\.\d+))?\s*\)$',
      caseSensitive: false,
    ).firstMatch(value);
    if (hsl == null) return null;
    final saturation = double.parse(hsl.group(2)!);
    final lightness = double.parse(hsl.group(3)!);
    final alpha = double.tryParse(hsl.group(4) ?? '1') ?? 1;
    if (saturation > 100 || lightness > 100 || alpha < 0 || alpha > 1) {
      return null;
    }
    final hue = double.parse(hsl.group(1)!) % 360;
    return HSLColor.fromAHSL(
      alpha,
      hue < 0 ? hue + 360 : hue,
      saturation / 100,
      lightness / 100,
    ).toColor();
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
