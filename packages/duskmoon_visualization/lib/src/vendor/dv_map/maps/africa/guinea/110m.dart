// Generated from: assets/africa/guinea.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/guinea.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51YTWscRxC961cMe1aK+v7wLQQScgm5BxOEsjYL8q6Q1wdh9N9Dry1hqRtCZQ/DbPfMo95U1auq/nq1bbvz4/1+927b/bq/OX952P9yurvb354Pp+Puemx/+Lb8efdu++tq27bt6+U6v3h5/LJx/3C63z+cD5eXnh/ftt3x5tPlhd++HI77m5fnt213+Hz6+4Yve39M63JZ//3Vxu3peD4c98fz2Pv5w8Ph9mb3fffpxY6P+9On/fnh8bUVz2b/ebp7/Pid5Qvq6eGfw/Hm/APdb78f79/+27afSCAQNfz6zQ4xWDqlvFp/f/3fcJShEgs81qA07wImJwfVApCUXZXbFqqQY06ABEnEXl28QoyqmTGBRwY18RSISdF1iRdE0cWTZCqyBZ5hcTS/n4KneQav8DiSJXuABiQoRCtAVNT/wTilzGT2MEKGW1AzBhW8hGU2EMHNBbHJWMGivHKOaQQmVY9m1imIIIatAJEsqNqfEENRp5gpyHTyfo54GtkU0gVaGtqNGAFWN0N5i5dQKKjZ9C9DEJXNIlggyv2UY7DyoKIZzxkpu6LKoGzFuXKHWIpSF48MRXJhX1padPkSFAVHzJKFgOqV2sUjCs2FIgw8y+Bm/OFQBLIJr8AzWb0pgQjOLLXCY48ibPpjyIhG4OTfhIqgSOviaaks+CYEmSk2/YtgOAxc5JtoZnnTvwgsiCVTviUoOmO3Rxgi5+a++H7KaSi9cCkIM1FefD5TQrNeuBSIBEdN5Shg5LRoz7sFiiKak3UBxl7Yto4xI+d2I0BIipu1LaHY0XVybYBgoUQvVBKCmXiOlBiS7aE9JU1QKa5ZSAM8HZW7ZDkxUJZwQdGsugnMFMWTKxKIRTjb1lWNYrjIWnJV6WVZAqPoomlJUDM16cVdQAoT4oKshQW2PYtRRPPcUSBxUesmnGA5zYpSEFldrsOxJRJTvSUE4kLGNlmu0jkrhrKim2ibrZjEoqW/VJKk5gwz8oLFlnyj2KqtAoohtBjZEAqLrdmP5mjDhFfmJWFWW/MsSdCm8jgaGXHWZj3LEbKCOnfzBFLial26kY61gktic+zCjSLjC/MYMEdD2mt/CohDY1ZRYhBMdOxFS4FwOPnsDgYR5Wy2ewU2mjpaHWlQKat0+WZhFc/RzDDIRnd8QSA3psW8S5CqmE2lH/1eCfMSsFgqrDnAjLkbk2t1ykQRmdHscAlQ3GyFx0Ss2mRMwBUWC0VlwIgKarb0BGpOPhffC6CndI+tCIykdBk1qlwZbcpuKTiLIIOkW3J76GUUc10a6OYafcBIW8gWg5hqc+Zg0Co0XGWxCDc1cBxBUCTNXfgY/sMypBnRzXPYq9X9893T1fP1/dXT1b+tMvIxLBcAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/guinea.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaGuinea110m {
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

/// Widget for rendering the africa/guinea.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Guinea110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Guinea110mWidget extends StatelessWidget {
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

  /// Creates a Guinea110mWidget.
  const Guinea110mWidget({
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
      geoJson: africaGuinea110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
