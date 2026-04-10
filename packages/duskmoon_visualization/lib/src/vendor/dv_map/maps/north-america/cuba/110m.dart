// Generated from: assets/north-america/cuba.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/cuba.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WXTW8bNxCG7/oVC53dwXx/5NYG6LHopaciKFRXSQXYkqEoByPwfy9Wjg0nJFDMHhZcDvngJWc4w/26WZbt5fFhv323bH/d7y5fzvv3p7u7/e3lcDpub1bzx+fuz9t3y5+bZVmWr9f3OPE6/Gp4OJ8e9ufL4TrpZfiybI+7++uE91/+3r2OXpbt4fPprx1fLX8M/fLc/8tbw+3peDkc98fLavvtdL78u/x8vz8fbnfbb4OeXsV82p/u95fz4/dSXrT/frp7/PRtqa/w0/mfw3F3ebPm5+dt+8evZfkpGdiTjPjmBxMLUKYTxneGDzf/CzRCFZ8BMTLUvQcUYA/T8AHIUCmoVF1gRLJUTYCRSZTaAyqwoFhMeOa2au/yVAOdaQJk1NJqrlihQotoBBJkOXJSF2gaKDg6mSCRmKO9ZDQmw5wAi9DCmgoFCjMRdbKHZGpu0gVqqVqOChnI0yi75yTCsmY4zyTDpj6CKEOkKVC8XNsCyatqCpQMwmorTMZSmbqkGK2bGRCMwkRnmQElMJrHBIEpNExmUc0hrL0VRwGnTWBmtQrvwRKCKt2nwEoisS5Qk5N9zFsEyOkkvTwYCSTBxWNWQAip0uyFYARosdvEwQgeQmhNhQGYRphjCCIoiZi0FYaZJg61hAry2dIDOgiL21g+qaCMs7pAAxf1xCH3rwpDIrpBrVBOVqNTVoUsKl2nKHC5a47VCQENJbIZ2AoUiaxjgUfgVOdoelmhRLKmYVhS2CxOq0+C0CfFaT0ohkVNn9iaAZh5BBIgubM2t9CBSp3HqGECXlO1tYHGkqyzAs/oSdVL/hFA6so8S4dukUZNhQFVwmWzayFHUPXzq2io6KhwvSPz6pZ+OSHNWbmTKkZqbmGBRxnL7OIaboLSE5gIThmeI1CA0CqxeYsjUFS1mP6dUHBQ86re/t3ZzNovrafNy/vD5mnzH5vfdDeaDgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/cuba.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaCuba110m {
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

/// Widget for rendering the north-america/cuba.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Cuba110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Cuba110mWidget extends StatelessWidget {
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

  /// Creates a Cuba110mWidget.
  const Cuba110mWidget({
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
      geoJson: northAmericaCuba110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
