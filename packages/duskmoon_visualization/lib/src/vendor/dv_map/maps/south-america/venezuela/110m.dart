// Generated from: assets/south-america/venezuela.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/venezuela.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51Zy4ocVwzdz1cUvXaE3g/vQkiWIRDIJpgwOB1nYNxtxu2FY/zv4bY9xhkVBHkWTU9V10G6ko50VB9utu1wef/meHi+HX463l7ePRx/ON/fH19e7s6nw7N1+69Pl98enm+/32zbtn24fvYHrz+/3njzcH5zfLjcXR96/Pm2HU63r68P/HY8Hf95d7y//fLIth3u3p7/uOXr7R/bdfl0/eevb7w8ny53p+Ppsu79en53+Xv7/vXx4e7l7eHzjz5+sejV8fz6eHl4/197Hh345Xz//tVnf7+Anx/+vDvdXr5y/NPf19+f/rdt3zlCiFgoP3tyy4AROYL/c/3Fs//BI1BCQa6OV1boSVM8klKyp3AOLMrlOYazEnHpeF6OETrDQzCVqmrH55DmljrG4zL3pKd4AahSRGM8l6jg7HhKWlU19tfQMlp4AyLKUUZwVhCWnNrgEsQDRYfhRSBDLPOO58hhPnbXg9hYO54lUujMX0dIQSuPp3gFkiRS43S2zPBo5VGQIehTfxkk04haPApKk1FtiheCO3CEoIzsGVN/M7G0hZcQgszZhvEQwChhbue3AJGCp/WrIJSIvmehKykNA6wgXBrZEoYQJMtqeoIKWajGjbAIASOYdAho4GYssecxI0blMAcdmCNdGwVejzCdp5wfwOWsuRdkU0vPYY9LoFLi3SCbqZuMAVmEo3c5Qsi0UB12zYRM3mtLRKAqktNCLrBUQexBIVArJxxGeRGKsO6UMgM5C87SMFbjlFRpjZ0IUj2ZZ5Ucq5UYV7bOSQQSpklDCwkU0XnHQoTyrCFXB4EYYko3EIGJSmyWNEGAa5Sp1uwK0lYyzeouCNjVrJrDBSRBNczBIPAy104MBRjMLkN/GTCUYs9dN7fhqLXME0GX3Wanrt/iL2N67idMqQ2HtyAoDdTqFhIoC+e0RgjEEdF6dyKwlUviY0AhS+msQBDhnEMiXC6HFNOehY7pQUMLeXUnC2tZQwSEGcjjLHRSt9gr42SqsGFQGAqNc685qaHocGYNAeRw3Cu7EI8YzvwhIKhlvdkVkFHVcAYOhsgMrnaABZiGPFSwKyCOWtrwEpyNM8b2qVR6n7gSFI2/Ib7iWIg7GgeRXXJIMwwa5ZE7ks6FDccFoqqa0VgrFsdE6pC0GKhSdiRYgCiq4LgrlSNF5yyHKnKa2rckorJ0ygrAjMjhPB0IWCK0s6BY8jp8PLhJlkbnfAesSschXkKlCXV6cWD0xOHxrdHXDa0rMAcy4fG+KNaQgBk7Cxn2kKn+WklGKrXjLpbpXIoYk0kXxAZmnoFDuRkQql5diRgwE3HOitcDkgWJW/YpGEpJDPV1gDOlWPNXIKXGM/QKh4R5n3kFTNdCcCi8AgSFQlq2yNLxalPdFZBYJX19x5CMbsNiC1AN7CqOwRE5p5orgJK4tEWXYfG8TGvNIWO1iD5PApvImFschC3c2ukhrE2MTaNrYJrsfcJHiCy2qQg2ENOgHQW3yICTh9Wh4ES76zEQvu7vpnhUJWh9lAQtTptyswKmYFpfS0CRi9cwXwTEM7qi5rUoyqqhuwLKnDvhZVAi9BgfH3vtLU0YtAJxWr0Kipncd+UCxB7pw3TWdXxa2vwVWCt+mjYPhSRHb3AKuGS2jc1zTre+PlAgTR2zlUBmrnc8O/YxmuA4+7CEqi8qBSLQgob+MiSqdTJQQPSazmm8xIpytbFU1zqMWIZ4a0XgWXvmmbiOiwPBkSh6cSgUJU5fXExfO97sfX/89vHm8fPFzcebfwEr8KqYJh4AAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/venezuela.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaVenezuela110m {
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

/// Widget for rendering the south-america/venezuela.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Venezuela110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Venezuela110mWidget extends StatelessWidget {
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

  /// Creates a Venezuela110mWidget.
  const Venezuela110mWidget({
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
      geoJson: southAmericaVenezuela110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
