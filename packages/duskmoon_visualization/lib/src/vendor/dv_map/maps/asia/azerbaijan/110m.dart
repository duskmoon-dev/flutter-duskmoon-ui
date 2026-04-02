// Generated from: assets/asia/azerbaijan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/azerbaijan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51Xy4pbRxDd6ysuWpui3g/vQkh2gawTTFAc2SiMpUEjLyZm/j1IkzHzKC1SWlxud3Wfe9R1qvv0t9WyrE/3t9v1+2X983Zz+nrc/ni4udl+PO0O+/W7c/jTY/fd+v3y+2pZluXb5fl24mX4JXB7PNxuj6fdZdLT8GVZ7zdfLhN++Gd7/HOz+3uz/z5nWda7u8MfG77Ef3vTL4/9Pz0PfDzsT7v9dn+6xO52m/V/sYfvTD5vD1+2p+P9Sx5PxH/5enPa/Xq4uf982L8EPhz/2u03p2f/+vH3/P116217WdRBUcsw372NEaSjh/Gr0IfXY1tcUlOhHjeYE1lHuC5RmNziUpIHxwjXkFxCW1x0VdUJrkE5O6L1fFky2Ee4TKHsPV8lUqMa4CpUsCZSi8uaxDnjS1FaVg0uQqWJyYSvgTmKUacHhCTmLBvhihWFdvpFMCdDyRFuFhVGz5cpNWymMydE4gZXCrKqasTXAUVNtNGDFPi5jHFWb5qi1chBCtSVTGd0DS2omrRJQgQ62mTbCfA0jGrKTQoMU3wCm4COWNZnzZJZRnQTxMz4Cl3ODJ8URQIShqr0q1uKNMpagotKWEc3gQMlYsY3U1irE2+CMLKazHDNTbjnm2ftjuRQwCzM2acNtZhyskkWSBlb9TKTKk2aFHGBeTFyd1ggUDgh/X9YQ5DiZOph2dycBp7EEDA1ubqzGMHYyWLAVwucsujaWRFcrBOZFRAhu0R/Fidz+iRtCZYqJr13SMz0nJRxQGVwSu/NFC2pJl4yziXlbv06kJGST/IWICFC1nszpgqZetR0DPR+fTlIYuapB159da314ouDewOpOEu/tYYSI818V4hJVHfEFAhVUE1yfcatimxyfTYc5+AQlytJr8FS2GSrUgNEqox+GUIRUSY2XCFKKqsppTMuCeLoOqJQxp6d7SoQsfDh7Uktgrtb5PmgDSUZZW2k3uuVtHr99rB6en5YPaz+BVgw7hTGEAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/azerbaijan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaAzerbaijan110m {
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

/// Widget for rendering the asia/azerbaijan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Azerbaijan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Azerbaijan110mWidget extends StatelessWidget {
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

  /// Creates a Azerbaijan110mWidget.
  const Azerbaijan110mWidget({
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
      geoJson: asiaAzerbaijan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
