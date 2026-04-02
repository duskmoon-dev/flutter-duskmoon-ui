// Generated from: assets/seven-seas-open-ocean/british-indian-ocean-territory.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for seven-seas-open-ocean/british-indian-ocean-territory.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52UUUskMQyA3+dXhHm6g1XapG1aHxUOfFLQNxEZdnteYW2XTu9gkf3vMrPusmpBevNQMk3yNUnTvHYAfdlufH8B/S8/lL/ZX6X12i9LSLFfTOrf++2xv4CHDgDgdV6/Os7ms2KT08bnEmangzlAH4eX2eEyhxLGP3AdV2GIcLP0Q4R7n3MoKW+PHIA+jOlpwMnn+ubLPu33708VyxRLiD6WSXfn//kIox9G+JE2PkKaTvrZv5vvjgE/+/TiS95+DPeQ321ab5/fy3E8JuVViEM5qcv+O5U//wEwnisnnUNcfNKc8TkxKyXVB8Xj4nue1aRrPHTKosJmHmmtuMYzkqW1rTyljdC6xkOhpGiOjzSrav2QBDI1189oha6aL1tE5FYeE5Oo5UvCGdNcPoMoatERMTtqprG0XA3OsGYrmy+X0WhT4znNgpp5OD+BajM7K1TrZRCj1bIWHxoitq6VpxxXb+P/cEqwkVydBTSVtrn30ElRTVeRJi1Nc7vUm0XJuY2aJ0vT5Otq8kHadYf1sdt1bzfL1j3IBgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for seven-seas-open-ocean/british-indian-ocean-territory.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get sevenSeasOpenOceanBritishIndianOceanTerritory50m {
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

/// Widget for rendering the seven-seas-open-ocean/british-indian-ocean-territory.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// BritishIndianOceanTerritory50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class BritishIndianOceanTerritory50mWidget extends StatelessWidget {
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

  /// Creates a BritishIndianOceanTerritory50mWidget.
  const BritishIndianOceanTerritory50mWidget({
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
      geoJson: sevenSeasOpenOceanBritishIndianOceanTerritory50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
