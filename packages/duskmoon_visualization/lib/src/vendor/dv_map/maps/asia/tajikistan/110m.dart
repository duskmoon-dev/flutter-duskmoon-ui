// Generated from: assets/asia/tajikistan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/tajikistan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VXTYsbRxC961cMOi9FfX/4Zgw+JBcfcgsmCEcxsteaRSsfFrP/PUibNbvuJlA6DK2u6cd7Xa+ren5slmV7frjbb98s2/f73fn7af9uvb3dfzof1uP25hL+52n6fvtm+XOzLMvy4/ocF15fvwbuTuvd/nQ+XBc9v74s2+Pu23XBH7svh6+H+/Pu+HPNsmwP9+tfO77Gfxvm5Wn+95eBT+vxfDjuj+dL7O39Ybf9L/b4k8nn/fptfz49vObxTPzDevvweT2+xlxPfx+Ou/MLwU+/l+Nf/y2LByRXVfnNLxEJINUqfTX/8eb/4RJIzJx1AocsREZNvLRStZzgiaqIZQuvgMo5eIZHRqRiTTyjjLSZXses8ujgBQKRW+QMzzKZuaU3EDjQQnmCF2Lk2uUn4YITvEvmU8qqiZfoyWgTPE3nJG/hEYgmCdEEjy0LTZp4LKUoNdm/MmHv+TkITKkoZv4rtAhtnbcgUE0vGfcvAN1ctecXglR1SRnwHEKSgnr7x0AlqDjqdShNzuj5j8HFMytmejXMspcPAXZEm9YXLWPznp/losrLZn5RJnPv7Z9CJSLyLL9KVYU9vXot9znVW4WIvXQopGuSjelIkMjUtly2MNLRfgmObthPB2caz8qVoSU1y4GAh0nUyK9AhVia/Agi1UvG7lvAUerCzXJqWuQ0prfAUamixc8L1DXTRzsXGLuntPbv0i6tHGvgpwiEwkS98ofgmkg501tiYdLNB5LSlB6rilvrdnChh6Tow/G44FEaR89+CHrx7HhZUwQt19Ju93V3Zx7srAjlyNROr3Bp6UxvcCT3upsXIJELD/ZTBEynZrX3BBNX8rGaFpiIGveOR0AgKedY/gosUSN7egNUmWnS3QpIsX07TaDwWfNIKCSzNpwUo0zxyAK5V03b3x6b2fh59Lh5fn7cPG7+BUxXtH4iDgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/tajikistan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaTajikistan110m {
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

/// Widget for rendering the asia/tajikistan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Tajikistan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Tajikistan110mWidget extends StatelessWidget {
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

  /// Creates a Tajikistan110mWidget.
  const Tajikistan110mWidget({
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
      geoJson: asiaTajikistan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
