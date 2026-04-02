// Generated from: assets/europe/lithuania.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/lithuania.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUPW/bMBCGd/0KQrNBHO+bWYt26tChnYqgEFI1FeBIhiMPRuD/XliOjSQiClADQfHlPXpPx+NLE0I7H3d9exfaL303H/b9p2m77R/mYRrbzVn+c1l+bu/CzyaEEF6WcR24bF+E3X7a9ft5WIKu20Nox+5pCfg6zH8P3Th0t5AQ2uF5+tXhIn9frdNl/cdb4WEa52Hsx/msfT6cv9m+qqeblcd+eurn/fG9kavzb9P2+Pia6I067X8PYze/yfjyvJ1/fAsBNXJmoiSbD4pI1CQJNL8T7jf/50kUImBd8zQmAMzVPADIxFTiKQuBVfE4uoI6c4FHhoLOVTyKbo5KXuChkVqq42FESEk0l/yROSSv4qUIIg5QyhcogWmdvxTx/Pd87U9iysCe6uqBkZIYUun8QRLMrpU8EzMlW/E4uqgY19ZDJYGkdb4cxdE41dqjBNlL9ghNqLI9KCJTdlu3B0dEENW6clBk54SmKx7FnJCz1bYbC6hTkQdigFh9vShJod04oiMj1ZVXoqkzYfG4sGbFuuOnUdzRMpbaQy2Z1PIqr+emNL/OTs11vG9OzT+PZ+iFRwcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/lithuania.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeLithuania110m {
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

/// Widget for rendering the europe/lithuania.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Lithuania110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Lithuania110mWidget extends StatelessWidget {
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

  /// Creates a Lithuania110mWidget.
  const Lithuania110mWidget({
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
      geoJson: europeLithuania110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
