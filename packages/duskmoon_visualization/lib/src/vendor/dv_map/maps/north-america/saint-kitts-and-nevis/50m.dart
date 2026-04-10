// Generated from: assets/north-america/saint-kitts-and-nevis.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/saint-kitts-and-nevis.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51UTWsjMQy9z68wc+4WWbIsu7eysJfSsLDHpSxD6u0aknGYuIVQ8t+XmTQhTTyHeg7G+nrWSE96b5Rq824T2jvV/ghdfh3C97RahWWOqW9vRvPfg3rb3qnfjVJKvU/ndeDkPhk2Q9qEIccp6OiuVNt36yngVxf7rB5izlvV9c9qEd7i9hSuVBu36U+Ho+vD4kpPB/39uWGZ+hz70OfRtkhD/qfu12GIy679cNqfsnsJaR3ysPuc2/FnHl9XOf5Mq93LRwFOL6ThOfZdPqvE4Tu/X0rXslLfLN4yIaK1N1dGLbcatRO+sDxdus7hGi1eyrgCWgtWAosRKOMiaEA2dbhWMzrCcsLea9S6EhiNB6SZCnt23lVWwqFB7cvAAOzY1/buq5xo5qRPL9bw0xJYa3S53+S9h0oeWQOMUm4LWiQwUgksLE6XiYQevK5st2gSnGE+MaHoylEVbyy6Mo8MIDup5JFDAQZXzthZg1xZCkfegCn3jiwTVXLCGTDiuIw7rh2g2oSd1+WBIvLIUssJYSYpTwfBuM8qcQEBZijsLBDXDh1b4+emGY3RpnbJfn1NzO+s5vK2b47nU7Nv/gO/NcHsrAgAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/saint-kitts-and-nevis.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaSaintKittsAndNevis50m {
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

/// Widget for rendering the north-america/saint-kitts-and-nevis.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SaintKittsAndNevis50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SaintKittsAndNevis50mWidget extends StatelessWidget {
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

  /// Creates a SaintKittsAndNevis50mWidget.
  const SaintKittsAndNevis50mWidget({
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
      geoJson: northAmericaSaintKittsAndNevis50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
