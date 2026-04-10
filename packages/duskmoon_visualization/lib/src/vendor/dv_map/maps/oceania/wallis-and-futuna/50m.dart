// Generated from: assets/oceania/wallis-and-futuna.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/wallis-and-futuna.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE6WTy2rjMBSG934K4XVG6Fx063Ygqymd3SxKKSJVg8GVg6MsQsi7D3ab0Fy0GI0XQtJ/zqdz5F+HRog27zexfRDtMoa8G+PPoe/jKndDaheT/P65vW0fxHMjhBCHebxNnMNnYTMOmzjmbk46hQvRpvAxJ/wJfd9tRUhvYrnLuxTOqUK03XZ4DTiHLW/2ad7/dSGshpS7FFOetKdVDKkL7Zd8PNe0jsNHzOP+sqJTC4+7Pne/h36//mr7zB7Gty6F/K3/z+/7/Hp1uxbiB1gjwSjttV3cUUkSoQPUV9rLdXAJjU5Zg/fRaBwYhlo0W8++hEYw1ttatAXwwAU0o7auumqvyQAV7lqBMQqrqzZecQnNyoOrJVcYpCmtLg6t8KuTis30c++Vw5LAkfZc1emEJqPx7h2yJEWIWGcqJ0Fphb6ARsdQ61cngRHJlND/4VcnwTqFtoQmMKxMLdozOXYFtNZsXJ1hnQTttKeiQ6bHXX0highVySHIXiFVm+/ffV1+Zs317Nicxpfm2PwFcdZJ2WUHAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/wallis-and-futuna.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaWallisAndFutuna50m {
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

/// Widget for rendering the oceania/wallis-and-futuna.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// WallisAndFutuna50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class WallisAndFutuna50mWidget extends StatelessWidget {
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

  /// Creates a WallisAndFutuna50mWidget.
  const WallisAndFutuna50mWidget({
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
      geoJson: oceaniaWallisAndFutuna50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
