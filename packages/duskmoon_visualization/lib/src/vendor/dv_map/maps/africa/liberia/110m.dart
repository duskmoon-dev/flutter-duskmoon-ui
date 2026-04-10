// Generated from: assets/africa/liberia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/liberia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52WT2vdMAzA7+9ThJw7IVn/e9sGO+0wdh1lvHVpCbQvJc0OpfS7j6Z9pa0Dw8vBOJL1Q7Ik2/e7ruuXu5uhP+36L8N++TMPn6erq+F8GadDf/KovngS3/an3Y9d13Xd/TrWhuvyVXEzTzfDvIyr0XF51/WH/fVq8HX8Nczj/sWg6/rxdvq5L6vyeyXnVf7pjeJ8OizjYTgsj7qPF/N4vu+ftQ8vjlwO0/WwzHdv3Tj6/W26urt8DvOFOs2/x8N+eRXv0/d6/v6v6z4ECGfJ0JN3GgcLQynxRn528i+cl0KFrcY5kblwIy6LockGjjGRXZpwCQXDw2QDR5wF24JNEGSWKDVOiyVqacQxe/GMGpcllEUbca7KUirvAlQItdE7QkAyNasqJUBKKHK28gojZl0qAYJWUK2VZ6makhvbxynWVipEQGKOwhu1kub4H7zMQNrILqGGtIZLIBzuWaXDwEOTrDkdbsrB1fYZkKBTc28ksRSsWk1Bk9XQG3GI4sn+HicQXISirTcc0oXQq94QYFVXpUacUyHNKlgBNlHTtlw4GCtbfa4oUARptnqnnE5KNY6JWRoPAgd1JC1V3yo4OmtpxWWyZY0zoGIU2VYoAUzE4lu4ZGRu27sAwxKBVSoMxFxN2oIN4FBR2vAuiQKx7RAIkFAR3bi8ObWgt17ebW+B3db8OHvYHcez3cPuL9OTNTOxCQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/liberia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaLiberia110m {
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

/// Widget for rendering the africa/liberia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Liberia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Liberia110mWidget extends StatelessWidget {
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

  /// Creates a Liberia110mWidget.
  const Liberia110mWidget({
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
      geoJson: africaLiberia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
