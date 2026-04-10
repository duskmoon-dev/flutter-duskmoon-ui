// Generated from: assets/europe/romania.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/romania.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51cS4udxxHd61cMszZFvR/ehmSbEMgqmCCSiRHYGiOPF8b4v4fqKxvbtz5CXS2G0VzNUT+q63HqdP/07unp+e3H716ev3x6/svL+7cfPr386fWbb17+/fbh9ePzF/3xf28//v75y6d/vnt6enr66Xy9/8Xzz88H3316/e7l09uH80u//POnp+eP7789v/D312/ff/zw/tdfeHp6/vD967/e8/nwr3c/l9vP//HbD/79+vHtw8eXj2/92Z9/6P/x+fOnP/86kK9fXr99efv04++H8cu4//b6zY9ff57mr6ivn/7z4eP7t9/M9/bnt9//8W9PT5zAxPbFH36sBmqoUva7D7764v+BkY9gRhK+ByMqUprwvEjRl3gYGhgTXGWFruEKRXiAc+JQpe1sBdNKJzxODlqvnlW4+YSn0Su7xpv3Nm4DX89Wy7EmvMz04LWtmHHIgJdsJrGeLYmFTrubKWi+N5aaba+CHUPXwzsH4A7PgSQ9aL0d1btxb3wOomGW2+myqojdb6+DGvHeFTCzm99vh4NhPrAdLKUm967FwRWTUbZ4qJ5xfzwcAl3K94d3girGrFx7PYoYToZDRSrt4AIqlCnzDi4AVZh4Z3kBaZKY95YcQKSGOz8QkMiiMg2PPIVwtxEB4VE+Tpc5LGM7XS/vozvhpSvbdju83cDglwNEsT3iEs/I2vwHPA1z0e341DXn/TBx99qun2pdmJ+ZEG+3V8THFCPApVOCXdgI4IjiuvfzAUFtSLHF0yTVaXsj2yfu/F4AXyQZAakU690lYzScdqOsONbWh4kSdL8dCaidzGy9ARLzEHU7fqIuPalDJYbTCGeGXLvZOhRihd+7vs7JiYS344sMQZ3Gx2a59X3emV1n7ROei8bS+BycsqPuOL5Kl+36WbBOOWSnH6npWzxVluR7a+70oyrX63fyxMG5dLogYWv7496NIWk52SoL75JIBxZnwWl/0VXMtvMl78xuih1VbNvzYVCYPsfK8rDInXM28Cy2GL2VcJeGSzztgD3jEcaywDIgL+e8N+eAZMGy7fAw2pqn2BZqgbIbn0JFEdKUqQUrMW3xsrpEmLb3lrHuzFkhJbKGmqiTOExZHjcFt9k9B2R4MxpLPDvDG49HJ6a6xdPsUmWCe6C+V5BsGxtHd6LyEo6TSmRavSKipF3wULiZxOgM0B9YPbygR3r5NMK21oca4jLurhKSbeeLSGk2ZX4ltnUuAtGV47x8yU5LvkXAu0qg2ddjm9IWzwv1InTI0hVIM2ZBQ2bQcJZau80QuHECkyutrKpllSrAyC4+ZWqYarzk+gTogs5ovFDkXeSVpjbHKrDz8Fq7eoE+n2n3vioB0U13w2Mo4gtPX7eQvMTLcHe8cKVNPG3xjOIiMWBes2kMHn6BF218y+PBcAuHY+R1F1yPz/xqP8KqU40lnh5yc/IGEY+s3ylth0S358uuS3aOQYya15jwbin1Eo/rgsMJjpSdc+HmXi/ySC9vdniJR2loI0PnXM0xbfEu2jrRBR1unR8DSlTmZC1NMW2dFUHNVH2A4b7Kb7hDTE0MXe3TcIIy5fJpe+UB50eQdcWoibB57pwLQXqN1H+AoNqWvyaItCb9BjySpC0jSRA88+HNPjXbtjM/Andq3nbCU8kt9U/gl87lgVjZcHOq4VC+b8oSWBOFA8PpkJHNpi7xtLpVNHWyIvcMLIFGjJSkQ5g8NL7AGFKh7uycg7jFI0IZUqHuPEXasi4iEG+mcOxkMYbtggeBtAcerM/BMXJLsBPwSUyn5fvM3m3xjFl9mm4TfrGLRdREJuc4vFMEynp4rjZbnxI3ObvEo+q2wdRHlTod7y1eoNKQ6TqIseeS8iMgo5GSbPJTRZecFQEx+exdOFl52dcmwM5zh/aTAyuzLClibI4JaWgBeFPYQb4LRtjMFJtM+8vqrMvCEiHklHsT3i0HXuNxzO6Abn57i4fdPp7mS8GJS3vGDr4X3pTU1tESwUlaPTHhSStWdtEDW51AOLA4TZZ76bJyQ+CZpDvDQ1zmfgisV+6Fuk+4pDgRBHv9pu1AQ8+1uYj1KO7Nr2Uzppnb7dWLUsGgFGOrsUIwOdzZgJdVRrRdP0siG46vdVatuezwYCd/I2lqEFHNGa2P7+nqTnhivA2X+Lm+HeH2tBVCzCIcg9C9wO84Z7KBhjCI005dr97F2Cq3icHBiilxMQhmw2WV1Xg1VpUG7ox7Sw6fdSQttox13ocQ6aOjty7y9YG9TTeW6WTYY4HyohdtYNht/v3+zjIr67ZP96m3eKUTv95NzMhYciQIGZg45LkGyp02b/HqIhAZiJssKTAC5Ln1aSBMj+Adkn9aPi6xbfOJgG6l3oi3luEQcJOYQ5ZmHeDXfC6BJIWMYbLlPtvGO4FKi5gmPHpAGECg3hzYpKaloIxtEaOHQ598AWkU4pYB04uizYBuOtb1dM8RnfBwr5vp7VANnpYPo8mn9fpxMyTT+FC4ltJwalo0p+6EATLztsYikG4FjkkkMq35cOpKedT4GeCtybrGi7GVqt1KXSelPd+5U94KDlHZHw+sUaqvUBZdHW7xgmoyP+0oUMVb59z+fDI/haJMXXNCdrRU96mGtmBvXcQQWE9qqCkVMnEty6OWqdGU5ipkiORSY9revo1ihOv5PmDONVFMCumt+1jjOY7tJ4Xk07bdbgfLKKlVaF+/VXRT57MjQawQZm3QSzy/MboTHmF3QpZ4p5Aa3YEntj5xiVcXNaCCuxMtoxED8qxqVHCqXEqIGbCkZzXA9WZsGRcGvhDpKpij1xpPbkTINN1wWpa83SpvFdNofd1TXqK5nhsm0+BuYrglXhy40fbQjGKNJxeuyvz42C1cU2Zj5DV7ZHi3SnlyfeYsJtvtMFPEgR1uW8ZtFcNgF3djWkpYVktVVNve3NtRULG1p2Kwc3InTyARFblevqScOtEKIimCO8/XpyNq6kQrCHXfZ43XgxiKaD13gbacRuPNAlhtPTwva/I+HafWm+B6P7aeKuL0igY4KuNtGslQamMrS4E4uHSrQEROo0EQqoAPWF/jqU4ylyMVXZcxDJUmE2eggOTrtLlFdHPjWKAyeCmGZ0g/OtIJ7oEiujV0PnIG0tT6A5q3PCK6+8MmkLee7Xr5RsGqQN6q66W18KEP7yOldFKfyxpGwORI/Cc4E/Ml8S9QNkdKaSJ1fY1Pm7EaFY0C8cDVog44567NhFcquXQuCnkh+BUISeXlflhfxnefput5FAhLuCtRioDfiNklnudccwgEUfgyETLIW+E9bq/nVhZgUCKjYLVPB9r2+nc3w+fuRMvug7fi/9aezDeLFG5K2y1e3sQnU2zTc394hdfKtvmaqwL5uSW0xKMLxu82PuXttVTt3uGYueCNcV7i2YUs4OCtOY04p2q2v6pYyxb6glPrIO7HJy1gX2fiLTvO8bWKdtzOldv1y+PjJv/SFfm2kGkZfR+Qyb8UncbeCi9h0HILJJ9raEso5pmNlG7prfV4CXKR5grEA/eKEpTnmrfxULdpaYJdpJGNt1dEJVhh8Lx+FQ/sh19IPtr0JGVJzyX4ZZnAtVcIJfiFXLqL1EPMLvGu7oooGB4vtsXLrnpHvir6KZft+iVedSfMDbed3oS8eFinKSHW7VWqhDwvTIwUk3g3+dd4p7qYCDXa343JTlAu7C+0NULb8VVXWXM3gVppsH0eJots5pjaNduSkEyoi0xcoW6SkC1eXpFCVVxber0AL65jdHfMUJehsrqYv0jVqm9PLLtFBejzy07djqF1alVwOkzDoxDd7sjclh493xbijvZssb4uUmB2AuY0X5W+d7nE67vA04M9bc+2jpcFLle0S0Vfp9r5+wKPrrVGLYTRup1V/ajBeHmstRX795iqWb+LZ+jYqrbxvPo6y9jeMRCSWqZXBXZB4xjIA5VvgaKMN4UNlMpjWegX8OH5J52a4pENbI/beUpw2g7hfeXb7n5+mM2As0qXlWVCsjb5PW4v4dIbJMSl8kgekLoknIu9s9Aq9zc1G69y0gYYsHtuBbUJcXHTtU/bIRjX65fjfZZWgmFTUOv5zoWqAUtLy7bZ5OfX/ya84rV0K0Ho0h089Mjl5jHUd9P3v3z387tfvn717ud3/wPK/waSsFYAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/romania.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeRomania50m {
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

/// Widget for rendering the europe/romania.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Romania50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Romania50mWidget extends StatelessWidget {
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

  /// Creates a Romania50mWidget.
  const Romania50mWidget({
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
      geoJson: europeRomania50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
