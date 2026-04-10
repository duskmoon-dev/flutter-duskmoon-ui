// Generated from: assets/africa/rwanda.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/rwanda.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52Zy4obVxCG93qKRutJU5dTN+9MIOuQTRbBBDGWjWAsDbJCGMy8e6geaxhbJUJpFkLq0/1Rp0/VX5f5tpqm9enpcbt+N61/225O/xy3vx4eHrb3p91hv77L5U8vl7+u301/raZpmr4tn5cPLrcvC4/Hw+P2eNotD51vn6b1fvNleeCPfzf7j5vX+6dpvft6+HtDy9qfF9f55fr7twv3h/1pt9/uT7n2/tNxd79Zf199frXj8/bwZXs6Pv1oxdns3w8PT5+/7/KVejh+3O03pzfbffl7+/3nX9NEMYtpCOPdTyu/4MxuHqA/LHy4+18emwUXuAFhKl3cUAt1r3jqoDq6PMAr2xWwQRhNHguqAlU8NDHHJo/UUUdlnxKKUxOHoeKVdYYR/d3iYFK0gueogO3TRQqOIRVPgYT79oFShQsfYsBtnMPQuODRjIzO0jaPUcZlbNCMIYjWPlzQMaTiETMB93zP5/AQgctYo5mRLHpvz+dASmmpcAaMJE2em7LapTPTPACobZ6LKda4oWphXV6k91XbFRHpKlXyMjQqnrKAeC/WfA5CMyt5ns7SDQ7AwSKXwUazERAO7/LIFbm0T0f6ZZenGaNa8RZp6SozAkEdHRKpLW1emIiX9lE/PGKmMDAo359xylg3s41wGJdaT7MFCrS1mQOIxyh4Di7B3fMdqQZYibODc3i3MlDBK/JiQWbc5sW15GExjLSbK805d1XxVFN5mjy/UmnQbHgTLyjrnTp+dbTPI5AGUKmnw5Wp6y/BgCZlduO4QV/CeLBV+sdsCNHaL8MMgV7VQjQPRKGe/zHMWVC4lPktS1Zs+V/yBl3lcWhP75PnzFBXG2bQPA+GrHnMo/I/HosydnkGEXqF59J+fwN8XOEhhXvXvuFEpFX+YNPsZZo8oez2ynItREFa+Sh5wlfy+QCAsFZ9lbxglqj0j0OzsmnyVBbZLN8fO/U6N4bZcPjg0p+Vh/X0PnlVJ5PGYbc4TdjSe5eHq0uV3uQ5eWpcKX5+w2Zdstqo9ksqg9r79dxu+f5wLG7U5b2ksIIHY8Bovz5cmoWqUVUbDt1Yc1Bjr6YuLqDO7eMgywq5mkIEq1B/vyRh1dxAlLP668cGQYUb4hrYPV3D1MtqTHKjtDAGF60HznzT8Qo4QtFq4Uzg3UY/U4ctDVrBQ15qjTbPytYIZ3AGsG4ql8y8hbrgDLoUNV37dBl2lbz22Cp5SFy1Rsm7xZ35pSOteDa0X0pydqpWni/eYh9ZuFPJM3fojSKSB8sAqPJnGTmYbPKwCg0mhGZXmah0h3KEyOpd5csuIUComLpgTpnCqDdlWroYqLosPDt5l1eS0ou7/ak7lvVUivIyCu/yhnrRXuF55N7FZYSV5jGL9McjCqFahQR7u/vr/xtmVX0/f3tenT8/rJ5X/wEvZTsJLBsAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/rwanda.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaRwanda50m {
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

/// Widget for rendering the africa/rwanda.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Rwanda50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Rwanda50mWidget extends StatelessWidget {
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

  /// Creates a Rwanda50mWidget.
  const Rwanda50mWidget({
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
      geoJson: africaRwanda50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
