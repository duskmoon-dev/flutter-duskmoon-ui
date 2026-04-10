// Generated from: assets/asia/jordan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/jordan.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51ZTYtbVwzdz68wXgeh74/uSqGLblq6LaEMiVsGEjtM3EUI+e/lPndCkqdQNLMwb3yfD7pX0tGR7se7w+F4/fDudPzhcPz5dH/95/H00+XNm9Or68PlfHyxlv+6ff3++MPhj7vD4XD4uH3uf7i9vi28e7y8Oz1eH7YfPb1+OBzP92+3H/xyeXx9f/78/uFwfHh/+fOet7Vfd9/L7fvfv1x4dTlfH86n83Wt/fj+4f7439qnz1b8fbq8PV0fP3xtw5PRv13efPj7cv4a8/L4+uF8f/1is7e/L5+//e9wEIPIENR48e0KQ4gWMX218PLF/+KJanCLx1noPMRzIha0Bs+TMXFqn5WakHR4nkjhU7zgNPIOTzG9xvZ5obbmUWXIFM1IXbOBkzLDyPluMbAzjyWWe6d4ouHWnR6hIM/3K6Rqe/sIKp8TzWZZqdrghZvN7dMqJaUGz4PFZYznplz7bCMwZzGxKZ6hpVWDp1FcXlM87rODQNhkHi+6bYpbPM1n7BfRUzr7FunM2UCx3PfpRsBbXE7DT6XYosMjYWWaukNSEBs8hErmMJ3iMRLF3h0I6cho0/1yRRsuCInM6mM8cWfapxuCh2j6NN0oFFn2dIBgvFw1pVNSdN7XNgRlXMQzhssVZg2epAqPay8Je+9eKhPiabaRkmPr3rVSNbUPPcn3bMoFFZGJ0/RAE6VddnBBlhfL1Lt4i4kGLzLQcXZ8ChWiEjv3coGZIdcsmnXLefadO7hAcxNxU7wlKPbSigsWaZNNyZRcwqvbrzCWjouvSJHjLpy5gEuxaCyGbknQ4Zlm8hQvHaVhv4VHuurACM8BqRUHXECFGjmLP1/pptbBMaJJzMjZgZOzPz6xBTfF03AM7dyrZatMDfGsKMp3WogL3J1oqNUcApfg6dIjhVyHWsghNgG6K0YLzx2n6eZQHGjY018s1T/CC6Be6y52VuccdkYBunFwd35VtmJzilcY3HSqCEvUUM7SLcBMnGTfe6zqpjbtVANcxEo6sSYkK3WmeFqF3NkngmUztg9wr2iqx4K7yZAhXvo2H+jEkLIPi1FA5VK6nfQbG0ZcuY+7JSK9OIe8F+Bm6tn5NTnLhqI5VmeGKF3PhhjhMj054dLirsci9ZyqyADClqdWz2ZGMRTNDrU61CYvCLTIUGaqL4DJOhFOYOaEw5Zy0crK2267zpaRU/MiZBXKDq9cJGZ4CURLTHTHF0lkPKP5BIkldrqRS2qoD0V4QngtJuhGOGuUpTOaTyjndsBJUCvOhz10Qt2KYTOyQgwNnKVbAakp7VXpGoGxLt0yxOPi6NKNgVVSY4x382KDJ4YVPpMZa7+LrfbxzCBCjMOyVoC6uujOH4LmrjM6TajcxFiDp8FmOd0vWnQyd+HV0n1z+7YhRIMXhF4yzg/S1IZOGUrUfcbOCamGtG/aRIAMx/SXi/7aiZ+ABDON7bOe7eVpVjSE49Vi7ZsEEcAqppxlWwKahVN3fVKl0/l/QCxuaW8nkiuHsRJgEarUcUvIlm1TqUFhnUhjsMIImtZezKz+ukOfMa53SMq2lvOynNOmLaVGUVXH9at14Jy2vPLd6xhZV09Dblktua7i0Z2fzWubA1PfI/AzW3K0+s7losm6f5rOh8u8vS5al4H+jIFkLvPa/QZts6wh3vBy9q57fnr6dPf0+fLu092/dg/LdEAfAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/jordan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaJordan50m {
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

/// Widget for rendering the asia/jordan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Jordan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Jordan50mWidget extends StatelessWidget {
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

  /// Creates a Jordan50mWidget.
  const Jordan50mWidget({
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
      geoJson: asiaJordan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
