// Generated from: assets/europe/united-kingdom.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/united-kingdom.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE61Yy2ocVxDdz1c0s7aLej+8TEiyCIEQyCqYIKyJGJBmhDxaCON/Dz22HNsqLVRkFk13376nq+uec6rufNgsy/b0cLvbvlm2P+8uTvd3ux+P19e7d6f98bB9tQ7/8+n2++2b5a/NsizLh/Px6cTz4+eB27vj7e7utD9Penx8WbaHi5vzhD8P+9Pucvl1f7i6PN58mbcs2/37498XvD7zyw9P7sun+398PfDueDjtD7vDaR376X598fbz6Mcv8Vztjje7093Dt9E8hv/b/fVp//vx+uHq8yd/gT7eXe4PF6evvv3T7+vz76+eXi/LaweqyNR69WTMBNLD3L4befv9ow2sgTuVpjewCmbqKDzAdQiR1GhgDSg4fQAaYMHk0eXAgISceRJsgLij4DNJKEul/zlcBbQqcx3ltkxCkHvckECWEe7LKbZ57uqbF76Y7QJYkoIdfwQU1TQmqVOwqKrqUiegZYiSI9wIRBJtcBlSEXGiTgVmFvWOmAyCJGYxUj17cFmXXoIq0mm8lSoeXXoJrNZPmShJQJmDylpcZU/NifAFlDStFf4ZF3FkVAqCVVnZ4jIhIk3yYBDh5t4pFIGsPGISrwGrIUuzblpQtkqmZnJTNmwdEEGUUmLGB6dQTWpxmVPMJnlgKHOOTsUIXp4Tb2DQrKroyItgKxdGJEOIDKNncCO0MgeLhmCGItJ5A0K4hUzSQKBa6Sa9JLKUYwSLhubUKzjRw3GQXAKzqoxOwAy4yiEHBkngSSbYw4aUMQ58DEG9KryHLV7DHUSLQKmV1C2ZgLAhjfoiBBXU7HiroK4SoyJBQKRVnScoOJ/ZN5Ivonm0tdIgUQt54o0MmIZYXXYNCocUey1AVIjS5cGgQqImzSEDU1VmV9odcu1+Rh0ZreWFsy3BAZ4aVZMWRwDNVmvtcQuRZhUNQ5Jb8gaYCbJOioSsLEPULtwEl3OZmHWQqyq0izdXp0+dbRvxTNBOFGu4ay88YZlBpCe3+8aApEzN2ZZptYZsjdchzkKcNdKu+kweHDgMaZZeS5eK3nOEiHRkkQaoUYn9BjpSKm3W9wcVEfees5IseNaXYrJxu/8xQCdHnCybQqqSP1MrorCCZvuJlfpofWlzMqRRrVj7XQ1s6avgaxXxWWtaaoitm8m6l6ux+RZjVLdu5+27Kg5d8uV/C2yeu/rv/PHs4+bx+HbzcfMvE9GAGtsUAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/united-kingdom.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeUnitedKingdom110m {
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

/// Widget for rendering the europe/united-kingdom.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// UnitedKingdom110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class UnitedKingdom110mWidget extends StatelessWidget {
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

  /// Creates a UnitedKingdom110mWidget.
  const UnitedKingdom110mWidget({
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
      geoJson: europeUnitedKingdom110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
