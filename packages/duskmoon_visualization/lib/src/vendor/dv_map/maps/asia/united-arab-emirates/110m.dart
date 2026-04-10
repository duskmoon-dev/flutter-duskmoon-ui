// Generated from: assets/asia/united-arab-emirates.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/united-arab-emirates.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WVTWvcMBCG7/4VwudFzJc0mtxCSc+l0FMJxU3cYNi1F697WML+92InXrqxSpEPRtZoHt7xOx6/Vs7V0/nY1neu/tw20++x/TTs9+3T1A19vZvDv962T/Wd+14559zrct8mLseXwHEcju04dUvSety5um8OS8K3vpvaZ3c/Nj/dw6Ebm6k9XbOdq7vT8KOh+eT9w2afl/2vN4GnoZ+6vu2nJXbqmvo9drlqemmHQzuN51tFawlfhv355b3iK3MYn7t+0baW/nb9vf745FxAH9QCJt19iJB4kiCmeBN43P2PF1EVNGZ4gEJoXMQjDwDKzBseewDEIKGIFzxATLDFkReLJlqKI0gsiBmeQuKyYoMnFkkmmWIRwYy0kBcopJw69oEkxUIzZl6KjFtz2RtzBCnEWUJCTpleQYYgZIW8BIL/6OVoEYRKeSkSU8jwbPYdYhEveraYRLf2zjxRpjJ90VNEENzWG7yiRIhlfkQPColg60f0EILE4vcnbECS0ydsKKGMJz4aA3HOXzVNRmX1igdIAGC5/iPUoGX9x15A5vGS4wVkjKlw9gVVSJDrP1QVLvx80asJJ9sOv3k2W6JY5gd6DSoCuVlPJqCl8gp/RVVuva4u1Xp/rC7VH/nPeVU8CAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/united-arab-emirates.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaUnitedArabEmirates110m {
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

/// Widget for rendering the asia/united-arab-emirates.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// UnitedArabEmirates110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class UnitedArabEmirates110mWidget extends StatelessWidget {
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

  /// Creates a UnitedArabEmirates110mWidget.
  const UnitedArabEmirates110mWidget({
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
      geoJson: asiaUnitedArabEmirates110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
