// Generated from: assets/africa/nigeria.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/nigeria.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYy2obWRDd6ysarU1R70d2ITDZhdkPYRAexQgcySiahQn+9+HKsXF8m4HSoml19T2quufU4+rnZlm2l8eH/fbDsv1jv7v8e95/Ot3f728vh9NxezPM354f/9h+WP7aLMuy/Lxe54XX16+Gh/PpYX++HK6LXl5flu1x9/264Mvhbn8+7F4XLMv28OP0946vxs/Tc3l+/vGt4fZ0vByO++Nl2D5+Ox9ud9tf1qdXR+72p+/7y/nxdzde/P7zdP949yvMV9TT+Z/DcXd5E+/z5+39+2/LwuBFgRQ37wwObJkU/Nvzrzf/iyZgoZRIq2iCaB00BWFzjDW0QDeiDpoBiliovEczcKJEbvlmIM6Jmu/RFDKjAqOHljX22mc0dlYT6aA5eCUGT/umwIpW2uI0AJOt3GY0dfWsHpg6EyavgNEwtAJNMETOmMSrEEGV3PItISxMVvShUe6WHbACFiHnmrWrqlo9fRQYc6CtoZlosnbQCIEoOXwSbwBKhpc34bRCwia9BaCZWLR2jgjQMjJWgnVVZe/ChVqE6gxXSdJTHBGklGBOkguQClTuwTGgS6lP+RAQVYnZKkrEwJS5kvkJgpasrYpJDGHiQVPqJwRFOPeYYCgznVVXoBQR1EoJEiAPq5qYKHBFZ+8xISCYHj7JZGSLo3iraNLohFw6e0cIUWneS7FRHk0ip5wgGj8kzTI88DypeNIdERRqWJMMBRsExsTtUHiaOPakokBJIj4VY2LQFDfvxStQZWK85p86mVtbLZSBNDXsQby5WFt9mFIZc7wCVk7am8OIQZAxaOZXACWoKRcC40iUNTjhrB65CJVlJVOVGmgZwtwTH0IgodCcHAKsY77t+kekSTqVvYEXwUat3RvNW2tVemlEyC1qC5C0ZB5TBhy7WzWnu0T1oDXhiYpxL9ECRDDU57IngJUoLSYcklF1lVgiw6LmXKxqyr6mO60xDzWPAKqjq65tXQ4eWkOZgniOHV9BCw1NanUMBcIoXa1PQkzWSjGB8uDkmdbR050wm3Ce6CKzdwxmXNg778g4wFHivHUE7kgerbHn2rqZViYBAuEoqRaxAlFBxLNMEEI01FrECjgiro0VIkzZG1MEAk1lRcI4BlMmbIbKjGJzV6xx6CHrHbEZilgwJx4KSMIxWpWJIVhipQyPQ6SnWitShtBC50lyARkYok203p8wm7X7l7unzcv16+Zp8x8BMGsTKRMAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/nigeria.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaNigeria110m {
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

/// Widget for rendering the africa/nigeria.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Nigeria110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Nigeria110mWidget extends StatelessWidget {
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

  /// Creates a Nigeria110mWidget.
  const Nigeria110mWidget({
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
      geoJson: africaNigeria110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
