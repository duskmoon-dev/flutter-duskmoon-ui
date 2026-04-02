// Generated from: assets/asia/northern-cyprus.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/northern-cyprus.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VXy2ocSRC8z1c0c9Y2+X74Zgw+mr0vZhm8vfaANC1GrYMQ+velRpbwI7WQc2i6J6uCyMqMqKrH3TTtt4fbZf9u2n9cDtv9efmwXl8vX7bjetpfjfC/z3/f7d9Nf+2maZoeL8/fJ16GXwK35/V2OW/Hy6SX4dO0Px1uLhM+reft23I+TR8ebs/3d68Tp2l/vFv/PtAY9EfmbwEuAl/W03Y8LadtxN7fHQ/777GnVz5fl/Vm2c4PP7N5of/nev3w9Xu2r5jr+Z/j6bD9kPbz78f3X7+miWUGEEmiq18jOoMpschPgc9X/4/HczKSFmgowAHZRQNPhIodAXGSdfEEs86WkkCwBSezGGOwFXCarKC9dGVWNVDxAs+MwEC7/BCRKSo8Skrr8iMnNuYqX8t08CYeJklA1S4q6sDdeoCxuFX1EOd06baLgRt61S6sggpdcYiGR2KFxxoRvfXjmcGjlhsPetyVGxILe4mnQd160JCbAVb14ASh7OVLc5KxlfUgD3CjJl54RpT6wAA169WXZn9TH6g5GrqLh2SpJZ7jMO4uHgGhlPmKsmGbXwhEVQ5EdceeXdEclsKlnUKkgHTpJaYyVssH4SEYXbzQrOWBaALN9uMZ3JVLO0AxTOzaCyYCarV+6IwivXrwTBLMWbaLWjJ37ZRJNTRLvNF9vfryzMFv2CnaRThdeyYhjFoekM12GW4/RF+hAQp2F0+Mo/Y+AEnu47l61OIA4K44eFZSq89CMIhjdy+y0bBcFReIhm66eGMOlPzQw7G3t/Hs9Ob6sTNIdy/3Z0mVeOPo0uaXRKFlv0hgctdcgscBoL4oOIZ3zSVsWGa5fskG3MVL4MGwNHsdd5wunqkTVfIFtdEwLbz2RWtXvb+8Pe1enp93T7v/ANVl3B0WDwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/northern-cyprus.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaNorthernCyprus50m {
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

/// Widget for rendering the asia/northern-cyprus.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// NorthernCyprus50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class NorthernCyprus50mWidget extends StatelessWidget {
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

  /// Creates a NorthernCyprus50mWidget.
  const NorthernCyprus50mWidget({
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
      geoJson: asiaNorthernCyprus50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
