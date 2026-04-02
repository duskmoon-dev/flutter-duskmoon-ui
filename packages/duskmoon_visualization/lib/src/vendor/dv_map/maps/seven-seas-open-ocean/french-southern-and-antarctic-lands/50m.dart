// Generated from: assets/seven-seas-open-ocean/french-southern-and-antarctic-lands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for seven-seas-open-ocean/french-southern-and-antarctic-lands.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for seven-seas-open-ocean/french-southern-and-antarctic-lands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection
    get sevenSeasOpenOceanFrenchSouthernAndAntarcticLands50m {
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

/// Widget for rendering the seven-seas-open-ocean/french-southern-and-antarctic-lands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// FrenchSouthernAndAntarcticLands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class FrenchSouthernAndAntarcticLands50mWidget extends StatelessWidget {
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

  /// Creates a FrenchSouthernAndAntarcticLands50mWidget.
  const FrenchSouthernAndAntarcticLands50mWidget({
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
      geoJson: sevenSeasOpenOceanFrenchSouthernAndAntarcticLands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
