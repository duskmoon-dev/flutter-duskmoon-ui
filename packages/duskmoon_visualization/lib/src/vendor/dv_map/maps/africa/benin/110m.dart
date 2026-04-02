// Generated from: assets/africa/benin.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/benin.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WVTWvcQAyG7/srBp8XoW/N5JaW9tBD6b2EsmydYNjYYeMeQsh/L3G6IbtjKOPDMJZmHiTrlfy8Sambnx767ip1X/vd/OfYf54Oh34/D9PYbV/dt2/mx+4q/dyklNLzstYXl+OL4+E4PfTHeVgunY6n1I27++XCp34cxvfjKXXD4/Rrx4vrW2WXxf7l+0fHfhrnYezH+dV3fXsc9rvun/flPYy7frrv5+PTeRCnqH9Mh6e7aTynTsffw7ibP2T79nzcX76lxOCFAim2Fw4Htpwp+Mx+s/0PLbSgs13SAnJgiGojjSUK50taBkPPao20QiyY9ZJWgCQco7TQBJhRjLymqSoZWxst0FSyXNIIAV2YsClVAUfEqqSEIMKUvammAlGCiNdiC9FQ8zacBTN5VQYiEI4ipTVVIspYKY4I3JE8qE0kWbNrnSsDi7lYk0gYtCC5VCJZcILGjcGRqYas5VoUybAJR1DESrbVT6dEhk06IVANiswrONMIKo04VlEvtYoJiNAIcwsOIZdivibiUkIaVYcQwSJWFxZBAzPmxlwxIkpdCAQKc/SmDiNQNvS6/wtkNiltY5NAXVDrIVxARJ1V2mjuqhErY5M4W2mbcwROuRhWNIcsjJIb+yG7sdajxIGUySLamrXtx7pZ2592L5vTerN52fwFVPCVpvsIAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/benin.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaBenin110m {
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

/// Widget for rendering the africa/benin.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Benin110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Benin110mWidget extends StatelessWidget {
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

  /// Creates a Benin110mWidget.
  const Benin110mWidget({
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
      geoJson: africaBenin110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
