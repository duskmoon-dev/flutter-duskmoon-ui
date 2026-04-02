// Generated from: assets/seven-seas-open-ocean/heard-island-and-mcdonald-islands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for seven-seas-open-ocean/heard-island-and-mcdonald-islands.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52US2vcMBCA7/4Vg08tbI00kjwzuTaU5hAo9FhCEbtqMDjSYjuBJex/D/bGyyZRKarBYjyPz/OynyuAejrsQ30F9bfgp8chfE19H7ZTl2K9mc1/TuqxvoJfFQDA83J+DFzcF8N+SPswTN0StLoD1NE/LAHfgx92cDP2Pu5gvm+31yn6ftWNZxRA3Y3pt8cl7PaD3pz015eGbYpTF0OcZtvP8BQijMGP8CntQ4S0DT5+rl/dj+ec70N6CNNweJvxWuKP1B/uXztyfk0adl3000VrTtel/P4JgExDiixq2byzfHGm0Ya0EvvGcrf5J1Cc1oRZIAozciGQDZGYLE8jiSnNz2h0OZoSjVpJIc6xI4vZchWStlzaP8Os2GUGgo2IiMLSgo1ySMZmgW1rFLeFQJwHnFsZbIQcsS7NEJ0R1WZ6iI2wGOdcKZCdtfKXocwzKR6KaQ2yzgP/Z6mtnnn5rbYtEZX20LZOm5ayQLaahIoXm4Q5nyFbR6r4wyv801Q5eZWO1XreVcfqBXuRByY8BgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for seven-seas-open-ocean/heard-island-and-mcdonald-islands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection
    get sevenSeasOpenOceanHeardIslandAndMcdonaldIslands50m {
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

/// Widget for rendering the seven-seas-open-ocean/heard-island-and-mcdonald-islands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// HeardIslandAndMcdonaldIslands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class HeardIslandAndMcdonaldIslands50mWidget extends StatelessWidget {
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

  /// Creates a HeardIslandAndMcdonaldIslands50mWidget.
  const HeardIslandAndMcdonaldIslands50mWidget({
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
      geoJson: sevenSeasOpenOceanHeardIslandAndMcdonaldIslands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
