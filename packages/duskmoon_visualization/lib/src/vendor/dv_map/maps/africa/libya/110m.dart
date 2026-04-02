// Generated from: assets/africa/libya.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/libya.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE62YTYsbRxCG7/oVg85LUd8fviWBnHLw1RgTlI1sBGtpkZXDYva/m5G9i3e7DykSHYZR9/TDWz1vVZf0dbMs28vD/X77Ztn+vt9d/jnvfzvd3e1vL4fTcXuzTn/8Pvxl+2Z5v1mWZfl6vY4Lr49fJ+7Pp/v9+XK4Lnp6fFm2x93n64I/Dn897J4fX5bt4cvpzx1fp94N43Id//XFxO3peDkc98fLOvfLx/Phdrf9Mfv4LOPT/vR5fzk/vBTxpPrt6e7h048gn6mn89+H4+7yU7TfPz/fv/62LGyAN6/HGPDF0IebPsPAk+0/YwpY0k17JIVAxHhNEwRUpWqyysJ5wnInb6ISOUdZBJjFPVkG5JqjLALzou52FRPphJVV0otRoDhsQDEguUcT5VgkExZlcFcWi+cMVaS9nWfI1RETlktatlgEplwzXanCLRRCmtpoCIZA76lCIJEafcprMrZUUUEyyvgOCcIoehuPgCYyeguh0qLlByqwUBwtj2Bs7RgxXWnCYndpxUgJyIQ1YYWLtfKHHJxoUrkIKJlaliCDIKlZiZDwXi6SAav5LK/ZDXu6BIpymthBVD1dApjCs8TOyKYnGNxFRk8wRHH0YiTQzMhJVRUg8ape0Vl5wmyTTGIQz0KhFg+hVCOnBQOTkrTnWwQXL6RRH0E4Kfc8UlCGzDa+jKt50Zs2WcuQW0x4COWUQtqUF4gUM5xJCfeOpwJNJqlZCREMM2+93IJEc9Eh87lAWV2yGWxa1XjgcUJZVVbLKQWekqmD8TiBVCl6xbcgzIlzjDXAM9myZZQC50Ib6gkHkGKZtJq0giDntHHrHIyY0aWHEyolnOGwtO+6IvQaiycbyNq+a3PrSpN97P3WVlW8rNeU0mp9SfUhKVhBooSktXmEEEHiMoarYM4m3Kuga9OO7uP5ygpYUVi904egqmzmPQENcu9lLQlY0pruEx4qGvaKCimQSsbY5zCDFnH2miaFtIlXGNK5WllGBumYw8mz7htWtHtfnaUEgZZhr/cVSAkfWGsfm9g7X1fWGCD+D7/5ERAFW9b6d/8/bGb3T3ePm6frh83j5htlg17sGBIAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/libya.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaLibya110m {
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

/// Widget for rendering the africa/libya.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Libya110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Libya110mWidget extends StatelessWidget {
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

  /// Creates a Libya110mWidget.
  const Libya110mWidget({
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
      geoJson: africaLibya110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
