// Generated from: assets/asia/east-timor.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/east-timor.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE6WYS2sjRxDH7/oUg86bpt6PvYWQnBIIZG9hCWajLAJbMrb2YBZ/99Aj23jt7oPLOgjN9MxPNfX6V8/3zbJsT3fXu+3HZfvb7uL07Wb3y/HycvfltD8eth/68n/n07fbj8vfm2VZlu/r9+sb18vXheub4/Xu5rRfb3q8fFm2h4ur9YZfL25Py6f91fHm6Z5l2e5vj/9cUF//9Pur83w+/9fzhS/Hw2l/2B1Ofe3n2/3F9mHt/smSr7vj1e50c/ejHY+G//Ht8rT/83h59/XhYZ/Ax5t/94eL07OnPn+e/3559Pp4WZC0mRgkx4dXiz9FQ84UlBdLn19eOwETzsFaY2oIBI2RHobMRS44UuQQTK6Q7kWwpySNLWbEQKt69+1h28yOfvjLSg6B9QfBgTHZFDFRsPaUhEDKo7hkE2BFtRpYIAB85L7sAffAYib5atQo4Nmwh8yLqR8CzBMuA7pGkZviZDYBUy+LGjjXDPUxmDipZrE1cAaxcVKAsKqUitUampAOkyJapplnEUwmLjaqj2jp5MolH1vjIMXUMVjd0KkGlrBetWMwkqWW6sOaWvQADcHBlAhFi81UKMdgDwKuVbQ1T5KAsY9dFTxKzc1aohKLjMHntQrYG6KowjiPNViTS5XnjXIuOkKiiKUC8UbqPUBjmUxRxlJWeCOUkInF7NTFuQYGDclJSbMECRXzOM0EbOIKVCcqNqEEsfBxHrOgAZa01FrIGr2Jj52llm7WnFfyJN3e0TYNc6J50US7IBZ9rIww627ifeYougKdQnFicUSaFOU/Ye1gE7D1LlScK0AohyodTZIwqoMQB/YeNu5uPSegOBMyMYqMC0QTGaIIRg8gH+exiffAFsHnfjBWkPOEWwPDqvDjrAhNiFJzk5ZEZDpO45RVZ4tgVOAc70CAUaUk/tKS163NmKssWHKwtHTuEjHmnsfQYkoA9AoYg0H6ahFMIuOJMBvgOnsVwZJAPHHx6oni5hElpxYjlbV/9bFEjOo5G0ZGUfB6VvT+NbG424ul4ElLA9ThUJGNkN2yWncaOp4Is5GuA0fV4iDD8e6RUoijWtFpfcs1BDNpuhWbMTBPXfGgWUXw29+ubGZH73zVIw3YmIbzQr5nipQGujaYMbgu69IgAdnGARdch+0aGFF1LOvZ5DxLFMHTubdbzGG1Xb00CuqyM7HYs9jDpTEmj2ey1eJ6f2FXCx7LGUt25aiBBSlnPZyxv0UqWiwcFDj2MXGoSzF4IiI8cQVmfzlYzLaMydjbW7j1FxHFwnt7q5j3rc3LX/ebx+/Pm/vN//ZqjQsrGgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/east-timor.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaEastTimor50m {
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

/// Widget for rendering the asia/east-timor.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// EastTimor50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class EastTimor50mWidget extends StatelessWidget {
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

  /// Creates a EastTimor50mWidget.
  const EastTimor50mWidget({
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
      geoJson: asiaEastTimor50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
