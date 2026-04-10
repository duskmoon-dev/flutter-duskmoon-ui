// Generated from: assets/europe/czechia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/czechia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VWTWsbSRC961cMOpuivj9yDcl5zwkhCO9sVuBIRlEO3uD/HiTHxkk3CzWHoadr+s2rV2+q+8dmWbbnh/t1+2bZvl935++n9e3x7m69Pe+Ph+3NJfzP0/S37Zvl42ZZluXH9T4uvL5+Ddyfjvfr6by/Lnp+fVm2h93X64K3/623/+53LwuWZbv/dvy842vwwzAvT/PvXgduj4fz/rAezpfYu++XL25/RR9fiHxZj1/X8+nhdxrPvP863j18+ZXmC+rx9Pf+sDu/yvfpej3+82lZyADJq6xu/ogYAaF7KP0W+HTz/3gKFhiUPMFDZJHSJp5gIInO+FGwRzbx0Jw5YsBDKPai8BaegEiSjOkihAiL9tJlKPcUzwmepmJ4F48ViYgmeOwu0pSPQcmocLCLFpQXMXbxjAlZB/20wDSUTJrlQCHhGb2Ljzy5CWdlpTa4RRMygoKq62bJrNF9mmBmgs10FQpJNYa/QxPKVZF65TBgEyXziX4ohaE9/RyQyzVkwi9EsnryOWgVJ8/ki7Rsms+hHDlz+Dku1Siv5F41AgipUkf3JSR5efbSDTA1xKn5ELHpvYBM19ShtVy8gqJhvdoGFIkRjV5JqHIt7lUjgVAreORXgCqVYl28QK20CR4HGWmXn1RVyQxPyBCxy89MK8bWrAVahmS9Vp+QJqTTVqrlzNXPl4tk2uoznbO3Uwa4luognyGgFkr20o2LfOYx29nEmdS6vSU9w2u2k2tIhUQTL6g0JgcrBCYL9Z58DhTOJkMrvfBjdoxes3JgSWefHYS8IoR7+RpoYQXP6hGpwc1e3z6Ybmbj59Hj5vn+afO4+Qn+FwwuPwwAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/czechia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeCzechia110m {
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

/// Widget for rendering the europe/czechia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Czechia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Czechia110mWidget extends StatelessWidget {
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

  /// Creates a Czechia110mWidget.
  const Czechia110mWidget({
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
      geoJson: europeCzechia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
