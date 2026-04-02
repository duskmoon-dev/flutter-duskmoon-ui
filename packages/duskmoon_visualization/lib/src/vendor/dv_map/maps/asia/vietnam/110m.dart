// Generated from: assets/asia/vietnam.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/vietnam.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52Xy2ocWQyG9/0URa+N0P2SXRiY3YSsZhNCaDI1ocHuNu2ahQl+96HasXFyCgZNL4rqUp0PSef8kur7bpr2y+P9vH837X+fD8s/l/m38+3t/HU5nk/7m9X89/Pjh/276dNumqbp+/U6Lry+fjXcX87382U5Xhe9vD5N+9Ph7rrgz+O8nA53rwumaX98OH858NX4YXguz8//eGv4ej4tx9N8Wlbb+4fjYf/D9vTqxrf5fDcvl8efnXjx+uP59vHbjyBfmefLX8fTYXkT7fPv7f2v/6aJUEFERTRvBhNouqnET4bPN/8BNMBwRvJfgQVFqYXW4ylEGaXxyGMllJSuf2TJLkPACVYVVt7jOSgaEcfonwmmVDN/AcxYnEP+CEFcNbXHSxB3koFGgJjC2Ay3gBFJrDaA7p5W3AWKGHuNB1BA2ZG7G5yQEYQ+JtCAw726ISewl5bRAHTAqFBuehggTmUyeujgFWreP4PsST7mMAFRiamrEXdGtNHBArQkt+YmG+TqHg8ipoIwRutWBYcgwzFgRvDyNGyqLgENKXHQCROYsURVd49RRYd4mSCJsrKJczAPDtEByMCUjNoGBpuijAEzRCl7NIG2BsYaY8gMFZ7FzcJlIFyMNYYsIMbo0pSdgoan5VYOk4oMmzIRMFQjHWSy5hAl2jpel3nVKJMrMNdG2AVSoIqNOmFQ1zBpA8M0y7d04mEk0awMAoySTkNxZYRwN+cmUEHFEHHcZYSwDJE2MJktZGjwVJDprpRdIKVIxthCC5zVPdvnMMtNtooru1EXZ4ClVqNOKNcWX6HNY21QbOEb1T9A04SsXf3NHHEjgw6Oyt0ZKUCIAzeGGoPCtPaQGWCuxuPQus4gyBTdQxggycFhA1BXoCq2+5OT2sbYL2BiJt0GGqBFOvZPYhAJRvsf7QTXxrsxZ5qHkzYddGAtH3EI5bT25K5/VFU07gdCZglWuyg0v8N2W/cvd0+7l+vn3dPuXwRTe1ctDwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/vietnam.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaVietnam110m {
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

/// Widget for rendering the asia/vietnam.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Vietnam110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Vietnam110mWidget extends StatelessWidget {
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

  /// Creates a Vietnam110mWidget.
  const Vietnam110mWidget({
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
      geoJson: asiaVietnam110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
