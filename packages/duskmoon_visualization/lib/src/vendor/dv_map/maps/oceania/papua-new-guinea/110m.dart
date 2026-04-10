// Generated from: assets/oceania/papua-new-guinea.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/papua-new-guinea.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VYS4tbVwzez68wXqdC70e2hWbVNPsSikndYJjYw8RDCSH/vRznQTIjLyLoDBjfe+75rKsjffqkjzebzfb84W6/fb7Z/rbfnR/u97+ebm/3b86H03H7bC3/8/n2++3zzZ83m81m8/Hy+XTj5fHLwt396W5/fz5cNn19fLPZHnfvLhte7e4edpuX+383Lx4Ox/3u287NZnt4f/prx5enXjy5L5f7L39YeHM6ng/H/fG81v54s98dD7vtl+VP30x6uz+925/vP/xo0Nc3+P3h9nx4dbr98PbLW3/DPt3/fTjuzt+9/ue/778/vnp6vdmQEiAiE+qzJ4u/MDgiGdGjpdePn70CTIHm1QAbpBUy1RBYJI2yAS4giizOCTADerJlZ3EBWVmZz4CdU4U6HxcIezKOgAWUpEi4AU6oFPQc+ViA0yWs83ECq2kRz4CzAjM64IAiE0GbACuEKnl0hxfggsQpE2AH1NQkal2BHko6coWDeWRiZ3FCKZvpKCoCSEy1jYoCLVaVkY/XAQlSdnFMCCSoiqPUSygWkvAemROLeWRzQSRLd3iEICXsMaE3Q0DOtb9HdmMNHyJ7oYX1wJYcxJOkNoREcr7q5BJPH0VcQUhGZWdzQQaXjL0sGXwF2Bep5qg6FbC7S5t8BUaqM0YuWJwr1uceBqnMakhCiBKa9MUJ1V2GwJjqYj0NoSphjvgtgIoypKd6yUSeEmcFFlpHQw7B5DYL44AsImwTxMFJkaaM7JoY0luMKW6lE2CDSiputZCBujnWyMcGyRXpncUKGa4VI2VhwCEU1flYQWL9j4AVLKWiY3qBdFKKmIm3EGP1zuAlk4psRMcz5X1z7eqHn/zpNsAYXBHJo31Lt6qRejIGlqqsjsAFWBExJyllBMkXF7Xeq6oKGgJrVKV2DM4Qa20iRAyhpMpb1mIwvATDUC84o7YZxbDkac6ECIGkclRnsQCKKU9dXCYsbWsooM7oPIw2RUdu2xaByAodqciVHpIerY5UoHDimPCsMSQHF/fA4a48U04CpIjS9kMKWiuhJyXHBJCqSvqMrlxJOXTFz1PQ/0WHBIIk1XKzQSoG58h7BGpFeGUqYo6co/535VRyVCvjDDQSXYbHIpRe3B2LQnq4j0YBC1gy9EpOCXG5j3zMQOJR1EsM0ozC4eGZRHqrthTIY2m8GbDrtVGAQlhgyES8GAFmebT0YkAk62BnRScx1Fu5ZaBmqTzyMcIqDL0GNzBhZhyWSZIKu5IgiCQ663MKqpztClcgO+FsVlaQauadEDEwNMMRg6/et1KJrnBQSuiormuCImVffg1UImza/ArlGk+0wKFBs2jThCxE147cfJ0d6ija1kQEq7zr1h2E3GhWfRF4nVxbJBdwhI3GAIYQpqptQl9a1PAZU4xK6f9V1xeZVhV27jOQ1arIZIBpuiZ+htIDo7IKjoZ2uoZRRG07YovSiGIkGBSCi4o6HWdQiMmj0ZoZkHuV9rFvYiU0sthgnV21k3iHosvBzoAzEdn6pMoF7KOo8ItW7ns+B1tyV0ZRYWAaoW1tcGBENx1ZbIDORW3bsPTp0lUjH48y7zoN3Dz+9unm6+frm083/wE4SfZSQh4AAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/papua-new-guinea.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaPapuaNewGuinea110m {
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

/// Widget for rendering the oceania/papua-new-guinea.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// PapuaNewGuinea110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class PapuaNewGuinea110mWidget extends StatelessWidget {
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

  /// Creates a PapuaNewGuinea110mWidget.
  const PapuaNewGuinea110mWidget({
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
      geoJson: oceaniaPapuaNewGuinea110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
