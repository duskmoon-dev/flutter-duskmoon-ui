// Generated from: assets/africa/tunisia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/tunisia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWO2vcQBDH+/sUQrUZ5rXzcBcCKUOKpAomHI5sBLZkznJhjL970NlnbGsh7BVib0fz4z+vXT3tuq5fHu+G/rzrvw375eEwfJ1vbobLZZyn/mw1X71s3/fn3e9d13Xd0/G5dTy+fjTcHea74bCMR6fT613XT/vbo8PPh2m8H/dvDl3Xj/fznz0fjd83+3Lc//XBcDlPyzgN07Lavlwdxst9/2p9fhNyPcy3w3J4/CjjpPvHfPN4/RrmG3U+/B2n/fIu3pff+/Xnf12XoMEkmWefDIIg6KUYfTBcnP0Hl45IThVckRTWbMERAhYrXmq8NAohbZRXkLmCIxA3tLRGeSaWSKXCcyNljEZeqnqkb3gMGBSk3sQjUGEustXHIBaJ0lTdlRfh4VueAIlllrZ4CQijIFqFxymi3Jq/KBZiWuG5hSu2xYsgklaips+juFJbPRBIsyRv66sggu7SGi56aGXaFEKkoHNr+0kWiq28ApaRoa3pKykctk1fgVRX1abpXccNEVG37WegtJpa23l14rKN1yAys/E0IECOMOcNzgGTCaW1HBRoBaUiz1lRvHU6+CXeij6WNXtN3ZxQMDMrh4uDaGa2VTdAGdN0O7sGqabcNhwBTB6steSpCHlTrLFeD2Je62T1DG/qlABSzKhcGwpWCmkTzaGwatBWmwKmi1tTHRyM2LSCExBVorYrPEAF1Xn7gcHgGiKtZVVJQo4KrqBxtKlLwFIMKwcyAyFbNk1s88fUrrY+rZ53p+fF7nn3D4of7hvyCgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/tunisia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaTunisia110m {
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

/// Widget for rendering the africa/tunisia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Tunisia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Tunisia110mWidget extends StatelessWidget {
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

  /// Creates a Tunisia110mWidget.
  const Tunisia110mWidget({
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
      geoJson: africaTunisia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
