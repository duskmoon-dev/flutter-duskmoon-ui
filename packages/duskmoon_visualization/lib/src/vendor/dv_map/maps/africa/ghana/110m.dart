// Generated from: assets/africa/ghana.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/ghana.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WVTWsbMRCG7/4VYs/pMF+a0eQWCm2PvZdQlnSTGJJd42wPJvi/FztxcKyloD0IrUZ6eEejV3pdpdTNu83QXafu29DPf7fD1+npabib19PYXR3C92/DL911+rVKKaXXY1svPE4/BjbbaTNs5/Vx0Wl6St3YPx8XfH/sx/5jekrd+mX63fMx9KMal7fxm/PA3TTO63EY50Ps5n67vuu79+j+Q8bDMD0P83b3WcRJ9c/paffwnuQHddr+WY/9fJbt23fev/xLCQFZCnK+uggQAVKxQv4pcHv1X9wXBJXiSIu8KKLUiHOj7DkqHEKIBYc18QgYRbL7kjyMQsFNPIZQVAxZ0mdsgdLKMylhvMCTyCJaGnmFXcMqfQGmrIatuGxMJarqFmAKY2/FRZFcKpqDeDhqNNEEWFUc6RJnwBnVKbduHeHSSc4gJTBT60kp2aj2mUKEque2nSMIU0ezGueEatxmMwI0MdYKlwERszbWFSGjm3jl2gyios5Npj2IQ2KqPJshuBRxbaEhFLEQqhxmwB7hpem+Q8iOUnThzAWp5NKUKYIGRvYFQyiRqzZdJghOjBxVpgWEWE2b/ICgRhRUapq5M7fVFEEsB2KVaYBaRmwsqZjnShghUBATt10jCKjhResnAsHRgtrM0PzArpb6p95+dWpvV/vVP7olW6AECQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/ghana.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaGhana110m {
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

/// Widget for rendering the africa/ghana.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Ghana110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Ghana110mWidget extends StatelessWidget {
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

  /// Creates a Ghana110mWidget.
  const Ghana110mWidget({
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
      geoJson: africaGhana110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
