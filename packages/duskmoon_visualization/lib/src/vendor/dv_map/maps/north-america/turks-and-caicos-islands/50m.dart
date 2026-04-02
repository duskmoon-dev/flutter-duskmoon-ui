// Generated from: assets/north-america/turks-and-caicos-islands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/turks-and-caicos-islands.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VWwW7bMAy9+ysEnztDIimR7K0oMGCHDTvsNhSDkXidscQubPdQFPn3wUkTpIl1GIf5IFgi9UTz8VF+LZwrp5enprx15cemnp6H5r7fbJrV1PZdeTObfx6Wx/LWfS+cc+51P15v3LvvDU9D/9QMU7vfdHR3ruzq7X7Dt+fh9+jqbu3u63bVj+7TuKm79XhCcK5sx/5HDXvv+6t1PKzfnRtWfTe1XdNNs+1LP0y/3N22GdpVXb457U4BPjb9tpmGl/fhHb/n8/Nmar/2m5fHtxycTuiHddvV01kyDs/5++Xseu7cBw5VSoEgys2VEULFKQISXZgeLn0zwJg0UFgGFo4kYgROglFpEVgQiRhtwOJTiIDLwBG8ajICE6eYYBmYkCIbcdFTUF1OsfoE0YbLEJh5ORGs/h9qIkUUnwk4BvZqxf3rIi5ys3dHWhQlrIohZdj2BGqlWzX5XOGbyVYMkZa51hjUk0lNUPngE1HMAHtCNQU8A89BLeMGgRSM6VWhCGE5YFEkL2AETshJc8DgKRhxY6QknKkHIiN1c1BMKSNTARUBY+s2SON/6RQqRJAAGVpiwMQmvqFCAhTIdCONGGxSnSOORLp8j3AU79nEC1TovbDk+nIEINPNB1VQnxhzjVmZo+kmgSpItmuxeA9q7FqBCDHmrlRgeyZIxVNGrH6m1VhtECTl/lpYE4ia2otJH3mxFpdvu+I4PhS74g/PqPoFAgwAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/turks-and-caicos-islands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaTurksAndCaicosIslands50m {
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

/// Widget for rendering the north-america/turks-and-caicos-islands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// TurksAndCaicosIslands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class TurksAndCaicosIslands50mWidget extends StatelessWidget {
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

  /// Creates a TurksAndCaicosIslands50mWidget.
  const TurksAndCaicosIslands50mWidget({
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
      geoJson: northAmericaTurksAndCaicosIslands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
