// Generated from: assets/europe/austria.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/austria.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWTWsbMRCG7/4Vi89hmO+P3Eppzz20pxKKad1gSOzgbA6h5L8Xu0louoIyexBazerZGb2jkX6tpmk9P95t15fT+uN2Mz8ct+8PNzfb7/PusF9fnMw//wzfry+nr6tpmqZf53Y58fz52XB3PNxtj/PuPOnl82la7ze35wnvHu7n427zOmGa1rv7w7cNn42fF+NyHv/yxvD9sJ93++1+Ptk+PJz+uH62Pr06cr093G7n4+NbN178/nS4ebx+DvOVejj+2O0381/x/nn+7v/7Nk3kUFHunhf/WDSBWLTizfjVxf9wGVXJNcBpIJJIk1eOnEkDnpVXcpenVZwcA16kJWYTh1yuISOcSFa1cAZsomS+wBWgFIZyi6dQSKqhA/fKVZF64SqIZFaMVs/MBK2nhoCVldqIlxEU1Fs/AVYRG8ar5ETai5chUwl5tDk4i9R6PAFkS6NlugS4hKVY078S9kEyB6iHq3kT54xhNeJ5sGR0eaQkFjbgBQqmaItHoOxKS3UDjCXce7sDwVQNhzh3qeriFBlTlskSIMia0SqlBVmOPqh8AZZI5a3cK7BSZh/i2NCSejgXLqFhsBqO1Fq8Ao0qr1GmnPZf07cSVs2lsA7FGE3cSVjlQFo655Alpt6regSoaWbLM9IhjMSyVwUIyDU5RrxSsqhuVSETzJG0RCYlvX3BIOGaxqNwPcyqJ4dAomvYSA7DEvQeT0+prEHLQ9dBhZKiJ68BSWDRSA63DOTulQqJTvVoxEtxwi6PkblypEcaS/aKvIOJssdy+QK0nKKnhoMoWuroiAziwuaVwKFQwnRU94I0vXlGdu/Lq1H/pfe0emmvVk+r38uQn27VDAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/austria.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeAustria110m {
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

/// Widget for rendering the europe/austria.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Austria110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Austria110mWidget extends StatelessWidget {
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

  /// Creates a Austria110mWidget.
  const Austria110mWidget({
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
      geoJson: europeAustria110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
