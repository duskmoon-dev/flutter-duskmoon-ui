// Generated from: assets/oceania/palau.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/palau.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE62UwWrkMAyG73kKk3MxlmRZdq+FPW1pb3tYyhJmvSWQJkPqOQxl3n2J2xk6E89CzeZgbEv+Iku//NYo1ab9Nra3qv0Wu7Sb4900DHGT+mlsbxbzn/ft1/ZW/WyUUuotj+uD2T0btvO0jXPq86Gju1Lt2L3kA4/d0O1O7kq1/ev0q8Ns+rHap7z//cywmcbUj3FMi+1hE7ux79oP8+EUx3OcXmKa9+dRHMO+3w2pf5yG/fPHVU/saf7dj136dOf37/P8crVeKwUEGgTJEd2sjKQNOkQjF5anS9crXO8IPRS5Fo0PvpYrPhhX5DI7YKzk/iMPznDg2jwwsEMux2vBgKvkkhPwvsilYJmglmuDM6GsB0Zra7kZa8tc8ML/v2xl+TbXVmd//HorWc1hKSiuYxFNHg1BlTQXrkeLRa4lj76W6wgFbEFCotkAgbeV3KVbTKEmol1+FGrjZQCBgjRFCyCYUBuv8S5AQZqiHRLXpoFDECNFKrAIVCneauYlvcWihdz4lVhgQSxzkaW6aGyKr98iXakvGZN1rqhccsZZW5vbL3fw9dekuZwdmuP41Byav19mBALbCAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/palau.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaPalau50m {
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

/// Widget for rendering the oceania/palau.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Palau50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Palau50mWidget extends StatelessWidget {
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

  /// Creates a Palau50mWidget.
  const Palau50mWidget({
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
      geoJson: oceaniaPalau50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
