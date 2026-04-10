// Generated from: assets/europe/poland.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/poland.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/poland.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europePoland50m {
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

/// Widget for rendering the europe/poland.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Poland50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Poland50mWidget extends StatelessWidget {
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

  /// Creates a Poland50mWidget.
  const Poland50mWidget({
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
      geoJson: europePoland50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
