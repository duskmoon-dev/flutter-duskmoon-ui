// Generated from: assets/south-america/paraguay.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/paraguay.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52WTUscQRCG7/srhjmbouu7ylsI5CzJKQQJg5mYBd2RdTws4n8Pjq6o0xDaPQyzXd0Pb/VbXT33m67r58PN2J92/ddxmO/245fp6mq8mLfTrj95DP95Gr7tT7ufm67ruvvluV64TF8CN/vpZtzP22XRcXrX9bvhellwNuyHy7vh8LKi6/rt7fRroCX6YzXOy/i3N4GLaTdvd+Nufox9n+7mv93n63G/vRj650kPL4Iux+l6nPeHt3KO+s+mq8Plc7ov8Gn/e7sb5ld5P/1ev7//13WfNADNOElO3oeoALp5Kfkmcn7yf2KwOK6JmBAWnMltxARELUJaI7JaFmsCWoEirCZWBQq5mLcRETyMyaoSjdm5lUhApmnINWMU2VkasyagRPSsWI1QFO0DRAst6rgmEpBkoaRWZ0JMTXxNZIgojtTuNUXa2moSKEye1liNAYuMWFtNAu4o2pi0Org7odOaqIBGzBmtRGOu5axghU1NW3M2DHSuEB2Q2DHaFZZ0zYrRDpwaGY0aDSTMC1Y1qoRkYyNTsNQQrRjtwOHBbUdaBTzCU3INNDBCD20rbhUwUspS2UUF5yTVxl0UEIoUqxzppRYxpDlrSha3SiMTUC+e+QEipWb9TBMWFGzeR6VgqZxAhuBUj0aiQiHPglHVWJC8tXoUpBSXWpdgSLVkbexkCopunBVnGNQx0xvrUcGwWFClHglM1TCllejpqVG9Yh7vfspGjQbizOiVa5CghHEpjV4bRKCWWj0SUBAqN3fHZEfV6j6WLOja2MwcwovVki7gTBbeWI7tH46b2vvx7WFzfJ5vHjb/AMNsXffpCwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/paraguay.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaParaguay110m {
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

/// Widget for rendering the south-america/paraguay.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Paraguay110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Paraguay110mWidget extends StatelessWidget {
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

  /// Creates a Paraguay110mWidget.
  const Paraguay110mWidget({
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
      geoJson: southAmericaParaguay110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
