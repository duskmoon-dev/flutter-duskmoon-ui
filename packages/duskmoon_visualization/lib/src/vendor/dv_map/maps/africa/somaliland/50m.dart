// Generated from: assets/africa/somaliland.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/somaliland.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE62ZS4sbRxDH7/spBp2dot4P30wg50COwQRhy0awlsxaORiz3z30yGvsnU5CCe9BzG5pflR3V//rsV/ulmV3+fzxsHu57H477C9/Pxx+Pd/fH95cjufT7sUwv7v++dPu5fLn3bIsy5f1c/vi+vXV8PHh/PHwcDmuLz19fVl2p/2H9YU/zh/298f7/entt3eWZXf8dP5rz8P+S9XGIBPDm/PpcjwdTpdhe/Xu4fhmv/tqffzmzPvD+cPh8vD5R1eefP/9fP/5/delfqOeH94eT/vLd2u+/nz//Py3ZdGEkrRQfvHMQgRsqRryg+H1i//loRDbFKeZnE2chyopTXjC7Obc5FmwWfqUh4bR9U8l02O6fYUkHk0eUrGkTHgkJWbW4gXE/DCIGIl6zgVoSHLODoNCE7XNQ63EqX+hyKJNHgtiTP3DqkLuxbJDhajE1j+EYpNCb/LMDaW2/iGEWpVTk6eOw48ZT5SieufhcF3UNpgRIolQesHngKxGFDNeSSD1Lq9BknvVzL8Uy8zeeg28LCt1xsN1J5o8kfCy7eVFcK0wqxZPoZTLMyc8FQ9qrldB0o1ltl4VZNZePCtwFJfP4k+Hd71wUSBLRpldDxvK3AwXgTQO0dlyI5WjmdoEXIiMZ9qMYqrV9U+VmHC7fQSirtLUegG+isiEp1VteRYgq5n6EYhbMHdxqOnC22gmoFKR5u1gKOaYq19VCXkvezAU+vR4Eeqqs01eOmfhttTAUSNxd/8YEivcZry8IXswhAumTbNHepF2eW5lgVP1Y5JslkKD56pzNe2SfF5UIZiHRbZ3jo3mOq81KqEuLmXs9wQnXiOIuoFCrvM0zhbSlD2GVHKkWdwxCkYzSzLUrCRFIMUh/11RIQ2daB4CEltFW6Q8axJ0BcXOjG0JvZ7FFpcxJLmt8JRqm3qqIALJe7dCQKadWoFjYXZzmVwlfEvTxJGFu6kx1yu2xUmUFne9syQ0nWycKN6QyfzaKk5wsvYt3TqFVxXa4uimsqdSIrddRgFipkS3CEXmtO31T6h0FOt5pyDo26BLyBL0ZspWcBkF4+a25shgmF1ajgZ7GyUJgTj0voUzYB7NwOYcEqz6SmdgZjppBhI017a3iVtrMdokiRw3rD2nceCa1p4JLFqOvaBzcNVgnwQdrYrabZRrHN8sTpCdbhgL5CjfntMCqgKjebABgua+HXHdivN5E3or7qcuNoHmWpfAzOTd6RvHtAVI0DUb9QQgQTmdZBImHuukoIlz8lnhlFC+FuxNXMzlqYCFg5pV5zr4nZX/BWo0juhn4cyViNpj5HXSOKnDEsMpumPff8WNEV/6Dd6NHDsdpAg3c+KK09iq3ejESLkpnv+Fq2RhvcG9zr8I7mbPT0+Pd0+fr+8e7/4BJmnn5s0ZAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/somaliland.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSomaliland50m {
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

/// Widget for rendering the africa/somaliland.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Somaliland50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Somaliland50mWidget extends StatelessWidget {
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

  /// Creates a Somaliland50mWidget.
  const Somaliland50mWidget({
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
      geoJson: africaSomaliland50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
