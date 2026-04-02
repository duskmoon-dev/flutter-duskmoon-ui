// Generated from: assets/asia/armenia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/armenia.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE61aS2uk1xHd61c0WptLvR/ehUB2huBtMEE4ihHMSINGXgxm/rup257Bo6kbMpVo0aj76z5dfb96nDpVv91cLrcvH97d335/uf3b/d3Lr8/3f3168+b+55eHp8fb7+ryv68vv7/9/vKPm8vlcvltP379wf32feHd89O7++eXh/2hT2+/XG4f797uD/zl+e3948Pd5w9cLrcP75/+eUf74g9fvc779R+/uPDz0+PLw+P948u+9v7h7vaPax8/m/HL/dPb+5fnD18a8cnqH3598/Lw96c3H37545d+Bn56/tfD493Ln37y9e/P/79+9vXzy0VkuQUZ+ndfXeNcDqyo9urST6/f2+KGOYZrj4uJAhNcXcBoAtbjmiKbz3DdxCR6XKEg4hEukhiktLiWxuw5w5Uwpt5eU9PEmOEqBVMLq0Fms7uGTqrR3zV1MFAd4ZKScmKPmyo6O1yKoEDuYU3VjUa4LJlAB1zK+tYRrqgFa7a4kiJBMsI1BBc6eINkgMyCzcLleA4V3jRzB1eQiBMuJecQN0Sc+iSpomP39TQJ6ZODRCDLzB88BD17ewWd2GbJzM0YDmHMHmI2tDfPyYwVMHVmb1JfgCgwmWepLN1FsL9nJBxpM19IxVDt7UUPHIWELRCNjN5cQFfKydHaguMxxEqVYSqzhSii3GX0WOHuwZPUawsdEL1LZbHCEmR2DIzuzodjQDIZeYMtyUqCPSyYxSiR2ZJNy7pAi5XpRVWGuBnCfQCDpcyCzZa4ch7YHiJExKQA2RLAI9tDc3Odea8AUPb1B5OKEM9gCRhPuQycfea84o5yyA2YlSMntMHWIYsRoODMDzTETXs/IGKLKS7YsZugDGWdZRthZ5C+ALPMcavI4qFOBpHr7IaxKfGJhwBJwtDca0N24CHmabN0w+52xGWOGDWBFRBxCjNxhfQhbATEgZ4rUt3SIe4ulj2uKk6zGFPdm/54DV14GG0EBAq9++q4TbEFWR/t2xSzzSdmuKTh0d83L7Y2bH+SM08U0ivPDdufMMbgPpsFBEvOKK/H7lN63EAEntlrhoHW46YaAc7abPX00N4f0otSTPxBlwak9mGRkYA8cwdNzbSG8gosAJoxXl3Gxe+baCtYFBpRPV2hgdBV+A2L5KOGQleEJneCYeHSrpmzYAOoxN3jqkPAzBmyZ2QCC0FsxvR0pbl69L6ALmPFJbe62YSawCJmj2FIOGuvEAkspkQYlQpdaqncKXACxRxCdHYOosIp/X1TphmT1sVu6NhUCoFlvKv/EDeqEexxnTVmup5A0bIe1sGRYmaueh5PN0AkaZjQ97yg94ag9Kmepe2EokDFkngmZimVttmHWqQ5xSw1iAhxJ24KrBTPHGrH12FMDxtqsyZQF1tkS04FF8BUINJFztLXicKdUiesGUTXsBWqJfMwgMFBwbsijAtcdZoY6of2VQ0X/A/KMTg4dPKb4EKA4GG1xJp7dB1m4VI1c7PMgBFVgHpccUEa2lsNcSdoFa4rznQ9XXASMgp3PrACopTsj4FE65bOcI+FAhcl5Ezwl5V+6KwK130oOMgKRKaWPuGizS+HsHDgpnW8MSvDsuKqBPWwBDgathbsqVriIkQeqRhSg7le4y1YCJr5mCwpqcx6X8BikMMNBNqV4mAvMs9SmaytHB9SGQGzjai01ESFpG0DcWGQ4kjz55WQ/TCwcPdwaOK9vDxrFeNgL09VAV4me+LX46KZwsxeScxsW5XCVaUR9+e1G4pjyZySaV6yTer9DEwsh/bq7iNPBEpixPe4OLplW4JgpQUhzY7BTgs/hUsJwEPc0+y9eqCU4YISLycqBa/HrUn2SNTitR3pcA4mW9WanYN5OPaKg7qAjxafuDp4bndSqoOPYaddbnYSiURkNsXlZahVv3oVI5kRhqkMgtvhe+GOl7R42WFOscWcZBgRB14OtYfRH8NOvFMXC2bodP/ClTSNWUiYGSH0LjZvKqqynVMZOJCNhF5eKacKVBIn1zBnxhxA+RTCNXNFnISF1NoJkPf+AFfhb8bMIknbphgWCHCMpGlZnHnctcxUHw1di/hu6aqFjXCdjQVl+VV3bXH9SjJnuN++0vvF81ff8vo7Dg0o9xtcRSpoE9vBb6kG9DAyLNxr1h6dUe6Vn/+zubJSo4bPPa7ulDQ0F4XaWU7JSEkjtUdW1mZOW6NLRVLNocoOlZYPrRf4ns4NccP7hF/HyyUFDXG/2XtvTs+++MYvv+2/iiQ9Kk+wDA1sVCRqokL9Ssrmj7vizXD5sGtauCbzqeh1XnDCDRniitc2xolHB/NUR/9PuGA53cFWFG73QoufZ9by8Qz32/3s7PM3r//7ePPp8aebjze/A2bB6WbGMwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/armenia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaArmenia50m {
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

/// Widget for rendering the asia/armenia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Armenia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Armenia50mWidget extends StatelessWidget {
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

  /// Creates a Armenia50mWidget.
  const Armenia50mWidget({
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
      geoJson: asiaArmenia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
