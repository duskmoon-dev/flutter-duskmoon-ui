// Generated from: assets/europe/isle-of-man.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/isle-of-man.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUTWvDMAyG7/kVxueu+EO2rF7HBjt07D7KCJ1bAqldUvdQSv/7SLKWfngM52AcvdITSbZyrBjj6bD1fMb4q6/TvvPPsW39MjUx8Ekvr0bzjs/YZ8UYY8dhfQwc3Adh28Wt71IzBJ3dGeOh3gwBb7vWs7hi8zpcghjjzS5+1WpwmD/Y9Wh/vxaWMaQm+JB67WXff5X/qqdLMmsfNz51h9tUzrl/xPawjuGWGrvvJtTpqubxud7fvzH2BFOQSlhhJneKgal0Rhtpb4TF5D+eJqWcURmeUkaTKOZpJOd0jmdJkHSlPERJmONpUgadLK7XGGNthgdCkSIs5IECFJjFoUQsxRnhLKhcehotCirEWQkOdC49ZS2BhlIeOdTZ26cUkFC6kIfw12lI6fqLVMobZyDDE6gF2NL+oTWIMlev6NunS6fDkhWUPQ/hJIAp7Z+V0A9BjmecJVl6voV/lyq3P+9O1XldVKfqByO23hkIBgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/isle-of-man.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeIsleOfMan50m {
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

/// Widget for rendering the europe/isle-of-man.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// IsleOfMan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class IsleOfMan50mWidget extends StatelessWidget {
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

  /// Creates a IsleOfMan50mWidget.
  const IsleOfMan50mWidget({
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
      geoJson: europeIsleOfMan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
