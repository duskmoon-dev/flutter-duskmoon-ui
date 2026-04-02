// Generated from: assets/asia/northern-cyprus.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/northern-cyprus.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUTWvkMAyG7/kVJufZIEvWh3tbCntc9r6UElq3G5jGQ8Y9DGX++zJpZ+iHoTgHo+SVHiS9OC+dc3057FJ/5fpfaSzPS7rO2226K1Oe+81Jfnj9vO+v3N/OOede1vNr4Zq+Crsl79JSprXonO5cP49Pa8HvvJR/aZnd9WG3PO8vhc710z7fjnhK+hHjF4Eqwl2eyzSnuZy0n/tp7N+046Wfx5SfUlkOH7s5t/8nbw+Pb9NemHm5n+axvBv79Xkff35zjnBQ8mqAm88KDz4AIMcPws3mO170kRVDhQemRqhNPBp8hKhaa0/JY2jFkZER1drzgup927g0BOaI6Gs88AGptb+gbF65tj4ACkEaeYwsxlTjkYkZN/JEmaKPNZ5XE2zdn4kEijV/IRLHZn+jkniRGo+NQUIrD8Ag1PzAwMqN1yMMrBKUrMIT9Ry51V8RRaytj5TQs7Xe3iBRoGYvmShQ2/pwMMCgVLPDB2agtnGb/1ZdLT5Hx+583nTH7j9h/vKrWwYAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/northern-cyprus.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaNorthernCyprus110m {
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

/// Widget for rendering the asia/northern-cyprus.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// NorthernCyprus110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class NorthernCyprus110mWidget extends StatelessWidget {
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

  /// Creates a NorthernCyprus110mWidget.
  const NorthernCyprus110mWidget({
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
      geoJson: asiaNorthernCyprus110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
