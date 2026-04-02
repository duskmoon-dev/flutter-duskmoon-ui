// Generated from: assets/africa/niger.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/niger.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WYTWsjRxCG7/4Vg86mqO+PvS0hOYaQa1iCcbRG4JWMVjmYxf89tL023u2GUDoMo+6Zh25V1ftW69vVtu0ujw/73Ydt99v+5vLvef/L6f5+f3s5nI676zH9+WX46+7D9tfVtm3bt+fr/OLz488TD+fTw/58OTy/9Pr4tu2ON1+eX/j9cLc/vz2+bbvD19PfN/w89es0Li/jf76fuD0dL4fj/ngZcx8/nw+3N7vvs09vy7jbn77sL+fHHxfxuuo/TvePd983+UY9nf85HG8u73b78nl///O3bSOFNJLrn4aZIZ3Lfhj+dP1/KFLJwFrQtIizWjgBS1JWn3ACqGjo1OIRVJWhrXga5J7a4SVYcJbQhCMwN3eMDs7AI8ynxVGBI3EPpsAeSmULGpmxGzdxgTxtlBzSmDlaaSIQLMoUCxylckr2cC7JllPSkYF5ElULxxBaVTyvzkCxjLWFI5A04+QFTljMqZfDgGSRMtUrKZQnJUsHhyChWTyvTqE4C7OVJghc5uq6wKkqi7YEAEF5RGIuCYHKDGnutUpQbQ6sgIiFljcjwUoo80/HQ1CTrVWwDBRBGLnAORtSNLOYTDVkrn+CUiTDVtoN+UZymSPBwCJo3MSlpuucxINmLtZKEwEnosTVXt2RPFqLE/BEl+Vezbiwl3YC5cG50BOGMifMprATRs2WOMxSiKmXdQriKbpIE4HQ0KRWTRioClrOgRVIt+KWvzqomrLPtiOgQxayZTsOyahKs08IEBkWteIaIIKhvpITrMSeiQUkqsfchw1xUjH2VkkUIGnJwiYYkn2Eoocz1uKVNqURIbdohECkSbrKOo5go16fiBBIKMvIsno1tZMQKssWjd0IRoYwt4qMCIwjV1YhIJy9/oQYBBmDVjSUoHaTjSmVsco8KyeNXnAFhDKQlgo1tN1bZTasvkxsmXzqZG49ngIlifiqNDTFrVdppMAkJrjS90RGsZbojU6pLDLmHmoUW0k1fz8FG7y1sghqU1lGPEZn4XM8BMRENXvpPHjulStelXtRN/9MUWphacPsgkR6xStQsTqrGHhqk2XAGiGL0nVwjmGdTZ7gsLRZqAKKo7R6sR17slBcnUHLgrLXNZJBofDCIxmHkHpXqww0Y1jHgheCStr7v8LGsX/eLROgZpuF5ZnzYYUJBMeJoBfbzt8yV6v717unq9frp6unq/8AjQybWDYTAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/niger.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaNiger110m {
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

/// Widget for rendering the africa/niger.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Niger110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Niger110mWidget extends StatelessWidget {
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

  /// Creates a Niger110mWidget.
  const Niger110mWidget({
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
      geoJson: africaNiger110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
