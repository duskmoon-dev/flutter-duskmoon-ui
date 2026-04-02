// Generated from: assets/europe/spain.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/spain.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VXy2obSxDd6ysGre2i3o9sLzfrQJYhXESiBIEjGUVZmOB/DyPHwU43F0qLYaar++hUV53q6p+bZdleHu732zfL9u1+d/lx3v9zurvbf7ocTsftzWr+8jT8fftm+bBZlmX5eX2OC6/Tr4b78+l+f74crouepy/L9rj7dl3w/n53OP6Zvizbw/fTfzteTf++H8blafzdS8On0/FyOO6Pl6vtx/p/29/Wxz80vu5P3/aX88NrEs+s353uHr6ejq9RT+fPh+Pu8sLbp9/L97+/luU2QE2CzW/+skgAVkSGvzJ8vPl/PAdjpMIc8BxKuUikicfiXlITPPHwCGrhGaS7CssED7mSvOevgUSQ1eivQamnYY+fQpUx1YyfsAYmN/HEsxBn++cRKdXjJ6BkkdP4umVW9faPgdTVeMy/lZ+Sas9fApWUZJrks6qgS7TwEDxFsmyC58pikk089SCW0d8ELha3Fh4CEXFhTOBC0kh7ckPgyCAa069AsCqylS4IhO5Fw+4pArGUSCtbEIJJZIitInikUGoPLQmNdSRHgKQhrcxjwKJUGiKhBMyOmS1XBVBKU0dfCbKYGFuBZai0qqEKKIOGIFkHjCDZo4QnaKIiqS2NIQSSFQ6SUIYoC9FmWEUS1We+WpRpr0ARGHLEGIc1QorUI3dLUEhio8BUQJkTe+VOwChMJlknoGaF2CtPCqKRykN5X/FQVKvHz0CJMl0neBbKUj1+DmGqNfXXPAqrlcm3AWtJy5rhhaZI9I6LAinOlBkesjv3pHGbUKkqU6lZcYT14lFr0ibFrEplogX21JHgQaU25gsDiXpWTx4J7JI20mPgVdTZ3T4kodCxtBBErTW51/3EqtGZeFc4xmhGN2AFG3szJShK0SY7B/d0tNmBlmsX49XEkyzMabJIUpL1xOaQRsQ+wyMiTO5tn0O6Ik1OtfUMwAzq+RurRJWm/QWlGjd70QB0t6Kx1ysIoizqiS1AK114KKZS4FzWvAqtF7xEGcMha5VAjGY4AiQUi4daJQkSgtbrgK7hKE6a4WFYuHb9JXfDGK9CAYmS1TzKA0yCJnJbrxqchc3eu30V38zen98eN8/Pj5vHzS9eKBAFLxEAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/spain.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeSpain110m {
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

/// Widget for rendering the europe/spain.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Spain110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Spain110mWidget extends StatelessWidget {
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

  /// Creates a Spain110mWidget.
  const Spain110mWidget({
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
      geoJson: europeSpain110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
