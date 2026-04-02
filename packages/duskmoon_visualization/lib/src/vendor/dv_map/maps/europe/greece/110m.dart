// Generated from: assets/europe/greece.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/greece.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51YTW8bRwy961csdA4IfnOYa9D2VCDotQgKw90EAhzJUOSDEfi/ByPHiWNTh1CHxc5y5i2X88jH0dfNsmxP97fr9u2y/XO9Ot0d13eHm5v1+rQ77Ldvpvnj4+Mv27fLv5tlWZav5+vrhefpZ8Pt8XC7Hk+786Kn6cuy3V99Pi/467iu1z/nL8t29+Xw3xWfbf+8ei6Pz989N1wf9qfdft2fpu2Pu/nC7Xfrww8/Pq2Hz+vpeP+rF09u/313c9q9P9zcf/r+qT+gD8f/d/ur07Nvfvw9v385ej1eFnbgRETON69sYsCZmSgvTB9ezi1wDUINWbjEpcjMiB6uJ2OMEldMkQa1cJENyazEVdZM8wauAqu7G9X++kBmbeAKeGYOrHEDDVF7uEaaMeo48Nw36sUhxBBDS1wcmonWw2XNwVUcFJIyR4tnDuSaGV77i5MPnfi28m1zafTLG3879xnSWCKKHFUCkciUbHwjQzhF1KioowVpGYKjoI8S0EQNbuGimUS1zRNXc7h1/CXwUHKscBFSiEM7dCdARlSUEncoB3fYjjCJN7JgpSLYQMQO2XFGIdOLYq0IKjrf2sMlmz6VuESI6J1dQ5iwZFVyJvgUgVYxQWCKoEoLE0SRRXuwIYjCFe6YOpnDOtpNQIwoWuMKobB06EDAaUhVUkiAq+bInr8eiOyVZjkMPWdxqzhoIvKotMVBJ82w02sIkCmzFUk8cZkNW0WHIUKzKucSIDhD33NXMS/BTlNih70CNLOtVMKAZESiDhsUUOfammRmSNprYGaDyFq5O4Aps8VdARNE8ooLA2xyjDqbxjD1MrPqtwZkYKJ0BFNgtnEclb8JlN1dYxiaoWVfn+CWQtjLCWfnHLWysbk59RqHQTJ7y1rawhGtGV+dXWAd3/SZiZ04CIzM9KilLZ0Rrdd/K0Zeii9NyeylRZAOqiRTEXwEcXbCq5BsQ8s+EiE10Kl3LFUNv8CGYWzaiq4DmqdWCj9xWamnxPMUoo7Vqencnjp7K4sdHJXS6nbanKlXfB2IYiKXuIM9sYuLTlIp/Dyr8Bg5OtlmQBmMVB9XWFRHT4M0efZJdXiHjPRe0Tn/pyL1tgkmDuwdBBsHzM2l0c/7p7uHzdP1w+Zh8w3eJgWyKxQAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/greece.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeGreece110m {
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

/// Widget for rendering the europe/greece.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Greece110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Greece110mWidget extends StatelessWidget {
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

  /// Creates a Greece110mWidget.
  const Greece110mWidget({
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
      geoJson: europeGreece110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
