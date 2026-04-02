// Generated from: assets/europe/kosovo.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/kosovo.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52Yy24bVwyG93qKgdbuAe+XbItm0033RVAYqRoIcDSGrQQwAr97ccaxkUR0C0YLYaQz8w1nSP4kz5fdsuzPD7eH/Ztl//Zwff50d/h1vbk5vD8f19P+ai7/8/T3/f7N8uduWZbly/Z9eeF2+rZwe7feHu7Ox+2i59OXZX+6/rhd8Pt6v35eX85flv3xfv3rmubaL5kXC1wsvF9P5+PpcDrPtd8+zTvuv64+vhjy4bB+PJzvHr4349nuP9abhw9fH/OFut79fTxdn7953qfPt8c//loWgsEizJpXP6wIjSBPSv9u4d3V//EIFdm84HlGUGCTh0nqgRVPxTi69iFlBmjJSze1Jg9UKK16f24AGm0epSRRxWMCRuryTJ2o8oeFBmd0ebE5pOIxqnAX5/OZKneoOgR0wwWM06QyT8Wp714EVlSreCSm0XUHhrqU7hXS8MhuugkoORc85phvosljCartY5jmdf0hEAxQ+YNcUtvhLKEiWdlHxBxtOVCiUKz8i44SIl2eKydUPECG0K5/NVBEL/2LI9GFsRvPakYIl3KFI5wt+jyPMj9wxNOdmjyb6oelfcoBbTn1Qlu2Z1XWbuy5CErhWxwJWxHo8hRejZVgzW7suUctpeAIIj3zcMBTPaxTg7pSgAOFpK686NpkERioVFVtWqbatY3UWLziQaYi9mQFB23RX3UtCJvTu7x01Sh9wQDe7KpwMKNzVGUDw7Fb1nDwfOm1zGPOitLkqcHsTSqezKDs88rEIHGFZguEQwUNyppBAYHQDWbFyErjaTCFYNu8Vztc7lpmkGFcWhYu3eqNwzBBKpwQz7ajiXMGM6myTFOlWWtxuNIs+VVrq3Oq6YqAK80BquLZzySFE88BqmzltyzreqNOCguUlLaiJNQ4V5RmW4FDgKFua6M/ZeBg4tlGVTgXh7a6syNkFSiJPCO5y6M5mVRNbaoRtNMMyaFSYx4gDOhdb4DOKe3SGzwg0TK7jVSam2tlH05lbQ9pkVDOuDxQ0Qy69oXMTZFLgeeBzsLNbgVGvJK4PAj5J4a0/+CxJ2fbvrlRUewB8SBDiHYfasweJW7epqmjMPx188jYvOtee0UNeOAsd9R1h0GaldHs7fINw3huRJXBzMCO3Qnc1A39Ulxm8mZosyeAYTIvKnkOKd7dATISIL4UUx7Agt7egNxaurKVT92KSpe37ZKVYk+i1uz25g7GHLMrXnjOzZwuzyLq0SXUE9vi19wQ3lXHz0ePu+fvd7vH3b8wk60TtxcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/kosovo.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeKosovo50m {
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

/// Widget for rendering the europe/kosovo.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Kosovo50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Kosovo50mWidget extends StatelessWidget {
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

  /// Creates a Kosovo50mWidget.
  const Kosovo50mWidget({
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
      geoJson: europeKosovo50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
