// Generated from: assets/africa/lesotho.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/lesotho.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52YS2tbVxCA9/4VF63dw7wf2ZVCV4UWuiyhmFRJBI5lZHVhgv97OVexcaIRZeyFuL5H59PMmTnz+nq1LJvj4/12827Z/Lq9Of572P6yv73dfjju9neb67n88fT6YfNu+etqWZbl6/p5vnH9+rpwf9jfbw/H3brp+evLsrm7+bJu+G37sD9+3r9sWJbN7mH/9w2ti3+evefT+99fL3zY3x13d9u741z7+eNh9+Fm82316UWQT9v9l+3x8Pi9GM9y/7G/ffz0Tc0X6v7wz+7u5vhK39Pf6+cf/1sWiuFsiYLXP6z8xDAQMJXxu5X31/8HTEBwoQoIHOJmXaArJZ/xKEdmCkpPwBxACcBZAs3Vow3MALEaiAnCTR4SppNXvABEx+wChTBcK6ADZNckOTAV0c9tTDlM0QyoCSRJwogSiBHi3gUmq0p5hmoWKdoEskRQnN8TyiGCmdRVmcP8gso87d82Cic41W5D9iagQ2RICcQQ7dqEWZNrN0Rj6/s1A7LVbrhKztH1Gk03tRLowQTtq+wB5GXwglPg7cYaDQAvvCZGKjtC7wxfdlXACBTRnsoxQo0KG8dwt5kYujg0uiCfa0RYzwtjOKF7ZZIYFm7ZVtgCUakGis3f6gKV5nWogJoeit0MajSzWimhBjpHV0IN5jIyTAkFBboSitcJKoahRvfexSAmKxNUDAcky174jwEhZeiabp0Z0OP5SM0wLk0SzvN0m8BgYMciP82KLCF6986Hz/xZFTUxUmb91ItcPsxAJOtgLTM/9S6yD00gljI9oZiESBdIjnIh37EhU9cmkghYpxOaeYa6XiOXov/MheTcVllI5imWQAPQ6F1kH6wWrGUtLKpTxCaQUpSr2JVDMWdJ0QXOJISlhKprJdcEQiqhlEbRTEbrqgxqyVy6jZFqtFUGxdnXlEAT6PshJHrWHY+/oQrxgQxidTEcsl7zLvBy/Z+CDG3HJk4XK/tkQGXueg2vWejcr9e+W82aleG8eVomgAmcPtMshn2wpMP5CTIMEmfjXk72wSdXK4Geb7h4HOs4oQIyamI7XMN6TCWP5gyiy+O1fi55b5iErPlkNpol0DhNuhormEotYEA2GzwfuiaT8wTKMASRuF0laUylauAaubomMTMDLF1GhSi0XSYpY+3TXeMmYKjWKOI5e2gBYwAGWj3ZszfoGjMvlbl9AhlBpduKQdqcgpTWmPOFdtmPFGUzO4GkkM0xUgzkvBSzRHJ6exfoNgd4JRDWlqAJZFShrMN0f0gTg5Pm7KRMI+LarQhjyOUjRCHptk4xJNMgy6CAFPPHmkD1GRXKsDqDllh3pmJcNosnAd8wozGxqjteef02oj/zv6qen5+erp4/3189Xf0HW1TmLZsZAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/lesotho.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaLesotho50m {
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

/// Widget for rendering the africa/lesotho.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Lesotho50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Lesotho50mWidget extends StatelessWidget {
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

  /// Creates a Lesotho50mWidget.
  const Lesotho50mWidget({
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
      geoJson: africaLesotho50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
