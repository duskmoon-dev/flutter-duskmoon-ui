// Generated from: assets/north-america/haiti.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/haiti.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VaS4sbRxC+768QOjtNvR++hUBIDgk55BZMWBzFEaxXZi0fjPF/Dz2yjb1bHdhaooPQTM98U6qu+uo1H652u/35/ZvD/vlu/+Ph+vzu7vDD6ebm8PJ8PN3un83lvy+n3+6f7/642u12uw/b98Mbt8u3hTd3pzeHu/Nxu+nz5bvd/vb69XbDT9fH8/HL5bvd/vj29Oc1bUu/PzjPl/M/f73w8nR7Pt4ebs9z7dfT3fmf3fevD3fHl9f7Txd9/CLNq8Pp9eF89/5bWT4L/8u7m/Pxt9PN+1ef/vCXJ5zu/jreXp+/+ueXz9e/7x89PN7tvnMc7kkSzx6sYQ7HQBO8t/Ti/rU1brA4Wg1saU6hPeBUobSsJSY0T+8A0yDMIKEaWMQosgcslMloJXAgUyD3gI0dEL0EToDwrsThpsgLYApwow4wD0R3Z1lIzAFhPWD6D+AItkTpATMqc20UoaKR0cMVAGXHGhhcCFt7x0M42GPlH4SYLY/mwWnMXgObxpNUrORcA7MzSMujecCEldooDKeSW2ZMI4yFvPYPJZvIPWAHJqIaWATBpMWaNFzQV6zJgiHaZE03T4taYhIw6gtMCLXAyMjiTYEDEaK2CXDUaO6cSSJh5c8xIgUFWsxGQ0ypNuIYLqza8w4aLG5qFbXFMJdUbKqCZQvvNTBNh27aBPvmWiWwbiG6G6ExEHUB3Kc2GoYBZvXmqYJHV8emOXevBt5CVhM3NdNqMxYLwq6KnVOUF8BCyNEloEhWra1NWAK7lJk4rbg2ClH1pip4aKJBmQ/GUCI2buWDPCxW+WAMta5R8AijWr/qKpwt/fJInzZcq8EABVuEKQMBZkSrcQURe+qVQeSLdCKGGVlqFzhEvIz6MUzNoqdiGRy+omFxaDmcDJmstfC3ppwySacM9jE4eVJoExgTpMosY0YpbPK6DMytHiyByRLbOwahAlDbGKEiWzMXzljzLwp3C30eEbLcOxCcj20C8+TJmn9Bg4C7Em/GX2viUkf2cF2cUWrPwISZxTV5XWRlxUQ5q5xmIEIJKcv8GCTK1mtM8OBQXKWWpIjeLW7JiVZpDzGrSBMYDUBjAQxqqN1S0c1WVoyKrt5qINDwrWiumQI3gdtdJWaAOn6iG1EvcNDMeyYb1MBbkt1yaBqqq6p5bl5wRjN9V2C1hcSEmc0mDQ3QDOOVS4e263wAAl1sHiHN9LADjCPFIBdcgWHQUzGOUErKBe4M0L26GYdbMEK9d3AJLV1gdsuFUQCnarNl7uykukgqHAKgRRVT4qnIOvazIDe7rjhiCrxgTUGbDZyutc1mcK0KRdLsdn8AgBMWtVd6AjTtOMPCFtWiIbD2yhkcYabAtSpsVkldO57DDoxVnbR1J5rmJjz7BHXHiimx7XnkS3KLS+e063lsQrVVhBqnNYdVHsZlnzhGEgD2ygScEwJc1R956QJ0946gZIoc8BSbMHVgrOcoyODWFdhmVVOWoznQWEmbDm0yp4n1ABNTU3plwlSxSSymEhQ605UmsDI61xIztdujOBwsmesB5hxUedvvEMVlARym3sthpyq2CVoJbBEY3M0qHj0uv1odffPEx4/uaQRs88eaZ90ttN35TOKos9Owbcs6wDzAtoSupi2eFX13ruxgsGgCX142aAKTmyxatanSL72nRLqI6tF/PYIHuKcvhi+ekNgsN4NoQYcx/BKNmsCPt+L/z6XMtpHlQ2EIBrB3Z5mJgFXXYqJmu0VGIxRnMFkAs7V7AAnmJQNM4H6MopG2pcI1sNGsf5qq2N6xKaLqtnMo0mvOzwZOlNOEiUsu0h0NhkhNspvAs5PVfYeA01MKapnA22ikh2scYV6ncPkUmzBiCVtool/hPN6b17xydf/Xx6vP3y+uPl79Cw2IFIiuKAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/haiti.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaHaiti50m {
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

/// Widget for rendering the north-america/haiti.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Haiti50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Haiti50mWidget extends StatelessWidget {
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

  /// Creates a Haiti50mWidget.
  const Haiti50mWidget({
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
      geoJson: northAmericaHaiti50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
