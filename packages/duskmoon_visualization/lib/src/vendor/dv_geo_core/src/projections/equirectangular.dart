import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import '../projection.dart';

/// Equirectangular (Plate Carrée) projection.
/// Maps longitude and latitude linearly to x and y.
class EquirectangularProjection with ProjectionMixin implements Projection {
  /// Creates an equirectangular projection.
  EquirectangularProjection({
    (double, double)? center,
    double scale = 1,
    Point? translate,
  }) {
    if (center != null) this.center = center;
    this.scale = scale;
    if (translate != null) this.translate = translate;
  }

  @override
  Point project(double longitude, double latitude) {
    final lon = toRadians(longitude - centerLon);
    final lat = toRadians(latitude);
    final cosLat0 = math.cos(toRadians(centerLat));

    final x = lon * cosLat0;
    final y = -lat; // Flip y for screen coordinates

    return applyTransform(x, y);
  }

  @override
  (double, double) invert(double x, double y) {
    final (rawX, rawY) = removeTransform(x, y);
    final cosLat0 = math.cos(toRadians(centerLat));

    final longitude = toDegrees(rawX / cosLat0) + centerLon;
    final latitude = toDegrees(-rawY);

    return (clampLongitude(longitude), clampLatitude(latitude));
  }

  @override
  Projection copy() {
    return EquirectangularProjection(
      center: center,
      scale: scale,
      translate: translate,
    );
  }
}

/// Creates an equirectangular projection.
EquirectangularProjection geoEquirectangular({
  (double, double)? center,
  double scale = 1,
  Point? translate,
}) {
  return EquirectangularProjection(
    center: center,
    scale: scale,
    translate: translate,
  );
}
