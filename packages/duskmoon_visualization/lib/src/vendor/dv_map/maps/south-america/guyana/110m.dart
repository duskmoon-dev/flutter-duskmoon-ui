// Generated from: assets/south-america/guyana.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/guyana.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WXTWscRxCG7/srhj3LRX1/+BYCydVgcgjBhEWZOAvSrliPDsLov5tdW8LaHgg1h6Gnq/uhqqv67Z6vm2naLk8P8/b9tP1t3i2Pp/nX493dfLvsj4ftzdn87/fuL9v301+baZqmr5f3OPEy/GJ4OB0f5tOyv0x6GT5N28Pu/jLh98en3WH3On6atvsvx793fLH9OfTLpf+PN4bb42HZH+bDcrZ9PD4u/02/3M+n/e1u+2PQ86s7n+fj/bycnt468+L9h+Pd0+cfwb7Cj6d/9ofd8lPU35+f29df0/TOHExK0uLmykSQVcbsb/o/3fwPL4AMsSKveQzhWezV5XGSitg1T0BEtKjNcyTzWsOpmzbDTUBVL9VrngI6pkt7+dKRsYZwFSw8kajLK1LOHOJVSGJnty5PMFht4BlgiLn3y0VDxYd4DSqEtNrpNWWm9GuegzCxJ7fzG0koPPISC0uiy1PTDKcVnnBkaJuXXM6DfwGi4UVNXgEheergX0BVMTaXryAsOXUolwTxQNFs8RzBDC1j4AVElKN0cS5RwYNYBei59prV5whc5p4rq4cqRc1snMNVOa/7SrWYW2qTR0BWIi4jz8sxmtV35kkpDZvXgUW5vJldAiUU5BVxKSv07ImfI4SIhQ7LZ8CIHNGr5nN6STxlEHsDVtX09marxLJRrAyQFJ3a/hERIq8cRhZa3hX7gvBQtGF7KCiLITfFucAkUWrl8C3LxO5doyDJlEZxFnB0rWzHW6HGo1oxhBkLN8W+IChNx7sVA2u5YLteXB1VVu5qkZ4lvf1mBSiYTkP9EQiFV7QPN1NEGtSFgD0xs6fO57ONSyMGNSVQl9L2UU4kqmP1ERgGlbWvVu5Ya955sqW2by4iljyKH0FpmnST4RDJgaP4EaRLEDaLpfujsFlrv7SeNy/vT5vnzTeZGM9a1Q0AAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/guyana.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaGuyana110m {
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

/// Widget for rendering the south-america/guyana.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Guyana110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Guyana110mWidget extends StatelessWidget {
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

  /// Creates a Guyana110mWidget.
  const Guyana110mWidget({
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
      geoJson: southAmericaGuyana110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
