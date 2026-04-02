// Generated from: assets/asia/siachen-glacier.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/siachen-glacier.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52VS2vbQBSF9/oVg9aumLnvm10pNNtClyUU4U5TgSMZWVmY4P9erMQmj4Ey1WIY6cz9uFfnID01IbTLcZ/bm9B+zf3yOOcv026Xt8swje3mLP9+fnxob8KPJoQQntb1Y+F6fBX287TP8zKsRZfjIbRj/7AWfB/67Z88httdvx3yfC0MoR0O088ezoc+uX8QsCBsp3EZxjwuZ+3zYejbF+107ec+Tw95mY9vu7m0/23aHe9fpr0yp/nXMPbLq7Gfr9f793chqHaRTBBs805B7lJ0T5DeCHebf/GSGDNpiaeJEaGSBw4uVuoPkJnEK3kESKhc4GEENq3lsSY2KOHUlN0qceLiCqXXR4QgSSt56k6JUonnbG5UywOKgFTiWWSRWh4rMJuUeJoMpDYuDDEmL9lLuhpfGxcSMirOq8zGtXEBJwMq5YWjJSas5EWPEb3kLzNEjnX5k87UPEqpP0kIlur8kE5FzKnkh0jSZHV5ls4SqGNp3P+Ii3RmACDF+CErQS3PQRWLcUESwVgXF+l8taM0L5AQcm2cYyRyKNmbXBCrv36Vf4+mtL/sTs1lvWtOzV883Hnu6wcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/siachen-glacier.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaSiachenGlacier50m {
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

/// Widget for rendering the asia/siachen-glacier.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SiachenGlacier50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SiachenGlacier50mWidget extends StatelessWidget {
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

  /// Creates a SiachenGlacier50mWidget.
  const SiachenGlacier50mWidget({
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
      geoJson: asiaSiachenGlacier50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
