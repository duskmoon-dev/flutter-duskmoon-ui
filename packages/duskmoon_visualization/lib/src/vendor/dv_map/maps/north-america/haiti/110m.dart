// Generated from: assets/north-america/haiti.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/haiti.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WVzYrbMBSF93kK4XUqdP91Z1cKpd2ULrorQzFTz9SQ2MHjLsKQdy9xJiEzERR5YWSdq49zpCv8sgqhmfe7rrkLzeeunf9O3adxs+ke5n4cmvVRfjxNPzd34ecqhBBelvftwqV8EXbTuOumuV8WnctDaIZ2uyz40vZzfykPoemfx18tLtKPm3k6zX+9Fh7GYe6HbpiP2rdxmv+Ej9tu6h/a5rXocHHz1I3bbp72b72czX8fN/un16wX+Dj97od2vgp9eq7H779C+GAQDZAUeP1OAo8GzCL+Rrhf/weIUczVMBeA2UBS0jogRchunrQAdBDNVOmQIoMkRCoAlVwkVUe2zJC4FJkziQNXAx2UXQpASKAoUAsk4pzhdg9zVM2MILVAdXYyKACZxdwrgRSZXRixABTUJFTH40jqjnJ7yMfE7MkqDXJkyYmotIXEKNV5HZGJSnkTJXe06g0UFik0YY4Ix/tT3YSZmQFKDoFFAeqb0JBNS0AEdk25DgjRUqbSvcsxMbtbpUOIms3IimcMqpqqgc4CgKVroqCe6oGWgBJaAWhZGCq7BqIiZyu0oUdQz1R/JHW/k1VpfB4dVuf3/eqw+ge3ToOJ+wcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/haiti.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaHaiti110m {
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

/// Widget for rendering the north-america/haiti.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Haiti110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Haiti110mWidget extends StatelessWidget {
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

  /// Creates a Haiti110mWidget.
  const Haiti110mWidget({
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
      geoJson: northAmericaHaiti110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
