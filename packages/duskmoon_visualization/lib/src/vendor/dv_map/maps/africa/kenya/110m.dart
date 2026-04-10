// Generated from: assets/africa/kenya.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/kenya.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52WTWsbQQyG7/4Vi8+JkEbfuZXSXgql9xKKSTfBkHiD4x5MyH8vduKQZrYUdQ/LrDTzoHdH0szjYhiWu/39uLwYlp/H1e7Xdvw43d6OV7v1tFmeHdzXz+aH5cXwfTEMw/B4fPcLj9OPjvvtdD9ud+vjotP0YVhuVnfHBV/GzX71On0YluuH6ceqHV2fOjs/27++dVxNm916M252B9+H6+36arV88T69hnEzTnfjbrv/M4hT1N+m2/3Ni8hX6rT9ud6sdm/UPj9vx++/hoETGrbWzt7ZzwXMzf0P8+XZv1iGEjnDYjHlIisQ0ToWgwWRVViCQI2oj4uhuVsUWc0YpWM1UGfMIsvYQ2dYkulVVoS4z7AwmmqJRaChxB2LwIJbjYWQ2ZMQQqNVFWYQdn+rgYdoKwoMVQym9zCGpEiiWmQE5BRzrCxnhFtIhxJo6ljSeCgglewSlSE4arnFCarJId0+MkhrWCpGDohsOvPnFdGliDInmpFoZFhrXQHCll35MGiEUhFFDZO6RGXQDMNS+bAdMzW5a9ACIh4mtdgMSBM9ur76fziFIJeZtiPgbmla24S/4hSYo3GrRtcyEL3LNQUtJq2ANaS0rgIEQpxaqwkVwL6RCTTJCKnVpoB49r2aQVWrGjUNZ0oAlYuFqYCs2R24BIkaNdThHtK6HTx0XMsqqe/RCEq1gmSIZLVOGwJhBnGVlshO1N+/ELKGEkBv1oMIUDNqZ4eDZfQazxkwLWsJ6uA2izJ3qh5phbvqYm58Gj0tTu/LxdPiNw8ooThMDAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/kenya.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaKenya110m {
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

/// Widget for rendering the africa/kenya.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Kenya110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Kenya110mWidget extends StatelessWidget {
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

  /// Creates a Kenya110mWidget.
  const Kenya110mWidget({
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
      geoJson: africaKenya110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
