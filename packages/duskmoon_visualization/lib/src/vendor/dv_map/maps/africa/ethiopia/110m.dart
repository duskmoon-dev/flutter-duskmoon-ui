// Generated from: assets/africa/ethiopia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/ethiopia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52Yy2ojVxCG93qKRmtT1P0yuxASsswiuzAE4WhmBB610XQWZvC7h5bHxuPTCalo0bTOUX9U1fnr0vq6m6b98nB/3L+b9j8fD8tfl+OP893d8XY5zef9zbr94Wn5y/7d9Ptumqbp6/U6Pnj9+XXj/jLfHy/L6frQ88+naX8+fL4+8NPy6TTfnw4vT0zT/vRl/uPA193fhnV5Wv/l9cbtfF5O5+N5Wfd++HA53R7233YfXyz5eJw/H5fLw/d2PBv+63z38PGbny/U+fLn6XxYXjn89Hl9//bbNGlAZCnfvFlPQJTv1t7f/DvIoTRF34ICqjyzhRLwyLC3qAJKsS6Ky6tGlClqD8VQnDREihCQqbTJMsvwDZYFN11kiPA0yg1asWekt23TkoFGQGhETZaQ0iAKIkBRbqEIwsxiC2VYPbMIQsoGVRCBWNdFAnfaOEoCF+q5yIADhqEdcSMbzWEwZe6lNANijXlIDOmW3eOzyg27BNQYq8kiszERBSJEei4iZPlolQJRei+n1zrgPEZLwais5aEUiKLTFkvIrMnCqjEFFUKx56IkGHFtuoim0WIFFDqO+axQVto6RQmwkthiMUkrf8RBuWwr8srcKw3iwIG8JVTzplDFIF18rMoMFsmtjiEG7Khj+WPA5F63EIUU2rCLQCirywohGuWFUITUk5cCW+gWywV79UYEysmHcyyw7jyyokJraNUJnmq9aAkk2+BggkRRl8SlGzaJadM9hjIdJ5F1yNTqHeCaJMmDSAOCRHplSwFjTOkAZqteLV1VhTIowSHZsSvQwMANlJVyq7eu+VyJGIOLBoY9KRgkhepYSw1EkoV7FfAfcboOreXWi5kDWWHk0LAVVCNdu/U5zbDG8/x/uARirLF+yTr6OPaUlqDiNcRNwDKta5cHjUO4gFNXtAlZPKaSgCFGLykLzEpSh9Yha6dtyrYgTcchRyAlozdcIoTnWA2v/QS7My/FWAwFiqo98a5KTdmIfFEWUQ/HQJzjeKnAotR9R1jzeCO/2bg39K6v/Y65gSqL3syrCuUyVAkDRPLeGf73/0d2W/fPd4+75+v73ePub5D6tV/AEgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/ethiopia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaEthiopia110m {
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

/// Widget for rendering the africa/ethiopia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Ethiopia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Ethiopia110mWidget extends StatelessWidget {
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

  /// Creates a Ethiopia110mWidget.
  const Ethiopia110mWidget({
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
      geoJson: africaEthiopia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
