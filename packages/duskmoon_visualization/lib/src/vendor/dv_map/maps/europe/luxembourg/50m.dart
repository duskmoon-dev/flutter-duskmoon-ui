// Generated from: assets/europe/luxembourg.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/luxembourg.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52XTWsbQQyG7/4Vi89h0ehbuZb21EMvhUIJJW23wZB4g+NAQ8h/L7NOQhKrFNWHZb3aeawZvfrw/WoY1vu762l9Oqw/TOf72930br68nH7sN/N2fdLNvw6Pb9anw9fVMAzD/XI9Xri8vhiud/P1tNtvlkVPrw/Dent+tSz4ePt7uvo+3+4untcMw3pzM387x8X++eg5HZ5/eWn4MW/3m+203Xfb+9v+o+tH68OzLxfTfDXtd3evPXly/dN8eXfxuNNn6rz7udme719s+fB5ef/22zDo2JoKUJy8MQiMDSFC2yvD2ck/cQDimuLILKiGAw9QlAwnLB5exAmbC+Y4DI0KTsYwRY3UO7XmJjWcq3pwhgNHb1jFNSNHz3Ctu10KhYzmDi5HQuEYQxsSFL0zZmDKaC0UvRgJI0E5VjHH6CZKXNJJdw4cIfPOxZqZFXEo5i3FERGHlnEZCpwAqht1C/fMMxN31+JGHcgaZGEwwvq5+cJrCU6ZzYSLOFFJJacNnVvx6JxMwizBiTkhFNPLlwqU4oQcvKoRD2PNjk5oKSZF75CYLJOdgIB5qUvIGNBI7agOc4x88LuIw94mssh2lVBUcRJsmIWChZW8pGIdoTVGOarDHcfCUqp0OoJxwzQn/su51iKwZRnLLghSbf/eeo/NcOGBUuzXyNjbaIpjourZoRkxpZGo60RH4sWHNBRoxKXy1HH+txyr92sd6VCFMlyEQhS9Y1CjtFMocxgUdcfMvctnuN55a/VJR3Y2laOxszeeXp1qo5OOHHkgTJiCqzA3gjQnLJxdi3FlhmiZhh2EEKsqQe5aSEcT61W1mGGif8l/N2xaTX9gTybYZUiU3kGKxYm8OWUiCWNqWsyIBpFprs/XS7Os0pbxLaMFI3kxrsW/davs/unuYfV0PVs9rP4A8szA438PAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/luxembourg.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeLuxembourg50m {
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

/// Widget for rendering the europe/luxembourg.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Luxembourg50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Luxembourg50mWidget extends StatelessWidget {
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

  /// Creates a Luxembourg50mWidget.
  const Luxembourg50mWidget({
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
      geoJson: europeLuxembourg50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
