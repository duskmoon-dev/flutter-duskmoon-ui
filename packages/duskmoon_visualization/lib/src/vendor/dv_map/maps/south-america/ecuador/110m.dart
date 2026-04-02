// Generated from: assets/south-america/ecuador.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/ecuador.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWTWsbQQyG7/4Vy54TodHXSLmV0J4LpacSinG2qcHxBmdzCCH/vawThySzUOTDMh6NHl59rGafVl3XT493Q3/R9d+G9fRwGC7H3W7YTNtx35/N5j8v2/f9Rfdr1XVd93R8to7H40fD3WG8Gw7T9uh0Ot51/X59e3T4unlYX4+HN4eu67f34+81HY2XzT6/7P98b9iM+2m7H/bTbPsxPkx/uy+3w2G7Wfevh57f9NwM4+0wHR4/qjnJ/z7uHm9eo32Dj4fr7X49vQv75fd+/flf151XBa5MxHT22YRQlJCLfzBcnf0X6FjE1D8DEdDFsXCOZ0BBXERanhRDqWmeVuMaC/pILVg1x6sgJOHCLY9DzS2ZvwpmboUW9DmpB5csz1XRykL+HCMoGa7POFJv5BVgxyBOhhugQtWa9kMIp+BaUzhHwEDDqC2vmgt5pHmEHr6gjw1ZMFcNn5simKTRd45AzhU5186OoM6z3wIw0MwoncFgNo2GVwC1ikquYXxOvDhaK7BAmKLkSxxWq6k2QAISCyFL18S8OrchE5hrUU/3dLipRjtTCYiwhkgWWCtScJtDAtOqpaTbmpHU0Bogg6C4WrrKxQWLtDlkcCrFkteII4gFhbQKBVCDsnN1BgqRtDURENJKyZocJ4MHNnPwXIDFMJJjOsBIoi70jIColPA0kFDJoywAQ6OQpye/cXjUJYUqtbokFTqIonlzMc0tUxnDcu/xfNNxDZS2JAyIjITJiA2MlaO92ufXDt1qcnRVBRWJ0Hb6F1ArhpH+2CLmSrR0nUQpUiw3GPKfg6ul9Wn1vDo9r1bPq3/lIt2pvQsAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/ecuador.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaEcuador110m {
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

/// Widget for rendering the south-america/ecuador.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Ecuador110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Ecuador110mWidget extends StatelessWidget {
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

  /// Creates a Ecuador110mWidget.
  const Ecuador110mWidget({
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
      geoJson: southAmericaEcuador110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
