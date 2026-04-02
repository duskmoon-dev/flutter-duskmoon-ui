// Generated from: assets/asia/israel.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/israel.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51ay4pbRxDdz1cIrU1T74d3IRAIZBGSZTBhSBQzMB6ZsbIwxv8e6spjbN8aQnkWQlLrHqq7Tp8+VT0fbg6H4+X929Px5eH40+n28u/j6cfz/f3pr8vd+eH4oob/uX797vjy8MfN4XA4fNhe9w9uP98G3j6e354eL3fbQ08/PxyOD7dvtgd+fvd4e7r//PvD4Xj37vznLW1jv+y+5+3733/7cuCv88Pl7uH0cKmxH97d3R4/jX38HMXr0/nN6fL4/usYnoL+9Xz//vWnOX7GPD/+ffdwe/liste/L99/++lwYF0h4ET+4tsRXoJqzvHVwKsX/4fn4dqAsaW7yhSMRbwNjpkMnYZ4Rk5i2OCRK0hMJ2tASdnFRwJGOoRTT0rLNjyUkOnyKZNidumgbbY8xJNkNOmWDzElaBqfIBJDFx+4WrAN8Rgiwrp0gKcKDuGImDmjg0vMpCn7EEKTW7xgS5wuH7iDwh6PVppj+JR+ABqa0uAFmSHO6CIrCTsxoGU43x2yAjggrMHDNGbPIZ55CO5XD1ekOvCMLbIkOEP2q4dLkyh0xhZZ4s7SsAWXhoTxNBtKgoT7zYtLBU1hxr7C06JLh0dqLDMtlcUKmMoNHhu5DHevLJZody+u0mzMKV1IlJH2dMZFEAwwni+Fou7pDCtzW4opXwDSrcML8uAx/SJTcE9nWJpGkdN0KHoRusMDZ5+zOa0TF1giBiJjMdBem2FhoqhOp+usoHuxolwZBIzTdHgiIu92B+UKJISc7t6wDBJq8NQ4cXbyykqQzrlQfpIxn+JtD+3SW+GpAuXUuQBxku7SS1l+FQzGR6Vyc3ZUNtKSxqYZLDpjVWxxj4AZm3WhoAF2WlAjmWPncnXb7e7YVHEcX6BIt3s5hMnG8W1+ohMDgsiYGit0Aeq16sqjIR6xWXf0wjLnOsuneOmhbXoDqAqcIR4TYJ/eMCAYip8urvPQOzHNIJqXgVKL3uBhEVMIp9tDIM1aZ1CsHDq/goMqVjo8BkWfljFCrKz7dOBiklCe7jYp+9nQpfCUE8bxKTzj/ORawI7XL6r66fCCEmGqBuRmBt361UoAzQ6jqtsQHbv5bvt6qM51WHr0TpIVGYdyJSsCxKLjM1/PlSmekyu3891M13S6m9vu0qFs6jQuK7U3uljtGMqh9dMFLL0amJe6jM+i1howPjWzpmQGdoQuGeP6HrOI0kK5jXmnC69dqa6CRvNhAbh5Kuo6kbiCPXlcEOUzp9A1vKlMycpqgVCLd20UjXnc9zNwhSDpHK+qPOgK6DArgzRev/SuWYorax3GJUyWk23nm7nZ1TEectftowXh31ESpWpqB4cGyXPZy1TEDo8CQWUqBFAPNbuXFnPgvFkKpsC5Ty+tawE91r3cioQGT1lkXhPxs+0+RRrLgVYXqUjR4YGLwzQfxT1sTl2qNjl8h+sDMm7pLArjfpouia6CLjjAskdDOFUUk266nKrg0/DUEmQvVtUczhi2g+rmpLe4tOzqLqd4WXVAG57FdyTXnrnpoGVBEDCN77mLMVpOkVOt327tGKTFY0mkaXzBTMHdfINgKs11SYlh1GlfuKYO20u6IryuIxu8FGGPqYUMTaDG9FEdomw2pUuIQjQVTN0Uidn47AgSh730cV1JwfjaLqoa6m7ZkBl92Gl+niu80NgBp8oSZCHR3aLidiKP44Mw9L22cDX+1cc2PACAo72EVkMal+MeCtTeylbxHDEliycpN92qunQXBB9rARqSdOvHhuExXr/ZfyzcdO+f3n28eXp9dfPx5j+l7lbaVSIAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/israel.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaIsrael50m {
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

/// Widget for rendering the asia/israel.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Israel50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Israel50mWidget extends StatelessWidget {
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

  /// Creates a Israel50mWidget.
  const Israel50mWidget({
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
      geoJson: asiaIsrael50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
