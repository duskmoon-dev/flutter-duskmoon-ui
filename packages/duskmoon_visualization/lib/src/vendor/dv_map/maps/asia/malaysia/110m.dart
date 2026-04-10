// Generated from: assets/asia/malaysia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/malaysia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51Yy2ocVxDdz1c0szZFvR/ehUB2hkBWIZgwOBMzIGuENF4Io38PPbIUWVNauGbR9O3b90z1uade99tmWban+5v99v2y/W2/O3293f96vLrafzodjtfbd+v0v4+P77bvl782y7Is387Xy4Xn188TN7fHm/3t6XBe9PT6smyvd1/OCz7srnb3d4fd84pl2R7ujn/v+Dz758VzeXz+x8uJT8fr0+F6f31a535Z0b7PPTzb8Xl//LI/3d7/aMWT2R++Xp0Ovx+v7j9//9Rn4OPtP4fr3enFNz/+Xt6/Hl2Ol4UQAdPCvN5dTDqoq2bpq5mPr1/tcQWdHbnDRUVzyhkulQd6g2sgxFrsM1yzUIy4xFUID04c8uBlKqaXuAIlRVIxwSXgEJNq7BXgQC4a4kqhS9olLkM4JskIl8FCnDoeCMqDyEb8ChhVYDT2EjC7yMxeBeZMoh63BHUkXwXWKKHsYF2IlGhGQ5p6KHXbZmQ6ZhdZtWOXIYqQcuRtAsqlnK16JTk9R/QKiDBxExwEgt0ramiurFGyoUGBkhzNhuYmMal3uGmGOFMDQzkFds5mYKxaNsSVINJoVOZAnIxT3FX3nRocmMnFR7AEScpJTW4zSMLEHHkFAZkyZePEBl4kqTzDxTAja+TgwKjpMeIBga2svJGDgysnz4LZpHbYvDX64R9/uo6hgExG0cYWBZKV18leU4JTCmOz1woaychDXJUKbsuNcjfKSaSiAiL0klaaSL466RA3qVBaV1KMFJskAkoQjdVlOtzA9LKJNCnAszCsiVQGlaGFE1dacVWkpC1rdY1VPpJDAHE5extZixONR3pwCDbCht4VViNmXrGGZWyrDQdSoaKRygzUMAibPGugGsE1UsMqUQvsaFAoM+YYqddW9Wq3aQpCPsxbpLDq3qI1VzRlVoOTgp/zQAeLGC4+YlfX3ITkLa6xZchIuwJBXG+0TlliOGpNiaHKnLpUIUDIUjqylyDKi7PZNoZMy/JJlUgEEojZlvZeISgjGgjIM62xliANXXwkMgQpJ+lx3SVCRw1ZrYvZsaUB0XVkLhakILM3iZhAJElsSIORomMjMoQIIZlF3rX2LJJoEjxCha8lyVS8Ydr1/QiFqjoL6QySyNbV4ARKSDwKkQxplVhNHibQilGfRwKJltpFSAKmlZ9p4GUS6w8/VNBztmkGJIrSJQqGZNIcHbKRrYcqGNlGXvJiGTVOZJBuRtHsmq7nhWY1rMqQjEnb/lxWL9Qh7s83FZu3Rv/fP909bJ6uHzcPm/8A4gdnf+sWAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/malaysia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaMalaysia110m {
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

/// Widget for rendering the asia/malaysia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Malaysia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Malaysia110mWidget extends StatelessWidget {
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

  /// Creates a Malaysia110mWidget.
  const Malaysia110mWidget({
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
      geoJson: asiaMalaysia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
