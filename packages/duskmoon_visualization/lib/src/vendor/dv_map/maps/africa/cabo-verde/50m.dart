// Generated from: assets/africa/cabo-verde.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/cabo-verde.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VZTW8URxC9768Y7Zm06vuDW4SUWyROXCIUObCglYwXLcsBIf571GNMwK45uCL7sNqZ3nmuqa569ar6625Z9pcvHw/758v+j8PV5fP58OJ0fX14czmebvbP5vK729uf9s+Xv3bLsixf18+HD64/Xxc+nk8fD+fLcX3o7ufLsr+5+rA+8OLqn9Py6nB++98zy7I/fjr9fUXr+qsH93m9//KXhTenm8vx5nBzmWu/vzsf31ztv69++2HL+8Ppw+Fy/vKrJXem//n5+nJ8ebr+8v776/6APp3fHm+uLj+99+3fz9/vXz28XpbfSAdaBgk9e7CINlJMQuTe0uv7v62BAR0iowD2AZKM1gKWkZ4WrjVwipNZ02IWs9pgdJu+6OEisrhZDZxsStwDZnaElA1PIKA2PcGCquQ1sLmTdIEJk3gjKFA5IJvAEAxQAdtI1uBsbh6ZExvXwKRJ7s2oeHzi7baufvmXj2cBHiJCHNVb6gDw1Na28FBWUs4SFzlJvbUtPNQzAyoSmJ6FiGhtCw8HMJYqkHSQo3EvQiewE5UsoIPRIkWbwBKQWiXrzLfQJgvwcE0ueXYaDJ7YhRVJqgJfBwmrSnfrghRzKyYMkVs8O4EVoCxlOsAtQbrAoOyIBbCMNGSKpo+NnaAKCRlJLGFNgxVko/bKSPwfLn48AT0VGcqIcLCSW2wEBqJST7lE4kzzGrivtWQkm7hU3DKLFCH2clVG3qqIGhiZmLrq0AHR6+oXDg7cslgHJINZpYlsBK8E0dWzmV7mlA1PJ7RWKZuJnihQ+9hTMHoWt+L4qZKKRuIqG0tjiJ20JzHojnZKYJQQ9pb7aOQq7mpgEJ3h2wOOEIi6/mVSV1zTCAIFr8tUhgH3eIuGIyB4nVMgzJotFqBhgRGl2LLZNVFg02JLsrJ/sam7m/WahksKSlWvbRChMndDAsjYaoOJdKqEJjALk9U8SxiZ0gRu5PPTVWyGIK1eUkaoUUaTmik16q5y6qjUnvNkMOWmBAZMiV5ZlcGJuQnM0U0oGbI1c5GRAeTcNFg3p0RT1SA1S58k4Za94TIXm8ACSmVRkJlrgb0uTgbHqvdrYAxCatXHTm48XZ5CuKXWJdWIFHpTGpmdOSTX/Gki4S3Cl8FuDtX4woa5e/T4fuYpzUytgU1Ee/J3Am8NA2wYrsKjS1lzDFZv3ZzmtpsiWlmpVqnq7QGbzFnCZieguRbyHjDMZzcEuxp2dZYMYHLckEPqBIRNcgExjg15obcNUxP48Qn9VOwydXUwQ63OTLMZ+jQSOGFDQzkTUnRbFxDfmi3/n8aFKRE2emtpHwvQyITEOjwDIti7fggwLGuUzXlseNvBmlIfN9iwYNDeURGNpCnYN2h2jkah3Rs+NoafKp94rKojtob35ubNwTKihmX1kuug1hRadDSBc3aj9WjZ2tWPB7K7lI3fnIW3D8R4EMLmAQkTa7OW8CBxLA8zdZCuR09dXJKtgxe6FcdNYMWAjfMR9Gi2AjwIMq3UcDOKGUGbwI302M7V3f1v33Z3n69333b/AniWbFYNIQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/cabo-verde.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaCaboVerde50m {
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

/// Widget for rendering the africa/cabo-verde.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// CaboVerde50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class CaboVerde50mWidget extends StatelessWidget {
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

  /// Creates a CaboVerde50mWidget.
  const CaboVerde50mWidget({
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
      geoJson: africaCaboVerde50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
