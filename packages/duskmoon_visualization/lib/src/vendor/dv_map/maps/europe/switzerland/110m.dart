// Generated from: assets/europe/switzerland.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/switzerland.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WVTWvcMBCG7/srhM+L0HzP5BoSeiz0WEJZEjcsbOxl41C2If+9eJMNSSwK8sHIejWPNR8aPa9S6qbjvu8uUnfdb6anQ3857nb97bQdh249y79fpx+7i/RzlVJKz6f30vC0/CTsD+O+P0zbk9F5eUrdsHk4Gfz4s53+9ofdZrh7N0qp2z6OvzY4L7j8tpin1/mrj8LtOEzboR+mWbt6mv/avakv75u578eHfjocP2/lvPfv4+54/+bqO3U83G2HzfTB59fn4/jrV0qRJRhRYf1FYMuCUsThk3Cz/i/Os8wwiArOqTiatOEIjApIBadAYuEtOMusahI1ZxWLOLbRIBALYoXGHKbS5KtmIxWDaiYYvAA14tQNyCs4dLPS5qzmQka+zKtmQzFza6QhaollXjWjYXhbXjVLKSXCKjjGUMNGnDNJ0IImOQKAVdvKBI1cyjJ0ks002JpCZ9lEInBZJpIdmaM0HlgCVayGDpSUsfHAskcIcgVXioCUaMOFKhVZFvFcjxoETbjI4OgO1TrhgsBNqYgciE5aq2KCORDcgoOSSYnMl6nVzE5ibR0ASmZGq3VPzR4krE28yEHI7LXcBhbDtqsiMluEVnqAZSjNMCUMglq3IzYt0NTtmm/FVW18Hr2szu+b1cvqH/0yfW2/CAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/switzerland.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeSwitzerland110m {
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

/// Widget for rendering the europe/switzerland.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Switzerland110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Switzerland110mWidget extends StatelessWidget {
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

  /// Creates a Switzerland110mWidget.
  const Switzerland110mWidget({
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
      geoJson: europeSwitzerland110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
