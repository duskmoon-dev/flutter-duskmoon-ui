// Generated from: assets/africa/djibouti.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/djibouti.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52YS2sbSRCA7/oVg86mqfcjt2WXQHLKfQmL1lGCFkcyinIwwf99aTk2TlQmVHQYRtPTn+pd1fq2Wpb16e52u361rF9vN6evx+2fh5ub7fVpd9ivr+byx4fHX9avlr9Xy7Is387Xy43n188Lt8fD7fZ42p03Pb6+LOv95vN5w1//7f49fD3tnnYsy3r35fDPhs6rby+e88PzN88Xrg/7026/3Z/m2h8fj7vrzfr76v2TJJ+2h8/b0/HuRzkeBX93uLn79F3PJ+rh+GG335yeKfzweX7/87dlER4kmml49dMK4pDMAPEfFt5f/YqHho4RBU/NANWaPBByZ6l4EeLW49FIRKUXeGaE2OR5pEtpPz1bomc/GqbkLKV8kOrATZ4Ge2TtX3P3No9f1BeE0rLLI5xSVDwntOiaTwC4VFcNEFy67s2EOlycU0B65pvhHCCWBS8oQambbuQEDpX50lIZqcljtjJ9aQA5QBsXQFX20oBE0uy5l4dAuqkVPIxMwZ57ebCyYsljc5BeMeBBGcZUWU+Mw7xrPmQIzcp8ZiCSbR6aZVLB8/lD3I0+ADWTy2yb8hF3mweNCGaAyn5GSJHd4hymiTWOZmR2caSUl7lGQy2ZtVv63FwCtIoWolDstjYHdoTL2kIzDZmoW+rNAdGraOGZhKRNnnhySqWvIltbvJpEyOxdT8g5+su8TeGQbhdijxfKipgJWC9vaVBM11Z5xiRk3o0UlEQqeciCDD374cjUyKi6ZCLNGtvlSRoUdQ9HqIdhL1RwBM5wrZo4sXt2cZ5krtWMa2HA2nMvDjdT4Goo0EjEtrpuYlK6Q2YVhV644PAgYKyGDIzfMl+Q0GVdgTEPHBa9bMMR50GxwqkGQjv41IXw0hswUrB9gqEBSlh5A0ZasGZ3JMV5TCnKPIxMNGi3DYZppCo7AJRIujyxWc694onDb5xg1B2lyjYIcMP+CUuyars4wIOpLZ8Llv6Y+hIHdZuHBwN4qS8k9U9sIYICl81oxotnd4ikkUSuRbWavGS07gwOUg/NODClPVbxwDnIVu5lU6f+Cav3B8mqun+8u189Xt+v7lf/A3k9W7/IEgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/djibouti.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaDjibouti50m {
  if (_cached != null) return _cached!;

  // Decode base64 and decompress
  final compressed = base64Decode(_kCompressedData);
  final decompressed = GZipDecoder().decodeBytes(compressed);
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

/// Widget for rendering the africa/djibouti.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Djibouti50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Djibouti50mWidget extends StatelessWidget {
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

  /// Creates a Djibouti50mWidget.
  const Djibouti50mWidget({
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
      geoJson: africaDjibouti50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
