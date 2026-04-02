// Generated from: assets/africa/gambia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/gambia.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51YTYsbRxC961cMOm+a+v7wzQkkp0DuwQTFkY1gV1pk5bCY/e+hR95lbZcJtToMo6mZR1V31atX/XmzLNvLw/1++2bZ/rrfXf4973853d7u318Op+P2Zpo/XB9/2r5Z/twsy7J8Xq/ff7i+vhruz6f7/flyWD96en1Ztsfd3frBb7u7vw+75/eXZXv4dPprR6vt9++e8/X5zy8N70/Hy+G4P16m7e2H8+H9bvvF+vjsx8f96W5/OT987cWT23+cbh8+fonyGfV0/udw3F1ehHv9vbz/9t+y/IQ21IhB/OYbE/LQ8Gn5yvDu5v8BGcADC0BRT80unggoORd4rIzO0QVkxQCzClCYNaULiKwiSVXEEiREPUAdIZlAVciimQbNNdShlspYepgZytoFFA5kiQowmICxDUguCaWHFv1N0SGOFFmnYZiQdQEN3VzLkA0QvO1hwMyaMmRSTmh7mDOu2kOIYG+XHmpwhlSVEgLMzcS2geGRUJYeGTr2PQwFjQqQghylTQ7kaJ4VHVKyZ7QBBZk9sgK0dLLmLttQNREt+RCYiPqEncGcVdqwrrXXBTQUT6lCFlaGvodmOYm5AvQmddlwBa5z8FVlZyNIou6gLAgmfQ9/GC5KSBj3AZkZKi4EEzRo17GDqFR4iK/KaZNwzyqnUQUV2i1ZGEKzYi5UZ5J2xERrX6sADV6T08AMWqqQybqSbfYPFvJSJ+GVMdqAKAJSEg0pirVFgyuqkVaAHJMk2y35upclc2kg9GVNYNSVx25s3lZyFFNelyHnlHJtnURzJ2slR4mA7bQhJISyUuTaW7uAmGiAVWIr62TYNqAilmJ4dsKU9hJCGoeVEw+nSbSFHJBYvYSKK/H2AGWkApVsKE7WVpoywmbPK7Uwz37SpAYZAUFaJiEiMjVFkgxzTOJagqB35x2Z44l6SQxkEdmlLhkk5jW5Eq8iuQsIKJFUCtdrevYAeYS4Qq3iXiO6eASZQ6m55nhPzSXkETpbaJnUoW2VxCPduV5BFRZtxisDZerxmhbsNUmN6xBf00J0dasM8oD6HETS0druMamyl6QQa/W0iw5ULMoFBHbsV7GCZVC5gPqqkNUhJKuUMTQ0ahO1GUxJUwEKWbfmZPgVsMKzhMR2xMnqJfF7KIH2eyeJGFWsEGAA3VlRB8IqdivAqzBp65kfHnV55OxObU1IFqqVhHNy6M5OOhTSrOJpvWrFLp6ZTzopAYMC26MOABpiKbhyThjtYYwhXMqzPU1rM2H7yHpT3T/dPW6eru82j5v/AGj2YZNZGAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/gambia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaGambia50m {
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

/// Widget for rendering the africa/gambia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Gambia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Gambia50mWidget extends StatelessWidget {
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

  /// Creates a Gambia50mWidget.
  const Gambia50mWidget({
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
      geoJson: africaGambia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
