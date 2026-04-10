// Generated from: assets/europe/france.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/france.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE6VYy24bVwzd6ysGWscE349sg3ZXoPsiKAxXDQw4UuAoCyPwvxfXjtPEphdltRBmdGeOOLyHhzzzdbdt+/Pdp8P+7bb/9XB5/nJ7eHe6uTlcna9Px/2btfz348+f92+3P3bbtm1fH75f3vhw+cPCp9vTp8Pt+frhpqfLt21/vPz4eMPt5fHq3+u3bX/9+fTnJa+1i6oXC9IsXJ2O5+vj4Xhea798Wf+4/7Z6/z2QD4fTx8P59u7nMJ7i/u3Lzfn699PN3Ydvz/od+nT71/Xx8vzDQz9+fjx+fvbyfNsujMAtokLfvFhUIHMW1mcr759f2uMmiyhXh2tu4UkTXIZMJiV5iWugWGkjWAGnVOvCNXB145rBliWqegcb5qbJE1wFjXRpkqCQ5WEWM1ipMmXucJnYiUZkUED0ErSXuALOiBLDeCkpuMmuAGVFVM5g2SvQmjQwhLAUDcM11jBtcYUoNUcsU8BMdG7Sy0BoZm4z9kakMUYbb3ggj/IrYKYp1edBNMt9hquU6kYdLppI1qjaGErKLdp4iTVtRl8GM1fWNr+GGmgyw2UtkWjLjZWwdMSHSa/YvXb20z/+177lQOnC2EVSoC45oqbBEg3riLlgld1j0F4MPLSVEy0wLk0Z7IdCVDFTo35aUGkSA/YocDpy11kKCkNHtSlgmZTa7JchSGTVZMwQIBa2LgWGEIniMsgBg1sqc6MjC7Y8dUAuBiOx6AYXAtI09IE6EbgUIvWxlrqjDzJLIJLhPSpxUMhEShEqS70bCgtEQ8ImHYWgRLR6NYhwUZo0VgInN8JscBNcVZkmAi3AZUlduAmF5KNiuFCwYtF6JdxUcpzovoIWmWm3awFlWqaTNDCUC7ck0wALFB7NAQzMFtyNWRqAruI86dcEVBIVneA6IGnRaA4gkKU2bX9QQGYnnPCBFpfEOqukAsqcOKlhAkOO6HZNAEWRdBAtLsHBXhoYLMp0wAWEQLLCbssYoixkEuwytx4l3Y4xiIqkDpjAq2tX9SnQEKRB+QoQolKbAgEMY5yogq7ZtVrPobJspE+MuK9xiLUthdXsM4sHUhOgYstetbBekqqDBhGwtK+8E3JdXbKQBkkIQIw1TbewbBrugy7pEFpl1sEaIKfRADUAy91aHhiICNbE1DokslhLBIPAtJG3d0gVqz4FVUQ66TgOhohVjY9TB+XymLgRf9B+rC61DhxcOcsBSkh2KuMQbBE50C6H8AySrsQCOCNw8qrLIcQtuvF2zQhKiZMRLICKGdsXXQGqFW4DUQxQ97Dqo3VGm+QgwEo8WpnJhxKjGshMAlZxZO8fkSJGttSXeWKuHpaRynKwYyPHv3vt7H+9fEgIdcR2lxmck3hiNxJsGQruVISBzY0m4pQQYcHSRUtgKU4DThYwV1hbQGueRcRJjyowRyTvBJqBjHXyBq9gWWRsfZzAUu6RoR/x4HVK7p4f3e+evt/v7nf/AIXfSzQLGwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/france.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeFrance110m {
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

/// Widget for rendering the europe/france.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// France110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class France110mWidget extends StatelessWidget {
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

  /// Creates a France110mWidget.
  const France110mWidget({
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
      geoJson: europeFrance110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
