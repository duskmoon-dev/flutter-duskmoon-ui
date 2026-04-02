import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import '../projection.dart';

/// Albers equal-area conic projection.
/// Preserves area, commonly used for US maps.
class AlbersProjection with ProjectionMixin implements Projection {
  double _parallels0;
  double _parallels1;

  late double _n;
  late double _c;
  late double _rho0;

  /// Creates an Albers projection with standard parallels.
  AlbersProjection({
    (double, double)? center,
    double scale = 1,
    Point? translate,
    double parallels0 = 29.5,
    double parallels1 = 45.5,
  })  : _parallels0 = parallels0,
        _parallels1 = parallels1 {
    if (center != null) this.center = center;
    this.scale = scale;
    if (translate != null) this.translate = translate;
    _recalculate();
  }

  /// The standard parallels.
  (double, double) get parallels => (_parallels0, _parallels1);
  set parallels((double, double) value) {
    _parallels0 = value.$1;
    _parallels1 = value.$2;
    _recalculate();
  }

  void _recalculate() {
    final phi0 = toRadians(_parallels0);
    final phi1 = toRadians(_parallels1);
    final cosPhi0 = math.cos(phi0);
    final sinPhi0 = math.sin(phi0);
    final sinPhi1 = math.sin(phi1);

    _n = (sinPhi0 + sinPhi1) / 2;
    _c = cosPhi0 * cosPhi0 + 2 * _n * sinPhi0;
    _rho0 = math.sqrt(_c - 2 * _n * math.sin(toRadians(centerLat))) / _n;
  }

  @override
  set center((double, double) value) {
    super.center = value;
    _recalculate();
  }

  @override
  Point project(double longitude, double latitude) {
    final lambda = toRadians(longitude - centerLon);
    final phi = toRadians(latitude);

    final rho = math.sqrt(_c - 2 * _n * math.sin(phi)) / _n;
    final theta = _n * lambda;

    final x = rho * math.sin(theta);
    final y = _rho0 - rho * math.cos(theta);

    return applyTransform(x, -y);
  }

  @override
  (double, double) invert(double x, double y) {
    final (rawX, rawY) = removeTransform(x, y);
    final adjustedY = -rawY;

    final rho0MinusY = _rho0 - adjustedY;
    final rho = math.sqrt(rawX * rawX + rho0MinusY * rho0MinusY) * _n.sign;

    final theta = math.atan2(rawX, rho0MinusY);
    final phi =
        math.asin(((_c - rho * rho * _n * _n) / (2 * _n)).clamp(-1.0, 1.0));

    final longitude = toDegrees(theta / _n) + centerLon;
    final latitude = toDegrees(phi);

    return (clampLongitude(longitude), clampLatitude(latitude));
  }

  @override
  Projection copy() {
    return AlbersProjection(
      center: center,
      scale: scale,
      translate: translate,
      parallels0: _parallels0,
      parallels1: _parallels1,
    );
  }
}

/// Creates an Albers projection.
AlbersProjection geoAlbers({
  (double, double)? center,
  double scale = 1,
  Point? translate,
  double parallels0 = 29.5,
  double parallels1 = 45.5,
}) {
  return AlbersProjection(
    center: center,
    scale: scale,
    translate: translate,
    parallels0: parallels0,
    parallels1: parallels1,
  );
}

/// Creates an Albers USA projection centered on the contiguous United States.
AlbersProjection geoAlbersUsa() {
  return AlbersProjection(
    center: (-96, 38),
    scale: 1070,
    parallels0: 29.5,
    parallels1: 45.5,
  );
}
