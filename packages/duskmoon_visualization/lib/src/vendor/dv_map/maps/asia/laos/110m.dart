// Generated from: assets/asia/laos.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/laos.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWS4sTQRDH7/kUQ85LUe+HNxE8CXqXRYJGCayZJRsPi+x3l8k+WO0BqRyGTlf3j6r+V1f17800bc/3t/vtm2n7fr87/zrt3803N/uv58N83F4t5u+P03fbN9PnzTRN0+/Ld9x4WX4x3J7m2/3pfLhsel4+Tdvj7udlw4fdfPeyepq2h7v5y44vlrfDvDzOf3xt+Dofz4fj/nhebG/vDrvtk+3hxYcf+/nn/ny6/9uDZ5c/zTf3P54ifGHOp2+H4+78KtTH3+vxv/+miTBAkoPDrv41KTCyKtZfhuur/wLN1dh4ANoCpBDuAoU40GoFWJgmKT2gg5kjxgh0cFRO7fEMii2cx4gDNE3IrAvEUqvUAZjg7hXqPaBAlpuMDhawGyX1cAqUIrlygAXO6t4HJrOFxAow010pu0AVQ8ThBBkhLEO6SSjAKOlEa0B3c24CGcI0y2UAEngYSbSBFKhiOQAZ1DVMmqIQuDHSqDIzCCVVNkUhSBSiGlRmAgoV9zaQA5FtDchIbtSsXQSUiGhroqi4RbPSIAgXIQ0Xb8madGKKLpDIKsNXgEqRWs3KgGCamat5TVgsTUkQHJ1LBgepwDBFtVlcCTgZSdeA6mypbY1RrITWiqtiFnfbCQFamY6aUIARa3WzhoFIrGi4yZSLJoTdrGFQEsSxxQeUcGSfV5WB471bgE5e/f7EiFQ8ZCElCJYLN2uXQJlr+OhhAiuWabtDxRJXjB4GKGdaMwsVIkp4RRMHVUrvprWBZaHkCDSwQCFvRmxgqiIrjxCFYCmRpsgGTBnh46tBgUOYuk3eAVVKfXzWCGQuN6XL03IJGao/6XKElt1i2H5bb9bGz6OHzfP3evOw+QOQKRID/gwAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/laos.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaLaos110m {
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

/// Widget for rendering the asia/laos.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Laos110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Laos110mWidget extends StatelessWidget {
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

  /// Creates a Laos110mWidget.
  const Laos110mWidget({
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
      geoJson: asiaLaos110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
