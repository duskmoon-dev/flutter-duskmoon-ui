// Generated from: assets/europe/norway.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/norway.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VZTWtcVwzdz694zDoV+v7INrS7lu5LKCadBoPjCc6EYoL/e7mTOCS2ZhGVejHM833vjJ6udHSk+2m3bfvT/fvD/uW2/+Vwdfp4d3h1vLk5vDldH2/3L9by35///WH/cvtjt23b9un8+fzB8+3nhfd3x/eHu9P1+aHH27dtf3v17vzAb8e7f67uv96/bfvrD8c/r3it/VT1bEGahTfH29P17eH2tNZ+/rh+cf9l9eGrIW8Px3eH093992Y82v3rx5vT9e/Hm/u3X971K/Tx7q/r26vTNy/9+e/b70+vnl9vGxmQcvKLZytR4KFCTxZeP72zwRQISruA6Sg1wqTAiOeYiYCE6gNMBFU16e00HtlJwMxCDWZCesn01b1FRNYRpIJ7WYcZEGJus113tmoxJVEmmAZFQtZgOkSgTjADiNqAd0gsnQR8gJVqt+kBLlGT4EzQoOjsDEh2nwRnAXJIk0SRYM4DM5nAVLLLoYQyp4k7E9ioxSwIpJjsukMVZhNJiz8Mc7JFBsZsFzDJMUeYP8jHu0tX3/3aj9YFIaBFq9xY4gVmSTjZW0FANJUupREonS0HkS0EXKKU2uKqSWTEILwTyM00umAkoDQN1QGugwSiVpeLCJXOThN7FUzdVDo/EKCglk9wBZAllDs/IDAyBg3CnQkkUsn7fWMz8hr4lwooFbmLBy9IClXlEY2oWHF0uItDhdEm9KQQTqRd+fSAJHSlCUUxiKWoZ4NrkFHBNqkkCMYRWB09KGg6Sg6ESYKZKFFTSl1ATREnsEtGcCF2u8bgpBoDVIUqxsjOWIIKrBqkhIFgsmjDkLbks7DQYMcM3C3FGhdYgmWS2SDRAlAztMszS8DIzEmeJUgythtmCULCmZM0Q1ji1rp0sAL1ShywI9FZV3k2gtoS0px0xGIE6slBDSssc4WlZCL/GQRR3DpWQCCKEp6IFwYXIvWmqvm5QltMqhrROdNcO7YhyPUuPAkHghI0r6aquQBxCsWMdS2qpGstXQHdeZLCJGBBRd4RjgJqEY3aF4GiKuw69kXmaso4cYOArVzrRI4rRAbyRJQtjYyp1PWF7kAlOWuPfOEGtZo3QJDVbOIHh/DM6OjBE5CkZCLKKCC4KKlL44WLZqM4C6jlw1Y8LZETUjShnYKMNKveD4pBpQNcRkA29k47FaAbSU40L4KrWXGPS+g8kg1MwKol3rdWEqgjLyyp5yzRR0MqhdKkVRFw59U39LhFrJOOnPU8aYpWQia41uKOAa6BZzFxxzoFWEwkE1wHivILDXGycQ1yjde8jbm4Gx4hkCtNBnxcgGTWta1eEO5aNJBlnGBFxW0srFTTiAnzcoFUdZOUlWjmNbB1NsHYXbr6T9MUjsVuhnZhfm2uaBOKMlBdU9eGqRPXb4riJOd5KYLFqS2uW9CMowgKo1QbjsqlzcNjFO5rxGPVZlEiWK3uZlK5A8QTqVNGy17KLJ+MERLUmV26CXxBWmXisMJWsHs3XitIZZmYuwpsGGU7XSsw92SZ4K6pkmrbh0SBIiKNpmAGxeqGvRuMImWSFaMs/p8YRSFY6cLxgMmkO2YBTmpHh6uVr8l8gBnWBKA/vVIbtcWMkNT1xLEODtRnxKTk3dgpAkpsRKIIwY4XToXW6dXInVoo/barjg4DfzyULof07um3h93j5+vdw+5fSrYpOM4fAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/norway.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeNorway110m {
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

/// Widget for rendering the europe/norway.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Norway110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Norway110mWidget extends StatelessWidget {
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

  /// Creates a Norway110mWidget.
  const Norway110mWidget({
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
      geoJson: europeNorway110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
