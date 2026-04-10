// Generated from: assets/oceania/fiji.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/fiji.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VVwWojMQy9z1eYOTdGsmxL7nVhYRdKe1/KMmS9xUs6E6bTQyj595JJE9LEXqhp52BsSX7zLD/JL41S7bRZx/Zatd9jNz2P8duwWsXllIa+vdq5/+7NT+21+tUopdTLPF5unMNnx3oc1nGc0rzpEK5U23eP+w3pXzpGK9Wmp+F3Z2bPzws77e0/Th3LoZ9SH/tp57tdxq5PXfvm3h5pPMThMU7j5j2JA+ub59WU7obV5uHtpEfsYfyT+m46OfL+O52fry7XSqGAhqsL8wK9Bs9Ihs989+fBGUwO2iI5CDaPTBzAWapDhuB9EdkSBalDFu2CFxKfR/YU0NXhsnHg8oxZAxqwWJll8hat4TxjASRnsQK5rAnnnEHvPxWzoLOmtHr3tw/rnUWjcS6bM9YOrNRkjFl7BimgkiDaOlQjDgrKYWN9lSJnQjarc9HoLZk61EDGF1CNcAiVVekMY4Hrrq4qaxIFslxZeyO2RuEsmpgKoEQhVKX143L9msJZ7PoNByID2dvwGgyImIreu/iKR+h/oNVdbE5CQCZfeoAcIAtVtJDq/JavuzmfbZvDeN9sm1d39IDTWQkAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/fiji.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaFiji110m {
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

/// Widget for rendering the oceania/fiji.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Fiji110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Fiji110mWidget extends StatelessWidget {
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

  /// Creates a Fiji110mWidget.
  const Fiji110mWidget({
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
      geoJson: oceaniaFiji110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
