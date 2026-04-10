// Generated from: assets/north-america/costa-rica.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/costa-rica.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWTWvcQAyG7/srzJ5TMfqWciuFQi+l9FpCWVI3XUjWYeMeQsl/L940IckYinww49HMgzSS3vGfzTBs5/vbcXs+bD+Ou/n3cfwwXV+Pl/N+OmzPFvPPx+m77fnwbTMMw/Dn9O43npafDLfH6XY8zvvTpqflw7A97G5OGz5Md/Nu+Lq/3D3vGYbt/m76vqOT/Ws3z4/zn14aLqfDvD+Mh3mxfZ6O86/h/c14XLD/Fj08u3Q1TjfjfLx/7dBTBF+m6/urfwE/w6fjj/1hN7+I/PF5OX77NQzvgkDFMI3P3pgS1AxZ4tX8xdl/eAwN1dys52VSBmGVJ40Y09/ysAGnCkcZaKqGuAZMDjcpAyO1qegK0MmCswgUwGzo0R3hAkwWreJYNbnFWsCZRGpVoDk3y46H0IJMnaq8bNwadyW4OKjEjaUGVFDDUFpxkNARs+iggiOptD7DS8QhIlkFpqCTykrEkUoe5YhNk5HXitpVmIslqOCJ3mKNJ5zMznWgi8haES4iE9UiVDBrHtblJCGZWbzYJQrMKRErOhgsKlXdUkBsSdylOEHVG6eXmwSRXbquS/DUTCyrQrqatbUSbGFO1ZIRcGTWXmYSskVTLPaIgImbSNfFCYaq7MUWEViEpPW6nyDhrEUcQ7ZcyrbH0RIvFfPLYEwmuMJrihxavoc1jbEr54DgJsJFCWRwRPGuWgJMLdjKOG0h7CvuiViSFdWAIE29b94AIm1UPDuCREa3lWiFWLF6wREEpXvrSi/AyCi12LsEYbHcsyvJbU5mRXEmcEwMxp6XpMs1UD4/ctQ1rWouzK0oLQTJFNm5lyBugeVs1P54N2vjp9HD5ul9sXnY/AWccM8MogwAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/costa-rica.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaCostaRica110m {
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

/// Widget for rendering the north-america/costa-rica.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// CostaRica110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class CostaRica110mWidget extends StatelessWidget {
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

  /// Creates a CostaRica110mWidget.
  const CostaRica110mWidget({
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
      geoJson: northAmericaCostaRica110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
