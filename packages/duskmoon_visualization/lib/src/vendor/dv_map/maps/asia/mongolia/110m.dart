// Generated from: assets/asia/mongolia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/mongolia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYS2sjRxC++1cMOpui3o+9hUBySsg9LEFsFCPwSsZWDmbxfw8tr83udhMoHYbR9MxHVX/1+Kq/3Gzb7vL8cNh92Ha/HPaXfx8PP5/v7w+fLsfzaXc7lv95ffy0+7D9ebNt2/blep0/vL5+XXh4PD8cHi/H60dvr2/b7rT/fP3gt/Pp7nx/3L9/sW2749P5rz1fV3+fnsvr81+/Xfh0Pl2Op8PpMtZ+ejrud1/XXt7tuDucPx8uj8/fW/Fm9h/n++e7r16+Y54f/z6e9pdv3H39fXv/479ty4AwYle5/WFFC7iCKr97/vH2/+ESkCSFeYJLsCp17uKlKVfEAg+9MCk6eIXAicnmE16Al5gWNfEqMLF0wnPITFLv4llaeM50GARVUBuv1Exq9teA0zFEWngMJJKFucAjMgxvwQloDhtmehUqTIN77ip4ZnGu8MRYhKqFZyDoGTbTq8BKItjFC2c1rQlPQKhUi1t4DqIlZTMdDMHmYj16A9QoLGZ/GUIzs3rpVmBkSWELPGP1IuvgESKkWrqtAN0lUbUHSJAiqLjy2EgzWhtIOHhkjkUCExSGerYYJlQwZk6aQ2YApqi3KBmA5VolK0CrUKxWDhM6EJfQoqaOaqHC0bQwIFQjeAWoSSOkeoAFrGLrNLGRdt5jmRCUmFBmlhkyiEV6e0g09tBz0TcFFD2lF9ZEkFyWMXssECpE2QZ0j5CYPVbAEIomJ0QgmhI+h6GCWqj2OvvV5RBBp1VrQsaopssMKo7Oc60xQCJXa5IsoC6FvupOiZklrW5HpKCOIjQDGohUkjdJMag0LF+5HBwsvXJNDkGRKznjIJmM3OQkQJkCaQXowSHcashECRkqvCgNDok20rwHWKMPsdcc1w5e3GWkIIKTF9U6ADXRsgmYkO4WC8E/ym5gM6aHDFdSXgt0D8FmyARwmeFCggyFHoE9hT5iUDDLFhYGpIkSNgENQjllaWGwm2rTZQNN41zNTCQmyU1OHKgocdFMajRkq2xvoUcm4hyENaYcE2qm8dVjr4WurpF1FE3ZRUPUMGFNaWwIpMjaB5Sh1OdKaAisKcjN9sSQFSE1h2GBqZhbuyNbEsuSFImortIkBHdGwrn4j7BB4mbYYMHYea1VHHJxebM2YIKGkS9ESAEnm/aVZvoYT1Z7GCWB1nT5OvUn6uTyCJtQ7mprg0y3oilRDIcuROoNjEP9O9Pc7a7mmTTBBDzcdE5jQ8Cs8t5pBSEDm+XEhiEYYVNuIQO68SQHjYCtml1kDJ5ZmvOcaARGntbTv1VQSbE4KDMCF0XsjSQ12jppzclrDKgh3juYCUi2kEU9JUDCKusdVCSwUDityqkyD3+b9rFVzANijQ7cKytlkKNFLLAqQnt2KSRZaU0VamTEGIab520KpGHuy/xPtC6vAoS6yAkELetp52Jg0aAlp4lDpnfPZoPEfdZVhiBCSdQ+O0Yz91naF2igcc++9lH5zer+7e7l5u368ebl5j/APd4uzxgAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/mongolia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaMongolia110m {
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

/// Widget for rendering the asia/mongolia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Mongolia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Mongolia110mWidget extends StatelessWidget {
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

  /// Creates a Mongolia110mWidget.
  const Mongolia110mWidget({
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
      geoJson: asiaMongolia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
