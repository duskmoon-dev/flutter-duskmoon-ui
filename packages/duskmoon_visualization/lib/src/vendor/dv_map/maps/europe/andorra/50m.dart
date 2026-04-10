// Generated from: assets/europe/andorra.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/andorra.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUTUvkQBCG7/kVTc6DdNdXV3tbVve47F1EgkYJjOkhxsMg89+XRGdwtEAqh6ZTb9eTt7uq89aE0M77Xd9ehvZP382vU/+7brf9/TzUsd0s8uN7+KW9DDdNCCG8reP3xHX5KuymuuuneViTjstDaMfueU34NT7UaepOCSG0w0u962AVr77FcY3/PRPu6zgPYz/Oi3b9unyx/VAPJyNPfX3u52l/buPo+1/d7p8+tnmi1ulhGLv5037fn8/zr28hpIscJTLlzReB4IIjIkQ8E243P+ESFiG1cMCCpE4cRUAiC8eSUb3usBBjsnCZC+TsxMWigmjgJBIRkg/HoknIcifIMRbn2XFMKBksHEEGEh+OWFXFahSBJLk4z45Al+6ySlFYizrPjhIpodl3pKjqdpdKBvNWYNQU2YnDCBmtNqaSlZO3FKAJ2KJJQtDkpJEqqNV2hJk4gROnAhhNd0iUwVkJRopqNTFRklKc5liFgK02IebCTm+y1I7FLKv4r4TzV9xY8+Ps0BzH2+bQ/AcFtFicMAcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/andorra.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeAndorra50m {
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

/// Widget for rendering the europe/andorra.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Andorra50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Andorra50mWidget extends StatelessWidget {
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

  /// Creates a Andorra50mWidget.
  const Andorra50mWidget({
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
      geoJson: europeAndorra50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
