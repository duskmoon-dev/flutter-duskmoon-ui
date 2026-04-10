// Generated from: assets/south-america/bolivia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/bolivia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52Yy2ocVxCG93qKZtZKUfeLd0kgq0ACWQYThDN2BiSNkMcBYfTuoUeWkN0FoTyLpqdPn4+qqctfZz5fLMvu9HC3371Zdr/sr06f7vc/H6+v9+9Oh+Pt7nJdfv/0+OPuzfLnxbIsy+fzdbvx/Pp54e7+eLe/Px3Om55fX5bd7dXNecNPx+vDv4erlw3Lsjt8PP51xefF3zbP5en5r68X3h1vT4fb/e1pXfvj+On0z/Ljzf7+8O5q9+Wlxxd7PuyPN/vT/cPX1jyb//vx+uHDF29f4Mf7vw+3V6dXbj99Xt9/+21ZfvAC4/JIuvx2iRDKKETlq5W3l/9DTHA3jIotkcGcBJGmxEzEKOuIWRVcY2JxMUtuiQKO7Ck+JmpmeuO1gpq4lM6IBSJloi2xTKjMpkRyFHXfEg2EpUJqbGNWuHJHdEf6nshYuZhuiQ6G6BVjG61Q21gHWCISjYmEyF1gEnh12oahTij3pGycTqgkTxkTVZnZmrIuUDT0HCZPQliQx5bICBLsllMgUxVJAyTQ0jVRZ8SA5KSo2hIZcu0SObQxgNA9ZFsxzBBixTq00YFDRGobaiZIYSEcBkahXLO4+R0ZMCydxkSJwB4YlVg0lASBSk9pRIYJqsR1KjIMqa6eW0lYnRatnNYgg6ehdfnNwFrIxVMiF1H0oUYjl2nyMLBbOUlXg0YSYyJBpAt7I60FLhLiMSMioIq5NiJTIMqhQ6IVEBkqtzaKeeHMaUugFA1q2m3BmqhVs3Rcie5S3IQagcIDcaYxFpAmidT+jOVVZbN0tIDSqopt8pwlARF1TPRwxNz221W2nFJqGOoArZSgRrYSKJQyZr3MAkLULBuvA8xYPWeNwhI4MbFJngAOCsJx8kgmWqf+DhlBOByiVhOVVnXtiFxlIcN+i0CW66zXEi05ZSitCKZcbg3RAEuKcNjBEdiItEtHA4xgyuGgh8Cuwt4kj4KrVUzHWwS1ospmYFYQU8QYR8ZQpEtHgQgr02EDJ8Bcs6dxWkCjZHw2IggSRu2JWYw8llbiwMQm1AJUGTnUhHWgQEHH1kZEdJOhjashrpXNuYPBOVB4aKOCkItx4zWDOlUMa9BAkTmpUVYC89XIYQ2u50jK1mmELMvgYcUYqGpK0ybWkYfUaAwUSRXblmBB+Dl5ZkAHVy9sJKaghESm83cAxar9TZNAEPQkHh8HUZOKm+xGCGK0YWfMVerYmoMRESCpMQ3LJddJlCx6orjkUFe/46+ti+7++e7x4vn69uLx4j9Ir/lYihQAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/bolivia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaBolivia110m {
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

/// Widget for rendering the south-america/bolivia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Bolivia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Bolivia110mWidget extends StatelessWidget {
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

  /// Creates a Bolivia110mWidget.
  const Bolivia110mWidget({
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
      geoJson: southAmericaBolivia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
