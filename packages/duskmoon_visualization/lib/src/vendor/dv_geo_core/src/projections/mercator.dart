import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import '../projection.dart';

/// Mercator projection.
/// Preserves angles and shapes locally, but distorts areas near poles.
class MercatorProjection with ProjectionMixin implements Projection {
  /// Creates a Mercator projection.
  MercatorProjection({
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
    // Clamp latitude to avoid infinity at poles
    latitude = latitude.clamp(-85.0511, 85.0511);

    final lon = toRadians(longitude - centerLon);
    final lat = toRadians(latitude);

    final x = lon;
    final y = -math.log(math.tan(math.pi / 4 + lat / 2));

    return applyTransform(x, y);
  }

  @override
  (double, double) invert(double x, double y) {
    final (rawX, rawY) = removeTransform(x, y);

    final longitude = toDegrees(rawX) + centerLon;
    final latitude = toDegrees(2 * math.atan(math.exp(-rawY)) - math.pi / 2);

    return (clampLongitude(longitude), clampLatitude(latitude));
  }

  @override
  Projection copy() {
    return MercatorProjection(
      center: center,
      scale: scale,
      translate: translate,
    );
  }
}

/// Creates a Mercator projection.
MercatorProjection geoMercator({
  (double, double)? center,
  double scale = 1,
  Point? translate,
}) {
  return MercatorProjection(
    center: center,
    scale: scale,
    translate: translate,
  );
}

/// Transverse Mercator projection.
class TransverseMercatorProjection with ProjectionMixin implements Projection {
  TransverseMercatorProjection({
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

    final cosLat = math.cos(lat);
    final sinLon = math.sin(lon);
    final cosLon = math.cos(lon);

    final x = math.atan2(math.tan(lat), cosLon);
    final y = 0.5 * math.log((1 + cosLat * sinLon) / (1 - cosLat * sinLon));

    return applyTransform(y, -x);
  }

  @override
  (double, double) invert(double x, double y) {
    final (rawY, rawX) = removeTransform(x, y);

    final sinhY = (math.exp(rawY) - math.exp(-rawY)) / 2;
    final cosX = math.cos(-rawX);
    final sinX = math.sin(-rawX);

    final longitude = toDegrees(math.atan2(sinhY, cosX)) + centerLon;
    final latitude = toDegrees(
        math.asin(sinX / math.sqrt(sinhY * sinhY + cosX * cosX + sinX * sinX)));

    return (clampLongitude(longitude), clampLatitude(latitude));
  }

  @override
  Projection copy() {
    return TransverseMercatorProjection(
      center: center,
      scale: scale,
      translate: translate,
    );
  }
}

/// Creates a transverse Mercator projection.
TransverseMercatorProjection geoTransverseMercator({
  (double, double)? center,
  double scale = 1,
  Point? translate,
}) {
  return TransverseMercatorProjection(
    center: center,
    scale: scale,
    translate: translate,
  );
}
