// Generated from: assets/north-america/jamaica.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/jamaica.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52XTWsbSRCG7/oVg87epr4/cgsLOQR22XsIQThKVmBrjKI9mOD/vowcmzhTEMo6DKPp6Yeurvetrvm+mabt+f5uv30zbd/td+f/Tvs/55ub/fX5MB+3V8vwl8fH37Zvpg+baZqm75freuLl9cvA3Wm+25/Oh8ukp9enaXvc3V4mvN/d7g7Xu+cJ07Q9fJs/7egy+NfqOV+ev30xcD0fz4fj/nhexv6eT+d/p7e3+9OC/fHSw/N6vu7n2/35dP9yNU/L/2e+uf/6I9pn+Hz6fDjuzj+F/fj7+f7Xf9P0h/sgQ3Gxq1+GMIaoC2G+GPh49Vsgq5BExTMTVezyRNEQuQQ6SJsXzsKuBU+JCC26wCQL1RIIYMHWBnqgc72FHkTcA8aAFGWkCigSJNQFEppl1sCAVG8DlURQKiAZWWoXyKTpVsmaJV21KesYzKlQRUzhBP2AUyCxyjFhgJm0c+xsTBUQE9Go6ZMY8KiNCugcFG3jpVFGVEYGcdVo+yQCF2IFxARp2sRHSAoKrng+MrypQB9ugVbSwp2T2uGag+tagT5C019Rt8Q4zGuggUpT0z7YUEjX+fARzJbY1LQP8owoNO3DPbVf+gkkA9aV2ofjJfddIGpwxtoji5YULPpAzNJ0i9gBvG86cKTIUtOA/cLqA1izOj4X1QgCNmVtI5fCD+tKvexhuGfTxjYijaQo1UvIr1phKBORV0BnZ2juoQ2/JLlcoRtjVzY2XILqJJtEu9TYcBdGq2SYAkLZLA02zJKj6AqX7smNrQ8k5SxVkwDLyd8FKolBls4zI4Rmw2BDUJV8fdwtwCCkNpABxco9DM/gtmgIwWvRICtpn8dLKmubACO1bcKSoVw11qi4tNxtWQM4ly0NqaN7W4WeTIbrkGPwYhNr5zghCHidlBicrzJe1tU6hsArttAHILtlDaRsL9AHcqpC+bFDKCH9pqH3Qbup7p/uHjZP14+bh83/TveJwn8QAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/jamaica.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaJamaica50m {
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

/// Widget for rendering the north-america/jamaica.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Jamaica50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Jamaica50mWidget extends StatelessWidget {
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

  /// Creates a Jamaica50mWidget.
  const Jamaica50mWidget({
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
      geoJson: northAmericaJamaica50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
