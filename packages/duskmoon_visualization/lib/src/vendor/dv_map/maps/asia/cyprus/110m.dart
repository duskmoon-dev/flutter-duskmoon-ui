// Generated from: assets/asia/cyprus.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/cyprus.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUTWvjMBCG7/4VwucgRjOar95KYc+9LktZTNdbDKkdHPcQSv77UqcJaSNY5IMYzTvz8Eoj/N6E0C6HXd/ehfZH3y1vc/8wbbf98zJMY7v5kP+e0vv2LvxqQgjhfV1vG9fyVdjN066fl2FtOpeH0I7d69rwcNjNb/tLfQjtsJ9+d7hqP2/ydMo/XgvP07gMYz8uH9r9fujaT+14cfHST6/9Mh++ejibfpy2h5fPM16Y0/xnGLvl6rCn7zr+vguBMColNcDNd4VjygDI/kV42vyPhywimko8ICSkSl52QBe64eWokISzVfJc3bDgL0fWZOK5ipcjQDYDK/BcDVzr/FF0JUkihfsDNgap80fRRDK5lnhO7FkreaJMnrzES2qCde+FIiOL8e18OQKZmHElLytbUi7xAChnqeUxO2L5PaeMVHt/ZGREucQT1JRq7y85uJbGm5QSVo4XoydnxZI9MDXCWl7l76Upxefo2JzXp+bY/APPIuleAgYAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/cyprus.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaCyprus110m {
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

/// Widget for rendering the asia/cyprus.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Cyprus110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Cyprus110mWidget extends StatelessWidget {
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

  /// Creates a Cyprus110mWidget.
  const Cyprus110mWidget({
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
      geoJson: asiaCyprus110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
