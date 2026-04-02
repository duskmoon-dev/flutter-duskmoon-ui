// Generated from: assets/africa/cameroon.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/cameroon.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYTWtjVwzd+1cYr4PQ98fshoHuCqXbMhSTeoZAEgePuwhD/nt5TlKS6JUiG8zz07vHutLRka5/brbb3fnx4bD7tN39ctif/z4dvhxvbw/X55vj/e5qMX97vv1j92n7x2a73W5/Xj77wsvjF8PD6fhwOJ1vLoteH99ud/f7u8uCL/u7w+n48gMvtpsfxz/3fLH+2u7L8/3f3xquj/fnm/vD/Xmxff52urne716sT/968v1wvDucT4/v/Xh1/Lfj7eP3925cH4+nv27u9+c3G35+vb3++G27JQUtiwy9+mhhSCspl3eGr1f/h8ckJhhreMgopkM8ShJxWcHTFDevIZ5FUESu4GGaOOYQTz2pmBseQaGGUUzxyCSyVvAsWDxn+5VlVWn1fCBEpbkP4QTTwztdEMhRnIdw5GHVvStwRech+RjKTL3ltkAplrQP0cLEg+wjXMLCIOcZUxiYMoOpwwlastIQDl1KvREvIKoS00ZwBCklmC0TAVKByrNMEIRahDaeOFSS5BQNLSOjFYWDqyr7LBMIWiFhLRMBaCYWUzii5Oi0C0DJ8BqVWIExB9rKXtVEk0f6WcAi5LyGpqqFo5JICAuTpsUGGuVuo7glGCJnNMYpRFAlj4QuQTOTrBXrpcE5xShsCaFaLC1sCmLMZCP+JpQmkbWdytIiiGeSXqCo4t58EwhR41lDLIgyKmvkFcAQRR3SzbXIsokSA6ek+0zjCDhcte2UgZ3QcNYKCcLIvVOEQdgXZg8FWKwksVUDAxUn8awVLr2LRDrlFu/IyWbNa0mfJXMT4CV2gRWzTCiIRBKvxI55GR9n3hmQumgfmqBckXQmwAalWJR9poPg8ODZjOOAxGn/ETqXmu61MCSxecdgFpI1G4gN0jmkeyeAy+Qds9ZqoGhSvd0IyDLH4yx2BssMSNV4IpBG4kPvFMqwTNpml2MGStYUTiMleuwUQtjRZgqgYJYl3tshClrFLHQKaqUYrSgM1Ch8mAkFW05H2IYcB2Yvy+m5JMJNbWWgU0ytacVylDo2mgQoU7HOEmGg4li0Mrz6RYqnJUaMudIoEiSZDGfKrlBRVdZ4khDlhDqFM1V1X4Ert3Sa1YRAmTJlS2yBaS3voXcUpO6NdoSATBLD0V/BORix7bagGIvGClBYYr3LFlQx8ViM1SODV06clSzi0yIrFvM+8BBCFgnbmHmOZNQbI4GZ2WwoJoUs6XJ3OdkWTrVz+L/TZu369epp8/r5dfO0+QdyDCdSHxQAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/cameroon.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaCameroon110m {
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

/// Widget for rendering the africa/cameroon.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Cameroon110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Cameroon110mWidget extends StatelessWidget {
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

  /// Creates a Cameroon110mWidget.
  const Cameroon110mWidget({
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
      geoJson: africaCameroon110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
