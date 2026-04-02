// Generated from: assets/north-america/honduras.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/honduras.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WYTWvbaBDH7/4UwufsMO8vvZWWZU9l70spJnVbQ2IFxz2Eku++yGlCWj1Qxgcha6QfM8/MM/+RfmymaXt+uNtv30zbv/e78/fT/t18c7O/Ph/m4/ZqMX95uny/fTP9t5mmafpxOa4fvNx+Mdyd5rv96Xy4PPR8+zRtj7vbywP/zMfP30+7+5cnpml7uJ8/7fhi/bC6Lk/X3782XM/H8+G4P54X24f5dP42vb3dnw7Xu+3Pmx5fHPq6n2/359PDr+48+//vfPPw9We4L/D59Plw3J1fxf30e33++79p+isFSIOprn6zkEKVJRf/Yvh49UeeEkoSr4AGHFjI2QVGSIX7AKisGNQEKqALmo6Arsmq1AWKJ5uNgClGFm0Pjb2iYgS0YBbvAitlmGVbslwszSwb0LJQMgq5sMhSu0BVRZSRh5kWWl2epwiFjhw0cetWjQMilamsgIvFFK0NJCqWkYNZopptniqWDqswklOsmRKHQqGidcQGYR4kPV6AeITzMGL1aroXYMzFOKqYqOBoVkyAk3kijdyLjErrAgspiW0EdFXL5gImEBOZjDz0TDdrNq4EZkPmHC0hRzA3Q07wRB83LlFnjaaHBWSaNIoY3ZW66lRLxMyDJCtkKKe3gaRmss6xgkciVTtgMRFeb2JdxI6kq54FaGk01HdRRO5uu4RUweARkBQNPbpAU2LBdREKVCKZ9oEoVSNeqmlaszEkoJvoICcC5ercFOOAtDKydV+VpfMLdXddQLAYjniRhobtzholRINdJyCpmth2ULMUc90WBLjCpKvuAULupmspYahUz64Yx6Lh4euiFkC2KG1rZyaaDQM2ZdRmm3EIkWQaFTW7YHWL0CHMMAdTtUCYplozxw7GGJjruX8Z4FMz2kAhJuVRFUaQmDdbqwOWs8t6DRWWN5aM9syaSFw6ynKKY3cJDbzSfdgYyhGjP1QbqQ4GOAWMQqJmZzUgN3EdqZ2YilezCg1oKQwcyZ05UnlzHxugceRg7FcwI+u/2hWrIa5TrBCFWtzsXArJiOKjIkwqy658Krgu7+mjicbdE605ZSqoloiNBN6ZnLQNZE5RGiU5NMO7SRGosGAaJTm0VLoKL+CclqOyzkTs9gVZ5K4yR2M1krNH+5tK7xvNZnT+fPa4eT5+3Dxu/geBfjUsUhMAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/honduras.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaHonduras110m {
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

/// Widget for rendering the north-america/honduras.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Honduras110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Honduras110mWidget extends StatelessWidget {
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

  /// Creates a Honduras110mWidget.
  const Honduras110mWidget({
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
      geoJson: northAmericaHonduras110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
