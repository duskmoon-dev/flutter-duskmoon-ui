import 'package:flutter/widgets.dart';

import 'legend.dart';

/// A legend for categorical/ordinal data.
///
/// LegendOrdinal works with ordinal scales to display a legend
/// that maps discrete domain values to colors or other visual
/// properties.
///
/// Example usage:
/// ```dart
/// LegendOrdinal(
///   scale: scaleOrdinal(
///     domain: ['A', 'B', 'C'],
///     range: [Colors.blue, Colors.red, Colors.green],
///   ),
///   config: LegendConfig(direction: LegendDirection.horizontal),
/// )
/// ```
class LegendOrdinal<T> extends StatelessWidget {
  /// The ordinal scale to use.
  final dynamic scale;

  /// Optional custom labels for domain values.
  final Map<T, String>? labels;

  /// Configuration for the legend.
  final LegendConfig config;

  /// Callback when an entry is tapped.
  final void Function(T value, int index)? onTap;

  /// Set of selected values (for toggleable legends).
  final Set<T>? selectedValues;

  /// Opacity for unselected items.
  final double inactiveOpacity;

  /// Creates an ordinal legend.
  const LegendOrdinal({
    super.key,
    required this.scale,
    this.labels,
    this.config = const LegendConfig(),
    this.onTap,
    this.selectedValues,
    this.inactiveOpacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    final domain = _getDomain();
    final entries = domain.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final color = _getColor(value);
      final label = labels?[value] ?? value.toString();
      final isSelected = selectedValues?.contains(value) ?? true;

      return _OrdinalLegendItem(
        value: value,
        label: label,
        color: color,
        config: config,
        isSelected: isSelected,
        inactiveOpacity: inactiveOpacity,
        onTap: onTap != null ? () => onTap!(value, index) : null,
      );
    }).toList();

    if (config.direction == LegendDirection.horizontal) {
      return Wrap(
        spacing: config.itemSpacing,
        runSpacing: config.itemSpacing / 2,
        children: entries,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entries
            .map((item) => Padding(
                  padding: EdgeInsets.only(bottom: config.itemSpacing / 2),
                  child: item,
                ))
            .toList(),
      );
    }
  }

  List<T> _getDomain() {
    try {
      return List<T>.from(scale.domain);
    } catch (_) {
      return [];
    }
  }

  Color _getColor(T value) {
    try {
      final result = scale(value);
      if (result is Color) return result;
      if (result is String) return _parseColor(result);
      return const Color(0xFF000000);
    } catch (_) {
      return const Color(0xFF000000);
    }
  }

  Color _parseColor(String colorString) {
    // Handle hex color strings
    if (colorString.startsWith('#')) {
      var hex = colorString.substring(1);
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    }
    return const Color(0xFF000000);
  }
}

class _OrdinalLegendItem<T> extends StatelessWidget {
  final T value;
  final String label;
  final Color color;
  final LegendConfig config;
  final bool isSelected;
  final double inactiveOpacity;
  final VoidCallback? onTap;

  const _OrdinalLegendItem({
    required this.value,
    required this.label,
    required this.color,
    required this.config,
    required this.isSelected,
    required this.inactiveOpacity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle = config.labelStyle ??
        const TextStyle(
          fontSize: 12,
          color: Color(0xFF000000),
        );

    final opacity = isSelected ? 1.0 : inactiveOpacity;

    final content = Opacity(
      opacity: opacity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: Size(config.symbolSize, config.symbolSize),
            painter: _OrdinalSymbolPainter(
              color: color,
              shape: config.symbolShape,
            ),
          ),
          SizedBox(width: config.symbolLabelSpacing),
          Text(label, style: effectiveLabelStyle),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

class _OrdinalSymbolPainter extends CustomPainter {
  final Color color;
  final LegendSymbolShape shape;

  _OrdinalSymbolPainter({
    required this.color,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    switch (shape) {
      case LegendSymbolShape.circle:
        canvas.drawCircle(center, size.width / 2, paint);
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
  bool shouldRepaint(covariant _OrdinalSymbolPainter oldDelegate) {
    return color != oldDelegate.color || shape != oldDelegate.shape;
  }
}

/// Creates a LegendOrdinal widget.
Widget legendOrdinal<T>({
  Key? key,
  required dynamic scale,
  Map<T, String>? labels,
  LegendConfig config = const LegendConfig(),
  void Function(T value, int index)? onTap,
  Set<T>? selectedValues,
  double inactiveOpacity = 0.3,
}) {
  return LegendOrdinal<T>(
    key: key,
    scale: scale,
    labels: labels,
    config: config,
    onTap: onTap,
    selectedValues: selectedValues,
    inactiveOpacity: inactiveOpacity,
  );
}
