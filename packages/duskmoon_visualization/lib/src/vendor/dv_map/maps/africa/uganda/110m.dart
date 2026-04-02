// Generated from: assets/africa/uganda.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/uganda.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWwWrkMAyG7/MUJueOkCzJlnorC7vXvexpKUto0zLQJmWaPZTSd18y0yntOLAoB+NY9odk/VLyukmpm1+ehu4ydd+Hfv67H75NDw/Dzbybxu5iMd8dl5+7y/R7k1JKr4exPXjYfjA87aenYT/vDodO21Pqxv7xcODXfT/e9h/7U+p2z9OfPh9sP5p1Pq5ffTbcTOO8G4dxXmxXd/vdTd+9W98+/Lgfpsdh3r989eLk9s/p4eX+PcoP6rS/3Y39/Cnc4/N5fv6WEjM4ciXKF2eWLYLrl7Xri/+hzFmLn5MQCN2IYzQBspakFKWUmumcQ0C1uIRICsjqTXAEjmoxlIB6wXqOYkDlGkVJdeIWpaolSELUc45AFjcTDwqBm3tiqDFIhmJFGlkunMw5hCIwI2mCWy7Jcg2isqiWFa+MYvEhGLNplhW30KlSLH3vuFagR1yJ0mplltJUYAZmN2MO3hpVIfEmmxkyihSN5RPBNJeKK3Vt4uwl1iMQpJhibQRCoMaGGitJBLRCyo1ICLBkppjisoNVrdXWmqFXrh6S3YIjV+S1fp9RmTCUi+ygVo1r494WF4ugRsPV6lJK6x8BCzHFan+JN5OSNdnYEogw5xzNrpATSlNnWwJiKeoUrbTiq94hicaETGClUPNdWVi5cqwDRP4LNmvz0+xtcxqvN2+bf3gfPhK4CQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/uganda.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaUganda110m {
  if (_cached != null) return _cached!;

  // Decode base64 and decompress
  final compressed = base64Decode(_kCompressedData);
  final decompressed = gzip.decode(compressed);
  final jsonString = utf8.decode(decompressed);

  // Parse GeoJSON
  final data = parseGeoJson(
    jsonDecode(jsonString) as Map<String, dynamic>,
  );

  if (data is! GeoJsonFeatureCollection) {
    throw StateError('Invalid GeoJSON format');
  }

  _cached = data;
  return _cached!;
}

/// Widget for rendering the africa/uganda.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Uganda110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Uganda110mWidget extends StatelessWidget {
  /// The projection to use for rendering.
  final Projection projection;

  /// The color to use for filling shapes.
  final Color? fillColor;

  /// The color to use for stroking shapes.
  final Color? strokeColor;

  /// The stroke width for shape outlines.
  final double strokeWidth;

  /// Optional callback when a feature is tapped.
  final void Function(GeoJsonFeature feature, Point position)? onFeatureTap;

  /// Whether to enable anti-aliasing.
  final bool antiAlias;

  /// Creates a Uganda110mWidget.
  const Uganda110mWidget({
    super.key,
    required this.projection,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.onFeatureTap,
    this.antiAlias = true,
  });

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      geoJson: africaUganda110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
