// Generated from: assets/asia/turkey.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/turkey.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51Yy4pbRxDd6ysuWpui3g/vQiC7QAjJKpgwOLIRGY+GsbwYjP89tPzAniktUsMgdNX3HrVOnzr1+Ljbtv358f6wf7ntfzncnD88HH4+3d4eXp+Pp7v9i7X85vPH7/cvt79227ZtHy+vzx+83H5ZuH843R8ezsfLQ19v37b93c27ywN/fHj49/D47f5t2x/fn/6+4cva788+l8vnf/6w8Pp0dz7eHe7Oa+2n98eb/Ze1T9928fZwenc4Pzz+uIevm/71w+35+Nvp9vHtlx/6Dfj08M/x7ub83S/+/Pf9+6dXz6+3TRUi2CPoxbM1CaBAFa8nS6+e3nsd9yqqjTCZLcy8Ra0gS9URrjIpcoebwEnrf4RLWMwmDW6BcpK4zLgtqayO3YIgQWSf8YCImA0PioBoiDjZr4Cbq7i2uGxiPjk2gTB2i2phQ5ERJ9IVsORQywaXAItJZUIDg1OZZo9rKRQcA1wCM8XUJoTXmpibT+SLICEq3Mhs8UDiMZGZFBixo3cyIyDkcM4BboJouGvHL0JpWjoNcB2KhLizSCUQMbEc6FcMyCNQOv0yoCKzDvQrAkbCyVdwKctxwgMvfiuqC2OCEGfXCS4BqZW0PBBghjMNdMYFvPxMev0yVRUO4o0TkqoiOlwEdUSigT9wACci96iMSDLZra90G2nNqa0k5OLEA3dgh0QNxK5wSKi0cJzhCiVTNjysZIxJIhPcANQM77KFBLiJ+CRbcIArUXZuJg5umcyDqOCEEC7sonjhhqfQwHW4wKsq2iLKgVTFYuJmCFKE5d25ObBz5STaBGGFP3eufuEh0kcuSYsHK+v366ocNtCZMBgWWatfB8Iwl0l2U0D2LOvppapJKlYIUjPpKlSHKDOZiFcMzLDEe1xzUx2leAdyTKZrwYaONuHBIJIxr5AbWmWTmFjxVKuaaXANkslEJzHhoBRmrff6qhycZrCeJtk7Dlt51SQiHEJKS3sxJIUxDtpBCUD3cOpZcBaUSd0reanLOHo1FBITTtSQy3GyqMvEDkFcPHLeAmO27CqHC66jTRxHETyErbpzC8AijlHftmovxt7KAjBUjGf9lWhZtXoIYK4MnowdGCKK+MrYQdLYZdJuC5Sug+uHJGzOHMMxSYkada4TgEhGwzHJYFS0u3b1wzf+37HVqmrXF1LfMyR7oU56BgdfqN1Zr17amWiIy6WO3PWQCLV6p1HP4IDmS0YtbrISy6RKXFlExKiJ/eULFGETza/q3hKxeh7IqEpmVTgVS3QDx7XfQnObdE+xZjZI0Y+uqip5MgtaPSS6Sva9NJqWD7uGylzFVd/zVpXopHtKIDJjbTxbCZw5R7MVDqjyYOx4YEAMsZydG4mtsqPFJSXNSdcw853rHrh7+u7T7uvrq92n3X/DQsPA+xgAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/turkey.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaTurkey110m {
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

/// Widget for rendering the asia/turkey.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Turkey110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Turkey110mWidget extends StatelessWidget {
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

  /// Creates a Turkey110mWidget.
  const Turkey110mWidget({
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
      geoJson: asiaTurkey110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
