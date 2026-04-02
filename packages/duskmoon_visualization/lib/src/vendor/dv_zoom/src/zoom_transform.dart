import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

/// A class representing a zoom transformation with scale and translation.
///
/// [ZoomTransform] encapsulates the state of a zoom/pan operation,
/// including the scale factor and translation offsets.
class ZoomTransform {
  /// The scale factor.
  final double scale;

  /// The horizontal translation.
  final double translateX;

  /// The vertical translation.
  final double translateY;

  /// Creates a ZoomTransform.
  const ZoomTransform({
    this.scale = 1.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
  });

  /// The identity transform (no zoom, no pan).
  static const ZoomTransform identity = ZoomTransform();

  /// The translation as an Offset.
  Offset get translate => Offset(translateX, translateY);

  /// Whether this is the identity transform.
  bool get isIdentity => scale == 1.0 && translateX == 0.0 && translateY == 0.0;

  /// Creates a ZoomTransform from a scale value.
  factory ZoomTransform.scale(double scale) {
    return ZoomTransform(scale: scale);
  }

  /// Creates a ZoomTransform from a translation.
  factory ZoomTransform.translate(double x, double y) {
    return ZoomTransform(translateX: x, translateY: y);
  }

  /// Creates a ZoomTransform from an Offset translation.
  factory ZoomTransform.translateOffset(Offset offset) {
    return ZoomTransform(translateX: offset.dx, translateY: offset.dy);
  }

  /// Converts this transform to a Matrix4.
  Matrix4 toMatrix4() {
    return Matrix4.identity()
      ..translateByDouble(translateX, translateY, 0.0, 1.0)
      ..scaleByDouble(scale, scale, 1.0, 1.0);
  }

  /// Applies this transform to a point.
  Offset apply(Offset point) {
    return Offset(
      point.dx * scale + translateX,
      point.dy * scale + translateY,
    );
  }

  /// Applies the inverse of this transform to a point.
  Offset invert(Offset point) {
    return Offset(
      (point.dx - translateX) / scale,
      (point.dy - translateY) / scale,
    );
  }

  /// Applies this transform to a rectangle.
  Rect applyToRect(Rect rect) {
    return Rect.fromLTRB(
      rect.left * scale + translateX,
      rect.top * scale + translateY,
      rect.right * scale + translateX,
      rect.bottom * scale + translateY,
    );
  }

  /// Applies the inverse transform to a rectangle.
  Rect invertRect(Rect rect) {
    return Rect.fromLTRB(
      (rect.left - translateX) / scale,
      (rect.top - translateY) / scale,
      (rect.right - translateX) / scale,
      (rect.bottom - translateY) / scale,
    );
  }

  /// Composes this transform with another.
  ZoomTransform compose(ZoomTransform other) {
    return ZoomTransform(
      scale: scale * other.scale,
      translateX: translateX * other.scale + other.translateX,
      translateY: translateY * other.scale + other.translateY,
    );
  }

  /// Returns the inverse of this transform.
  ZoomTransform get inverse {
    final invScale = 1 / scale;
    return ZoomTransform(
      scale: invScale,
      translateX: -translateX * invScale,
      translateY: -translateY * invScale,
    );
  }

  /// Interpolates between this transform and another.
  ZoomTransform lerp(ZoomTransform other, double t) {
    return ZoomTransform(
      scale: scale + (other.scale - scale) * t,
      translateX: translateX + (other.translateX - translateX) * t,
      translateY: translateY + (other.translateY - translateY) * t,
    );
  }

  /// Rescales to a new scale around a focal point.
  ZoomTransform rescale(double newScale, Offset focalPoint) {
    final scaleDiff = newScale / scale;
    return ZoomTransform(
      scale: newScale,
      translateX: focalPoint.dx - (focalPoint.dx - translateX) * scaleDiff,
      translateY: focalPoint.dy - (focalPoint.dy - translateY) * scaleDiff,
    );
  }

  /// Creates a copy with updated values.
  ZoomTransform copyWith({
    double? scale,
    double? translateX,
    double? translateY,
  }) {
    return ZoomTransform(
      scale: scale ?? this.scale,
      translateX: translateX ?? this.translateX,
      translateY: translateY ?? this.translateY,
    );
  }

  /// Creates a copy with translation from an Offset.
  ZoomTransform copyWithTranslate(Offset translate) {
    return ZoomTransform(
      scale: scale,
      translateX: translate.dx,
      translateY: translate.dy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ZoomTransform &&
        other.scale == scale &&
        other.translateX == translateX &&
        other.translateY == translateY;
  }

  @override
  int get hashCode => Object.hash(scale, translateX, translateY);

  @override
  String toString() {
    return 'ZoomTransform(scale: $scale, translate: ($translateX, $translateY))';
  }
}

/// Extension methods for ZoomTransform on Offset.
extension ZoomTransformOffsetExtension on Offset {
  /// Applies a zoom transform to this offset.
  Offset applyTransform(ZoomTransform transform) {
    return transform.apply(this);
  }

  /// Applies the inverse of a zoom transform to this offset.
  Offset invertTransform(ZoomTransform transform) {
    return transform.invert(this);
  }
}

/// Extension methods for ZoomTransform on Rect.
extension ZoomTransformRectExtension on Rect {
  /// Applies a zoom transform to this rect.
  Rect applyTransform(ZoomTransform transform) {
    return transform.applyToRect(this);
  }

  /// Applies the inverse of a zoom transform to this rect.
  Rect invertTransform(ZoomTransform transform) {
    return transform.invertRect(this);
  }
}
