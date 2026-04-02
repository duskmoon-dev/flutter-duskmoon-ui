import 'package:flutter/widgets.dart';

/// Orientation for the linear legend gradient.
enum LegendLinearOrientation {
  /// Horizontal gradient.
  horizontal,

  /// Vertical gradient.
  vertical,
}

/// Configuration for the linear legend.
class LegendLinearConfig {
  /// The orientation of the gradient.
  final LegendLinearOrientation orientation;

  /// The length of the gradient bar.
  final double length;

  /// The thickness of the gradient bar.
  final double thickness;

  /// Border radius for the gradient bar.
  final double borderRadius;

  /// Text style for labels.
  final TextStyle? labelStyle;

  /// Number of tick labels to show.
  final int labelCount;

  /// Spacing between the gradient bar and labels.
  final double labelSpacing;

  /// Creates a linear legend configuration.
  const LegendLinearConfig({
    this.orientation = LegendLinearOrientation.horizontal,
    this.length = 200,
    this.thickness = 12,
    this.borderRadius = 2,
    this.labelStyle,
    this.labelCount = 5,
    this.labelSpacing = 4,
  });

  /// Creates a copy with modified values.
  LegendLinearConfig copyWith({
    LegendLinearOrientation? orientation,
    double? length,
    double? thickness,
    double? borderRadius,
    TextStyle? labelStyle,
    int? labelCount,
    double? labelSpacing,
  }) {
    return LegendLinearConfig(
      orientation: orientation ?? this.orientation,
      length: length ?? this.length,
      thickness: thickness ?? this.thickness,
      borderRadius: borderRadius ?? this.borderRadius,
      labelStyle: labelStyle ?? this.labelStyle,
      labelCount: labelCount ?? this.labelCount,
      labelSpacing: labelSpacing ?? this.labelSpacing,
    );
  }
}

/// A legend for continuous/linear data showing a color gradient.
///
/// LegendLinear displays a gradient bar with tick labels to show
/// the mapping between numeric values and colors in a continuous
/// color scale.
///
/// Example usage:
/// ```dart
/// LegendLinear(
///   scale: scaleSequential(
///     domain: [0, 100],
///     interpolator: interpolateBlues,
///   ),
///   config: LegendLinearConfig(
///     length: 200,
///     labelCount: 5,
///   ),
/// )
/// ```
class LegendLinear extends StatelessWidget {
  /// The continuous color scale to visualize.
  final dynamic scale;

  /// Configuration for the legend.
  final LegendLinearConfig config;

  /// Custom tick values for labels.
  final List<double>? tickValues;

  /// Custom tick format function.
  final String Function(double)? tickFormat;

  /// Optional title for the legend.
  final String? title;

  /// Text style for the title.
  final TextStyle? titleStyle;

