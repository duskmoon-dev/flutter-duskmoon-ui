// Generated from: assets/africa/mauritania.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/mauritania.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52Wy2obSxCG93qKQWufou6X7ELg7A6EQ3YhBOHIQeBIRpksTPC7h5Fj46QHQkWLYdQ1/VHXv/v7Zpq28/3dfvtq2v67383fzvs3p9vb/fV8OB23V4v55nH56/bV9H4zTdP0/fIcN14+vxjuzqe7/Xk+XDY9fT5N2+Puy2XDf7tv58O8Ox52z3umaXv4evq444v9/2FdHtffvTRcn47z4bg/zovt9c35cL3b/rQ+PPvyeX/6sp/P97968uT629Pt/eefkT5TT+dPh+NufhHy4+/l++//pukfCkAXZeGr30yMUFVhTL8YPlz9Aehg4sLiK0DzSHfpAjkiJWkFiMXGGF2gRLjRAKQCK0kKbntonimyAsTyIMsukNRFQwdgAmFqkvdziGYUAzCA3Mu57aFpBUYOQAcPyeq3jbpgjVVekiGG4m0gMXrhGlDN3Nl6QANncfc1oHiJRNNDWwILibFtHCyDk7UHVLAI0RhGbwFWsktzUhSwyphsLWRUQW7OsoBeQh770AGlJJs8hhR0yzGFBoLiRc0iM1BgGI5ABSdP0aY2ECx7MMYUKkQVVrMkBO6OsR5xJmM3hQSihTX6Z6BEbE2lQXDDKBqla2l3DrXqAjE91dccFEFN62WwIBDZbBxjA3YljN7UFZghS64FrOla3gvYwCRCda3AhuRZPak2EDKOVZVhpLSmKCxRpTGvagIbYW9ADCqIOAdFYARXTJFeORZxl+WWMfAUytyqeVtQKBaR8SheeKEW2lP9BE+VquHg5AApC/0LXnDJmD+DTELztmCVl1LWCrBExLpXBYKSYNahYVhAFj3oSipDhjLTWGIBTk3pn0pEGaZjjRkiiLnZ08RQXIQ05pBAODCwfX9LNVqrMoGICEvznGtf+zdr709vD5un54fNw+YH2isGRaENAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/mauritania.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMauritania110m {
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

/// Widget for rendering the africa/mauritania.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Mauritania110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Mauritania110mWidget extends StatelessWidget {
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

  /// Creates a Mauritania110mWidget.
  const Mauritania110mWidget({
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
      geoJson: africaMauritania110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
