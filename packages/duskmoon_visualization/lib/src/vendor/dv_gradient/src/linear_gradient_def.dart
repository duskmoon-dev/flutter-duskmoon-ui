import 'package:flutter/widgets.dart';

/// A linear gradient definition widget for chart styling.
class LinearGradientDef extends StatelessWidget {
  /// Unique identifier for this gradient.
  final String id;

  /// The gradient stops and colors.
  final List<GradientStop> stops;

  /// Start point of the gradient (0,0 = top-left, 1,1 = bottom-right).
  final Alignment begin;

  /// End point of the gradient.
  final Alignment end;

  /// How to tile the gradient beyond its bounds.
  final TileMode tileMode;

  /// Optional transform matrix.
  final GradientTransform? transform;

  /// Child widget to apply the gradient to.
  final Widget? child;

  /// Creates a linear gradient definition.
  const LinearGradientDef({
    super.key,
    required this.id,
    required this.stops,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.tileMode = TileMode.clamp,
    this.transform,
    this.child,
  });

  /// Creates the Flutter LinearGradient from this definition.
  LinearGradient toGradient() {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: stops.map((s) => s.color).toList(),
      stops: stops.map((s) => s.offset).toList(),
      tileMode: tileMode,
      transform: transform,
    );
  }

  /// Creates a shader from this gradient for the given bounds.
  Shader createShader(Rect bounds) {
    return toGradient().createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      return const SizedBox.shrink();
    }

    return ShaderMask(
      shaderCallback: createShader,
      blendMode: BlendMode.srcIn,
      child: child,
    );
  }
}

/// A gradient stop with color and position.
class GradientStop {
  /// The color at this stop.
  final Color color;

  /// The position of this stop (0.0 - 1.0).
  final double offset;

  /// Creates a gradient stop.
  const GradientStop(this.offset, this.color);

  /// Creates a gradient stop from offset and color.
  factory GradientStop.at(double offset, Color color) {
    return GradientStop(offset, color);
  }
}

/// Extension for creating gradients from color lists.
extension GradientColors on List<Color> {
  /// Creates evenly-spaced gradient stops from this color list.
  List<GradientStop> toGradientStops() {
    if (isEmpty) return [];
    if (length == 1) return [GradientStop(0.5, first)];

    return List.generate(length, (i) {
      return GradientStop(i / (length - 1), this[i]);
    });
  }
}

/// Common gradient presets.
class GradientPresets {
  GradientPresets._();

  /// Blue to purple gradient.
  static const bluePurple = [
    GradientStop(0, Color(0xFF2196F3)),
    GradientStop(1, Color(0xFF9C27B0)),
  ];

  /// Orange to red gradient.
  static const orangeRed = [
    GradientStop(0, Color(0xFFFF9800)),
    GradientStop(1, Color(0xFFF44336)),
  ];

  /// Green to teal gradient.
  static const greenTeal = [
    GradientStop(0, Color(0xFF4CAF50)),
    GradientStop(1, Color(0xFF009688)),
  ];

  /// Gray gradient.
  static const gray = [
    GradientStop(0, Color(0xFF9E9E9E)),
    GradientStop(1, Color(0xFF424242)),
  ];

  /// Heat map gradient (blue -> green -> yellow -> red).
  static const heatmap = [
    GradientStop(0, Color(0xFF2196F3)),
    GradientStop(0.33, Color(0xFF4CAF50)),
    GradientStop(0.66, Color(0xFFFFEB3B)),
    GradientStop(1, Color(0xFFF44336)),
  ];
}
