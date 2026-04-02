// Generated from: assets/oceania/cook-islands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/cook-islands.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52TTWvDMAyG7/kVwueu+EuO3GthMHbo7qOM0HolNLVL4h1K6X8fSZvSDw+W+GBkvXofJGMfMwAWD3vHZsBeXRF/ajcPVeVWsQyeTVr5+5xu2Aw+MwCAY7c/G7vyTtjXYe/qWHamvhyA+WLXGeYhbOGtqQq/bq4uAFY24auQXcX7U151+cWdsAo+lt752GqLlSt8WbCLfLq2s3Fh52J9uG+m7/4jVIfNZdgrNtTr0hfxZurzuo0fTwAvAu001xxlriaPmhRTqa0URHfKcvIPpDJkUKaR3EgcQbTI00BOguMIoiGFVqeQgkjnxgxGto1YzNNIoyUOv0lSkivxx+BcE6nhSC01cUwipRVcjBhcWbTWJJGKOKEdcZeq9aWfkORkR7zKXCJSukttUYh8OHLg38lScR+dsn5fZqfsF+dTe33rBAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/cook-islands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaCookIslands50m {
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

/// Widget for rendering the oceania/cook-islands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// CookIslands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class CookIslands50mWidget extends StatelessWidget {
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

  /// Creates a CookIslands50mWidget.
  const CookIslands50mWidget({
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
      geoJson: oceaniaCookIslands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
