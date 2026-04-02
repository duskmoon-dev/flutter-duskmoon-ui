import 'package:flutter/widgets.dart';

/// A clip path wrapper widget that clips children to a custom path.
class ChartClipPath extends StatelessWidget {
  /// The path to clip to.
  final Path path;

  /// The child widget to clip.
  final Widget child;

  /// The clip behavior.
  final Clip clipBehavior;

  /// Creates a chart clip path widget.
  const ChartClipPath({
    super.key,
    required this.path,
    required this.child,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _PathClipper(path),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

class _PathClipper extends CustomClipper<Path> {
  final Path path;

  _PathClipper(this.path);

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(_PathClipper oldClipper) => path != oldClipper.path;
}

/// A clip path widget using a builder function.
class ChartClipPathBuilder extends StatelessWidget {
  /// Builder function that creates the clip path.
  final Path Function(Size size) pathBuilder;

  /// The child widget to clip.
  final Widget child;

  /// The clip behavior.
  final Clip clipBehavior;

  /// Creates a chart clip path builder widget.
  const ChartClipPathBuilder({
    super.key,
    required this.pathBuilder,
    required this.child,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _PathBuilderClipper(pathBuilder),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

class _PathBuilderClipper extends CustomClipper<Path> {
  final Path Function(Size size) pathBuilder;

  _PathBuilderClipper(this.pathBuilder);

  @override
  Path getClip(Size size) => pathBuilder(size);

  @override
  bool shouldReclip(_PathBuilderClipper oldClipper) => true;
}

/// Extension for common clip path operations.
extension ClipPathHelpers on Path {
  /// Creates a rounded rectangle clip path.
  static Path roundedRect(
    Rect rect, {
    double radius = 0,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return Path()
      ..addRRect(RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(topLeft ?? radius),
        topRight: Radius.circular(topRight ?? radius),
        bottomLeft: Radius.circular(bottomLeft ?? radius),
        bottomRight: Radius.circular(bottomRight ?? radius),
      ));
  }

  /// Creates an inset clip path.
  static Path inset(Size size, EdgeInsets insets) {
    return Path()
      ..addRect(Rect.fromLTRB(
        insets.left,
        insets.top,
        size.width - insets.right,
        size.height - insets.bottom,
      ));
  }
}
