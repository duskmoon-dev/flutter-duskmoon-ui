import 'package:flutter/widgets.dart';

/// A circular clip widget.
class CircleClip extends StatelessWidget {
  /// The center x coordinate.
  final double centerX;

  /// The center y coordinate.
  final double centerY;

  /// The radius of the clip circle.
  final double radius;

  /// The child widget to clip.
  final Widget child;

  /// The clip behavior.
  final Clip clipBehavior;

  /// Creates a circular clip widget.
  const CircleClip({
    super.key,
    required this.centerX,
    required this.centerY,
    required this.radius,
    required this.child,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Creates a circular clip from an Offset center.
  factory CircleClip.fromCenter(
    Offset center,
    double radius, {
    Key? key,
    required Widget child,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return CircleClip(
      key: key,
      centerX: center.dx,
      centerY: center.dy,
      radius: radius,
      child: child,
      clipBehavior: clipBehavior,
    );
  }

  /// Creates a circular clip that fills the parent.
  static Widget fill({
    Key? key,
    required Widget child,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return _CircleClipFill(
      key: key,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: _CircleClipper(centerX, centerY, radius),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

class _CircleClipper extends CustomClipper<Rect> {
  final double centerX;
  final double centerY;
  final double radius;

  _CircleClipper(this.centerX, this.centerY, this.radius);

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(centerX, centerY),
      radius: radius,
    );
  }

  @override
  bool shouldReclip(_CircleClipper oldClipper) =>
      centerX != oldClipper.centerX ||
      centerY != oldClipper.centerY ||
      radius != oldClipper.radius;
}

class _CircleClipFill extends StatelessWidget {
  final Widget child;
  final Clip clipBehavior;

  const _CircleClipFill({
    super.key,
    required this.child,
    required this.clipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final centerY = constraints.maxHeight / 2;
        final radius = (centerX < centerY ? centerX : centerY);

        return CircleClip(
          centerX: centerX,
          centerY: centerY,
          radius: radius,
          clipBehavior: clipBehavior,
          child: child,
        );
      },
    );
  }
}

/// An elliptical clip widget.
class EllipseClip extends StatelessWidget {
  /// The center x coordinate.
  final double centerX;

  /// The center y coordinate.
  final double centerY;

  /// The horizontal radius.
  final double radiusX;

  /// The vertical radius.
  final double radiusY;

  /// The child widget to clip.
  final Widget child;

  /// The clip behavior.
  final Clip clipBehavior;

  /// Creates an elliptical clip widget.
  const EllipseClip({
    super.key,
    required this.centerX,
    required this.centerY,
    required this.radiusX,
    required this.radiusY,
    required this.child,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: _EllipseClipper(centerX, centerY, radiusX, radiusY),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

class _EllipseClipper extends CustomClipper<Rect> {
  final double centerX;
  final double centerY;
  final double radiusX;
  final double radiusY;

  _EllipseClipper(this.centerX, this.centerY, this.radiusX, this.radiusY);

  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: radiusX * 2,
      height: radiusY * 2,
    );
  }

  @override
  bool shouldReclip(_EllipseClipper oldClipper) =>
      centerX != oldClipper.centerX ||
      centerY != oldClipper.centerY ||
      radiusX != oldClipper.radiusX ||
      radiusY != oldClipper.radiusY;
}
