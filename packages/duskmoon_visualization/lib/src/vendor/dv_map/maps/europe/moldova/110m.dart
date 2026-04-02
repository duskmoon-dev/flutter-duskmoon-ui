// Generated from: assets/europe/moldova.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/moldova.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWTWvcMBCG7/srhM9h0HzP5Bb6cSv0XkJZEjcsbNZh4xRCyH8vu8mGJBYU+SBkjfX4HevVyE+rUob58W4czsvwfVzPD/vxy7TdjlfzZtoNZ4fwn5fh++G8/FqVUsrTsV1OPD5+DNztp7txP2+Ok06PlzLs1rfHCT+m7fX0d/02oZRhcz/9XtMx+HUxzi/jF+8DV9Nu3uzG3XyIfXs4vHF4jT6/CbkZp9tx3j9+lHHS/XPaPt68pvlGnfbXm916fpfvy/W+//muFDIwTGaLs08RCSCqTkYfApdn/+MlCbphg4fEZKJdPAdiDqdc8ByCzL1mJ08V0YwaPKmK6NjFO2QVleuSZxBYxU16eVYr+jJfA3ZUI+vkVRURXuAUUkTDetMlZlXWBk8iKLjPLgESSpbS4Gla1u7lMM0Mb/GSM8P67BKQzI6+zNeANIJrn50DwiidlvoMhD0iuYuXUJ2wegOn6ObunTj0aspt9yUZ9bk5wTXTW5uD5bBOXfK4QiUxDWt9PeJk6003OAjrslgZKCmTRicva4TispgamAtb7dWnmubS0pcUGtTn5gRBRdYlz4HFTLRv9yZUrdE4OxwUK1G3+Ygso1WaQ7Jmp7oA8xqJzaMIAyV69y5pqthyswWgqhr16XNQIuVGbQkQc8Ts02cQ6kGN2hzAdvB5n5u7fw1Wrf6p97w6tZer59U/V99FXMEJAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/moldova.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeMoldova110m {
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

/// Widget for rendering the europe/moldova.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Moldova110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Moldova110mWidget extends StatelessWidget {
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

  /// Creates a Moldova110mWidget.
  const Moldova110mWidget({
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
      geoJson: europeMoldova110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
