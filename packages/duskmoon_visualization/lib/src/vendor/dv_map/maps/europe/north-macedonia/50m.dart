// Generated from: assets/europe/north-macedonia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/north-macedonia.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52ZS2sbSRDH7/oUg86mqfcj131clix7X8JiEiUrcCSjKAcT/N2XHsXGiSosFR/EaGb65+quR/+r9WWzLNvzw/1u+2rZ/r67PX8+7X453t3t3p73x8P2Zj5+f7n9aftq+XuzLMvyZf28Hri+vj64Px3vd6fzfh309PqybA+3H9cBfx5P53+X17dvd++Oh/3t88Bl2e4/Hf+5pfnS6z+u7vPl/q8vH7w9Hs77w+5wns9++zz/8/br08dngz7sjh9359PDt+Y82f/X8e7hw9fpPlOPp3f7w+35xbwvfy+vv/+2LIRDjfTmu9tCg8QVMr558Obm/2EQnFHzTI2aPI5UhZKHGSRtHqNzcMHDcNTo8ihdNaziMYAHdnlhRogVD4ATrMtTY3EveJCpiN7lgYFKxUOarurOF4UkoIo/dG2yQHOGWMma1vVsg+EeWKYGOIJIdnG6OrDiYbCmdHkiKAUPR4JQWtu+Yq44wllZe2kBw1KSMCueckD0whiGeigWrsWx5gt056qXUfV8LbBtn3IVKtM8muvXxYGi63XVw+FgktKNZEUzwGr5jBwUelV+5f1g+dTFVbvumGNCS54KQtsdImFM1fop/UwlkCSOksc5c7CbHhIOiNdVdO5PBtGtBBKRJpV55GTgXZ6ahxebEA4kD24XAxRRrnAQDGpd75rWexAOMDTLduGDJPdrTQAjKdj6+4ZAEJQ8UHLuuiMcCAv3wkj0xPZ8k1nSrv0x7ZtlrIubqcuVeVNRcTtc0oTUS55kAnFXYlQkNdQ+SWqxByOMkaUrlpnYuRA/k+fI0RVnAmuxLB3r6N7maZqVcQdsyN3lU1cPrPIiLFK0yzNy5Szdm8bsvbzA4T5VC1XzVRDOrh5Nqnk4EFwIu/Zl8pSJFY8htefd2aBEmJfmyVqnurwQcarKMmqYUK/M0yB2S70Ol8lb5VGTJ2s/VvKIOZrZRkOStd6GEEOhKYJo2CWpan9gaC/8aPjsrGr7Lmq6y1OdC1iJFqTZjHR5sQZgKYLW3r7JC6238cnztginkWhQ9xzMRp7d/EhKC6+aBFZD6NunKLXqM1i3txaPB0wpJpV/HS2lKVsm70fx7Jwh3M23nFKnLKeu/d2NRgrPTafizZOvPg+mHKviOVgJmkcjNGJtRKtyn8nWjxdPg0qn0QBSC+7WAwtikmt/0DyImTtSk6dBXsncefQl0Qy/WZ7n8WBlHppCNNUBDRYBqQ4OGXl2X13cPIcsWkoaTOgUXe+Sr418xZOMfvUjTpeiSaDBGqjSVgdiVmXHnG/XNpjpVM8VxPq6Ob0WktM2AGv24+v5W6nDJ4/AoSt0Qxmo2NnmfOdpe9e+WDeO68oyee0GcC3nZcNGg8ydpHtmbRhkxenI/A2BfqIt6vzAsamun64eN0+fbzaPm/8ALoSMG4waAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/north-macedonia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeNorthMacedonia50m {
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

/// Widget for rendering the europe/north-macedonia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// NorthMacedonia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class NorthMacedonia50mWidget extends StatelessWidget {
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

  /// Creates a NorthMacedonia50mWidget.
  const NorthMacedonia50mWidget({
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
      geoJson: europeNorthMacedonia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
