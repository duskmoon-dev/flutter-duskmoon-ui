// Generated from: assets/africa/united-republic-of-tanzania.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/united-republic-of-tanzania.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52XTYsbRxCG7/oVg86boqrr2zcT8NkE55JggrKeNQNraZHlw8bsfw8jaZe1uwlUdBhG3dMP9fVWd3/fTNP29Pgwb99M23fz7vTtOP96uL+fb0/LYb+9WafvLsNft2+mPzfTNE3fz89+4fnz88TD8fAwH0/LedHz59O03e++nBf8vl9O86fpt/nh29/3y+10uJs+7Pb/7PbL7gUyTdvl6+GvXVsXfPijG+fL+NvXE7eH/WnZz/vTOvf27rjc7rbX2acX4z7Phy/z6fj4o2nPvrw/3D9+vrr+Qj0cPy373elVDC6/1+8//5smZkhkJ2o3P838gpD6w9jHm/9GEYQZeQciwOZsJRaCW4aNWCRaswtBKAklBzRiMU0q8oKMeMizjCSp8lyDscc1aOFNkavuWlqfhgZCHP+LxX0iLjSVKPK0uY1ogW6tGjZhpI7FgCxcT0FrMmCxZpmlqDpiqYVW40Vk3GtTABOpFK+W4MpKAy8FRBtHSpHHnJneZ1NAMjO4ylPKjEF16Crg9Mgib12VrVeCQq6Wl3nWELn12TDQhkhard/VvLToeA7omVEuYVmN0A4XwIKIXkrHlYfZh+/K01L4mIDUXYkHPE1RDy/yVI0l+gYQ4NZQoia1BpQUNujqAcnIRXcbuCb7oA8kNEbN4qbD4Jze195a5U61DZEhBYO9T22CJZtzLXQCrS9iQqDani+guqqyR9FZYDV5KTA1Th/ihJPEaoIwUBKM0QGHwBtmMWoGqxy0r9/V3RTlomAdxKmNo2fhtVw4RHPri5cImoXXtBAgzVUHnX3FhTZstWNJgrZB3BAirSZ7QWAyHURtnfCSRq+ssF6lFxqm10okISUHUUPAjFp1JCirj7oRUeNa602gMO29DJBQrfW1hKYNR5sCohe3wARKsT6XDo5cK9kE6XXuULVH+oAbFDMX4JmDXm0grlaTdayb+mBPUkiM4nUvoWEbnIYEzM1rFeXgNkgcg7nXjrns6x1syMK0rFWBAHobyRlQM2p2VS7am9H789vT5vn5cfO0+RdwIUGWHhEAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/united-republic-of-tanzania.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaUnitedRepublicOfTanzania110m {
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

/// Widget for rendering the africa/united-republic-of-tanzania.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// UnitedRepublicOfTanzania110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class UnitedRepublicOfTanzania110mWidget extends StatelessWidget {
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

  /// Creates a UnitedRepublicOfTanzania110mWidget.
  const UnitedRepublicOfTanzania110mWidget({
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
      geoJson: africaUnitedRepublicOfTanzania110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
