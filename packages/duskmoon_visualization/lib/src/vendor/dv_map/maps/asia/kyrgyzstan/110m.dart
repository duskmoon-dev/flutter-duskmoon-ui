// Generated from: assets/asia/kyrgyzstan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/kyrgyzstan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWy2ojVxCG93qKRmtT1P0yuxCYWWSTdcIQxEQxAo/ayJ2FMvjdQ8vxYE8fAqVF032qz0f9+qvq9LfdNO2X6+Nx/2Hafzwelr8vx5/nh4fjl+U0n/d3a/ivl+Wn/Yfp9900TdO323W78fb6LfB4mR+Pl+V02/T6+jTtz4evtw2/XC/313+elsP5+55p2p+e5j8OfIt/2qzLy/pvbwNf5vNyOh/Pyxr76el02P8Xe/6eyf1x/npcLtf3ebwm/uv8cL2fz++Z8+XP0/mwvBH88nt7/+PTNAVCOQtp3f0QUQZ2J1N5F/h89/88ArZijRjwyCMIo8VDUEZk1g2PwKiqspsfWaSlDXikYhnU5GUgkeaAJ8WF2OMJoJlS0IaHkO4oXbkRmmEjHKmlqjZ5SEq1VYvAquJmTXddEyk3PCkosTCpDs8LzMpxmB+hMFFLrheoa6ZvukMKjN2zaQeCaZHTSK+jUkVL72pvqpf4gMdR6sLN6vMwiZIBT4VYvJefQDkiyab8Vr2OiNkrP4FkZpXNdJGCLKmQXv0pRHj6YLogiLuy9fw1UI/kUfmZMwb3cL4WmfgIpzd7e7PFoVA1dTT70F3Teu4mUAbVtjvWWZom1OaZijuOeJbMyi13E4GoVHDrLgOxlPbOosT1bKvCTXcog2hVVc/eAldxta0fDFruydnkkTJFjPSmORb3ui3ALaV4gCtHz+awd0BEse2wWnmZ6yHfbDYXLx/9exmRVb3qU2DidNt2mwBXijTdFXA1wYFcASzioO4s1aywGOk1xCzt2UGQqi45quZUk7LupwGlc+LI3kDl4p7e9pfpbnT/eve8e71+3j3v/gXVekDyQQwAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/kyrgyzstan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaKyrgyzstan110m {
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

/// Widget for rendering the asia/kyrgyzstan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Kyrgyzstan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Kyrgyzstan110mWidget extends StatelessWidget {
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

  /// Creates a Kyrgyzstan110mWidget.
  const Kyrgyzstan110mWidget({
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
      geoJson: asiaKyrgyzstan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
