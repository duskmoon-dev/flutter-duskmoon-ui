// Generated from: assets/africa/equatorial-guinea.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/equatorial-guinea.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE6WYTY8TRxCG7/4VI59Rq74/uEVRwilRco5QZBGDLC02Md4DQvz3qMcsAbZ82MKH0cz0zOPq6rffrp6Pm2XZXj6822+fL9tf97vL/Xn/8+nubv/qcjgdt89m8+vr7ffb58tfm2VZlo/r8fGL6+Nrw7vz6d3+fDmsLz08vizb4+7t+sIv/97vLqfzYXe3vLg/HPe7L68uy/bw/vT3juZjL/58dJ/X+79/0/DqdLwcjvvjZbb99Pp8eLXbfm799CWkN/vT2/3l/OHbgB568Nv93eXwx+nuw5vPvf6CPp3/ORx3l6+6f/19ff791ePrZYnhrC5Ezx418XANBojvWl5+/2hFNdfwyJLKmuzaorJbKldUswhxb1GJXLmMVT0zoBWrupMYVlQJYucWVDJAvISaG7X6LyYmISVUQUOzRVV09SipRAkgLSoLuZcKYCYh7MUqkoSlAihZoZkBlwQqY6VryltqVWLhMq+EDpGt+eogAPUcIGJj6lGNxc3K0QIxjpZePQnDtVTW7ARYh5pikHVebfUHbFEVLLjMgIMyUcsGEgE0aqoGAbdidYM5D2qqsGhvtJ68vmxuXX3zf09d6RAHUzhCIXIaaC6MDeEgDkjTKDp4pbaWD4ThCYmFHFeqejSGGGEoUL0qrdjWAoIwGBwYC6dbqXMdfDo2R3pG0K0UuHPDP3OEA6KXw0XIFEgtKluilHklIY6Of04qsGNNdZWIhnvkCDL0arWjQekBHRHkCAAPLPPKICK90XJPK72eBlgQUmNlnrHe0CuOpHXVbsWKawlaUT3CvFOb5DBxUytjNWwaQQ5jQqrqcxxqqtQpT3No3KjOcKgAsbQ0IDlnUEkVVm7qVVigcm0clMZhLSjHurepqMhJ6i0bEFFGqqkEptIbLMgwLtOKKJ7SkqtmSmmEOEDbNqAJs6wpqYwZ1KIa23T8kipmni0NmK/FfUl1cWhBHUQjb0Cbe9ScFZ+KlS7wA6Feva6Eks5quGfZs7AvFAAjM5x7CQgDViwKaRgZRk1qgnlpWDDSAMFbas2rJGuqY2sztRZZHlr44MyrO2ivzgQKRS0SiwOuW80WFj1qFUwsq0mv1mZUoSq1KxbcGvXALLbDCW5QCVv7f4QRGnOG1Vgky04O5voEZjeMu7urnnsu1pszLLNlMStVzEo3RALXznBN6PwyWVKnBtC7WJpfpsqiiNZ9QxOLqNXXJRwugKE9GTCvdXxZGvNUXnPAnrz13ty6+v/84ezT5uH4cvNp8x9a6QwNPRgAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/equatorial-guinea.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaEquatorialGuinea50m {
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

/// Widget for rendering the africa/equatorial-guinea.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// EquatorialGuinea50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class EquatorialGuinea50mWidget extends StatelessWidget {
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

  /// Creates a EquatorialGuinea50mWidget.
  const EquatorialGuinea50mWidget({
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
      geoJson: africaEquatorialGuinea50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
