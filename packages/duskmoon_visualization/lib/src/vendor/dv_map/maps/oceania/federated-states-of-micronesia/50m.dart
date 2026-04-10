// Generated from: assets/oceania/federated-states-of-micronesia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/federated-states-of-micronesia.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WXTWvcSBCG7/MrxJxD09X1nevC3kwCOS5hGWwlDDgjM1YOJvi/L92xzdpTc5gKnoOQ1OpnSqX3rer+tZmm7fpwN28/Ttu/59368zj/tdzeztfrfjlsP/Thb79v328/Tv9spmmafo3j6cTx+Bi4Oy5383Hdj0nPj0/T9rD78TThZj7u1vlm+rLu1vl+Wr5NV/vr43KY7/e7F840bff3y7+7NuZcndzHcf/Lq4Hr5bDuD/Nh7WOfrufdYb/bPg0/vgT4fV5+zOvx4XV4z+9z9fN23X9ebh++P+Xghb0cb/aHHvFLMn7//n/+9ur0eppAWnHDVhE+nAxywcaKjd6MfH376Bku21kucq1uSW6D6mghF9TBPct1sxZza1WDluQ6EmuEbaqNBJLYiz/b5tzVq3+8WEJoBaiJcpA6L1yrGEriHTvXGoNzzFVUzGEbICu1EEvaQDLKHOGyocdpcESonOSSuLZAQl7YkB01yQUxpzi9XME5md9qXNkk4pITW81IvnMFHCiQvBciVs4YdGC1WvzZCLxSMguXm+KdDMpQhFQZ/TQWLUgjq4l37FyuZIYhV5oRZJw04sUmECheC6o3ymKbk7fA+FrQKzXPGKlzK4tEwtSCZtpqksveTCHm/kkaRjcLfN+xjF4z5XpwqbnEKmNtTZJcVq6usRoYECypXu5lVYI61V3BXDWZX9bRm0MuWjXOrFB6ftGJo5bfuWONknXbpdXh/SqVGRBxmDsaC55MkWcoDo3PaIgYjTWpIYfKFGuepAJLMl4z6K095o5+leQKI4YVkERAWqY1dyy7S43D5eRKbWDZo7VzFwOoaTZaocYatGYto2lnjXS5eN/LSFYQyCjaJkkxQFFIFSErWB016B1SjEnQUq3OCiLFApJijiCU+tRWmpM0C7nOUJVS/uxrfQGMdotSXFWRUvXECiCpcNCTpDiRtXS8TQUlsJIUr3/w3UBqvOeR0nfT0DJ7npFfRDcKuRWaeJLbWJgCh0pRh16vk/K92G3nnb95e/a4eT5+3Txu/gP5aFhULBMAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/federated-states-of-micronesia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaFederatedStatesOfMicronesia50m {
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

/// Widget for rendering the oceania/federated-states-of-micronesia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// FederatedStatesOfMicronesia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class FederatedStatesOfMicronesia50mWidget extends StatelessWidget {
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

  /// Creates a FederatedStatesOfMicronesia50mWidget.
  const FederatedStatesOfMicronesia50mWidget({
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
      geoJson: oceaniaFederatedStatesOfMicronesia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
