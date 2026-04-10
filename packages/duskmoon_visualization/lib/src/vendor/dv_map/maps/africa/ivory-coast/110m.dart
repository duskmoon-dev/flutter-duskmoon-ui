// Generated from: assets/africa/ivory-coast.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/ivory-coast.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WXy2obWRCG93qKRmunqPslu8EwkF1W2QxhEB4lCBy1kZWACX730HJsHJ+GobRoWl19PqrOX1Wn+udmmrbnh7v99v20/Xu/O38/7a/n29v9zfkwH7dXi/nL0+P77fvpn800TdPPy3VceHn9Yrg7zXf70/lwWfT8+jRtj7tvlwUffsynh+l63t2fXxZN0/ZwP/+74+WF6w/Dc3l6/um14WY+ng/H/fG82P76cjrc7La/rY8vznzdz9/259PDn648+/5xvn34+jvUF+p8+u9w3J1fxfz0e33/9t80vUtArlLxqzcWQmB0E60/DJ+v/o/HXCJBKzziQkZp8gTLye0tryCyTLhJwygiiZEm4czSCzYghQlR3+ISLCxQu7EyilbWiFMz7QfLVag5SJsg5KribWUpileCJRbhzC4uMVAGYQM8g6KiiVMprlzFOSp3vdM0VVvBSRljdHGSpkaDFA5FlIhdKRw5E3nEqYe5dhNFiERjxTsqQRFqVkWVePEajp2yqWyABZKNOIPAEONesAEmFWRDgzIQElHr4lxMPAcpDCiTrLp7F8RkNRSZgriaW7dBGWUpDd4piCRnWgvnYJzhNeydQqBhNqvCIEW1fMW7KgnEXqIouFZRDHtnQJ7s0sUhZlINLcCAopKk19xlKTJMXVG2Urms1wIY0px4cG7ZOtWwnhIMSbhU2UpRZKFRrygEWFUChzxxYEMN6qUdQ6XYWmuXqMDmhMJgzpSjrglM5dxMYobk0HIZRwpXVsceTsCIsoYRoKAQhb0rRCWq1lBhBeksqr3utHQNZF2Znpwwu6OiQkRljqNnQTJVam/nFMrUTQYhlsnTOKg53Bkoquh4ZhOCLCePt7sdLafioMUyaTObaa8DOKCh2hoOy6WbeA6MxsxD5hGCsWKfpyU1zu2EoESCzYHMwd3Vcc09FVzaV5OXhoa+pi5JVknPvwBnDhsrbeFpsDQrNyCrLCvXsqVCknul2/7O26zdP989bp6vnzePm1+8TGDRkg8AAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/ivory-coast.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaIvoryCoast110m {
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

/// Widget for rendering the africa/ivory-coast.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// IvoryCoast110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class IvoryCoast110mWidget extends StatelessWidget {
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

  /// Creates a IvoryCoast110mWidget.
  const IvoryCoast110mWidget({
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
      geoJson: africaIvoryCoast110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
