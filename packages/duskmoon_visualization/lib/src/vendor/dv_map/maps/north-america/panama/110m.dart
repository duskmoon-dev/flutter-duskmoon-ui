// Generated from: assets/north-america/panama.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/panama.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VXy2pbSRDd6ysuWnuKej+yCwOzDNkPYRAeTSKwJaNoFib434crx8ZxNwylxaXVj0NV16lT1T82y7K9PD7stx+W7R/73eXf8/73093d/vZyOB23N+vyP8/T37cflj83y7IsP67f8eB1+3Xh4Xx62J8vh+uhl+3Lsj3u7q8HPu+Ou/vd6/5l2R6+n/7a8XXt4zAvz/Of3i7cno6Xw3F/vKxrn07ny7fl4/3+fLjdbX9ueno15+v+dL+/nB9/NebF+s+nu8evP519BT+d/z4cd5c3Xj//3o7f/1uW3yJATMQxb94tJXigocYv819u/hcvuIzERrxST1Xt4SWgWXHEe7wC1gjBNp4hZoaPeMqoltXDK0BLNRz8LVBTc5M2HhMVDfEoMOMSavpbYCGCPMFzIqcuWpFa1QRNiMONW3iJYEyFxCMeEWFwz75EKA1BGqKbkJaGYj08ApXiDBrxIp2lF4wkCFIyHb1FoTJrW5eY5l6TXDN08uzhMTCGpQ/2JVSZRZPLyUAZxDzJNcZQTe/imTqVyyQ33Em07W8JZw3BLdDwpCaXGYqDTIdoFGCoCDa5zBCrDsiEe8UWmD1lTob0dIsh1xISg93b0U2uCByUOcHZubpsZigSihn7lMUo+vFwixzIksBsyG2upGHZpExiSDL3g8GISTPrCtOlbZ4Ulujk8rhYnJtKxUBCqqMwJ1DYqolt5WMSmuJhlnfvj8CojHQgX0CgN8taElBWkE3QXKPQmkJFgFamY9ENSIrqV7VMV8RBWQKY0ZSamYagTDRyOWAVsG6eIXC4T3QgQKnCtO0tonjWxFvTMO7jaaJnTVINCwWjfXuS7DaWjTXVUjHbeOSqOUsNERGydkcajhY5wVs7VbJ2z2cWGTHrCoSleX1RQLze+sS8KsfqsS/WYsPEY/+dEJTE2jQvQcXUbcIWyQi09nuDkrFGaUmQtbw3hXm1j4t8VnXRGJWa0U1g0hIf2BxgxNws4hGQSRY0kGWVKomg5nMoIEyUZCIGgZVSvToUASpE42s3wCXRmz1fBLCyuQ/sCygxjmzjaWgwTzp6Y+X0Nl7vdb+ZjV9GT5uX75fN0+Y/rI9u14oRAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/panama.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaPanama110m {
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

/// Widget for rendering the north-america/panama.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Panama110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Panama110mWidget extends StatelessWidget {
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

  /// Creates a Panama110mWidget.
  const Panama110mWidget({
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
      geoJson: northAmericaPanama110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
