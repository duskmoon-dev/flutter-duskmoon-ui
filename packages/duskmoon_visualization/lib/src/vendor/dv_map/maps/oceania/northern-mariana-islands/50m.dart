// Generated from: assets/oceania/northern-mariana-islands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/northern-mariana-islands.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WWS2vcQAzH7/spzJ6DGT1HyrVQ6CFp7iUUk7qpYWMHr3MIId+92HmQ7I4PK8gejOf1X1n6SaOnTVVtp8f7dntebb+3zfQwtt+G3a69mbqh357Ny39fpvfb8+rXpqqq6ml5Hh9cti8L9+Nw345Ttxx6215V2765Ww5cDuP0rx376qIZu6Zvqh/7XdP/2b8rVNW22w+/G5x3X1wdzdMyf/lp4Wbop65v+2le+3nTNn3XbF+Xn99Nu22Hu3YaHz8b9vYlFw+7qbsado+3r1//rj2Mf7q+mT644eX38f1wdDyuKmCpczJy47PjRauzohzMXx9uXFNV5aRlVU+cLSisnoA0F4UtgQJQUJhFUrYVYc2WISgsKORQdoWgkuagcDZAKeuiIHPQ4FOJ2KyNPv1fiE1ASF6yRGsih3CwM7gQUFlYPKtoFM81irSm7EoWDTZBEi5xPwtnjycUaSLBFVeAAEUtFqOUVlxBkj2aT56QeA0KBDSPQnEybV+HPiobU8l7XIMYJAnGG1UYvQQS12AJkYPoIyEj+Iqws1Aw4CAIXKxHXIOSYrAIgOR1g0kdogUUsov5SuwwuWtQGEGISqnK9UwnWlT3dNi+sOjnvHpfpmwuEvxKI2H2kvtsjnfWHCTf0hpIVkNGFY1eU+YoKz0JiDB4tNShQ4Jye5ZEnSjoikDwvpAkWa75gjFSAxEIh+OyFLuycGZNzlFhm4tSURhxJgmDiCJYLvWKy4VAlqIgmc5lpywsasYWvYwJjEqELmUQjYKeUGPMudT6SQ0oyXO033FDxhUogAQlCgU7gpWqgNSQMqJGk/X0/Pi6ZFVFSsUGl2vPae6qg3HhTErlgCdxzhgNOLKVLZY6aYJwsoppXgt4ojTfx0FhBy2Xfa7dzcINhL50NWXhBbJotp5OxTqim8O3583b83rzvPkPOG2z4oASAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/northern-mariana-islands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaNorthernMarianaIslands50m {
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

/// Widget for rendering the oceania/northern-mariana-islands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// NorthernMarianaIslands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class NorthernMarianaIslands50mWidget extends StatelessWidget {
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

  /// Creates a NorthernMarianaIslands50mWidget.
  const NorthernMarianaIslands50mWidget({
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
      geoJson: oceaniaNorthernMarianaIslands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
