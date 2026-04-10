// Generated from: assets/asia/jordan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/jordan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUTYvbMBCG7/4Vwucg5kMzmtlbKexhLy29lqWYXXcxZO3guIew5L+XOM2SxD5UPgh5Xs3DK2lGH1UI9XTYtfVDqB/bZvoztl+H7bZ9mbqhrzcn+fc5vK8fws8qhBA+5nGZOC+fhd047Npx6uaky/IQ6r55nxOehvG16T/Xh1B3++FXQ7P2bRHnc/zHtfAy9FPXt/100r7su6b+px0/Xby1w3s7jYdbDxfT34ft4W3ob5nD+Nr1zXS12fN3Pb//C4ElShJV4c29QpGd3ekm/rz5DxwJ+gKHMRsJJCvksWdRyCu8ZA6mhbhE4GhpBYcAoFJmL0UnUiC955FHAWTSsuNL0UWBM63wWFQk5SKeRlDzBIvrII/oOXkqOz897YowrfkTEBIu5eUEQtlWeKZCxlzEy1GAxRb2GCIA51x4HTmqGqIvqw8is53appDnbpZs2R0QBSy5eyEPgFBlUX6MMw/L7HkESGay3C5FQCAsK75TiUnSlWajiIoAVtZsFrMTJ5AFjyNnU9NUWHzGCZRw7elDcs5S+LhkdMeV6qOYwdGpzF/p01ytzS+zY3UZn6tj9Rcr6zzlPQcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/jordan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaJordan110m {
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

/// Widget for rendering the asia/jordan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Jordan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Jordan110mWidget extends StatelessWidget {
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

  /// Creates a Jordan110mWidget.
  const Jordan110mWidget({
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
      geoJson: asiaJordan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
