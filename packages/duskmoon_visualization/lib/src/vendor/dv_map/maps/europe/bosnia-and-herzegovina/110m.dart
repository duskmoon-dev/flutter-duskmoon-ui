// Generated from: assets/europe/bosnia-and-herzegovina.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/bosnia-and-herzegovina.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52VTWvcMBCG7/4VwudFaL6l3NqQkt56L6GYxFkMG3vxOoVt2P9e1skum1jQKj4IeUbzMDN+R36pnKun/batr1z9rW2m57G9Hjab9n7qhr5eHd2Pr+ZdfeV+Vs459zKvy8D5+OzYjsO2HaduDjodd67um6c54Ouw67vGNf2Du23HP+16+N31zTneubrbDb8anM9+Wdhptn+/vXTcD/3U9W0/HX03z8cE6jfv4ZzXuh2e2mncv8/qVMaPYbNfv1V9pg7jQ9c300X5r8/l/uObcxC96OqDkdGrvLPdrf5FsaAcFyDyGAJAESv5QKCSYTGhUCELIQpmWIIUuZDFwjmSxtICJSVbdp19oMhWyAIwhQyLkUIpizQGyrCilrY9BMnI4UgK+CkW5/o107hUqiKEwMueiQ8RJKayrpmPChZpKVjxQc04lMnMfAgImXLFI5GZxiKceiFOlJbKFY8AGkwLeQQRRJcfV3wIDKhl7ROfJJHaUnafq1e8SQiYHYkI0QDK8lOPlFSzY0ECwFQmZ/UsyowpN/4MSIXyU59AQTR3M6maIZaNh3lMRpaRM3lmJQ5lejGvxgkhxwsYRQvz+8//VZXbn3aH6rTeVYfqL/6sRrRbCAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/bosnia-and-herzegovina.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeBosniaAndHerzegovina110m {
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

/// Widget for rendering the europe/bosnia-and-herzegovina.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// BosniaAndHerzegovina110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class BosniaAndHerzegovina110mWidget extends StatelessWidget {
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

  /// Creates a BosniaAndHerzegovina110mWidget.
  const BosniaAndHerzegovina110mWidget({
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
      geoJson: europeBosniaAndHerzegovina110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
