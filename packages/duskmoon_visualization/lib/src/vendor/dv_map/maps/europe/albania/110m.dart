// Generated from: assets/europe/albania.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/albania.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52VwW7bMAyG73kKwedA+EmJotjbNmynHXYfiiHr3MJAagepewiKvPtgpwnSyh2g+SDIpPn5p0jTLyvnmvGwa5sb13xrN+Pzvv0ybLft3dgNfbOe3Pcn81Nz436unHPuZV7LwPnx2bHbD7t2P3Zz0Plx55p+8zgHfNr+3vTd5hLgXNM9Db82PDu/F/Zwsn++dtwN/dj1bT9Ovq/P0xubV+/xIuShHR7bcX94K+Os+8ewPTy8pnmhDvs/Xb8Zr/I9Xdf793fOMXkwEBHW7zwRPkdW1jf22/W/cfAJQpmswJFHTswpVPJiCqRCCzwhQbZKnBg4alzAZZGIyP/DS/IRr14fs5U09kyaa0vBOajEJVpgsJhU8qDQBZjkXFdVMp9BiUJZBvYCwEKVNDKvIUNoiZdyngpeyQuIMaey69iTiUahWp6SpsxLbaIqgqrSXnj5A17U2vOTCLCWQ4C8kllOtflGBIm2pC/CJEl1vmSQXE4VeGXlgHp9CQvlgGeBaqhtF0sAqPg4gnkjASTX8jIAFO0czCeLZnX6GH4SQVIc38TjaKbVQ34ClvoiPBGAVJXvxNNolsp2gY8hmlntFJ1Csi21i0wnW3d8tb/I1dL+vDuuzuvt6rj6CwvcgivICAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/albania.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeAlbania110m {
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

/// Widget for rendering the europe/albania.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Albania110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Albania110mWidget extends StatelessWidget {
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

  /// Creates a Albania110mWidget.
  const Albania110mWidget({
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
      geoJson: europeAlbania110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
