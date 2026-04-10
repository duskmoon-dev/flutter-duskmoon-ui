// Generated from: assets/africa/senegal.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/senegal.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WXS2sbSRDH7/oUg85OUe9HbiFkj0tgj0tYhHdiBI5kFO3BBH/3ZSaxiTO9LKXD0Oqa/lHPv1rfdtO0vz4+zPu30/63+XD95zK/P9/fz7fX4/m0v1nMn79vf92/nf7cTdM0fVuf24Pr66vh4XJ+mC/X43ro+fVp2p8OX9YDf8yn+e5w/3JgmvbHr+e/Drwaf9/sy7r/4ZXh9ny6Hk/z6brY3n2+HG8P+x/WpxdH7ubzl/l6eXztxrPfH8/3j3c/wnyhni9/H0+H60/xfv/8vP712zS9IYcgCc68+cVEAlZalv7K8Onmf4AGzmrlMgA6i2VIFyiVETgCpqN4ZheISSGmI2C4FjWBCp6BgqMcuqBYdHkSHiRDHpsncheI6lU8ijhK0aN6QIFULZdRTQwNlZpdo8ARgTQKmRMtrcsLYqrgEa+S0Zs1MSAl+q+Iy6gbsYERJbGNPIw0r/7gFSHiGIhiQl1gCXFZDYAkyKlNoEMqGauPgEZS0mxDB49Q2xaZQVLTujVxII0g33Yhg2mEU7MNDZLcQrddw2Bk5tGuiWlq+LYmDM5JgU2gQCBqbEvCYOmUTbEWYIqkHJXEYhH/ZgYZtAoNY1RjYWx2DK+zVaP0ialqm4ZirqN+UTfXaKoMgVsK0rCh3ZLbvGWslIcOKldGc0II1COrRh6GqVE2C0JgJlIxEn5SYpJ2yMXLDA94yoxhzQFhINbMGMlqlQZHu6MpMGxwn1Fw8hRt/rozpODSNxuggaB4dVVLQMVCYjtzDiglXVFQwCpj2qbQQVAFuQ20CBmploNVsnebxoDWiLcpdLAMTm4qw3ILFnffzomDeIl0hd+BGL0G0uCgZu7cLLKDumDlCEhiKN72MBADBxf/JRlkHM0cBlAaBW/FWqGoNKI5KLHcnlF529cKwWWKzRwGEDuhj4ASYtS9+bf/je1G6+fV0+75+Wn3tPsXaDYYeTUPAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/senegal.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSenegal110m {
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

/// Widget for rendering the africa/senegal.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Senegal110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Senegal110mWidget extends StatelessWidget {
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

  /// Creates a Senegal110mWidget.
  const Senegal110mWidget({
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
      geoJson: africaSenegal110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
