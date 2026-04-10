// Generated from: assets/asia/armenia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/armenia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUwWrcQAyG736KwedlkEbSSMotFHorlF5LKCZ1g2HXXrzuYQn77iVONmTjgTI+DLL+0ccvyzPPTQjtcj727V1ov/bd8nfuv0z7ff+4DNPY7l7kP6/pU3sXfjYhhPC8rtvCdfsqHOfp2M/LsBZdt4fQjt1hLbifD/04dO8FIbTDafrVpVX8tsnTmv9xIzxO4zKM/bis2mno2jft8m7jqZ8O/TKfb01cXX+f9uentybfmdP8exi75UO3r8/H+PNbCJyjgCi67T4pZFEVMgjfCA+7//HYiN03OI+cGYWtEgfEQowFXk4GCbSKJzEjAKZU4Jm7O9X5k2iODrrhMcSExiq1/kgclTfjYIiSUaDan2QgwZI/w5TMpZKH6uyymS9DdBMS8ioeR9fEBpv5MsbEhslyFY+iWFKW7ffDCJ6QiSp5KimLlvpVhgRQ1y/FLJkpc+l/EZJcd9o4MgCA5QIOQACgrl2O6uTmWjgeigSQ6sYhEQDdlEq8F+tUy0tuyFK6XRRVMFXilNzVyjxyd6zmCamX2iV0xUpejsiUE21vP4vKmADrTm/1Zd+U4mt0aa7rQ3Np/gHEjGeTkQcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/armenia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaArmenia110m {
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

/// Widget for rendering the asia/armenia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Armenia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Armenia110mWidget extends StatelessWidget {
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

  /// Creates a Armenia110mWidget.
  const Armenia110mWidget({
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
      geoJson: asiaArmenia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
