// Generated from: assets/south-america/suriname.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/suriname.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WVTWvbQBCG7/4Vi87uMt+zk1sp9FxaeiqhmFRNBbZlFOUQQv57sRKniddQVodlNLP7MK9mZvW4SqmbHw59d5W6z/1mvp/6T+N229/Mw7jv1sfw72f3XXeVfqxSSulxWeuDy/YlcJjGQz/Nw3LotD2lbr/ZLQe+3U/DYq//xYa78eeGlujXys+L//u7wM24n4d9v5+X2Hg//0kfd/003Gy6l01Prwnd9uOun6eH9+mc8v8ybh9uX+S+wsfp17DfzG90Pz9v7fO3lD6oZCVxFVqfhSgzYpES7/zX6//yyMJBL/CciQO9lYcFnewcxxlLuEdpxQFYMGjNMwJgb06PI1SokiuZkAxRWnnixZhrXAlz1cb0OIcWEKk+n2ZXUynUxtMMzKRQ5WcZSCla5Wougscq1vmFMpJyKy8kGItc0OtU3Bu72TOKC1vVLprDGSWaeQxOolHzwFnNrJUXKFRKxZNckIxMW3nFgCAqvZLVrQBiG6/kY/OFVPWQDAbFuFmvAapVcjkzi6k046igMF+4DZhZAtvbRQHCq3am7FaCrJFnWTm4qJ/zMJcIJWrUqzlCrZ42zAXdzBurqzlADQBruUAYoY2Xsx2HgAUvfD4i8Ghs5mVGmehCeorAxo3V0KwWrlWzUBZCBWu+qyBci1ezQVmJXUpjNVr/5KtL9sl6Wp3W69XT6i9Bmq69eAkAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/suriname.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaSuriname110m {
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

/// Widget for rendering the south-america/suriname.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Suriname110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Suriname110mWidget extends StatelessWidget {
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

  /// Creates a Suriname110mWidget.
  const Suriname110mWidget({
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
      geoJson: southAmericaSuriname110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
