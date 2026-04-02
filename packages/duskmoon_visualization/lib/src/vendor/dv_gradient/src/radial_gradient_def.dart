import 'package:flutter/widgets.dart';

import 'linear_gradient_def.dart';

/// A radial gradient definition widget for chart styling.
class RadialGradientDef extends StatelessWidget {
  /// Unique identifier for this gradient.
  final String id;

  /// The gradient stops and colors.
  final List<GradientStop> stops;

  /// The center of the gradient.
  final Alignment center;

  /// The radius of the gradient (1.0 = corner to corner).
  final double radius;

  /// The focal point of the gradient (defaults to center).
  final Alignment? focal;

  /// The focal radius.
  final double focalRadius;

  /// How to tile the gradient beyond its bounds.
  final TileMode tileMode;

  /// Optional transform matrix.
  final GradientTransform? transform;

  /// Child widget to apply the gradient to.
  final Widget? child;

  /// Creates a radial gradient definition.
  const RadialGradientDef({
    super.key,
    required this.id,
    required this.stops,
    this.center = Alignment.center,
    this.radius = 0.5,
    this.focal,
    this.focalRadius = 0.0,
    this.tileMode = TileMode.clamp,
    this.transform,
    this.child,
  });

  /// Creates the Flutter RadialGradient from this definition.
  RadialGradient toGradient() {
    return RadialGradient(
      center: center,
      radius: radius,
      focal: focal,
      focalRadius: focalRadius,
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

/// A sweep (angular) gradient definition widget.
class SweepGradientDef extends StatelessWidget {
  /// Unique identifier for this gradient.
  final String id;

  /// The gradient stops and colors.
  final List<GradientStop> stops;

  /// The center of the gradient.
  final Alignment center;

  /// The start angle in radians.
  final double startAngle;

  /// The end angle in radians.
  final double endAngle;

  /// How to tile the gradient beyond its bounds.
  final TileMode tileMode;

  /// Optional transform matrix.
  final GradientTransform? transform;

  /// Child widget to apply the gradient to.
  final Widget? child;

  /// Creates a sweep gradient definition.
  const SweepGradientDef({
    super.key,
    required this.id,
    required this.stops,
    this.center = Alignment.center,
    this.startAngle = 0.0,
    this.endAngle = 6.283185307179586, // 2 * pi
    this.tileMode = TileMode.clamp,
    this.transform,
    this.child,
  });

  /// Creates the Flutter SweepGradient from this definition.
  SweepGradient toGradient() {
    return SweepGradient(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
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
