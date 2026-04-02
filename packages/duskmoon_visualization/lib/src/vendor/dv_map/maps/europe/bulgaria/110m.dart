// Generated from: assets/europe/bulgaria.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/bulgaria.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWTWscMQyG7/srzJyD0acl5djS9lp6LaEs7TQsbHbCZnIIIf+97CQbkoyhaA7GI42feWVZth83pQzzw+04XJbh67id74/j52m/H3/Pu+kwXJzcf5/Nd8Nl+bkppZTHpV0PXD5fHLfH6XY8zrtl0PnzUobD9mYZ8Ol+f7097ravI0oZdnfTry0t3m8rOz/bf7x1/J4O8+4wHuaT78v96ZfDi/fpVcn1ON2M8/HhvY6z8O/T/uH6Jc5X6nT8szts5zcBPz9v+x/fSiGqTQ0l7OKDR6QSSxC/s19d/A8nCCJNOjgAh8aa5CkAalvL49qEHEWSvPAG6NrhESI2pCSvgTjgmkfVwxXds/PHTUPW8VJVB6a0PhUFRO/wpCG3LI4dlLSHYwLSyKbXHdl4HS7WiKCwrL5QYjPq8JgtgiPF49qCwLj1eBDgkONJlaAmEh2eOnsk86EVwwhwXW54ql7xlsK1itCQHXvhknskV3OriAaCvXCdWoDk9FlFVuNYh0sVBcUllw6rEc0IejwAY3VL8pqxh3Wr18yDcruVV+CA0HU+uFIwGub0eVV18M5uxdXApCV5VsMAobc5O5I0z61mqyTEEWt5UtE00qsZmqJ6T14IS3BuNWvVFmTYPYvcRSQ3e1IRoFmsNyuuJgiKubOXKzMxEPfSsSQqexaFiDOtq4OrE5tr9m6Qu2psev1z72lzbq82T5t/fD7QaREKAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/bulgaria.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeBulgaria110m {
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

/// Widget for rendering the europe/bulgaria.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Bulgaria110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Bulgaria110mWidget extends StatelessWidget {
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

  /// Creates a Bulgaria110mWidget.
  const Bulgaria110mWidget({
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
      geoJson: europeBulgaria110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