  /// Creates a linear legend.
  const LegendLinear({
    super.key,
    required this.scale,
    this.config = const LegendLinearConfig(),
    this.tickValues,
    this.tickFormat,
    this.title,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle = config.labelStyle ??
        const TextStyle(
          fontSize: 10,
          color: Color(0xFF000000),
        );

    final effectiveTitleStyle = titleStyle ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        );

    final ticks = tickValues ?? _generateTicks();
    final format = tickFormat ?? _defaultFormat;

    Widget legendContent;

    if (config.orientation == LegendLinearOrientation.horizontal) {
      legendContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: effectiveTitleStyle),
            SizedBox(height: config.labelSpacing),
          ],
          CustomPaint(
            size: Size(config.length, config.thickness),
            painter: _HorizontalGradientPainter(
              scale: scale,
              borderRadius: config.borderRadius,
            ),
          ),
          SizedBox(height: config.labelSpacing),
          SizedBox(
            width: config.length,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ticks
                  .map((tick) => Text(format(tick), style: effectiveLabelStyle))
                  .toList(),
            ),
          ),
        ],
      );
    } else {
      legendContent = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            RotatedBox(
              quarterTurns: 3,
              child: Text(title!, style: effectiveTitleStyle),
            ),
            SizedBox(width: config.labelSpacing),
          ],
          CustomPaint(
            size: Size(config.thickness, config.length),
            painter: _VerticalGradientPainter(
              scale: scale,
              borderRadius: config.borderRadius,
            ),
          ),
          SizedBox(width: config.labelSpacing),
          SizedBox(
            height: config.length,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ticks.reversed
                  .map((tick) => Text(format(tick), style: effectiveLabelStyle))
                  .toList(),
            ),
          ),
        ],
      );
    }

    return legendContent;
  }

  List<double> _generateTicks() {
    try {
      // Try to get domain from scale
      final domain = List<double>.from(scale.domain);
      if (domain.length >= 2) {
        final min = domain.first;
        final max = domain.last;
        final step = (max - min) / (config.labelCount - 1);
        return List.generate(
          config.labelCount,
          (i) => min + step * i,
        );
      }
    } catch (_) {}
    return [0, 25, 50, 75, 100];
  }

  String _defaultFormat(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }
}

class _HorizontalGradientPainter extends CustomPainter {
  final dynamic scale;
  final double borderRadius;

  _HorizontalGradientPainter({
    required this.scale,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Create gradient stops
    final colors = <Color>[];
    final stops = <double>[];
    const numStops = 20;

    for (int i = 0; i <= numStops; i++) {
      final t = i / numStops;
      stops.add(t);
      colors.add(_getColorAt(t));
    }

    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: colors,
      stops: stops,
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  Color _getColorAt(double t) {
    try {
      final domain = List<double>.from(scale.domain);
      final min = domain.first;
      final max = domain.last;
      final value = min + (max - min) * t;
      final result = scale(value);

      if (result is Color) return result;
      if (result is String) return _parseColor(result);
    } catch (_) {}
    return const Color(0xFF000000);
  }

  Color _parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      var hex = colorString.substring(1);
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    }
    return const Color(0xFF000000);
  }

  @override
  bool shouldRepaint(covariant _HorizontalGradientPainter oldDelegate) {
    return scale != oldDelegate.scale ||
        borderRadius != oldDelegate.borderRadius;
  }
}

class _VerticalGradientPainter extends CustomPainter {
  final dynamic scale;
  final double borderRadius;

  _VerticalGradientPainter({
    required this.scale,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Create gradient stops
    final colors = <Color>[];
    final stops = <double>[];
    const numStops = 20;

    for (int i = 0; i <= numStops; i++) {
      final t = i / numStops;
      stops.add(t);
      colors.add(_getColorAt(1 - t)); // Reverse for vertical
    }

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: stops,
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  Color _getColorAt(double t) {
    try {
      final domain = List<double>.from(scale.domain);
      final min = domain.first;
      final max = domain.last;
      final value = min + (max - min) * t;
      final result = scale(value);

      if (result is Color) return result;
      if (result is String) return _parseColor(result);
    } catch (_) {}
    return const Color(0xFF000000);
  }

  Color _parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      var hex = colorString.substring(1);
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    }
    return const Color(0xFF000000);
  }

  @override
  bool shouldRepaint(covariant _VerticalGradientPainter oldDelegate) {
    return scale != oldDelegate.scale ||
        borderRadius != oldDelegate.borderRadius;
  }
}

/// Creates a LegendLinear widget.
Widget legendLinear({
  Key? key,
  required dynamic scale,
  LegendLinearConfig config = const LegendLinearConfig(),
  List<double>? tickValues,
  String Function(double)? tickFormat,
  String? title,
  TextStyle? titleStyle,
}) {
  return LegendLinear(
    key: key,
    scale: scale,
    config: config,
    tickValues: tickValues,
    tickFormat: tickFormat,
    title: title,
    titleStyle: titleStyle,
  );
}
