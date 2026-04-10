// Generated from: assets/asia/thailand.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/thailand.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51YTWscRxC9768Y9iyK+v7wzQRCjjnkFkxY7I29IO8KaXMQRv89zMgSsrshVPYwzE5NP6r6Vb+qmm+7ZdlfH++O+3fL/tfj4frP/fGXy+3t8eP1dDnvb1bz38+PH/bvlj93y7Is37bruHB7fTPc3V/ujvfX07bo5fVl2Z8PX7cFf3w5nG4P50+vK5Zlf3q4/HXgzfrb8Fyen79/a/h4OV9P5+P5utreP5wO+++2p1c/Ph8vX4/X+8cfvXhx+/fL7ePn71G+Yl7uP53Oh+ubcJ9/b+9//rcshAZMGeF187NJgUOYKH8wfLj5T0BTFUmdAAZLiXgbMAslbQA0sEAhpx6gQkQJ4wjooErpWm1A8tKgATBAOdOaeAJlruEx4CWwYpk2IxZgRCoeHUwQLBduAjJUZaCNHgaUr5vRJJlBSXBCSUAJR1J08YjEinISMWERdgEJ0Mo0fOKhEWuFtAHFSmg8JwmKWZxtQE5G0tHDAnW27KY1gqNzyQzQMEVVu4CmmUlDGjKupLA0pQaByCpHThhBKVKrlYVVYCqCNVCy+pduFT28hLLymJySgjCuxFYSVgKbBI8ZUxCYjK2EqYCoiOTZEXEOTGzRWwESluXThFZTiV60AWlFPPEvwDxKe7pfCVoSPmqgQ0qkWJtcFNFJnXOgdV+Vm3gmIWFjITYQTK3o0ZFAxRijewbEEsjW3T3BpBq3T8GZkZvsFmBFmPGAJ5Ac1vWvgImRJoIvwF5c0vWPysVkxGNI1NDs0VFgGZyjlhJkcTi3tG/dPkliHPEQytHUengJZmKGg1TVWn/LqlU7NqUqGqp5QoUUN2NNIEOcyHKCrIb2wRApdxoO2iqIakRdHTCUSB8SOUGSBa0rA5XJNqpeQGFUSU/0CozKlYY8CRAVNenxWuCFXmOf5pCaTD1m1wqOaWHj9OGgrprV7jDY1po7pIqDKydr0z8CDDOyYfscGDU9mn0zAZky5cCugRdJ9mrGipeknGMuGyRhYk+ktrZZiXJQAQdmculOWgTOgjEWDYdQdO5p/EYHhXBM0iXN07M5dSCoFYcO/q1zW1lwc0hA4ChXH+hN4DIy7p62DEkZa1oB4yo53QrJLDWSW8BSbNYtuGQSk260oFzQqVsfNbJmQzlCqot7mwukDOERkEEwEJu5jFvDUjHiCSh6mre1qiLVY9YBKXFwd0RFWHMFaxbx1tB3B0ACzyCLWQ/kaqHdPWRYp9A5J9uA1dQDBtHEGjsDEpBS1u5Qzmv1VZ58KFFgtmBqf2viJKWcASp5aK+e/4/vdbvZ/cvd0+7l+mH3tPsXsBf18FYVAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/thailand.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaThailand110m {
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

/// Widget for rendering the asia/thailand.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Thailand110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Thailand110mWidget extends StatelessWidget {
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

  /// Creates a Thailand110mWidget.
  const Thailand110mWidget({
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
      geoJson: asiaThailand110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
