// Generated from: assets/africa/sierra-leone.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/sierra-leone.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52VwWobQQyG736KYc/uIGmkkZRbKe0ph0KPJRSTbsKCs2s224MJfvfidZw6noUy2cMwK40+9CNp5mUVQjPtd21zE5pv7Wb6M7Zfhu22vZ+6oW/WR/fDyfzc3ISfqxBCeJnXMnA+Pjt247Brx6mbg87HQ2j6zdMc8KNrx3ETbtuh/xcVQtM9D782NJ+4LezpZP966bgf+qnr2346+j4/jN39pnn1Ht6yeWyHp3Ya9+9zOSf/fdjuH1+1vlGH8XfXb6YL0afvcn/9F8InTJE4i0BaX7ksOiRgy+/sd+v/8pAYSLjkYU7Omet4FJ0d2K9xGtUts2gtjsnAbYFHmZypDodRwdBZrnE5WgZwq1SLkZOp+gJPTRyz1/LQ3QCtlIsgxlJZXYzIWYGLbtGYPCvUVhdidhFfKq9/oFkgUgLwlMvmY8gEtXIhCgirLgxHYjOvz4+dEwqVPEURhspuhpiP6UHRLhZdFdWkmkeUvMzPI2V1BKzlWfIFuR6zGXGunjZEZcOChxCBxZSqx8NRSbW4rGZgrh5fiiiQkmEp2MRE8QO3lThZUV+PlsQSV9aDonhW9IX8MgGapVqeIrpoMW8eE5Nird7ax2i1tD/vDqvzerc6rP4CBUICXzgIAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/sierra-leone.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSierraLeone110m {
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

/// Widget for rendering the africa/sierra-leone.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SierraLeone110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SierraLeone110mWidget extends StatelessWidget {
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

  /// Creates a SierraLeone110mWidget.
  const SierraLeone110mWidget({
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
      geoJson: africaSierraLeone110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
