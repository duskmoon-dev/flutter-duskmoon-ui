// Generated from: assets/asia/sri-lanka.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/sri-lanka.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VZy4obVxDd6ysarc2l3g/vTCCbOBDIMpggHMWIjCUzlhfG+N/DbXkc21O9cAXPQqh11WdK9Th1qvrDbln21/dvjvuny/7n4+H67v740+Xu7vjyerqc90/m8d+3j9/uny5/7JZlWT6sr49vXL++Hry5v7w53l9P600PX1+W/fnwer3h9/vT8vxw/ufw+ZZl2Z/eXv480Dx+/sujz/n2+bMvD15eztfT+Xi+zrNnb0+H/aezj58NeXW8vD5e799/bcaD3b++u7uefrvcvX/16bd+Br7c/3U6H65f/Ojb35fvv716fL0sniMtlZGePDrLYQxmgt+cvPj2qzUsYqJgCeuJCtKCjQhxswrWBdGoZ204kekGrDBr9mA1NDlKWBZ27aGKOnDpWkcxiaZr1YUwy4iFsXsvD8CCtUbFDBLqwX531u62rr76h40CCpcA8coUUHCmbjgyDUrHgakT9eLh4qbGFSyCaGT0YM08bcPadNemEwghufYtWaj2KiiBHSvfxshuUX53FvywhMwgJilrI5Bm4TRLzjKphPUka+ZjqgBwmTguxNzLm/SUDVstk00brBMwZoEAlHxukgnU8GzAIHVDr61FJM8eLIeyYtnUVMK7sELBBCWDSEBqIw+msZM/oqyfWVgWDV6asDhhy4iJqVD2rCU1Ea19kNKju4CBk/FrulMOZOk5AcKYohQM6h7cKwZcqVlLHyiTY4NIV9ipF6SC5S7lTx+s3bSEpdtZD3bKrVrhQaqpNLmWIqHq0jEikzCaZEuelEV+xQgx4W47lcmopbX/R5SnYK0pYticILgryiE8SlhBVO+Q+IRlTOaCbWMwCGizPwZEhJUhg160PFjSCjaIAThni6auTIfaTIloDg8uWYuqGJRCHL1QOVJGlPmKN+3UgwUPpIIQYyp2c25K661BwIfnpJ+eRPIkiCyYy4eGEmhzkta6KdgISkrr1WyKpVORCDY0RKnZawDm3F/UrA02Eeiw99pr5mxaOgGVsZUIU3TMFKIiYjYAco51PT2XG6JWR0pfKzsJEhY0o1Od9/gwYOQc3KqGawMi2KPTx3EwWB0wAp6LkR6oZwbUsAKJnTTAYewCVbe1IaQo1qkFnKQ4R8OyxBCjlwY43NydC91lw1DmqqYFGxiqVWew4WoE2LM2DIW0zK6E1UE9WF/XVRXXAoF0tosr6kaF+aAIZmgw+ISd0121WvM5+kkzaz3nhqgImA8xmeN6D5bWRWoFa9QLlgUlQvn7LUS8RVw4zG3mT9nGb5NUEzbqVZZP7a09msVht+G4hA0Shx6s8IY8iDn3RTa5S4jQiqqNgeKh2OOYbVRCJe7orrUpUJRbmRjCOLcKPVjmDCl4NoY4gUMPllzqsTmGxBrMHixtEGIMBVX0XsRozpr1XlclBTvPslbYnLNGOYhCTL+3YG+PPwqiiWGGadSjREADrJ5lxUimuWhsCq/EzNLaVJujbw+WVWQD1rE33UxYBNAod59Aoog99RnJovWSPzSis5aZUhkRuRL2OdiMe/ITBrvmxrNSa67W19Xn3P9WoJ7G7L09Gq6b4wo1EAA6T6XmIOZTr5So4L0m1nq+stu6+u/9w7uPu4fXF7uPu38B1BggswAhAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/sri-lanka.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaSriLanka50m {
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

/// Widget for rendering the asia/sri-lanka.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SriLanka50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SriLanka50mWidget extends StatelessWidget {
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

  /// Creates a SriLanka50mWidget.
  const SriLanka50mWidget({
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
      geoJson: asiaSriLanka50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
