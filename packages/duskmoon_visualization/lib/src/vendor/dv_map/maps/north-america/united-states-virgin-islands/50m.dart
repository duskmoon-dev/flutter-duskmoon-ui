// Generated from: assets/north-america/united-states-virgin-islands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/united-states-virgin-islands.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WUwWrcMBCG734K4XNqNJJGM8qtFAo5tJSW5lJCMbvqVuCVFls5LGHfvdibXZJd+xCR+iAkzcyn0cxvPVVC1Hm/8/WtqD/7Nj/2/lPqOr/KIcX6ZjT/OW4P9a34VQkhxNM0XgdO7pNh16ed73OYgk7uQtSx3U4BP2PIfi1+5Db7QdyHfhOiuBu6Nq6HM0WIOgzpd6vGiPu7q3193P/+0rBKMYfoYx5tX1Of/4qPW9+HVVs/Ox3OSW582vrc71+neLrTl8cuh2+p22+e63A+IfXrEMfEzwU5fi/nl6vrtRAfrGnYoASHN1dG4EZrKYnhwvRw6bsAZgcAeh5MRgFTGdgZJQ3McxmVxKKEsZFKW614HmwJiyvhwDmSNA9WoNiVlvjtvauWVq+OLBGSRcdgFpJBow0W9ptQGQNmQUjgSJWCmazDBYWaUby6EEzSSlzqC6ADLgQrdGTtgpKIWboycEHz/p+SyKJVc7lQQ85ojYWXZDYEdu4Hp4ZIKYv2vZ86akgCFXeFrSK3xLUgNZaBkaWxPPciUUPTm1KofMvAGt37g9+uiWV9VpezQ3UaH6pD9Q8n+UpYkggAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/united-states-virgin-islands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaUnitedStatesVirginIslands50m {
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

/// Widget for rendering the north-america/united-states-virgin-islands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// UnitedStatesVirginIslands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class UnitedStatesVirginIslands50mWidget extends StatelessWidget {
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

  /// Creates a UnitedStatesVirginIslands50mWidget.
  const UnitedStatesVirginIslands50mWidget({
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
      geoJson: northAmericaUnitedStatesVirginIslands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
