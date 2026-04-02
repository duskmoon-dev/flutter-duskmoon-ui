import 'package:flutter/widgets.dart';

import 'legend.dart';

/// A standalone legend item widget with a symbol and label.
///
/// LegendItem can be used to build custom legend layouts or
/// to display individual legend entries outside of a Legend widget.
///
/// Example usage:
/// ```dart
/// LegendItem(
///   label: 'Sales',
///   color: Colors.blue,
///   symbolShape: LegendSymbolShape.circle,
///   symbolSize: 12,
/// )
/// ```
class LegendItem extends StatelessWidget {
  /// The label text.
  final String label;

  /// The color for the symbol.
  final Color color;

  /// The shape of the symbol.
  final LegendSymbolShape symbolShape;

  /// The size of the symbol.
  final double symbolSize;

  /// Spacing between symbol and label.
  final double symbolLabelSpacing;

  /// Text style for the label.
  final TextStyle? labelStyle;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Whether the item is currently selected.
  final bool isSelected;

  /// Opacity when not selected (if part of a toggleable legend).
  final double inactiveOpacity;

  /// Creates a legend item.
  const LegendItem({
    super.key,
    required this.label,
    required this.color,
    this.symbolShape = LegendSymbolShape.circle,
    this.symbolSize = 12,
    this.symbolLabelSpacing = 4,
    this.labelStyle,
    this.onTap,
    this.isSelected = true,
    this.inactiveOpacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle = labelStyle ??
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
            size: Size(symbolSize, symbolSize),
            painter: _LegendItemSymbolPainter(
              color: color,
              shape: symbolShape,
            ),
          ),
          SizedBox(width: symbolLabelSpacing),
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

class _LegendItemSymbolPainter extends CustomPainter {
  final Color color;
  final LegendSymbolShape shape;

  _LegendItemSymbolPainter({
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
  bool shouldRepaint(covariant _LegendItemSymbolPainter oldDelegate) {
    return color != oldDelegate.color || shape != oldDelegate.shape;
  }
}

/// Creates a LegendItem widget.
Widget legendItem({
  Key? key,
  required String label,
  required Color color,
  LegendSymbolShape symbolShape = LegendSymbolShape.circle,
  double symbolSize = 12,
  double symbolLabelSpacing = 4,
  TextStyle? labelStyle,
  VoidCallback? onTap,
  bool isSelected = true,
  double inactiveOpacity = 0.3,
}) {
  return LegendItem(
    key: key,
    label: label,
    color: color,
    symbolShape: symbolShape,
    symbolSize: symbolSize,
    symbolLabelSpacing: symbolLabelSpacing,
    labelStyle: labelStyle,
    onTap: onTap,
    isSelected: isSelected,
    inactiveOpacity: inactiveOpacity,
  );
}
