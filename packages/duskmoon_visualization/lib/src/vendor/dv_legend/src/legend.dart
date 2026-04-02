import 'package:flutter/widgets.dart';

/// The direction/layout of a legend.
enum LegendDirection {
  /// Items arranged horizontally in a row.
  horizontal,

  /// Items arranged vertically in a column.
  vertical,
}

/// The shape of legend symbols.
enum LegendSymbolShape {
  /// Circular symbol.
  circle,

  /// Square symbol.
  square,

  /// Horizontal line symbol (for line charts).
  line,

  /// Diamond symbol.
  diamond,

  /// Triangle symbol.
  triangle,
}

/// Configuration for legend appearance.
class LegendConfig {
  /// The direction of the legend layout.
  final LegendDirection direction;

  /// Spacing between legend items.
  final double itemSpacing;

  /// Size of the symbol.
  final double symbolSize;

  /// Spacing between symbol and label.
  final double symbolLabelSpacing;

  /// Text style for labels.
  final TextStyle? labelStyle;

  /// Shape of the legend symbols.
  final LegendSymbolShape symbolShape;

  /// Creates a legend configuration.
  const LegendConfig({
    this.direction = LegendDirection.horizontal,
    this.itemSpacing = 16,
    this.symbolSize = 12,
    this.symbolLabelSpacing = 4,
    this.labelStyle,
    this.symbolShape = LegendSymbolShape.circle,
  });

  /// Creates a copy with modified values.
  LegendConfig copyWith({
    LegendDirection? direction,
    double? itemSpacing,
    double? symbolSize,
    double? symbolLabelSpacing,
    TextStyle? labelStyle,
    LegendSymbolShape? symbolShape,
  }) {
    return LegendConfig(
      direction: direction ?? this.direction,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      symbolSize: symbolSize ?? this.symbolSize,
      symbolLabelSpacing: symbolLabelSpacing ?? this.symbolLabelSpacing,
      labelStyle: labelStyle ?? this.labelStyle,
      symbolShape: symbolShape ?? this.symbolShape,
    );
  }
}

/// Data for a legend entry.
class LegendEntry {
  /// The label text.
  final String label;

  /// The color for this entry.
  final Color color;

  /// Optional custom symbol shape.
  final LegendSymbolShape? shape;

  /// Creates a legend entry.
  const LegendEntry({
    required this.label,
    required this.color,
    this.shape,
  });
}

/// Base widget for displaying chart legends.
///
/// A legend shows the mapping between colors/shapes and data categories,
/// helping readers understand what different visual elements represent.
///
/// Example usage:
/// ```dart
/// Legend(
///   entries: [
///     LegendEntry(label: 'Category A', color: Colors.blue),
///     LegendEntry(label: 'Category B', color: Colors.red),
///   ],
///   config: LegendConfig(direction: LegendDirection.horizontal),
/// )
/// ```
class Legend extends StatelessWidget {
  /// The legend entries to display.
  final List<LegendEntry> entries;

  /// Configuration for the legend.
  final LegendConfig config;

  /// Callback when an entry is tapped.
  final void Function(LegendEntry entry, int index)? onTap;

  /// Creates a legend.
  const Legend({
    super.key,
    required this.entries,
    this.config = const LegendConfig(),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle = config.labelStyle ??
        const TextStyle(
          fontSize: 12,
          color: Color(0xFF000000),
        );

    final items = entries.asMap().entries.map((entry) {
      final index = entry.key;
      final legendEntry = entry.value;
      final item = _LegendItemWidget(
        entry: legendEntry,
        config: config,
        labelStyle: effectiveLabelStyle,
      );

      if (onTap != null) {
        return GestureDetector(
          onTap: () => onTap!(legendEntry, index),
          child: item,
        );
      }
      return item;
    }).toList();

    if (config.direction == LegendDirection.horizontal) {
      return Wrap(
        spacing: config.itemSpacing,
        runSpacing: config.itemSpacing / 2,
        children: items,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((item) => Padding(
                  padding: EdgeInsets.only(bottom: config.itemSpacing / 2),
                  child: item,
                ))
            .toList(),
      );
    }
  }
}

class _LegendItemWidget extends StatelessWidget {
  final LegendEntry entry;
  final LegendConfig config;
  final TextStyle labelStyle;

  const _LegendItemWidget({
    required this.entry,
    required this.config,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(config.symbolSize, config.symbolSize),
          painter: _LegendSymbolPainter(
            color: entry.color,
            shape: entry.shape ?? config.symbolShape,
          ),
        ),
        SizedBox(width: config.symbolLabelSpacing),
        Text(entry.label, style: labelStyle),
      ],
    );
  }
}

class _LegendSymbolPainter extends CustomPainter {
  final Color color;
  final LegendSymbolShape shape;

  _LegendSymbolPainter({
    required this.color,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    switch (shape) {
      case LegendSymbolShape.circle:
        canvas.drawCircle(center, radius, paint);
        break;

      case LegendSymbolShape.square:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          paint,
        );
        break;

      case LegendSymbolShape.line:
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawLine(
          Offset(0, size.height / 2),
          Offset(size.width, size.height / 2),
          paint,
        );
        break;

      case LegendSymbolShape.diamond:
        final path = Path()
          ..moveTo(center.dx, 0)
          ..lineTo(size.width, center.dy)
          ..lineTo(center.dx, size.height)
          ..lineTo(0, center.dy)
          ..close();
        canvas.drawPath(path, paint);
        break;

      case LegendSymbolShape.triangle:
        final path = Path()
          ..moveTo(center.dx, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _LegendSymbolPainter oldDelegate) {
    return color != oldDelegate.color || shape != oldDelegate.shape;
  }
}
