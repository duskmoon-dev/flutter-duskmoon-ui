// Generated from: assets/oceania/samoa.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/samoa.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52VwWrcQAyG736KwefUSBpJI+Va6C20kEMPJRSTusGwscPGOSxh373sJhuSjedQ+WA8o5nPv6XR7+cmpXbZPQztZWq/Df3ytB2+zpvNcLuM89ReHMJ/X6Yf28v0q0kppefj/fPG4/Jj4GE7PwzbZTxuOi1PqZ36++OG6/5+7t+Wp9SOj/Pvng6hn9ef5vPL/NX7wO08LeM0TMsh9v126Kexb1/D+zcdd8N8Pyzb3UcVJ9lXT5tl/DFvdnevn/rGnrd/xqlf3n3zy/X++Xz0eZzSFyzU5ZzZFS9WorljFcrMZ7Gb88UVtCCYWamgjQxJgmhVVzJfRwvlAzyILsUERSto1OLqUTQzOFoFXawgRNEqVswrZVRmI6ZoGbOoZ15HF0d1j6LZWAhlHW0A6JKD6JzBxGuqCxcoQTIRuyDVRDPFDwgWNZFKPtRY1cKiUXKuiBZxKRDP9P87SFMbfXhpwNCwY2EEXO1f7oCVLWho2DG7KKyWhzsgYg32L3asmEvFKr0UzRo7rtgJqBlXTMfZHShWeexEhclrqjmDajTVCtlBa01WHKOmg52JoXCu9W9BsmgV3dg019DEjBz9LQGLuVX8zCSumjogg1LLtYNalnBCEB151Ru4A0BVCJdRc1GvNSMQCMTMErtCRkSr5/pgIYVUNNrnAXeqm2Vz/rRvTvebZt/8A8+Lg+ZACwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/samoa.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaSamoa50m {
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

/// Widget for rendering the oceania/samoa.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Samoa50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Samoa50mWidget extends StatelessWidget {
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

  /// Creates a Samoa50mWidget.
  const Samoa50mWidget({
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
      geoJson: oceaniaSamoa50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
