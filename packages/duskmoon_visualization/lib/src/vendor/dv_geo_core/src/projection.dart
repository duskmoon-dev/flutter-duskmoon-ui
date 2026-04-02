import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

/// Base class for geographic projections.
abstract class Projection {
  /// Projects a geographic coordinate [longitude, latitude] to screen coordinates.
  Point project(double longitude, double latitude);

  /// Inverts screen coordinates to geographic [longitude, latitude].
  (double, double) invert(double x, double y);

  /// The center of the projection [longitude, latitude].
  (double, double) get center;
  set center((double, double) value);

  /// The scale factor.
  double get scale;
  set scale(double value);

  /// The translation offset.
  Point get translate;
  set translate(Point value);

  /// Creates a copy of this projection.
  Projection copy();
}

/// Converts degrees to radians.
double toRadians(double degrees) => degrees * math.pi / 180;

/// Converts radians to degrees.
double toDegrees(double radians) => radians * 180 / math.pi;

/// Clamps a value to valid latitude range.
double clampLatitude(double lat) => lat.clamp(-90.0, 90.0);

/// Clamps a value to valid longitude range.
double clampLongitude(double lon) {
  while (lon > 180) lon -= 360;
  while (lon < -180) lon += 360;
  return lon;
}

/// Helper for creating projections with common parameters.
mixin ProjectionMixin implements Projection {
  double _centerLon = 0;
  double _centerLat = 0;
  double _scale = 1;
  Point _translate = Point.zero;

  /// The center longitude (for use in subclasses).
  double get centerLon => _centerLon;

  /// The center latitude (for use in subclasses).
  double get centerLat => _centerLat;

  @override
  (double, double) get center => (_centerLon, _centerLat);

  @override
  set center((double, double) value) {
    _centerLon = value.$1;
    _centerLat = value.$2;
  }

  @override
  double get scale => _scale;

  @override
  set scale(double value) => _scale = value;

  @override
  Point get translate => _translate;

  @override
  set translate(Point value) => _translate = value;

  /// Applies scale and translation to raw projected coordinates.
  Point applyTransform(double x, double y) {
    return Point(
      x * _scale + _translate.x,
      y * _scale + _translate.y,
    );
  }

  /// Removes scale and translation from screen coordinates.
  (double, double) removeTransform(double x, double y) {
    return (
      (x - _translate.x) / _scale,
      (y - _translate.y) / _scale,
    );
  }
}
