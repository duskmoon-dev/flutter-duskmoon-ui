// Generated from: assets/asia/afghanistan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/afghanistan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYy2pjRxDd+ysuWpui3o/ZhcBkm30YgphoJgKPZGxlYQb/e2g5HuzphlASiOvbt4+ruk49zv1+s227y9P9Yfdh23087C//PBx+Pd/dHT5fjufT7nYsf3m5/bj7sP1xs23b9v36O2+8Pn5duH843x8eLsfrptfHt2132n+7bvjly9e/96fj42V/+rFp23bHx/Ofe74+8HG6Ly/3f3u78Pl8uhxPh9PluvZ43O/+W3v+YcrXw/nb4fLw9N6QV8t/P989fT2f3mOeH/46nvaXNx6/fN5e//zXtrmDUTp63v60IgHiHKnybuHT7f/hMYWk1gqvJAq5hWcQai4YCzx3ItcmnGWWxtJdNCbPFp5CqBMaL/CIKCmiiWfqGkUTnoMQY0gvHAKVnGVzOBwQoyysiUclJqkTnkFakJu38Bgq1Z1lgac4vr14MLCgG9kCjwO9SRcCJkyKORwGbojBvXAgJAqVzMenw11CqiaecSrXTGcBD1ftRQOhXAJxNk/GP0ppu2viGDGzb8Sd2LMXXYR0cdPZXQZKLqq2v0ql6hMegWliaC97CbxKSOfzI5AoQ6cmXiQx02wfQoilYZt+oaw5ZQcXJBdLj30MppU29w4uEEoL7hYXM2THiS5coJ4izWKgQJqIPBXnYZ9iUvV6kYIYKuXUi7jAHFGwRz8DVE9fmafBlNhjn4OM3sETW0Z0M0qlV/wcJEkt1uzLrObxOdTYRXOvJBDUIurhBQxOlKyyV1DItIsXxZ61ss+SS7B3fglmXrKCCxLplYKEYvfwuZQSOCNl9fBGhka4zp2NoJCUmqW+gJ1tTjVhMBw1tmueZ5DGPBcIEJpWq1IFgrBY6WyewKijwr3MLShB00VsFZCRGFvuBkImJa68rcw067lLQOYRMuMpiGYRtZg88MiQcu67CiFCbK1KFQROgjFXPjEgE8ZepQoCrQxfzBnXMc28NzUHDTKL5nx+Dhgq2ZuagyDVx3iywDOs0l6yBUMxIi9ElkMwYq9xhAJ6mNGssRxSnKI31IeChWXxSmQhY2qTfoMUibwUbSSCgr30UKhERJ5FQoBSVTWzV6A0fSWyApTJ3HvhFWBHNFv5q2Vs3vOXwcUza6WhUcMse/7yEIFDmi34UpqcPdF7TQ91WaZbyJBf3fTVEQ9ZxRfdXLU1R8YQA1S05F+hRWi3XLGUoqz4UqMXWS8eNIo6Cc29PIEtC613fkOlejLO55eg6ZzUqwcIEi646L4JJCnVbG84pLzFAi+GLCLvybZAIHKLxUuNGK+LmLmnO2q8U4u0FZ5jVnlvsC+gco5lPSUjUunprIS0Ul3WF1EVsZ6/I4pmzit/kYWox2ePIUarah7sA0i1qjeHB2BYJM/pESDmpE3Z235lerO6fr16vnn9/XTzfPMv9Y3FPNsWAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/afghanistan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaAfghanistan110m {
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

/// Widget for rendering the asia/afghanistan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Afghanistan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Afghanistan110mWidget extends StatelessWidget {
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

  /// Creates a Afghanistan110mWidget.
  const Afghanistan110mWidget({
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
      geoJson: asiaAfghanistan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
