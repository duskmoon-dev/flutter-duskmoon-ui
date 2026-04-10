// Generated from: assets/europe/faroe-islands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/faroe-islands.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VYy2rcWBDd91eIXmdEvR/ZDhPIYphhtkMYmkQJDZ2WacsLE/zvg+TYxPa9Cxe4F01LVzp9VPfUqSr92A3Dfrm9mvbvh/2H6bDcXKbf59Np+rwc5/P+3br89f709f798O9uGIbhx/b98sbt8m3h6jJfTZfluN30cPkw7M+H7/c3HC7zNHy8Ph3OX64fbxuG/fF6/u9A2yV/vTjP2/l/nix8ns/L8Tydl3Xtj5v1f/c/V+8e6Xyb5u/Tcrl9SuaB/Z83p+X493y6/fbziR+h58uX4/mw/PLo959ffz8/enk8DL/ZaMSYLO9erBmOAZrqz1Y+Pb+0A6vBgG1YMoeswRohZIetoZtbCdcT3FHbuKlsyCXcEPS0bOImsGMxDhHiptbhm0iINVzjNIlOfIlUi3w50YDauLLFvrZvJqTe4YvKTDWZOaC1o+sWplRTgwm5d3LNLRihFoXX5/Cud/TkDyt2kilGbcGLiFHUBOTAih3BS2qK17bEBcGknfjKxl6zPxcw6qA6KHjUYB0As4Mbwl7TTwSaQDu4BuRRTKMETYh21htDVPWeLGHMHVxhsiJfSuqYnwElZU0MEYHcwVXejLyqhlVJ7ZxQIrFaEXBgIG+HV9YaqzX1mqeFt9UrKAxWi0PBc97I/3zE2OpDgwuNyFl8Rh+Jdd2UNq4iEVS06SOzrU1Th2+YY8WvfRQiA2+VJBpRgGqW4iN7ImCbL7gESC0OpJLcwxVDodq+oSdns76suACclRz1EdE6jeXGN2oW6COYYmiHrzMJFXHTEbM1D9CIAMpejMPr8+3tep+1gZN2jhJ5RLXZB17nnjauaZrV/Dg1TKiteUYjzQruqnlCa5UlGim0OFL6CMjq0t5qSM6U4syzarPJF8d0F0GplVFSTG2X0VQUk2ITiCIgHVyTdc4q8iXVaHeBmcB1+aZ4p3RBgGBWZ0q3dnxXPahgMQ4hoO32h0bEpChZlY1BvHboPatCLL5jcItI6+GiVPPC0oR7pSCFufguwFTXzr+XxwZcnIJfb79vVgoErM/l3nZLzyjOIJ2yT4mRUoudqmhk27NZ1ayoIVUChU4t8ECq0u1bCpEoYm1S09Xsm4MwjQRqqDVLURKHTvOeHopFNSiH9prs7TVVrXIV1NvPpN3zX3e7h+9Pu7vd/wrE8qjpFwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/faroe-islands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeFaroeIslands50m {
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

/// Widget for rendering the europe/faroe-islands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// FaroeIslands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class FaroeIslands50mWidget extends StatelessWidget {
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

  /// Creates a FaroeIslands50mWidget.
  const FaroeIslands50mWidget({
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
      geoJson: europeFaroeIslands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
