// Generated from: assets/africa/somaliland.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/somaliland.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WVTWvcMBCG7/srhM/pII3mM7dQ6LnQYwnFbJxg2LWD4x5CyH8vdrJLEisQHaqDkP1aj2dGr6SnXQjN/HjfNZeh+dG189+p+z4eDt1+7sehuVjk25fXD81l+L0LIYSntd9OXD9fhftpvO+muV8nnT4PoRna4zrh13hsD/2hHW7Oc0Jo+ofxT4uL/s19I+SCsB+HuR+6YV60q9up37fNq/p8DuauG4/dPD2+D+UU+8/x8Hj3muqZOk43/dDOb3J+aW/HH59CIAMnw0h28UFJCShFSZrfCdcXX+IJfcLDJJW8rKaWS/FlZbKklbyIiV1ygZc8R8lexVNgZGGVEg8V0VIVT0CIKSbc8CJYEianKh4DszhFLvDELaJzFY9AEiF7KvCIECPX+YUgJbWYt/VbeMzZ6vLNIEuz7fpGMKEkjpU80ijspfVFVY1e55cMiTh/st8EY/Y6PyOoinHa8iI4iqnV7TcEZiu4OQIrslWyHK3o5Iip0scZ0MX9I8uBKVJdWBlETTcbwiFZrsxQltMub846BXexOpSCmtOmWAYx1p7AZKKZN7UysKyCUrcBDDxbQi/Uizgp1dl/pWHGwkK6Zo6x7rRcceRFj/nyH61z2XJ7YYy85SXITihSHd//uF2/ztuVxqfR8+7UX++ed/8ALqMjzlgJAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/somaliland.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSomaliland110m {
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

/// Widget for rendering the africa/somaliland.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Somaliland110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Somaliland110mWidget extends StatelessWidget {
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

  /// Creates a Somaliland110mWidget.
  const Somaliland110mWidget({
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
      geoJson: africaSomaliland110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
