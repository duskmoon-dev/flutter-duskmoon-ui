// Generated from: assets/asia/kuwait.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/kuwait.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE6VYTWsjRxC961cMOi9N13fV3kIglxDIIZBDWILYKIvAKxlZJpjF/z30aO147eocanUQM9MzT6XXVa/qzZfNsmwvD7f77ftl+9N+d7k/73883dzsP14Op+P23Vj++3r5bvt++WOzLMvyZf1+++B6+7pwez7d7s+Xw/rQ0+3Lsj3uPq8P/Hz/z+5web5/WbaHu9OfO1zXfn9zna7Xf3u58PF0vByO++NlrP1wd9htv649PkfxaX/6vL+cH76N4SnoX+5vLodfTzcPn77+0Wfg0/mvw3F3efGPr5+Xx6/P3p4vC3tDE4qu796sYTRFJlB+tfTh9b0pLnFHYs5xgw1Vi7hGSpTiGkRYtyKuIyPmuI5aDBfRbEZDkBI6lHDB2VTybQtzF6ttG4hLkOe4EmKdarjkrpbT66HiWIPFDjCD9e+gF4hNc3rdOgJ7EZeNFXJcdrOo0dsdmGVSFeGBUoyXUczzeFUFnYr7ZqFukuPC+NVavAiOCpbjdgihWj4UVHIzO/vmFwuKzYzsPePOmzAGRNQU0EPZM6nypgQSUNsTMkCPLIe8aYCzFBWbYiRnimtr6ddyEwUDI8shb9EBNaQo2WQzHsKCgou4vU9zE6EbY42HftXPHNeE3YtaJcDKeYshETKo1Ki1iFUEc1wXYa3UhbUgIYGcX1LVDpXRwJqzEOAkXhVDrNSFNUNU0bwnUlAHq8VrozDyFsOgwVSZOKw52ETOorHbGCNr26ah6DFpMaoRxbJgJ4o8fSVMetRksnuMhMhxLaCWZqOFE0veEcWQtde6BZACYU6DggNIkd4xL08GUAMR0yJuF1WeTF40CK5lma1DfD4vs3h4rSrC3KDn2Rs+elulWVi7zjGJOFBv3VQBatWmto5IOW6IdqnFq0zZmLiiGkGpZVoTYE+TbMUdU1Bt14iGb0iKbWV3HXlLuIiUm9OByyCdaq0NZqZ34PYeVnK9NmwOieSaHqtu1KoNOnbpk2qjiOgVcbDWmVQw722OGCVJ1xYmMXORauhSknRt0YdLz18qCJVyTJtpEEmuODRca6lRaNNIK3gMkRKqNWaF5n63hyKXEkGbDWvFebfsKwcVYdAh2YiTTOgsKlyTXSA3jZzePpww1ISBibCnw4i38BDplX2zJjj3gsMeccljWhMhRMw9mxFU6RUn6KmOeVO0MC92tf+xxEL1eN0gbEKDkDCXZ94YqT/BLQmON5y8ARpvMbqg1dxl4e3IZnb23/HT0ePm6fvD5nHzL41B5F2cGAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/kuwait.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaKuwait50m {
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

/// Widget for rendering the asia/kuwait.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Kuwait50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Kuwait50mWidget extends StatelessWidget {
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

  /// Creates a Kuwait50mWidget.
  const Kuwait50mWidget({
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
      geoJson: asiaKuwait50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
