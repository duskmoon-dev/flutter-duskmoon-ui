// Generated from: assets/europe/sweden.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/sweden.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WXS2sUQRCA7/srhj2Hot6PXEXPggcPIhJ0lIW4E9YVCZL/LrMaMekBqTkMvV3d39Srq3p/7qZpf76/m/fX0/7VfHP+fppfLLe388fzYTnur1bx59/T3/bX07vdNE3Tz8t73HhZfhHcnZa7+XQ+XDY9Lp+m/fHm62XDmx/zp/n4d/007Q/flg83fJG9HOblMv/2ieDjcjwfjvPxvMpefl8/uP8jffirx5d5+TqfT/dPtXhU+/Vye/9lOT6lLqdPh+PN+R9zfz//jp//miYiQA7x9KtnEktIc9LSJ4L3V//jRUYpy8ALUKWkoBaPwdkI0Qaeg2BgIjd5pVyEo70G4hQSPXsVCDGYaIOnGJHUs1fB3T1p9J8DI2Zaj2eQUZE22utAqIJULZ6DagTWyAtAJaLs6eeQXJRjeBOCKjlatID0YtbawJVJuPeyJddsDqZ8znMETCrSXrYEpJCoD9niCC5uKV0eUZmN9jqBKJFb238aEcUDjyG0FLEX3YKIzLDRfwKOq+bS4TGBeLmQDjwFJbHMJo5JjHx0nwGyI1orHMxAKRQyZLMbBEsoWosnUCgS4+lwB0Qv7hUrFjC3jBrD4SDlaNgqBitPSkPGdA4occT0ZjzWUiU66pfg5KnW4yG4mhWP8S0gdNbopR8CsvFGuhSgG0n2TltBRpqNtdRz7R1UvdNBAVWSnuPpSDAPKeryYq3NG9UvAQnN2r0jPDPGu8aFJyXe89/awTKIx2oVIMhqvXQhW3lKtHXcaPWs9+wVMDPPio1qFRnI0bNXoKgKbbRXQdWUsWevgAUVbXQjBdQi0u5dzaJKbLi7rDx3bqYLQQma14gTIF4Lbc9cgipG19F9BIkozq3qvF5NhUh9DC8Bl1hQL7wMsmqx0SwRiKKEW92NCNSTg8bLUIEKS0mvHLT/Kuy2xo+jh93j+/3uYfcL5s1jLNANAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/sweden.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeSweden110m {
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

/// Widget for rendering the europe/sweden.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Sweden110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Sweden110mWidget extends StatelessWidget {
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

  /// Creates a Sweden110mWidget.
  const Sweden110mWidget({
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
      geoJson: europeSweden110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
