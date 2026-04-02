// Generated from: assets/asia/indian-ocean-territories.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/indian-ocean-territories.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WWTWvcMBCG7/4VwufEaD6lya0UCj2U9tBbCcUkbjBs7OA4hxDy34udjya7VksmdA/G2hk9Hr1+NfJdFUI931519UmoP3XtfDN1H8fdrjub+3Goj5bwr4e/r+uT8KMKIYS79Xo4cU1fA1fTeNVNc79OekoPoR7ay3XC5+G8b4fw9axrh/C9m6Z+Hqcl++hPbn89/mxxyT42OwjQRuBsHOZ+6IZ5iX247tv6MXb/XNhFN15283T7uqyndXy52c39t3F3e/G49mfwOJ33Qzu/EOHh9/J+f3Q4DgGiNAmFLOrRQfAYYsOGpjnvxU73kwvkKKw5F8gUVRl8ZFXLyFggszG4ySwSU6lmQWR1ksUkRYIS2VSdMkvmmAtaCKB4hWAisQLWTTXNSQpQZdCITq85XFyVRq+e+dY9ZdpkjoyWtorBBjJkEnv7MhcwiTJv6ocNJMBsDneuYGPZNic2y1sR8lbMkIpSMANHdYJRIW3aHhsgjSQOK/0TvMTAKQVKTnlzR70XnBIxF8ASNZNXY85KVLLbupd9YDYBKLnCEimRD7xMxc32vey8pCZOsCbKZTAwe8ECVt55WTMoOzV+exP6bx3RIC8GL71wfxswZAIteT+z61RduYJWdD4ho6+7GMbS98XSaEGQfK/bIC8tvFgxkTmVAKJy23rHYWaRl1On6Hy3FPnhuC82AYzJyaW/SGwoKTtPX9OUUhG8fpE6JVbhItdyZJ8Snu1c7i3V/t199XQ9re6r3zEKKDYVDgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/indian-ocean-territories.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaIndianOceanTerritories50m {
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

/// Widget for rendering the asia/indian-ocean-territories.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// IndianOceanTerritories50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class IndianOceanTerritories50mWidget extends StatelessWidget {
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

  /// Creates a IndianOceanTerritories50mWidget.
  const IndianOceanTerritories50mWidget({
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
      geoJson: asiaIndianOceanTerritories50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
