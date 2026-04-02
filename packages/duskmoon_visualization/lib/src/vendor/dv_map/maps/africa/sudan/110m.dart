// Generated from: assets/africa/sudan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/sudan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VZTWsbZxC++1csOodhvj9yCy29tRR6LKGIRAkCRzKKfDDB/72sXKeOPb5MqQ5id9/dh9n5eN5nZr9dLcvmfHez27xdNr/stufb0+6n4/X17sN5fzxs3qzLnx4uf928Xf68WpZl+Xb5f/ng5fbLws3peLM7nfeXhx5vX5bNYfvl8sAftx+3h++3L8tm//X415YvSz+/uC4P1397uvDheDjvD7vDeV179+m0/7Dd/LN6/92Mz7vjl935dPejEY9W/3p7fd7/fry++3w8/Ah9PH3cH7bnJ6/88Ht6/Pzs5fmysIBZsFa+ebFW4ElMyc9W3j+/tYWV0oiiDpbd0KNGsGqFxPUSNqFMOS1HsImWJNrBurtQzqzN9IryFpYquGIAq0Cl6BEdbHB6uY1gTULJuPUthUn4CDZKi62xtiAJWXHiWwP0cpQGlhA4ZsYaRKGLSIuqRFijTDAoZ8HeWBJXpgGqg0YIZxOxAjMOQRnBhjGit7DqniWT/AogYuOWEVzSPCZEE5AiZtjUWIGjsvDM2ArM7Eq3QCqZdYCaUO5W0Xp2jFqAiCXUkOJ/cUGBkZVJG7AowRilQYFTlkVfYphaM7ItqHKXsp4QCotjUA2CkBKpXe0WBAaLD0hcCMQ4vQ/amBaFIA2DOrYlBBPiwEHUhEERMaipByLAROfJpiMMQsqinb206g9NneFiSBZ12UBQIcI1UArC4KGhbZYxIGsKTeLGECraZQMxsCZiTMwVYPSSbGqYGChKJCdFIYDp4d67V5VIaYb7ur0IwUhEg31dBIKprBriJQRhY5/swCKQyiTYVnElFenM3GQtl8a9BZqKjrNsKBcpbrW++qqeB1vwBZZ6tWApE0EuCmyhPZW74IgaFUKoJQSEIqQJiyukkHdbGcHaNEyCb8CO2jMBJucMM11aOxkskicxcuBA7ipKwFYNPcJULuuqX0GZaVKjDsLS2qmwKq5JLq0SWbKLkQMXjWLkkMbWxcihzG2yDQbQul81mAHsQgO5KQGFTaNMAcphE8QEJew4lAKqUjBmdqZzdIIlQTxGMQrQpOgsXRv6mWRb+6I2RAWJMaIQh/LSpoz4omZ15k7K7DoXJkDKnKSnQ7pzk/LMgCMV1YRmhrV2Vd3LzsAM8H/GQkAUnLSPAtlsiivgDEzCu6JbxQDqZN51GaO1ZGvghDl7aWS1VzATR6MIBvNoOwOFUuVJV8sgKK9siMI+ms0yGHGX3KSwzhEmE1QGSunGsiQQ6TrD5HJrxCoJSLDM3h0l2rgzlNlErTNBib/SYlnm0J+ciT2mq096eGbQik6nry2m42j2xGCY3vmTwKNk4k+GDG8FG4Gk+mRUypCu5NY3rOsIomyGWxGm0jEeQpCq88QH62cZFdS+YcUsNpvMdiefe65eO/v3+PHo/urx//3V/dXf3E90FLsbAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/sudan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSudan110m {
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

/// Widget for rendering the africa/sudan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Sudan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Sudan110mWidget extends StatelessWidget {
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

  /// Creates a Sudan110mWidget.
  const Sudan110mWidget({
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
      geoJson: africaSudan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
