// Generated from: assets/europe/north-macedonia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/north-macedonia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52UTW/bMAyG7/4Vgs+BwA9RlHrdx2XosPtQDEbqdgZSK3DVQ1Dkvw92miCttQGaDwLNl3xMWpReG2PafNj37Y1pv/Zdfpn6T2m367d5SGO7meWHk/u5vTE/G2OMeV3WdeISvgj7Ke37KQ9L0jncmHbsnpaE72nKv81tt+3v0zh0l0Rj2uE5/epoDrr9tvLzyf/5WtimMQ9jP+ZZ+/Iyf7l9U4+Xgh779NTn6fC+nHP9P9Lu8PjW7oWapvth7PJV36fn2v74ZgyR5QBCEjYfFEeWCUiivBPuNv/moY2oUKQBe1fJEvWefQFGTohcLY6FtAQDH6pIYNUTluoCweBrWaiMKxba4BSxkiURyHkp0UQchPg/PHV/4zmq5DnPqFLqVlDqy/Pz/8ZYwEHwRJ4rBwQIwAGveGCDIyWtxHl16GE9J2AjI6mrO1rzdAmrrnlo0cXgpW6KyUpUhlDaXWRwQet2l6x61PUBQzvDKlFRiFWpBGONkesmhWwIyMql4mKMFKtbrbw1m5J9to7Neb1rjs0fYiXcwOQGAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/north-macedonia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeNorthMacedonia110m {
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

/// Widget for rendering the europe/north-macedonia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// NorthMacedonia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class NorthMacedonia110mWidget extends StatelessWidget {
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

  /// Creates a NorthMacedonia110mWidget.
  const NorthMacedonia110mWidget({
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
      geoJson: europeNorthMacedonia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
