// Generated from: assets/north-america/el-salvador.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/el-salvador.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52UTWvbQBCG7/oVi87usvO1O5NbKe2plEKglxKKcNRUYEtGUQsm+L8XKbGJo4Wy1WEZzcfDvJpZPVXO1dPx0NY3rv7UNtPvsf0w7HbtduqGvt7M4Z/P7sf6xn2vnHPuaTnXhUv6EjiMw6Edp24pOqc7V/fNfin4uHO3ze5Pcz+MlyLn6u5x+NHgnHD7beWnxf/5KrAd+qnr236aY1+Gcfrl3u/bsds29UvS6dLTQzvs22k8Xnd0lvB12B0fXhRf4MN43/XN9Er68/Pafvvm3Ds1T0KEcfMmAuwZGQj1KnC3+SdPNBFjygApomjEYiAxglEGiMwKEkuBacZxhgfEWCjYgg+RY0q24pFXBYsmxUATEV6PhHyah5WKBSsgGeWAgiEiQikQJabcjMmzqBQvjXplQsx+QxRLRIWS1bMSBchJhkgmQGXA5C0wAEIOyBYgFkpOPhkBQA5IyqyhbG1mIJKE9TUhn1SCBC7lqZiA5IBqRICFDaoPcb7KuZlY5IjFM5ZAZprrj4VVrJjHgBRyQNMAwuk/tjokXG81e+AgIRYCzQdRAcgBiUNAK5xx6c+/ytln61Sdz7vqVP0FiU69JK4HAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/el-salvador.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaElSalvador110m {
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

/// Widget for rendering the north-america/el-salvador.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// ElSalvador110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class ElSalvador110mWidget extends StatelessWidget {
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

  /// Creates a ElSalvador110mWidget.
  const ElSalvador110mWidget({
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
      geoJson: northAmericaElSalvador110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
