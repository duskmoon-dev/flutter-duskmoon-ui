// Generated from: assets/europe/belgium.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/belgium.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE62UTYvbQAyG7/4Vg89hGH2NpD1u2Z566L0sJWzdYEjskHUOYcl/L3Y2Ibt2CwP1YZD1jh5LGmveqhDq4bRv6odQf23Ww/HQfOm32+ZlaPuuXo3y74v7tX4IP6oQQnib1nngtH0S9od+3xyGdgq6bg+h7ta7KeCx2W7a4+4WEELdvvY/1ziJTzM/Xfzf7oWXvhvarumGUXs6jl+s39XzLZFN0++a4XD6mMY17+/99rR5L/NG7Q+/2m493NV7ee7tz28h5AiSsxiuPgmSoiVShA/+59U/aRJzyq7iMxrEEeYmJTiOruQOtIBjlYSkZbjEmhTmtULErCiWS3AUCdgVYAFHLCpS1LsRJwlA/oLT/F+zs6LkMAqQ6NJBAJukjGW0LMaI89xSVM/GVlYpIKFAXqJZokxUhhMzMOYFHKm5I5f9dGg54axz7NGTspedKkd1R5zXOuJMSItKlZiVk8zmgT0KOhsVTatENWTQpcYlT4TqJbgcE1NSWsIBWhIoGv7Si65asq/Wubquz9W5+gMqyN0TjQYAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/belgium.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeBelgium110m {
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

/// Widget for rendering the europe/belgium.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Belgium110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Belgium110mWidget extends StatelessWidget {
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

  /// Creates a Belgium110mWidget.
  const Belgium110mWidget({
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
      geoJson: europeBelgium110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
