// Generated from: assets/asia/iran.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/iran.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYy2ojVxDd6ysarU1R78fsQiCQTQjZhiGIiTIYPJKxlYUZ/O/hyuPBnnshlDGi1bf7UI9TVaf0dbdt+8vT/XH/Ydv/cjxc/n04/ny+uzt+utyeT/ubcfzPy+3H/Yftz922bdvX6+f84vXx68H9w/n++HC5vb70+vi27U+HL9cXfn04nL4/vW3728fzXwe+nvwx3ZeX+7+9Pfh0Pl1uT8fTZZz99Hh72H87e/5uw+fj+cvx8vD03oJXk38/3z19Pp/eY54f/r49HS5vXH35e3v947dt0wTzqCC++eGEC4o9IuXdwceb/8MrJRHRH/EEQSiwUFt4BRaehkv70oKMO3iGQGSI6Qv7SCOCrYmXxqU5mZeQpMboLTgCYwznyTwOSDfP6uExaIpV1ALPElOLWngCWoIVE5xDEotnteAUggyzZncdNNEtengGwRK0YItDubpIL7sOWkySs78BpCKo2cSrwHCb6TLsc0JvVZsFSAUbTdXGBiFV2CuOBGMLJ1nAOVY5RQuvwMlJlBZ4kkjmLTY7gVaI88xmA4xkaZnnBBlKGbbIBktVaIt9LiDkLrSqjjA36fUWF2CRrFixjylQe+4yhJmyreAkslharXngcaTgTL4EtnJtho8ggtJzZkuCV4lIq9icQLwEF8VbICgcvWJzHHRhzZkuBcnF0nY3iZlWkyjE0rBnHl2DRDpPXgKJMvRWq3cck7xUZ/sITBOjST+EdHGbR6UwUHJRb7Q5goljzKNNGCqJPXt0QSiXwJnOImCcKdyli3Eq1+yvgIerdt1NFKqFsFJQVELq0o8Jk2KqNjFwQ4ymuwTEgoFTdcgYomQVrVnkCBLhMkfPwTgkpSdcClg0fBIGEqDE1eOKJag42aLWAoxZsHo6I2BoCVl4m4BczNVqzebgVOI+JzeBmKS0i0eJEovaDSgxYu8JAwMjsshV/MqVKHrZVUjExSSSIZBYGXvpFSimlWqWAKosyl74BJItctEKhuwzlKZ9DOyKrNNkE4fRwbip0xBSWVZ0dsjgJG0vWWOVmmXpyEeoeU/3aQEN8cmTLh3llpyh3SV1tHOtVXkII6t18VxUwmZ/EzhQIlrtQBOQMFRnfxOiFKm3dmiCmI01dcIr4MzwtnmOWDY30xrpGExq4QWMDT+W5hmmeA/OwdCCFtWWEIGOTfN8rHrOsmJLKDFSL3wGahFMK/vGQiK9nVwVyobaWURPxMJ7Ok0VoqRy3vGlIEgQuVe8CoTFbDOZC5STpCfDVUGZFOefSEaxJY3/Jh6zhdmMF1BBlr1ZOeIX7HP0AsbK1qPKN6yFSHtBE2+JvkE9Rqd5xRKDijC1Hp4DhosuBq+Bx1Bpvdw6kFEsqGyAJWw9maYGrqlWsyZVCE2S6JWGgZJ74ZxcgfKIip59PkpDfLECCiAFZ/TCN2SkutPsL4N6kbUbc2oxyuwvQWBRNOlybfScC1mKUKlp0ivdBET1WtB54BlJ9Pwdc1fNc25VCGo8jpp4zR/Xd6vr16vn3evnx93z7j8vD1eb/hgAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/iran.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaIran110m {
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

/// Widget for rendering the asia/iran.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Iran110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Iran110mWidget extends StatelessWidget {
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

  /// Creates a Iran110mWidget.
  const Iran110mWidget({
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
      geoJson: asiaIran110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
