// Generated from: assets/europe/latvia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/latvia.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52aS2+c1w2G9/4VA60NgvdLdkXRrrroqpsiKIRUDQQ4kuEoBYzA/73gUWw4GU4KRgthNN/Mo3PhIV+S5+c3l8vdy8f3D3ffXO7++nD/8tOHhz8/v3v38N3L4/PT3dt+/J/Xt3+8++byzzeXy+Xy8/l9/cXz8fPg/Yfn9w8fXh7Plz5//HK5e7r/4Xzhb/cv/328//L5y+Xu8cfnf93zefaPq/fl9f0/ff3gu+enl8enh6eXfvaXn/of3v3y9NOXcXz/8PzDw8uHj78exedh//353cfvf5nlF+rzh38/Pt2/fDXd15+vX//2r8uFHazETOPtb56YgXsYl/zqwbdv/x/PGZk0J16US8aSF0EZNuFKqpSWuGRWxxp4gcWctuSVCXLIwEviktrxAtDYpGjiCZq7LnmCRVHT9iZKofOSpxykqSPPyna7G6D2O8MzMl/yLDwsJuuLyoilNQdYlpqM2/G6sEuea9sYD7wiakvf8kpZcjK/UjLjLS/LOQfzc8BwCqoVLwGFUeh6fA4kIoi55BFFBk3jI7X8AzyN0rrej+ZxUW3nSyEidW1/DlQosjttCYyMhhOOHRVx5w0SqMhrnK6QWSy9QQJ5jebnIOnptuYR5rx8Rugl6/miEF8HDwdTC5Rd8EhADKMaeVVpsnX2VeRIPvC8vQ6veUqKPm1voAThzprbGzDmuB2hhK7b8WWS6WQtydqGucVpuvA0vDRR2vmCgETHSQk5pEevw9Y3W8fryVelChNvp+syx6LmmZtuY1sQ0bx8FYlbZ9C8kBx4LWp0rfwCwjnq2loCSIwwtkooSW3ypQHk3mF+yzvC71oJBVCpJq/H14s3hMoA1gi0nbMKSE4nGXklQridb5RPQjxAyEuXrjnAg8PkWogHiCfRMnQEmKQHTTzlitzzbpyOAMPjxpY89Qr2a18fYKzI6/WTjkSDN2he7kOHsJsPobJxppnb6VJ2vJlOh0mK4Naa8eiqkRcZtnTODuWOZNN2OBbJMlQ6ZFXiEDyal5G1zlPpprlkBuM2jTZhp7iWBr0fhGjb+arzrf3Vvfdz4F4+n46vYzv73fF1YDKc8ugAdw5d1w1QWkFNvEgz9e36IRmLTuuXpKG+G5+1lKTZ26ckpewS6U6XZXT26T3dnfUZxNGR02yLeng7a+nSVB/eyZqLkXw7WQsas95W1Byx9M0GojgaX+fDR8MteZzz4U1APSJ4yzu52bWxnHydeb1+HB09Rh62HW1xll0amLajnJTXw+MTjGae5c61GNBJAm+sXhvSlkeEMtSEEtCl7W/F064kCedofai2zWMU8tQJJ2dQfyAUKURX6EahW3mqn0ueWmb6FHoLozXwkifzZNOdnHdHV0GYzXKK4xmdb+7OhoIcxzeNL1LXuuVMtnKo4MQfKkEo6PEg02bImiU33F4AG6Lm1pCPLp7ytWChZf6nndRyjYoF3TsWr3gCJZ31TDuBmFpLRSDgGmOC1ek9oerOUgQ4Q2aFi1lrxSJAnef5pAmETyq85KHEXC6Q1yrWCsfgN4pLAVYmW6/C4KfyOhmzG60r6wxmx5dPjoCVPXZBkqGPgA5RrQVzd+524yM4jYkb6xdptBsfQdwM4hZY2+NBNztPbX6nRbjldddzFPQs1kXtLQ8NY4jiXf7aJ2wEcnCje6Fumm3HxxbKQ73FoYTDZacKCPCGBu/isIQsy1UEeMOeHVzcgnfnlwBJu7w+8Niye+hbXtuYTNVXDERfpkQEQupTY9aBMkl0u79up/868OS1kLo9v6/t64nHVrHMORhQ+UYnUPFY+paXpyU08jxkWQBjELeiaXulzsC37j69aGwmSBjWMklgiBDWIRw1L7iW6oAhwyxtcgdSrtvjwVB+xN/ES9RtY1baXMpz3A9W3LoDAaJK1nH9BLvts+WVjRUSB/GgbfNEwIl9SlJ7fJIS2/WL10Mw8tRpWd+Uvh1za3xcvPRW2hK5LxpM3rmMt9FIgRjjBs+VLbbjE791b4G71rHmaciN1ien4rKkoWBcXbEal+9cCFnyvKpF7Xh6qRPOJe93vNXruVnyUmms/jsoEeVSnCoUzrfAenxJ23sLCqWSGuP68fGzK54Bdu4xijXGcw1syeO+jCHT+lGXIXbba2DZYnK8hSNIW23a5WHpkvfEQ811OTfDxYc6RFfdVWTdO8ETwEaeIolvezv42oEYeHl6tkscY41K6Fxp7KbPljeWXQzCULcXJFuNnXbQxENJzJ0p902gWUf2fVVWWhb81vdp30yvP7/69Obz72/ffHrzPwT6j9P1LAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/latvia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeLatvia50m {
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

/// Widget for rendering the europe/latvia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Latvia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Latvia50mWidget extends StatelessWidget {
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

  /// Creates a Latvia50mWidget.
  const Latvia50mWidget({
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
      geoJson: europeLatvia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
