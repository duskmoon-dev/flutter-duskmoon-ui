import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import '../projection.dart';

/// Orthographic projection (globe view).
/// Shows the Earth as it appears from space.
class OrthographicProjection with ProjectionMixin implements Projection {
  double _rotate0 = 0;
  double _rotate1 = 0;
  double _rotate2 = 0;

  /// Creates an orthographic projection.
  OrthographicProjection({
    (double, double)? center,
    double scale = 1,
    Point? translate,
    (double, double, double)? rotate,
  }) {
    if (center != null) this.center = center;
    this.scale = scale;
    if (translate != null) this.translate = translate;
    if (rotate != null) {
      _rotate0 = rotate.$1;
      _rotate1 = rotate.$2;
      _rotate2 = rotate.$3;
    }
  }

  /// The rotation angles [lambda, phi, gamma].
  (double, double, double) get rotate => (_rotate0, _rotate1, _rotate2);
  set rotate((double, double, double) value) {
    _rotate0 = value.$1;
    _rotate1 = value.$2;
    _rotate2 = value.$3;
  }

  @override
  Point project(double longitude, double latitude) {
    final lambda = toRadians(longitude - centerLon + _rotate0);
    final phi = toRadians(latitude);

    final cosLambda = math.cos(lambda);
    final sinLambda = math.sin(lambda);
    final cosPhi = math.cos(phi);
    final sinPhi = math.sin(phi);

    // Check if point is on visible hemisphere
    final cosc = math.sin(toRadians(centerLat)) * sinPhi +
        math.cos(toRadians(centerLat)) * cosPhi * cosLambda;

    if (cosc < 0) {
      // Point is on back of globe, return NaN
      return const Point(double.nan, double.nan);
    }

    final x = cosPhi * sinLambda;
    final y = math.cos(toRadians(centerLat)) * sinPhi -
        math.sin(toRadians(centerLat)) * cosPhi * cosLambda;

    return applyTransform(x, -y);
  }

  @override
  (double, double) invert(double x, double y) {
    final (rawX, rawY) = removeTransform(x, y);
    final adjustedY = -rawY;

    final rho = math.sqrt(rawX * rawX + adjustedY * adjustedY);
    if (rho > 1) {
      return (double.nan, double.nan);
    }

    final c = math.asin(rho);
    final sinc = math.sin(c);
    final cosc = math.cos(c);

    final phi0 = toRadians(centerLat);
    final sinPhi0 = math.sin(phi0);
    final cosPhi0 = math.cos(phi0);

    double latitude;
    if (rho == 0) {
      latitude = centerLat;
    } else {
      latitude = toDegrees(
        math.asin(cosc * sinPhi0 + adjustedY * sinc * cosPhi0 / rho),
      );
    }

    double longitude;
    if (rho == 0) {
      longitude = centerLon;
    } else {
      longitude = centerLon +
          toDegrees(
            math.atan2(
              rawX * sinc,
              rho * cosPhi0 * cosc - adjustedY * sinPhi0 * sinc,
            ),
          ) -
          _rotate0;
    }

    return (clampLongitude(longitude), clampLatitude(latitude));
  }

  /// Returns the clip angle (90 degrees for orthographic).
  double get clipAngle => 90;

  @override
  Projection copy() {
    return OrthographicProjection(
      center: center,
      scale: scale,
      translate: translate,
      rotate: rotate,
    );
  }
}

/// Creates an orthographic projection.
OrthographicProjection geoOrthographic({
  (double, double)? center,
  double scale = 1,
  Point? translate,
  (double, double, double)? rotate,
}) {
  return OrthographicProjection(
    center: center,
    scale: scale,
    translate: translate,
    rotate: rotate,
  );
}
