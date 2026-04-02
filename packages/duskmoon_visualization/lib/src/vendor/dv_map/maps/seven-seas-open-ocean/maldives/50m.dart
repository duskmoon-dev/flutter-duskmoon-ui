// Generated from: assets/seven-seas-open-ocean/maldives.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for seven-seas-open-ocean/maldives.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52US2vcMBCA7/4VwqcWgtE8NJJybektUCj0UkIxGzUYHGuxncAS9r+XdbJLdq09ZHQQ0jw+jUajea2MqefdNtW3pv6R2vl5TN9y36fN3OWhvjmo/72Jp/rW/KmMMeZ1mdeOi/mi2I55m8a5W5yO5sbUQ/u0ONy1/UP3kqaThzF1N+W/LS7a3ys5LfLvZ4pNHuZuSMN80P1KL2kwU2on8yVv02DyJrXD1/rdfH8K7THlpzSPu/PAjje5e+7n7mfud4/vtz+dlceHbmjnD2l4Gx/Xl7v13hhPDYOIBblZ6ahBAnQX8vtLwzKUOIqNRaizwKLEMnpPXMR6JhDWYRdqGRtiYPI6rAUn6MrY4CXqkkDhem49UBBdtBTQElARy8KBdbml6A5VVMRipMjKSvhk1VbXdmfHKb6PA0Tr13FwA8LO2aC6noNoufAW3ECQIA51VESQUKIigCU11QOHwu/hwwtL8LoXdhgIbTEHyERglVjw5RZywHpxokyCZSjWIzdILBBBV+aRPUoZC5Y56qLlAODwSn0FINZVLXuyLIXOxA146y0pk+CDAJWjdSGSU7aQyAEZy1gH3mm/7icbwvXWVF2u9tVxvq/21X8EJVLQLwkAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for seven-seas-open-ocean/maldives.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get sevenSeasOpenOceanMaldives50m {
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

/// Widget for rendering the seven-seas-open-ocean/maldives.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Maldives50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Maldives50mWidget extends StatelessWidget {
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

  /// Creates a Maldives50mWidget.
  const Maldives50mWidget({
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
      geoJson: sevenSeasOpenOceanMaldives50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
