// Generated from: assets/asia/bangladesh.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/bangladesh.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWTYsTQRCG7/kVQ85LUd8f3vxAr95FJOi4BtZkycbDIvvfZaK7uPaAVA7DpGv6oarf6rf752aatuf723n7Ytq+nXfnH6f59fHmZv583h8P26sl/PX38N32xfRhM03T9PPyHCdePr8Ebk/H2/l03l8mPX4+TdvD7vtlwqvd4fpm92W++/Y0Z5q2+7vjpx1f4m+GcbmMv3sW+Hw8nPeH+XBeYi/v9rvtn9jDUybX8/H7fD7dP8/jMfH3x5v76z91PjGPpy/7w+78V8G/f3+///tvmorBg4Pp6p8AM6ASS9azwMer/+FIHUVz4Ak4h1ZGi0eQXsXhqzwVdW3yAl3D1uqtNG7jyLJcZCU9QzH23vIRqEdw1cBTwGCXsiavyLB4lEOBBJWkJweDhDPSKIdChXtxduWoshpxBqShQr30EDKYCWONJ+yI3uFlQTF68Vp+7BVaLXmzIIU1cZTXoNwwmZo8McPSAeeApIohLVyCuaCu8lTd2HrLl8BYkTXuDoPwRLeWvJlQQmZjegYs6cXdcgVdgm2lmdMdo1pmkAmYqsy8wjMkt+Amz6tKcY3HIkHa674E4wqvcXcIuBApdXkZy7yxmxkyiprenAUoVE5juzCgWWD29C1QynQe6yUod4re2ZYFgYy64lYEaUFkLfNb3EBDPVbPXlnWr2l+HFyBo9cTpLh4dM3U0st85DFIcVTz7EDQWhx4Td7EZYP06iVQCsxRXYZww14zLxcN0aw1LSi5pGdVxYBsTDYWu9xAyLzavOSlmVd4VExlrZNjOcg9zWT0PgQPzJTWXlt4KCw68gg0TNO6PDdmW9kbBMKKGr1m6V5zN2vvj28Pm8fnx83D5hdVWwH1jQwAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/bangladesh.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaBangladesh110m {
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

/// Widget for rendering the asia/bangladesh.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Bangladesh110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Bangladesh110mWidget extends StatelessWidget {
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

  /// Creates a Bangladesh110mWidget.
  const Bangladesh110mWidget({
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
      geoJson: asiaBangladesh110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
