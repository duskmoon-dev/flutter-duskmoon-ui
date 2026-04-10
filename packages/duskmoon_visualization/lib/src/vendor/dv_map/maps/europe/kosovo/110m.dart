// Generated from: assets/europe/kosovo.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/kosovo.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUzWrrMBCF934K4XUqpBnNj7ot7eZu7r6UElq3GBIrOO6FUPLul7hNaGtBGS+E5CN9PjOe0XvjXDsddl177dq7bj29jd1N2Wy6p6kvQ7s6yS8fr/fttbtvnHPufR6XB+fts7Aby64bp34+dN7uXDust/OBP2Vf/pXLfufafl8e13DSrnJeCFgRnsow9UM3TCft9u30xfZTPV6MvHZl203j4buNs++/ZXN4/QzzQi3jcz+spy/xfjxf5z9XzkHwlAMkptUPJUWvRClo/iY8rH7jSRSMNVqSGK0shsgLFvhAUdnEih4JpIKCwGokkTBjzRYkAkjJikuIUKEhBCAjixlyjZUwAxhZIhSWZQGeFcRqCzHUbLFItLISKteSrwxkTRdIgmWtgs8hk63uo48JMS/zhT6wstqcBZ+JaekMfcSQbQUWvMaUtMICgWD1xUihyoos1u5OmSXX/qQmtt46QEJLX+A1glhjDBJqNwWpMlptKQqlWhfN3Z2t1gigUmPgIYraGsl88Te1+Xl2bM7jQ3Ns/gPpIOC2nwcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/kosovo.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeKosovo110m {
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

/// Widget for rendering the europe/kosovo.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Kosovo110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Kosovo110mWidget extends StatelessWidget {
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

  /// Creates a Kosovo110mWidget.
  const Kosovo110mWidget({
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
      geoJson: europeKosovo110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
