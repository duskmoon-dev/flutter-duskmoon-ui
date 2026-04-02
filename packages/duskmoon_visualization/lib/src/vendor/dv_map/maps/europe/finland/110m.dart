// Generated from: assets/europe/finland.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/finland.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VXy4obWQzd+ysKrxuh9yPbYQZmM2QfQjCJJxg6duM4iyb0vw/lftDpezOgWhTXV3VPHZV0JPnnZlm2l/u7/fbdsv1rv7v8OO//ON3e7j9fDqfj9mY1//u4/X37bvmwWZZl+Xm9jwevj18Nd+fT3f58OVwPPT++LNvj7tvjgcPxdnf88nJgWbaH76dPO74a/x725XH/n9eGz6fj5XDcHy+r7c8f6xu3T9aHFyJf96dv+8v5/lcaz7zfn27vvz65+YJ6On85HHeXV/4+Xq/Xb38tCydYUXH5zRuLF6BrhNcvho83/49XgGQWMoELdy3iFlxACHMxvcULBHKlkhacA0U584RdsnH1fDXwLCaO2bcrJpJs4SmEmEeN9BJcy8x7eALujDqJbUIWsYa18BjEnCVyhqcUStrCI2DVEp+FQwJVe8FFcDUrrgkcobNGD4+gIk105q6Tp5o3w2FSGjLksgeUOGK28dwyauTnIOVo2EtngUKRSJvgIXpx9MJrwKWoYykwMFFR78JJJXqMajMgImXvZfOqNjSi0V2FQhaVaKpDlUN1zGaBpEjCrjpMHLlGfgKUFdJzlwBtrUlj9jE4hpR01WGq6RPxEgSacHX5CTOrjvwQgpG6weDCcBm1gSBrw6Oetwzp5aVDbbGCVJeQXl9T0HJnndBDC6GmNhzYjCZdF0F5rQW9r5eAXlUxNg4EQzFqSi0BAxFprMxPeEVtvN9AtcIgCKsiMKZJnIgcrY4rBCRVNRWZWHhxF8/IsSYDy5qQ4dnr4IKAYhmTvBMw4yRptSBBUFVPHaOhwKhq0svjWouKzqZRhdL0oC4/pvCxghokWvWmqQI0tczRV4dS5fReCSioCGUfYxHglVxdzapaqcyGPXF14t400P5jsJmtn1cPm+f7x83D5j9f+5jTvw0AAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/finland.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeFinland110m {
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

/// Widget for rendering the europe/finland.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Finland110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Finland110mWidget extends StatelessWidget {
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

  /// Creates a Finland110mWidget.
  const Finland110mWidget({
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
      geoJson: europeFinland110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
