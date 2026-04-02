// Generated from: assets/europe/netherlands.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/netherlands.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUTWvkMAyG7/kVJufBSLIlS73ux2kpvZeyhNbbDUyTIZMehjL/vSTTGaZNlsU5GEWv9USyIr9VztXjYZfrG1f/zM34OuRv/XabH8e27+rNJP85uff1jbuvnHPubV6XgfP2WdgN/S4PYzsHnbc7V3fNyxxwm8e/edg23dP+EuRc3e773w3NG34t/OHk/34tPPbd2Ha5Gyftx+v01fpDPV6Sec79Sx6Hw+dUzrnf9dvD80epF2o/PLVdM17VfHqu7a9vzok3YAwmmy8CBx+VUIg+CQ+b/+AgRVRawzFChBBKcNEnYLMUVnBgmExjCS54DUCqvMChFwKOkctwARkQ13AhckoipbhoCfEfOGYsOzuICRLSCo4kEWtRdtFbCma4bAX6mBgopBIcewGxxLaCg5DItKgV4pFFWJfFgteJV3R07E1VWNc6oYyCXFSreFYLJsuhmHAEZEXZiddIKrb87cgTaYxQNGPJgxFwWJsxjBFi2cgWXyjVmn22jtV5faiO1Ttdeir/+gUAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/netherlands.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeNetherlands110m {
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

/// Widget for rendering the europe/netherlands.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Netherlands110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Netherlands110mWidget extends StatelessWidget {
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

  /// Creates a Netherlands110mWidget.
  const Netherlands110mWidget({
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
      geoJson: europeNetherlands110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
