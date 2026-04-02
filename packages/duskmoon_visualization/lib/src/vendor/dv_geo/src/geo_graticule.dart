import 'package:flutter/widgets.dart';

import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

/// Configuration for graticule lines.
class GraticuleConfig {
  /// The step in degrees for latitude lines.
  final double latitudeStep;

  /// The step in degrees for longitude lines.
  final double longitudeStep;

  /// The minimum latitude to render.
  final double minLatitude;

  /// The maximum latitude to render.
  final double maxLatitude;

  /// The minimum longitude to render.
  final double minLongitude;

  /// The maximum longitude to render.
  final double maxLongitude;

  /// The precision of each line (number of points).
  final int precision;

  /// Creates a graticule configuration.
  const GraticuleConfig({
    this.latitudeStep = 10.0,
    this.longitudeStep = 10.0,
    this.minLatitude = -90.0,
    this.maxLatitude = 90.0,
    this.minLongitude = -180.0,
    this.maxLongitude = 180.0,
    this.precision = 100,
  });

  /// Default graticule configuration with 10 degree steps.
  static const GraticuleConfig defaultConfig = GraticuleConfig();

  /// Creates a configuration with finer grid lines.
  static const GraticuleConfig fine = GraticuleConfig(
    latitudeStep: 5.0,
    longitudeStep: 5.0,
    precision: 200,
  );

  /// Creates a configuration with coarser grid lines.
  static const GraticuleConfig coarse = GraticuleConfig(
    latitudeStep: 30.0,
    longitudeStep: 30.0,
    precision: 50,
  );
}

/// A widget that displays graticule lines (latitude/longitude grid).
///
/// Graticules are the network of lines representing meridians and parallels
/// on a map projection.
class GeoGraticule extends StatelessWidget {
  /// The projection to use for rendering.
  final Projection projection;

  /// The graticule configuration.
  final GraticuleConfig config;

  /// The color for graticule lines.
  final Color color;

  /// The stroke width for graticule lines.
  final double strokeWidth;

  /// Whether to enable anti-aliasing.
  final bool antiAlias;

  /// Creates a GeoGraticule widget.
  const GeoGraticule({
    super.key,
    required this.projection,
    this.config = const GraticuleConfig(),
    this.color = const Color(0x40000000),
    this.strokeWidth = 0.5,
    this.antiAlias = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GraticulePainter(
        projection: projection,
        config: config,
        color: color,
        strokeWidth: strokeWidth,
        antiAlias: antiAlias,
      ),
      size: Size.infinite,
    );
  }
}

class _GraticulePainter extends CustomPainter {
  final Projection projection;
  final GraticuleConfig config;
  final Color color;
  final double strokeWidth;
  final bool antiAlias;

  _GraticulePainter({
    required this.projection,
    required this.config,
    required this.color,
    required this.strokeWidth,
    required this.antiAlias,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = antiAlias;

    // Draw latitude lines (parallels)
    for (double lat = config.minLatitude;
        lat <= config.maxLatitude;
        lat += config.latitudeStep) {
      _drawLatitudeLine(canvas, lat, paint);
    }

    // Draw longitude lines (meridians)
    for (double lon = config.minLongitude;
        lon <= config.maxLongitude;
        lon += config.longitudeStep) {
      _drawLongitudeLine(canvas, lon, paint);
    }
  }

  void _drawLatitudeLine(Canvas canvas, double latitude, Paint paint) {
    final path = Path();
    bool started = false;

    final lonStep =
        (config.maxLongitude - config.minLongitude) / config.precision;

    for (double lon = config.minLongitude;
        lon <= config.maxLongitude;
        lon += lonStep) {
      final point = projection.project(lon, latitude);

      if (point.hasNaN) {
        started = false;
        continue;
      }

      if (!started) {
        path.moveTo(point.x, point.y);
        started = true;
      } else {
        path.lineTo(point.x, point.y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawLongitudeLine(Canvas canvas, double longitude, Paint paint) {
    final path = Path();
    bool started = false;

    final latStep =
        (config.maxLatitude - config.minLatitude) / config.precision;

    for (double lat = config.minLatitude;
        lat <= config.maxLatitude;
        lat += latStep) {
      final point = projection.project(longitude, lat);

      if (point.hasNaN) {
        started = false;
        continue;
      }

      if (!started) {
        path.moveTo(point.x, point.y);
        started = true;
      } else {
        path.lineTo(point.x, point.y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_GraticulePainter oldDelegate) {
    return oldDelegate.projection != projection ||
        oldDelegate.config != config ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.antiAlias != antiAlias;
  }
}

/// Generates graticule line data for a given projection.
class Graticule {
  /// The projection to use.
  final Projection projection;

  /// The graticule configuration.
  final GraticuleConfig config;

  /// Creates a Graticule generator.
  Graticule(this.projection, [this.config = const GraticuleConfig()]);

  /// Generates latitude lines as lists of points.
  List<List<Point>> latitudeLines() {
    final lines = <List<Point>>[];

    for (double lat = config.minLatitude;
        lat <= config.maxLatitude;
        lat += config.latitudeStep) {
      final line = _generateLatitudeLine(lat);
      if (line.isNotEmpty) {
        lines.add(line);
      }
    }

    return lines;
  }

  /// Generates longitude lines as lists of points.
  List<List<Point>> longitudeLines() {
    final lines = <List<Point>>[];

    for (double lon = config.minLongitude;
        lon <= config.maxLongitude;
        lon += config.longitudeStep) {
      final line = _generateLongitudeLine(lon);
      if (line.isNotEmpty) {
        lines.add(line);
      }
    }

    return lines;
  }

  /// Generates all graticule lines.
  List<List<Point>> lines() {
    return [...latitudeLines(), ...longitudeLines()];
  }

  List<Point> _generateLatitudeLine(double latitude) {
    final points = <Point>[];
    final lonStep =
        (config.maxLongitude - config.minLongitude) / config.precision;

    for (double lon = config.minLongitude;
        lon <= config.maxLongitude;
        lon += lonStep) {
      final point = projection.project(lon, latitude);
      if (!point.hasNaN) {
        points.add(point);
      }
    }

    return points;
  }

  List<Point> _generateLongitudeLine(double longitude) {
    final points = <Point>[];
    final latStep =
        (config.maxLatitude - config.minLatitude) / config.precision;

    for (double lat = config.minLatitude;
        lat <= config.maxLatitude;
        lat += latStep) {
      final point = projection.project(longitude, lat);
      if (!point.hasNaN) {
        points.add(point);
      }
    }

    return points;
  }
}

/// Creates a Graticule generator.
Graticule graticule(Projection projection,
    [GraticuleConfig config = const GraticuleConfig()]) {
  return Graticule(projection, config);
}
