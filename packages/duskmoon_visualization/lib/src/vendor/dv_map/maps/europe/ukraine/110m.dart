// Generated from: assets/europe/ukraine.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/ukraine.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VZy4pbRxDdz1cIrU1R74d3ISSbbEIgq2DC4ChmyHhkxvLCGP97aNnj2O4iULMQV7d1z5zuqjr1uB9uDofj5f2b0/H54fjz6fby7vH04/n+/vTycnd+OD5by39/uv32+Pzwx83hcDh8uH7uD15/fl1483h+c3q83F0fevr54XB8uH19feD3fx5v7x7+e+BwON69Pf95y9fFH7b7cr3/y29fL7w8P1zuHk4Pl7X207v1H4+fVz9+IfLqdH59ujy+/5bGE+9fz/fvX33e5hfU8+Nfdw+3l6/2++nv6+vvvx0OQhBpVazPvlsxBkLyCP9m4cWz/8dDKA7TkgYPlcVEh3hOpaY7P4JkTnQa4pkZUXCDJ1SGYkM8shCXaPCUnCRH++UCXqeXLT9PFp3hJVRxiu32IHBk1DGeUzhxu1+OIKkhHq9jsgbOgpljZF4OUFN0747PigVn7scOIlGW3rmfMGfGCM9AOCKjO74idBtFGyuYCaF31s1MnQUHKyAaRmTnLBRTXxEwDgzs4CxSTcf0uCptx0MIvNp9yK+YwxotQFDWTJrxE1B2w9y1CkEwDS1HeAxGqYb0PZ4WaHiEzPbLEOFKWQ0eckiZTPlZksQWHAsvLWS6XU5MpZ1eQrJJMQ/xMM0bc2iCMrPrdLuumFQdPzJkqbE5CE1o5xeQyVRDKRUgZRbv9ovlomN3Dsey3MRFAyrNKkepkhUUGc13d154lBEzf1FId2lSuQaEhLFNtZkxQqW1RxGaz+TPoNRKqeNXGaTD3OFAFWrY2ZcZM2nmz75KKxHf5PQTXrDP4s0hLZJly+Wa19KFcGbfAGM2iQ5PPYhq5n8JbGXqW+69xq+ZD/UlwQOzaPfnBKIkHcZHATF77aXf8j8tLJvxK0DDbMwbYITMM+8rUDIS66JX1F3H7MzKQ3c8h+K05Jn6FRRmGu3bdfBQcZzuN2X5bMfP2IRnyVwQkNWbSlIdlKXEp/zCqhrxcxCtypjCUaCb7MnNQaLYedrHYDDhHmsORqt2mdFLSOeKvU1dpyeRWTPtSyiRoEZbHNgyBafa4rYOfednUFKVPm2LNI29OjwrLxz2RQksYtZos4Fmcspc+yqiOjxBRcFp9JJWcEvPtdim3uco3BS6Blwis0QkCBLhmJ0zo7ASjg5PEEIzNDupshRCnM00CDxMsNWCQGedjTQIQpUU97pvdcMiGiPbigBXmkeHh4nTOlIEVKwyd2U2qKCimI2YBLxKvc0cTGXBM3dRUEJFat0FjYZSKgohjNRri5v7rM6VVTdTFHfnF56UQ34GSOzWBVtIBM8KA1EoZ9H2+DiEymfuYpAsntpJvauVD8PDV+JN07bQqAzEUSqSAGUjadsYZGbG2QR2Fe9i0pV9hExZM29eVbMRcdcFmrriLFNKQgTabtxYPf6s45CCkORoBhCrY8uSWZaUgizbZ4erH1oyP8TyUO96l1iF5QRLcelktHMbwVCukSAvOK+mjVxZk8bmtNLKpmkpKHZ1miWLBFzzzKapKigyd5rxC5AStb1QWTO5XCOvmdg5ODt5MyJFYDarWeEjBmJO1AysESxidfxTvIjaTm9NSENqLOzMlLKj0RqVWPBM6RSYNWkP/oVnVjUrQkWBlCqaeSuBuSsN3+UoSFEIdsP+8MykWaIViFXD1+4rDCKGoTNlXwNDC8fdlxlYUt1m+2VQYrS9kFp4mT6brwgDWTUv6hjQicc16Oy15E13/XT18ebp88XNx5t/ATLaMKA9HgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/ukraine.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeUkraine110m {
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

/// Widget for rendering the europe/ukraine.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Ukraine110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Ukraine110mWidget extends StatelessWidget {
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

  /// Creates a Ukraine110mWidget.
  const Ukraine110mWidget({
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
      geoJson: europeUkraine110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
