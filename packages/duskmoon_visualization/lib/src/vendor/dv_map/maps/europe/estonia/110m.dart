// Generated from: assets/europe/estonia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/estonia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52UTWvcMBCG7/4VwudFaD40H7mG9FxobyUUk7rBsLEXr3NYwv73sk522cQORPVBSPNqHr+DpHmpQqinw66tb0L9rW2m57G9Hbbb9mHqhr7enOS/r+F9fRN+VSGE8DKPy8R5+yzsxmHXjlM3J523h1D3zdOccLefhr5rLgkh1N1++N3gLN4t4jTHf/y8Fh6Gfur6tp9m7fn0x/pNPV6MPLbDUzuNh/c2zr6/D9vD41uZF+ow/un6Zrqq9/W7nn9chYAa3QBQfPNByR5ZMynRO+F+8xUeMHzCM4MinkRnB8q2xuNsqdBfjiYM5mv+BCB54iIeR0mMwLTmT7JlsiIeRSJXz7zCA1PkVFYvRUbJkpb1WhRAzVRabxIAt6U/i5iVlKWQx2iOurx/FsmIodgfAZqgLHga1YmRyvzlCMLZKa/wXBNkLcRJQkuuKzhjzWhl10UiC2XC5fXTyCpkVuZPI5qB8fK5nXic0UrbgYKIrTzf03GAuZe1A42MCZaHYVGRC8/CIhCI+9rTpZQMc6m3uZV+1kj/h/X1tlytzc+zY3Ue76tj9Q8MvRyGPQcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/estonia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeEstonia110m {
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

/// Widget for rendering the europe/estonia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Estonia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Estonia110mWidget extends StatelessWidget {
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

  /// Creates a Estonia110mWidget.
  const Estonia110mWidget({
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
      geoJson: europeEstonia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
