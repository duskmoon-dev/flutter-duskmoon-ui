// Generated from: assets/asia/lebanon.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/lebanon.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51YTWsjRxC961cMOpumvj/2lgRyCiH3sARlo10EXsnYysEs/u+hx3awVyVCRQcxmtI8XnW9el093zbLsj0/3u23H5btz/vd+e/7/U+n29v9p/PhdNzezPDn59sP2w/L75tlWZZv6/flg+vf18Dd/eluf38+rA+9/n1Ztsfd1/WBX/Z/7o4v+C+hw8Ppjx2twR8v7vPz/V/fBj6djufDcX88z9gPD4fd9iX29C+NL/vT1/35/vE9iVfWv51uH7+8J/HpdLr/63Dcnd9k+/x5e/39r2VhHelGlnrzfUSGUWImvQt8vPlvPE9KL/BUXJCwi0fIYRWeJDOCNvEChNKywmMXIG7imXgoWoFHEiTUXT9DDDQp8IAJ3b2JpwjBGRd4PMLT2br5MqsLUYGnwGIWTTxSZPMKj5OMuukSsKJeloMHaWSINPFQFTywwEMDgOymixCaXJUDgi2xy4+IuS4vrN3blR9DRNVuPMBTpdu9gkgMl+4y4dSCrYuXjCZlOTBnv3W7g0mxcL8pF5CIbnfoNL/CXXiQo/TlZ0Clm/IgAaOu+Rk5iVXLR77m28RzFnGq6DGToXfV5+FVLdjSXbtrFwJOJTlBNedusjHbEyprEUbntlYSxetiiCkHZHunNDWq1k8BKNv0zLV2PmVRhx6eDSCaBCu8rpBtwFXhaSho9HxlkjMzKHe19JT/MQWhedm3Rgyp3W0thTiosnl7LlO7uCFa0XMmIWxLLwy5pOdKxtZL1wZghHjJLzhZ23JJwtpaglETe1ZgAyUDpOIXnAo9tdjATMFyV5twCl16FHMmuJwhJ55qV302WEJZq+4IcujzY1PgvJIva7u8bOTJFZwqNkfIuXrTqSqjihSM7LIj9+Bq8ZK0a8s2KOvzBo/UMKGu87FKVM4iA3D2dM9ZbAjRlfMQSE4ZdfHUywlNBswBUntWZUPX88FlOWQgC5N1e1dD0qA6TxIhSdsLFIRTqnyFib0rF1FVK4+TYobWPI7bYDcxqeQiqWht9VFeUZ/kXNbezDfxrr3NUGRmaKc7D0NYVVfNIqWtZmYAr/I1ZPH++gWXxzUZpp7YVh+lURTOLMM8HJszqQ2y9XVBhcc0h4buTqkIV/BWuPaQ23v7tamuX6+eNq/fHzdPm38AIPmcOKIUAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/lebanon.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaLebanon50m {
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

/// Widget for rendering the asia/lebanon.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Lebanon50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Lebanon50mWidget extends StatelessWidget {
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

  /// Creates a Lebanon50mWidget.
  const Lebanon50mWidget({
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
      geoJson: asiaLebanon50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
