// Generated from: assets/asia/macao-s-a-r.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/macao-s-a-r.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WSTWvDMAyG7/kVwucSbEeynd5KYbexsR1HGaZzSyCNQ+IdSul/H3Wb0g/DsA9C1is9SJYPBQAL+96xObAXZ8Pv4Ja+bd06NL5js5O8OYdHNoevAgDgEO1zYUyPQj/43g2hiUVTOgDr7C4WvNq19fBZLsqPaxEAa0b/bWVMeHuKVzG+WN4Ka9+FpnNdOGmLsbHsoh2vrWyd37kw7O8bmTp/9+1+exn0yvTDT9PZcDPx+dz6jzcAIaoStam5qmYPkpSlqIlIqTthNfsfaFDoWieBWlNVZwNrY6QRCaDkQikuc4GERFybFFAKNIj5QCMQKQmUiut8oNSceLJDpBp1lf+GKJCrJFAQSZ2/ZcEJU1uWQqPhlA3M+4dFyp+8YzHZVXEs/gAzWbYTMQQAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/macao-s-a-r.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaMacaoSAR50m {
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

/// Widget for rendering the asia/macao-s-a-r.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// MacaoSAR50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class MacaoSAR50mWidget extends StatelessWidget {
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

  /// Creates a MacaoSAR50mWidget.
  const MacaoSAR50mWidget({
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
      geoJson: asiaMacaoSAR50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
