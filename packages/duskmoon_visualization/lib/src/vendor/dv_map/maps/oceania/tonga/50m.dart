// Generated from: assets/oceania/tonga.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/tonga.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WWTWvcMBCG7/4VwudUaDQf0uRa6K1ND72VUEzqBMPGDhvnsIT978XebEh2dy4D9UFYGumx/Gr0Sq9NCO28e+rb69B+67v5Zdt/nTab/m4eprG9WsL3h+bn9jr8bkII4XUtzweu3dfA03Z66rfzsA46dg+hHbvHdcCvaXzo3ruH0A7P058ur6Gbs3Y8tP/4GLibxnkY+3FeYjd3fTcOXfsW3r/P46GfHvt5u/s8i+O0v79s5uHntNk9vP3qO3va/h3Gbv7wz4fn4/tp7bwewhcoHEFAgeDqPJohgigi60ns9rSzhVYtzGqgmUUIvGiuKZVqoEmoEjnROTNqEgMNtbATjCkRKltgxFK9SmPOkgpdRidVBPHKgVCTiIWWmgWKFy0ZGS1BklR/6iEykWYr9UoBqt78SBkJjdTLS8ydIcDCChZaUAp4BUmVUrX0WHInZy+5VCiWHpA1JXQbCIIiWlsRtZC4DYSKsKBpe4QoXrTDURur9umjDoPHqIwMfElEqFFQkdmXrxg1r2tgoFMlda7Pgl6c9jKZa+VCvnzFqGIZ2oIWRvSRKaaUicAil1QS+uSgmESBLh5Ki9K0WJLP4CkmRsiG0iL+U2nRQzHLJdNZ0FoKO50BoypgqpYeWgWzz999++W/bV+KCghIhr0uV4pa0bk+mpGq5YGYkMCnIUUtWc3jF0lrIt+lgaJK4azWpNejyK0HVOFsoIkTV+d9xLeKdlI1p2/75ljeNvvmH2bfPFk3DQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/tonga.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaTonga50m {
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

/// Widget for rendering the oceania/tonga.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Tonga50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Tonga50mWidget extends StatelessWidget {
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

  /// Creates a Tonga50mWidget.
  const Tonga50mWidget({
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
      geoJson: oceaniaTonga50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
