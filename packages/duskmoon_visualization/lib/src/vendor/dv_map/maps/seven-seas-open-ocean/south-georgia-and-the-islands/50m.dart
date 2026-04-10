// Generated from: assets/seven-seas-open-ocean/south-georgia-and-the-islands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for seven-seas-open-ocean/south-georgia-and-the-islands.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52YS2vkRhCA7/MrxJwS2DRVXc/eayBLDoHAHsMSBlvxDnglMyMHzOL/HlpeO2tbZdiawyCp1Z9K9S593Q3Dfrm7Gffvh/1v42G5PY2/ztfX48VynKf9u778z8Pl8/798NduGIbh6/r/euN6+7pwc5pvxtNyXDc93j4M++nwZd3wcb5dPg8fxvl0dTwMh+lyWD6Pw+/n68N0eX7CDMP+eJ7/PtS+5cPHV9dpRT1fuJin5TiN07Kujf+O03AeD+fhp/lmnIb5YjxMP++/3X7/JO/VOH8Zl9Pdc2kfX++P2+vl+Od8fXf1TSVPz5pPl8fpsHynm4ff98cvz16fD8MvVUtVRkR693pRvDAJitKLtU8vbw7I1qixBGRAE/McmYBY1bfJ5LVW1RyZAWsFi8hUgTBJFoQqHGgDhagmweveyH7NmSxpP2muFHlGq9UlKXLG53bR2bNn/nAEkBUE6nbdkoYLqGiVxGuSlUrVsW4GQAeDsLYcmdQt4kJDaxmTd+5D7GyRqTRn8IzFyYqQOLXNiKXSGllSxY1FwEKuKEiK7AXQmHBTFV3JDpDKXl1m7JkxAFdvkEq4ZEXRnW0zeXEBruAtKbJ6A6SIbJpM5Z38kEe2yUhsKplU3skEDTwiq7FD0um4dakCC6KIS+McGcURJIjsasjOSTL4G7mIEKVSlgxq5IE2iKFhyjW0uK8FKAD31iJViztZ0KAFYFXAnM9p8UoeBSAD15ZL+FqMuGkkMmuXOSmyvuEX6zMpaT4BFQ6sJ4iVcuGnha2CRfVaiNlqqvxpYRaLcpFYf2jS4QiRjYNiotny11u02JHNmntNGg8rKdXNusrFpbaaazG0gAtvNwJcXNWSISKlkbeoXjtxNUuVVelSNabNzp2LtUpJLUux5uIRWHvxSwW1lIZr6xmQEXovliTXcNzgoklHluJNKExDImy5WaMLrKwcKVnUQTVV+LQAUVysRXtXlIw+MELenpxXbWA62yOqBzM5FxYngGzGsKpggZ7zM3lPciQaaoMUmFvKN7T0zlMoyJ/VXQ2T9Zrq6nYBWRDzZA8nqd4ipseH/u3jrUbuYUjO1lWPqwmt2SgZg2ssSJD1KzskR2wtysZYMSBrJeBkBVRQ98g30LNfbHqXCOTggTYQ1tkiSVYAicnWR5NkywyCJpE2AHsYJcnsrUZkcOkvlCO3dUoPiiD4Ok1lyOswBcLBBIHINT1oJ75y7aKz/48fj+53j/+fdve7/wD+q3ih3xcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for seven-seas-open-ocean/south-georgia-and-the-islands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get sevenSeasOpenOceanSouthGeorgiaAndTheIslands50m {
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

/// Widget for rendering the seven-seas-open-ocean/south-georgia-and-the-islands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SouthGeorgiaAndTheIslands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SouthGeorgiaAndTheIslands50mWidget extends StatelessWidget {
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

  /// Creates a SouthGeorgiaAndTheIslands50mWidget.
  const SouthGeorgiaAndTheIslands50mWidget({
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
      geoJson: sevenSeasOpenOceanSouthGeorgiaAndTheIslands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
