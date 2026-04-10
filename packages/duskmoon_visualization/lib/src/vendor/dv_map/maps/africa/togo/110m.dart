// Generated from: assets/africa/togo.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/togo.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUS4vbMBSF9/4VwutU3Id0H7MrhXbZLrorQwmpJxgydvC4izDkv5dxJiETBYq8EPI90se58rFemxDa+bDv2ofQfu3W89+p+zLudt1m7sehXb3JT6fyS/sQfjUhhPC6jOXGZfki7Kdx301zv2w6Lw+hHdbPy4af43a8rA6h7V/G32talG9FnU/179fCZhzmfuiG+U37/DT1m3X7rh4vLrbd+NzN0+Gjh7PpH+PusH3v8UIdpz/9sJ6vmj091/PbtxAgmnsWXt3UEaK7Mnv6IDyu/kMDYgPKBQ4joImh1uA+QYTkaknv2FMQR7U6eyya7Q4MHQnJa2HZAYpePSbJAJUHlwTRsfBmUVSJSOpoigTkVNIYKUnKld4cPGvRqMaEqClxHS0rsCW8pUl0TJytslNjccaiU4mk7mpVecMIAkhYxC1HJzPWqm+K0SRTKgMiERNh1kpvguYZpKQZE7BhJU1SUi1oHpEse116MSZhSFSk1yNzEqpLCMZEGQSKr+DRKLPnSm+gql7eSBBRs4DU/llKzLk4N4SYFAyMKuNbdfs29+bn2bE5j4/NsfkHedp32x8HAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/togo.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaTogo110m {
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

/// Widget for rendering the africa/togo.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Togo110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Togo110mWidget extends StatelessWidget {
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

  /// Creates a Togo110mWidget.
  const Togo110mWidget({
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
      geoJson: africaTogo110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
