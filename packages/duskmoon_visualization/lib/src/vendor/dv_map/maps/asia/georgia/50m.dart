// Generated from: assets/asia/georgia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/georgia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/georgia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaGeorgia50m {
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

/// Widget for rendering the asia/georgia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Georgia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Georgia50mWidget extends StatelessWidget {
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

  /// Creates a Georgia50mWidget.
  const Georgia50mWidget({
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
      geoJson: asiaGeorgia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
