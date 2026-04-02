// Generated from: assets/africa/mali.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/mali.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYTWscRxC961cMe5aK+v7wzQQCgQRyDyYIZ20W5F0hbw7C6L+HXllCdjeE2sMwOz3zqOqqrnqvvl1t2+78eL/fvdt2v+5vz/8+7H853d3tP54Pp+Pueix/en78dfdu++tq27bt2+U6f3h5/bJw/3C63z+cD5ePXl7ftt3x9svlgz9u7w6vb2/b7vD19PctX1Z+n57L8/Pf3i58PB3Ph+P+eB5r7z89HD7e7r6vPr1a8Xl/+rI/Pzz+aMOL0X+e7h4/f/fxFfX08M/heHt+4+zz7+39z/+27YYIjKSU8/qnJWJQ5crwHxY+XP8voJqTpy8AMTxFuQvIFRayBowKoi4giput8JiIVZseI2Rgcq0AKSIzrAtoJcwyx4SgWCpMuoDkxrQETFVM6blckIVVy6RBR43s4plHEcVqB0tZpRfiAuFwclngiSin93KwgDg0xFZ4mMPlFl5CobFrrfYvUyx7/iZEOtYMR5DE5lhNOAkXXJhHICWu1sWzJEGbw0FA4qzWS5cEZxSmCQ4hCbMwm3CKIYRzNiMUFpt33eVksVjZF8VW0c0WEZMIXuBpaRJ17UOu0kVBRWB0E+3hBWSVZa32jyskuZfNAc4cVit/SYOleXod0tDQV/6SZJX08sXB3dVxPh4IKpiE0cTTkvK5uCAokSB3zWM0Zl6ZZ6zozePhgIZqq2hguXThDJK82Fd4zGzWbL8GiipKq+hKYIh37dNAW9VmhDJiry4eVaTybB+BhJFaF48ZS2lVnIMkm7VZQTnIfS5WDKbs3dqswImKczILMKeq9LiQAqJLLWqzgAZrWg9PwJgTeWYaAiLhTj13BQgl0Ff2mRJ7M/sYysNLV/sXlWTYo36DP1HyAk+B1ZWa3JQBkVBsThcFs0LMJjUFdBdfMCuF0TqoZx6CkaUt3DUgcrLolWYEdmeLmbkoFKv0iNUoSJrFc+kbaIO3tBobAZJFytI4T0puxYJA0oxzts5AWMx7OoshtKoWJ21U7DLW1skQcEm2nMuegfngQE24YFFeKA4HSuXscQIFDlwQ0kE9eJCZJpiHUs1JXEBm7NZKEwEa9FvmuBbg0NU9QS5A6qt+UeAl1pR+DD7kTq58TXMWbBl3kZ+1aBc8qCOzSIt6EyQLc0y9mxGcMLF6TJ7ADNFmbsE8lIF7u3kXi0johDeqp1poj3k7qEnkzJQHnrlVk9kajOkM53TKxv6NsUMvHIOb5ThQc7Y4CBv1kuXGQMg4FtV9cGhKk667Q6apzngGhuTZpI410oUlp/COEpqu1RSmBYHItmjeBuxK2BSmQwGkpy6ki4EIalpvAwnBDaNo5TEJR3fyMDi2Fi5KqQ1txU1ySzSkH0auIiyZ3KY/BGMgirHiP1GF1dzAMXHEMFxxgjGVbU9fGYh1jDAXhLRKo9nbbi4jzIiFXBNQHjvRnuaaiVSsGDgpMTUP8Rhge2TVShGFqVG2c7A5Yr9a3b/cPV29XD9cPV39B0P/AbgHGQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/mali.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMali110m {
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

/// Widget for rendering the africa/mali.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Mali110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Mali110mWidget extends StatelessWidget {
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

  /// Creates a Mali110mWidget.
  const Mali110mWidget({
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
      geoJson: africaMali110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
