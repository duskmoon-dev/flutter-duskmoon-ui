// Generated from: assets/europe/aland.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/aland.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WXS4sTQRDH7/kUQ84S6v3Ym4ieFDwKskhYowRissTZwyL73aWzD/bRLVjiHIaZqZ7f1FTXv6v612KalvP15WZ5Ni3fbdbz1XHz5rDbbS7m7WG/fNXM324f/1yeTZ8X0zRNv07nly+ehp8Ml8fD5eY4b08v3Q+fpuV+/eP0wuvdev/1Yfg0Lbc/D1/WdDJ9evGcT8/fv35suDjs5+1+s5+b7e1V+97yznrz4Mb3zeHHZj5eP3Xi3usPV7t5+/Gwu/5+96cP6MPx63a/nh/98u3x+Pr53cv7acJcZaQqxKsXNoMVK6JjPjOdPx/b54ooIw+4rpha4kYExYAroIFQ5BKDWPb9TcDQGtfDPUdhEFDymrvY/PU+l1ETo8ZVsXDtczEUtJYO4ahBfSygIXINa44jd8kCUanGFTe1vr9EoGpWzAYl5X6WETJ71MLrngAjbqiKFblsSiwDLrHXps3CEgUH0+ZWFIU5kan1scwAXhOFi2Za313ISJdiNmTGSMQQ6ByF8BKsgDlD+rMGyapSiO+JS0zSVwUqSUJBbY0rpB79+GKAmWCN683dgb/JorUwIKlE9Nd0AoiSiBtXFYZhSKKoLGaNm+JkfVngP6QDaURYP33JkDxr6Us8bkkoijJucQiBQQ2iZC/U9wY1D8f+pDGKZWWJbLkbLkCjxoGlUt9vl4bhnLEmkxUlTEAoozayqIlae7oY3T35YqFVNhv3XHjb4NTKFkVADMqWGCTXypYqsvkg4YVDvFZmFROkn5kYog61pkD/0GugSDoU3fVse4Y+lxU0atVb/1C90chSi80RJWYOqpYDW7FXNnMJ6PfKaOJihSpbk8X/kSjBqm0kaFBCQcC8IiWClbZ+FfoSBUujYsmXhKbRPtdbQ1WrHkKpkf2cB8O2aSpxOT1lkJv/El/Btp/t5yYwYGVD0LCjvSEwuXENqoTu3l//ANEsa7lg0Kr6AGspLDXs30tiLM/F86ubxf35fHGz+A0neNsjrhMAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/aland.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeAland50m {
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

/// Widget for rendering the europe/aland.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Aland50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Aland50mWidget extends StatelessWidget {
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

  /// Creates a Aland50mWidget.
  const Aland50mWidget({
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
      geoJson: europeAland50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
