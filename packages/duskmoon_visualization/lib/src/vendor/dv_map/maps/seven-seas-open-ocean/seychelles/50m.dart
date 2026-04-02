// Generated from: assets/seven-seas-open-ocean/seychelles.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for seven-seas-open-ocean/seychelles.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WSTWvDMAyG7/kVwqcNupLYlj96Lew82GmMMkKmdYHUDok3CKX/fcxtStsZhn0Qsl7psSS8LwBYmHpiK2CPVIevgda+66gJrXds8St/HMMjW8FrAQCwj/ZvYUyPQj/4nobQxqI5HYC5ehcLnmlqPqnraDzXALB29G81j/r6T1zE+MuV0HgXWkcuHJnf5GCkeoQ735MD31Dt7tkp/XBubkt+R2GYrlubZ3ny3bQ9jX5+xg/vravDxQ6O59K/vQEgLlGWQvDFjfAgl8qKUil5JWwW/+EkolaVTvAQjTa2yuQJI4Q1MtVfabnWIre/SmmrbIqHJbfZOFNxTC5PGi55Ls1KzZVK8DRKNNZk8lByq4xJ8QyiVDabl/NXipQ/e4ditpviUPwAciAOHuUDAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for seven-seas-open-ocean/seychelles.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get sevenSeasOpenOceanSeychelles50m {
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

/// Widget for rendering the seven-seas-open-ocean/seychelles.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Seychelles50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Seychelles50mWidget extends StatelessWidget {
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

  /// Creates a Seychelles50mWidget.
  const Seychelles50mWidget({
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
      geoJson: sevenSeasOpenOceanSeychelles50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
