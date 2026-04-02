// Generated from: assets/africa/algeria.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/algeria.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WYTWsbSRCG7/4Vg85WUd8fuYUse97zLmERWcUIHMko2oMJ/u9Ly7Fx3MNC6SBG05qH6up6366eHzfLsrk8Puw3H5bN7/vd5d/z/tPp/n7/5XI4HTe3Y/jr8+3vmw/LXzfLsiw/rt/zg9e/XwcezqeH/flyuD708vdl2Rx3364PfLy/258Pu9cHlmVz+H76e8dj8Lc/p/vyfP/j24Evp+PlcNwfL1fg1/Phy27zc/TpNZC7/enb/nJ+/DWMl7j/ON0/3v2c5iv1dP7ncNxd3sz3+fP2+v2vZdkmeKpU5e27EQ6QslClXwY+3/4/T6FYREInnkKFWjR5BGaIpjXxGKLY3arDI0gW5vAJh+CEiaUdHAM6VuGcPQRSZpEmzlMs097jqCDNWZA7OAFSd6cVmpdYpDdpliTCKzi0ENdWcArsoVRrcyUzdmvhDDzCfFrXMVckxujAEiw4S6bMMYG5ufdwRFBVhjZXnYAGuWerTGhEge61JjKsKKxW7gghgsRljk/BnE24JVpCEJRUn0WrIFFCIh1eQWmyk6x5iniZtAq5oAi9eJ6tgbipaRMnVEorHuCApcLacqiCIOe0NZwRM3ozd861VnkBpFgm1gzOnDjnwgvwTLaepdTwu0yNCZdAqhTSTF1arW1lCWVVWS3VFiSai85zLVBWl55oCzSZpCZNyFBLmHlLY8NzzZGn1AkDIXvPARJUipCn1AmDoXP2anjgUIPnuTKEpki0ajjAiV1pKmIREFWiXnQBxqq5gru6p4S3FjavQkqaNjJRcDPquUmChIvPDYoYaFRGk8YUyTo5pzioCEVzW1TG8lkR4lDqyt1lDQmMudsRh0wLjJY3BcjYdWZaAFFKYitzDuyUVLO+Bg7dWrEZCI8uZGooxIfdG2WrghWSLCzXcOmG4i2cADl55ax+h0gp7OmLQN2Lci5hB0dzjZbTIRhKxtzaiYMgcXArui0CcaitVLFBZrpzS/5bAsZ0XDE7gyBNzZbItgzkVSRz5RmQp1SvAdjSOCfVSkMhCsYxFqrLExlN0oobF1UQZ5Mnmag1exRDuiK1lLYlIFYzmo4pwuBGxm2eYGTVrDUGds7sSXfL4OSOurbVjnZRvbVzbwXQsxLn9BEEq1ZvNQRcQyvmaiZwCe6djweuUHVOHkKWl1Gv9nR0eK4+L+5wCaLm9rg1YGXildpDQETVntR8vA5w4fmgUhAyZN2zggC0Yo65Py6wKOZeCzpe9oQSzenjhFTiZiknuJtlrR0u3Fy5927mmTfUu8KzLI3qvTtqv9u6Wbt+uXq6efn+fPN08x/FpzTFghQAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/algeria.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaAlgeria110m {
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

/// Widget for rendering the africa/algeria.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Algeria110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Algeria110mWidget extends StatelessWidget {
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

  /// Creates a Algeria110mWidget.
  const Algeria110mWidget({
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
      geoJson: africaAlgeria110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
