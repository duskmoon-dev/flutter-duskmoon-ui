import 'package:flutter/widgets.dart';

/// A rectangular clip widget.
class RectClip extends StatelessWidget {
  /// The clip rectangle.
  final Rect rect;

  /// The child widget to clip.
  final Widget child;

  /// The clip behavior.
  final Clip clipBehavior;

  /// Optional corner radius for rounded corners.
  final double? cornerRadius;

  /// Optional individual corner radii.
  final BorderRadius? borderRadius;

  /// Creates a rectangular clip widget.
  const RectClip({
    super.key,
    required this.rect,
    required this.child,
    this.clipBehavior = Clip.antiAlias,
    this.cornerRadius,
    this.borderRadius,
  });

  /// Creates a rectangular clip from LTRB values.
  factory RectClip.fromLTRB(
    double left,
    double top,
    double right,
    double bottom, {
    Key? key,
    required Widget child,
    Clip clipBehavior = Clip.antiAlias,
    double? cornerRadius,
  }) {
    return RectClip(
      key: key,
      rect: Rect.fromLTRB(left, top, right, bottom),
      child: child,
      clipBehavior: clipBehavior,
      cornerRadius: cornerRadius,
    );
  }

  /// Creates a rectangular clip from position and size.
  factory RectClip.fromLTWH(
    double left,
    double top,
    double width,
    double height, {
    Key? key,
    required Widget child,
    Clip clipBehavior = Clip.antiAlias,
    double? cornerRadius,
  }) {
    return RectClip(
      key: key,
      rect: Rect.fromLTWH(left, top, width, height),
      child: child,
      clipBehavior: clipBehavior,
      cornerRadius: cornerRadius,
    );
  }

  /// Creates a rectangular clip with insets from the parent size.
  static Widget inset({
    Key? key,
    required Widget child,
    required EdgeInsets insets,
    Clip clipBehavior = Clip.antiAlias,
    double? cornerRadius,
  }) {
    return _RectClipInset(
      key: key,
      insets: insets,
      clipBehavior: clipBehavior,
      cornerRadius: cornerRadius,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cornerRadius != null || borderRadius != null) {
      final br = borderRadius ?? BorderRadius.circular(cornerRadius!);
      return ClipRRect(
        clipper: _RRectClipper(rect, br),
        clipBehavior: clipBehavior,
        child: child,
      );
    }

    return ClipRect(
      clipper: _RectClipper(rect),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

class _RectClipper extends CustomClipper<Rect> {
  final Rect rect;

  _RectClipper(this.rect);

  @override
  Rect getClip(Size size) => rect;

  @override
  bool shouldReclip(_RectClipper oldClipper) => rect != oldClipper.rect;
}

class _RRectClipper extends CustomClipper<RRect> {
  final Rect rect;
  final BorderRadius borderRadius;

  _RRectClipper(this.rect, this.borderRadius);

  @override
  RRect getClip(Size size) => borderRadius.toRRect(rect);

  @override
  bool shouldReclip(_RRectClipper oldClipper) =>
      rect != oldClipper.rect || borderRadius != oldClipper.borderRadius;
}

class _RectClipInset extends StatelessWidget {
  final EdgeInsets insets;
  final Widget child;
  final Clip clipBehavior;
  final double? cornerRadius;

  const _RectClipInset({
    super.key,
    required this.insets,
    required this.child,
    required this.clipBehavior,
    this.cornerRadius,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rect = Rect.fromLTRB(
          insets.left,
          insets.top,
          constraints.maxWidth - insets.right,
          constraints.maxHeight - insets.bottom,
        );

        return RectClip(
          rect: rect,
          clipBehavior: clipBehavior,
          cornerRadius: cornerRadius,
          child: child,
        );
      },
    );
  }
}
