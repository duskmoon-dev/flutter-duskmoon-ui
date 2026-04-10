// Generated from: assets/europe/slovakia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/slovakia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWS2sbQQzH7/4Ui89h0PuRa2kvvRQKvZRQTLsNpo43OJtCCPnuZZ0HSTwU5MMyO1r9/NeMRqP71TCs57vrcX0+rD+Nm/n2MH6Ydrvx57yd9uuzxfz7cfpmfT58Xw3DMNwfn6eOx8+PhuvDdD0e5u3R6fnzYVjvN1dHh6+76e/mz3bz4jEM6+3N9GNDR+vnk3k+zn97Y/g57eftftzPi+3j7fKX6yfrw4uSy3G6GufD3Vsdz8K/TLu7y6c4X6jT4dd2v5lfBfz4ez1+/zYMRE01kN3O3lkkG4Q6x5v5i7P/47AZeEBgBycOCM4lHrQIT1Xp8JjCnao8QQ1O7eljFGWp8DBbkAJRdHiEjqRVHhMsbh2eOqrXcNESUl168oQ1RLPIC2UUoR4vjShL6YLRVCUdu+mSClhcvmicmcm95WNUANAiDx0ko8cjR0Wpxosg6d10AeEMrunzlsiKeHp6o2WaJNX0eYswiU6+LJnE4kpFnooCeAcXAIC17POGgBmSPRxaWtR41tKAolOsomlaRq24oLXwzKCePnEA5CovPc2stxtILOnF5ZMI8Y48b2EuZlhNFnVkOk0+b64hVNyOaJam2NcXkMq1eKO5O1A3mSHQLWrbkQ1d2Lrph4jsxXizmSEb9w4vmRlKleeW4t3TRkCWWNpfgkacoHJ690ZjcjUvFYPl7nVWO707oqlRlCrf0hgAUva0GXGo1GLFFk7E1o0VMx1qfRAtzZNB9HhCRCa1voUaBYRgt/SRclJtL6pt36o3fh49rJ6fF6uH1T9R0NGynQsAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/slovakia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeSlovakia110m {
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

/// Widget for rendering the europe/slovakia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Slovakia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Slovakia110mWidget extends StatelessWidget {
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

  /// Creates a Slovakia110mWidget.
  const Slovakia110mWidget({
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
      geoJson: europeSlovakia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
