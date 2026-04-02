// Generated from: assets/africa/somalia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/somalia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WWTWvcQAyG7/srjM+pkDSSRsqtFHorLfRYQllSJyxs1mHjHkLIfy/ezYZkx1BUqA9mPPI86GvemadV1/XT4/3QX3b952E9/d4Pn8btdrieNuOuv5jNN8fph/6y+7Hquq57OrzbhYffD4b7/Xg/7KfNYdHp967rd+u7w4Lv4916u1m/Lui6fvMw/lzzwfi1mS/H+S9vDdfjbtrsht002z7e7DfX6/7F+vzqyO0w3g3T/vG9Gye/v43bx9uXMF+p4/7XZree3sR7fN6Oz7+6TgjUlcrF2fwHAvPC+m766uJvLCcMXWCJmNQUiwGFtDYshKAgS7EKUNFoWAgczCmSAJpTEyEBKntJoRTUSsQ5ao5bay4+AzWp1qJclSOFqlAFa+OVAFNIiuSgIdqkSqGUIEqhAkS5KZ+Bo1gqU4qAFYPPUQ7oVFP1UwRVLk2mAii8plKlCF6EvOkqBK5RUx2qNPdPoQWWCaZ64YAibaSBCMhMUyVUAirFmxoSQRWnlMzMLKKmhsSALJbNfC2MyyzKZQuB1WtbRAKroTnxC6js1rpFoNVzGzqArbbaQARSsOQkyyHEGWUpSCG05Bb6LzxG1KXElRA2y+mOQxSXWOg1hHAunNvnRx4XXhCNqEUR/8E94vbAnfWSquQaxUHcatHGOQcv1dhyJ2WF6iFLSou5ogqElaZ/FRAp6VIBM2w1SCC0au6mw1AtbAHFyprLOwOxWyPYAlyEcqmi+cBHb9W/QJAH5RRN5iYnbLqLobpoLvUIEe0dE8HVkxeU1H11tTQ+jZ5Xp/fV6nn1BxRV4kdSDAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/somalia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSomalia110m {
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

/// Widget for rendering the africa/somalia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Somalia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Somalia110mWidget extends StatelessWidget {
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

  /// Creates a Somalia110mWidget.
  const Somalia110mWidget({
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
      geoJson: africaSomalia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
