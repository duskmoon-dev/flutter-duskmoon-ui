// Generated from: assets/europe/denmark.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/denmark.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE61VTW/bMAy9+1cIPhcCSZEU2es+LsOG3YdiCDq3MJbYQeocgiL/fYjbBE2iHirMB8HSE5+pR+r5uQmhnXbrrr0N7dduMW033adxuezup34c2psD/PCy/NTehl9NCCE8z+N14Lx9Btabcd1tpn4OOm4PoR0WqzngczesFpu/p4AQ2v5p/L2gGfx2tZ7m9R9nwP04TP3QDdMB+7I9fLF9RfenRB67cdVNm915Gse8v2+XU/9zXO4eX896oh43f/phMb059Mvz9v1ydj0PwaMTOijfXEHC0S0hMF1Ad5d7S7TK7iYFVoms7u7ycVaEmA6xlAu8GtEBIFdkixBVs0FJBI1gmCxxFa0joaEVeVlMCdN/l0HB3VCreKlUMY3mAKh1ygorghZocySUnCjX0RoASEmBHHM6pFuhgMecRcTKtMzZGayGlolZvciKmUAVP85qUThxyqWS5YgIAFSRrEUSFcNycxm4q1dcBotg7lnLd0EYALGiEywiQUIoaStRMGeqaTCLQkrkqWyLSplTVX+REbCVROBoCUylQtsqE2/em5198KP/E6SYMjgwlS0akSFXeikkx1RyEok5uwvXOAlG4CScSpWWmJRNU8UtQpr73RHLpQYA5BqPpqiH35yWeGX2fq/wkrqyvd9CzeXbvjmOd82++QctGiML1gkAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/denmark.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeDenmark110m {
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

/// Widget for rendering the europe/denmark.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Denmark110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Denmark110mWidget extends StatelessWidget {
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

  /// Creates a Denmark110mWidget.
  const Denmark110mWidget({
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
      geoJson: europeDenmark110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
