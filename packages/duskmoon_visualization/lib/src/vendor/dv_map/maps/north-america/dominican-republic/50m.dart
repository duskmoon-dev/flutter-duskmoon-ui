// Generated from: assets/north-america/dominican-republic.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/dominican-republic.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51aS2ubVxDd+1cIr9PLvB/ZlZbu+qDbEorrqqnAsYKjLELIfy/zOQlJNKaMvDCyrr7je++8zpzR+6vd7vr07vX++vnu+qf9zentw/6H493d/vZ0ON5fP6vlfx7ffnP9fPfH1W63273ffp8/uH18W3j9cHy9fzgdtoc+fXy3u76/ebU98OPx1eH+cHtzv/t9//rtX3eH28/P7nbXhzfHP29o+9yvZ+/z4/s/f7lwe7w/He7396da++X4cPp39/2r/cPh9ub644c+fN7ay/3x1f708O7rjX06yW/Hu3cvPx78M/jx4e/D/c3pixt4/Pny9bd/7XbfOS63YAR99s0SxgJONKCvFl48+39AJFGkDhBULHwKaM7OzQ59pQoC2hhQncisAYwIc8w5YDBAdICEKDTfIaNzcAPozsYUU0C1BGnxtG53DIfBmtLhkU7BhCNNutszVk0dOwynOjB2gGKQPAd80r6WggJj+5I5hZ7HiK+QNEiZAiIYgGYXdA6AOTYKBBl6F8VIwZZ4AWAbdLGIhE3HeQYs08E7QAUWHMcIkAd3JyZnTB7aBFaSMNp5kMSiJAkY2gSWawR7Z2QWNdAxoImYe3eFzEY836GaCmVrE3P1GHoNLPFMxtZrcAuhKSBu1a4rd6RYWxwDChr0O3SHzGFugAXGzHCevR6trDJM1rAAn6rwfEExsVyRxmGdlQXdSWZHtlzuUAfrAIVVZZawLcuxvU82wsY+xlNMYW7xUM15fIWclk7tFRIg+syvLRe5KGILyBkyrHmWC4ojaXdkziSM4ZFjJW+lrdshBMAw8ixWYCq3RJM5GWzohrHcQ8zOy3xlL0PkWeQVIFUC6EKZMARiaOVYFi5AXaAQSlGRMeCTJYWIgHBWAQoQidqizGBDamix1Ngt29Sl1UuMfUaSCaktoZ4APKP+BSgSJJ0TXpQL62BJ7p2JlQNCxzvkxzauATREpSGvKcBATuuMYj7vdrY7rD6u26GjiPKMNWxhIt7nrgTxKWuo3AXI1rLhjPpf44oHjJRxnmpyATIGjwHRGNjPU00uoC2rjQtKAJGc32EuUKxmcl7ylIzPU0MuCIMYumEuhaiK0uAhuF1QQo02NtQBogfR+MRGTELnXlPWAsmxSQyqG27gCKyy/wWspmVJuQg3FjI2MZErn2fX2iGCy5zVmJB6ZxIitQvCpCzSNY1FoDDIxjtkkuzUrlpxZxm7tXNKJ9Xkoo13jY0SxMJ+nq5zsTnyBYDVJkO3Q3GmoTKwtRNI2BDDXBrpYmPALNdoxJCsAhU+7mqhJB7qbtCcUnLehFKK8LkykMvYcCzvwcLkkKaRL8CoujAFZJDqDdsj2ziSq5HnCuUukr0E46nMvCkDLG029KKMQ9JQYggbRtPIF6Aay9goFpp94HlyqWtTwGIufXoNhfAY6tawgjm6Rj5XhJMOuWZJXiqo0Dl2Fmec3mGphphd411ZY6NyU0Dip4wSEsU2x4CB3IdebCE01tZF0DK7ihLJOS3zJdare0+8IrXyzRTQULPrk6s0uEy70AIsCaVlXiFxybjDwUClTQ6pOKTrhcda/KXDe1wZA3pJwB1e5aC5jV1dCNuSFzHuJ7YpHoq39F+i5mdjp3GwJyK5Nu40Hsq4bkOylnmJGI2neC4mIZ2RKTR4yNfLrcUJ2zjB1JT52M2qGW6JCBor6TzwtkFZ26Hw1kTN75BA2i5UVKcan+MKcKTo9JoMH7cotcEo/bfDo4vmZM5FbDqpIdRKJhkDkoM2s8ZYAUx0QZzIU5LXxtbnA/7Su7DRLqL88yIjmyk0vKYUKrnkKwgZFtaMVwsQWKffGKAFJQ1CZ2XN0g3HgZcCHK0YrkiawwlF3WHxtegnFFbt1dhtDBObUK4xFDLEBTV0o5QNIHkNAOZF/klxmIBTdV5EZ1+Fuepef3r14erT7xdXH67+A8w0GRXEJAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/dominican-republic.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaDominicanRepublic50m {
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

/// Widget for rendering the north-america/dominican-republic.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// DominicanRepublic50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class DominicanRepublic50mWidget extends StatelessWidget {
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

  /// Creates a DominicanRepublic50mWidget.
  const DominicanRepublic50mWidget({
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
      geoJson: northAmericaDominicanRepublic50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
