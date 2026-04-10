// Generated from: assets/africa/gabon.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/gabon.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWy0ocQRSG9/MUzaz1cO4XdyaQbLMPIUzMKAM6LWNnIeK7hx6doFZDqF401XW6Pv5zq6qn1TCsp8f77fpiWH/ZbqY/h+3n8fZ2ezXtxv36bDZfv0w/rC+G76thGIan47tdePz9aLg/jPfbw7Q7Ljr9Pgzr/ebuuODr5tcr/dWwexh/bvhoumzm5WX+01vD1bifdvvtfpptl9eH3dVm/Wp9/ifjZjvebafD43sRJ9XfxtvHm/cyrsbx8Hu330xvvH153o4/fg0DEXC4ap19MDCwExrWu/kfZ/+lpWE0NAK0cKcuWkEKciot0DyyJPtoWpyZvkAjJCrro3GRGNpHGgJ7ujv10VBTqRpt5whqJUZd4nIOHKbHAi6iMMT7cFFRZa06AiISJO1MBBqraYNjIFUh4a6aQ0B3EpMFXnlpclfwiABLIjgbnkBFJntX9IggzYipzYaAsmdgL08jUbLVxxBunU02y2Mslza7DEZK3ld7xKBlgQvhY5Aiz5ROnoVxatNp5wSlaUR95SJAWE6L4VPOUOzTJ1DFirFUfhqYqH35UOAqJuQlfys5rK9cFJRNzVp/CURE0aOTJ+RK2eYDwYydo69eBFJFGBt9CCgZFr3ucji7LRxBVF5cXYcGKSC7ezbNSyBlHtG19ZEAJ7tQEzwCIaWUvlwIIApR27s0nwBZ3lvKGJbMzc48XwYCK7oONWIoIxFZuFsIz/tKn7MMYiWJTaMxUHES9+0DBGHkbk0qZnUe1lnGnfeo1dL4NHpend4/Vs+rvz+NDeXqCgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/gabon.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaGabon110m {
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

/// Widget for rendering the africa/gabon.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Gabon110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Gabon110mWidget extends StatelessWidget {
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

  /// Creates a Gabon110mWidget.
  const Gabon110mWidget({
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
      geoJson: africaGabon110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
