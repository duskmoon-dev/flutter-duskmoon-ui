// Generated from: assets/south-america/peru.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/peru.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51YTWscRxC961cMe1aK+v7wLYTkbJJjMEE4a0cgacV6dRBG/z30yhKyuwlU9jDMTs88qrpevarqrxfbtjs93u9377bdb/ur08Nx/8vh5mb/8XR9uNtdjuVPz4+/7N5tf15s27Z9PV/nD8+vnxfuj4f7/fF0ff7o5fVt291d3Z4/eL8/Pry+vW276y+Hv674vPLr9Fyen//+duHj4e50fbe/O421Pw4Pp3+2n2/3x+uPV7tvLz29GvN5f7jdn46P35vyYvv7w83j52+uvoIfjn9f312d3vj8/Ht7/+O/bfvJC7LExfjyxyUFrqT0+m7hw+V/AwaClKLqhCcQ7lZkXTwv9mRaASpncBcPNQLTJjyGYCNz6QImiYbFApDN07XpMYGSuFouAEU5kbULGKHhuLKQvCIreoAMwhbpqz1UUabs4QlgoBTPJGQQzDJteizgVoYyG0jAjlrUZI0CMUst0oQAkVO4GWQFVXLE2UIEE8ymfQaE7qwrOLRgtKZ9BhLCLLPDCGSM0o2xAYsE80xChCJS6gqNgalWLfKOwJwcq2mhg4tJqSxY6Jge0UyTgJQo1DmRBRAFGZtBSVBDz5W2ZgiWexfPpbJiJf6mEanUAyxgNM6axVqhrIiz6XGBs1bUykI1pcqehYmAnIVzSBREHasNp8qsS/PYgpvCNfC8uNQXgGjF6T1SJwKlImmtOMNE3szjRBBkc5wtFFDUNO+FOAmwyr2WLotLNUmYo35iKa8AQzxc2y4Xu6jPpDHwQjPvCUMSsFaVz0rjQOIpfdqYhCbNWuhgSu7RVIaCcLTImdgBVCqKTbUuULVinLUroARTpFnia5CjTGapSZB082hamIDFZDxnCiFIRFC3xscoylQ8+0wMzBzkzTLvwFastOhrBExsNFFdRGUZmrNCTJb+AOCAWIw2B4YUXIeGNUM9WofIXLQOZMBunty0UUBVjReaQw5iJd5FJFBn1EVhoQBx0eymIIGEseEiMgEREtUtpoPG56I0IyaIRoX1IjOmR0tVWezjOZ28pKe1XmCFyrLcR0tEol5kPEfn4WILrx0M0aupFF4gWeGLqk8G7kjcbCO8gBxFfbGPBsJSIX0bpUx0kTOjFROq5kQw9lEz05eIaudK3Ubk4mWsBRzZU3o54wmZiFELfWTIqmhHJsHdMGrhNY8xQxDbsR7CE7nQR4QyCtH2CQTW0IoFHwlosKeZM4Fgmp6r2WrMu0Xa7EMDQZOyZK6uBVpI1GzkhzwiK/HcQxECRql4E5FHq5y1OCYZiCbWFYoYDBGU2cTBAaSuOIYAswfJLGU1yg8T9w9eyGRVWUd7xSnSpKKABaHV7HKCsqo2W+UQqAwWmzM6wFiSu1O+QLAoLlqogNHWVjbr9ABUXemiQ1FaV2hDgBiRY46yg3OVdHtvAaYKotW4gVmU2T7/K1fDxbmBQSixUZM2Q5ypOOY9NOBQ8+6pMUFoKi4ETMFKKruZMmbATF3kssJg0/84147S8FydRLARu/aC0j/Jv1jdv9w9XbxcP1w8XfwLktjkLnUZAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/peru.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaPeru110m {
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

/// Widget for rendering the south-america/peru.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Peru110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Peru110mWidget extends StatelessWidget {
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

  /// Creates a Peru110mWidget.
  const Peru110mWidget({
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
      geoJson: southAmericaPeru110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
