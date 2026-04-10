// Generated from: assets/asia/brunei.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/brunei.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VYTW/bRhC961cQOgfEfH/k1hborUWRaxAUQsoGAhzJkOmDEfi/F6RjN7aHh0xTHQguZ/dp+HbmzSy/7IZhP99dT/u3w/7X6TDfXqZfzldX08f5eD7t3yzmvx8e3+zfDu93wzAMX9br64Xr9NVwfTlfT5f5uC56nD4M+9Ph87rg58vtaTo+zR+G/fHm/OeBVtvvr57z+vzdM8PH82k+nqbTvNh+ujke9l9t909efJrOn6f5cvfch0enf7u9mo9/nK/uPn190Sfg8+Wv4+kwf/PGD79v71+OXo+HAVFHFABOfPPKKGNkumq+sHx4ObXGBTJXjy1c8C5sBISVsIQoZD/cXUtkdWniKqqRVrgaZNZ0F8GBkStYThDKJr3oYKClu2xC0AwGEjNPL2HFCS2auAkb5LKShjfdZUziqNk1pWBq4m4HGQe4YXPXyJPSssIVNRbv4ppZJpVJwZwhzaSg1eEyHFxBo6s5aCFawsbDmzRhv1sid1ujZ//Ykev/S1bFF0WpYNNIFJvUgbipFRGkI6B1ZVXGTBWEGpeIjbmHG7IlKCnGYS16ZXSBoJreCAToBbyMJhoZUiZSBopoD1dFnKyssk6iBk1cIRGUMpPMQACa4UCZm7jg6D0BlBF9U6g0Ia1Xt2SENZZKYdVcMryLm4q4gWtK3BNsWYQ1xGseyFIZm/tGgoTlvol7RK/fkJEMgbXkQVBIvckvhWvWPLCKszVlhyJN6jxmEGxWLhmZKKUu4GTk2XRX0AywlAfSpXw3w0y2qxABq7XlDImg3DVcW/smu7oqS+kuSIJTk16DYICyxgNxurQODTLaUjPrbQN2E2vS63XFhDTlXqssoy/dMJYtLVp4RjODA0E2M8IUuKk4HixppZJRv7WXMRhBZUtxJKnJbwgs5aA+QDIhNXkIDDIs/ZVVPZv75gnIVuMaJzZTwrdPTqoM5M0Uds00KHHtP4XZ9kHaMcCsqbweglu4KsFN2DBRrZUsAL1dh3O7P43lc0sHtXG22m2N/r1/vLvfPV4/7O53/wCXCY8x1hQAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/brunei.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaBrunei50m {
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

/// Widget for rendering the asia/brunei.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Brunei50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Brunei50mWidget extends StatelessWidget {
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

  /// Creates a Brunei50mWidget.
  const Brunei50mWidget({
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
      geoJson: asiaBrunei50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
