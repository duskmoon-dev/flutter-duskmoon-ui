// Generated from: assets/africa/rwanda.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/rwanda.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52UTWvCQBCG7/kVS842ZD52d9abFHouvfRQpASNEtBE4pYi4n8viUbUbAvbHJbJvDMPM7OTHBOlUn/YlelUpS9l4b/a8rnZbMqFr5o6nXTy6uzep1P1kSil1LE/x4l9eC/s2mZXtr7qk4ZwpdK62PYJb99FvSyu8Uql1b75LLDX3kd+Ovtnt8KiqX1Vl7XvtNmqrRZFelFP1zrWZbMtfXu4r2Io+7XZHNaXLq/Upl1WdeFv2j0/t/bjm1KUZwwOcnaTB+UJMiA22sGdMJ/8yUOXCYIGMQEeMxEiR/K0dWwMBnjEQEAYyUMHIkYCPIN5rrXE8jQL8ZiHWTeI2OkBWLYyvg3M0CECxHabIzs0HOAJOdTWRfIMIVgDAZ4DK9rGTs+RkA61SywsJgrXLbNxxtJ4+TBjINH8L94vNIpkWS2UB29WLOo8FidggILfrXHigKM2L/4/kITswTolwzlPTskPATAKLq0FAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/rwanda.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaRwanda110m {
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

/// Widget for rendering the africa/rwanda.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Rwanda110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Rwanda110mWidget extends StatelessWidget {
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

  /// Creates a Rwanda110mWidget.
  const Rwanda110mWidget({
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
      geoJson: africaRwanda110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
