// Generated from: assets/europe/portugal.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/portugal.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWS2vcMBCA7/srjM+pmNG8cy3tOZTeSihL6i4Lm3XYOIcQ8t+LnWxIIlMYH4SssT7PU6OnTdf10+Pd0F92/fdhOz2chq/j4TDcTPvx2F/M4r8vy/f9Zfdr03Vd97SM7cbl80VwdxrvhtO0XzadP++6/ri9XTZcjafpYbc9vO3oun5/P/7e1kX6s1mnZf3HB8HNeJz2x+E4zbJvD/Mv+1fp85smu2G8HabT40c9zopfjYfH3audb9Tx9Gd/3E7vDH553s8/v3XdlyhA7Gh28UnCWNxBDPSD4Pri/zwvEWAevMITJpbgJM8CXKiu8NCZKI1TV2+1g2IKSh5Za81ISFZ4KEGgmOJFAXYCaaylKCYCQVkes4Z7rPAoKmhaP6k650TD82JkXCPLq26s5Cs8EmcXT8bDKSKsiQd5qaqV8+nCioBNvpAVFSQWyeoX7tIUG2lxdYegJI68Oiqu8MLcHXLhsOIiim2xzfqRV/WcuVZYyKq06WIFwswtd7hYETIEacNrhasHcM5/VlBVwNrysOJAHpxLFytQozq2/vMCJqacjQcZQ9Q1HhmBeNZ/EA6kbf7NbQDAqmXjG65U2/KIojXEsuaCqgS26RLFED0wbW5VRmrKYz6dnaVyTfHmImXAaNKFoRCBG+a6hxYXxNqGY+5tiODJcGghD/DVXk6OjsnTSouq60q5LXcDItecvVaqIEHrPiyBTpxsRnPNz8AVnEUF45z3vAASGjfZt/DAPane3HFo5aznWqoDq2fVU8NgaVol14LE6smLVfrit1mbn2fPm/N4vXne/AMnfeFBoAsAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/portugal.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europePortugal110m {
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

/// Widget for rendering the europe/portugal.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Portugal110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Portugal110mWidget extends StatelessWidget {
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

  /// Creates a Portugal110mWidget.
  const Portugal110mWidget({
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
      geoJson: europePortugal110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
