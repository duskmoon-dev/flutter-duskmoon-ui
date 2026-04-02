import 'package:flutter/widgets.dart';

/// A widget that groups child chart elements with optional transform and clip.
class Group extends StatelessWidget {
  /// The child widget to group.
  final Widget child;

  /// Optional translation offset.
  final Offset? translate;

  /// Optional rotation angle in radians.
  final double? rotation;

  /// Optional uniform scale factor.
  final double? scale;

  /// Optional scale factors for x and y axes.
  final Offset? scaleXY;

  /// Optional custom transform matrix.
  final Matrix4? transform;

  /// Whether to clip children to the group bounds.
  final bool clip;

  /// Optional clip rect when [clip] is true.
  final Rect? clipRect;

  /// Optional clip path when [clip] is true.
  final Path? clipPath;

  /// The clip behavior when clipping.
  final Clip clipBehavior;

  /// Optional opacity for the group (0.0 - 1.0).
  final double? opacity;

  /// Creates a group widget.
  const Group({
    super.key,
    required this.child,
    this.translate,
    this.rotation,
    this.scale,
    this.scaleXY,
    this.transform,
    this.clip = false,
    this.clipRect,
    this.clipPath,
    this.clipBehavior = Clip.antiAlias,
    this.opacity,
  });

  Matrix4 _buildTransform() {
    if (transform != null) return transform!;

    final matrix = Matrix4.identity();

    if (translate != null) {
      matrix.translateByDouble(translate!.dx, translate!.dy, 0, 1);
    }

    if (rotation != null) {
      matrix.rotateZ(rotation!);
    }

    if (scale != null) {
      matrix.scaleByDouble(scale!, scale!, 1, 1);
    } else if (scaleXY != null) {
      matrix.scaleByDouble(scaleXY!.dx, scaleXY!.dy, 1, 1);
    }

    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    // Apply clipping if enabled
    if (clip) {
      if (clipPath != null) {
        result = ClipPath(
          clipper: _PathClipper(clipPath!),
          clipBehavior: clipBehavior,
          child: result,
        );
      } else if (clipRect != null) {
        result = ClipRect(
          clipper: _RectClipper(clipRect!),
          clipBehavior: clipBehavior,
          child: result,
        );
      }
    }

    // Apply transform
    final hasTransform = translate != null ||
        rotation != null ||
        scale != null ||
        scaleXY != null ||
        transform != null;

    if (hasTransform) {
      result = Transform(
        transform: _buildTransform(),
        child: result,
      );
    }

    // Apply opacity
    if (opacity != null) {
      result = Opacity(
        opacity: opacity!.clamp(0.0, 1.0),
        child: result,
      );
    }

    return result;
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

class _RectClipper extends CustomClipper<Rect> {
  final Rect rect;

  _RectClipper(this.rect);

  @override
  Rect getClip(Size size) => rect;

  @override
  bool shouldReclip(_RectClipper oldClipper) => rect != oldClipper.rect;
}
