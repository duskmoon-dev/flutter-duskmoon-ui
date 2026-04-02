// Generated from: assets/oceania/new-zealand.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/new-zealand.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51Yy4obVxDd6ysarZ2i3g9vA1nltXYwQdiKEYylYSwTjPG/h5Yf2DPVi5QWTXffvken656qOn0/7pZlf/1wf9w/X/a/HA/X9w/Hny93d8dX19PlvH+2Dv/z+fa7/fPlr92yLMvH2/HpxNvjt4H7h8v98eF6uk36+viy7M+Ht7cJvx//XV4cD3eH8+tvk5Zlf3p3+fvAtwdePLkvn+//+v3Aq8v5ejofz9d17I9Xx8P5dNh/Gf70jc2b4+Xt8frw4UcuX8n/9v7uevrzcvfhzZcX/oZ9eXh9Oh+u373559/354+vnl4vC4VDpiWLP3sy+JMioFtF1KOxl48f7pADULjUtUGWgowq5ZggO5RUJVqPrFohrjPOjF7FXTSkgNQizGfIFaiOvIHsLsqjOCdwaAhRh5xgyUk84pxgFFjSxjnAyySEZ8hIKKatNgIsKllH2ghQySRpoxFQTqxpM9WFC5VtcM4kNhmpzqAstTZiYSZJOcNNzEzPDtkhKkt5tH4GYmHlrTIcjJ1KRmo2EHEnazmv6VlYo2AoODFitmF2IHOpGC2fgnBJ9eXIgN20bCRmATPiyg1kRKecSU4AMVBZOmQFNXSnEWcGF0e0lrOCcRH6KAEF0JSC2hJqwBJrBs6QU7E25UxMlTiSs4JQIfYl1MFEk2eJosDFyNmWI4cgwpolt4JXIHnbBAMkiTiHORgqGhJ9q0KOxBipTsFCE6nN7oSo8Jy1KoE0Zt/q2+qOPJRzsqJ6G4wCw0zTkZwVCpFsC7kwS2bBMGAOl9bFKIJasdgoGgpuWMHdAioBJyXTjDJ6ZLV5ogTKlqXDVsVS5tHlthJ4pmCM8sQBiVX7MK/BKGcdRcNXXSHFxgI6auKQ8uQ7Yrd19cN//u+vGi9wjyRt2cjNU/HIx3tCaSlm509UoMSSapJbniAo4W2rUAViqZDJonsAqitru+gGa6dQmlQaX+VUpNrZCLW1cgbqRE/u4OGZ7QI6MFVRTAqNx2rjQ7UrjityIc18oCcokZi00nBwqtJZMApEWKR1PiuyEouNOBekkDJvIItZxIhzIDi5V19p7NaEOEe9noDSqA+zQlYQ6qi7EahxsbWUFVjZaGZ8GATTsq+OAunmNev1Ams9J27lvHoXEZXR1z+vHpL7/RsVkGDOmVkTYOaQajnzulGCklMjH67aWldlWHMoZ41zXf408g1/EoGIObTbrGHZujUlEC2yUXKH3PYVsN2xUIRiD8Shd2UNlr7uE4hQ1SxTBJBRQtvsRigqNB5Fg9cND4tq+yuClpTPLCbD6lz7FEQoc0IdUSYozej3LJTASJV8lNwE5hW0YYrDQ3lKmdiwJcxgxGGzaoRgrEXVIgug0Oq3Zy1w4hW3nevu8dmn3dfjy92n3X+IXVtH2BgAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/new-zealand.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaNewZealand110m {
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

/// Widget for rendering the oceania/new-zealand.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// NewZealand110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class NewZealand110mWidget extends StatelessWidget {
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

  /// Creates a NewZealand110mWidget.
  const NewZealand110mWidget({
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
      geoJson: oceaniaNewZealand110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
