// Generated from: assets/asia/taiwan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/taiwan.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52YS4sbRxDH7/oUg85OU++Hb8GQW0wOBh+CCcJRjGAtLbsyYTH73UNrs2YfNYGUDkKjnvmpVP2vV3/fLMv2fHe9375dtr/sd+dvN/t3p6ur/efz4XTcvpnLfz18fbt9u/y+WZZl+X55f/3g5fbLwvXN6Xp/cz5cHnq8fVm2x93XywMfdoe/d8cf9y/L9nB7+mNHc+3d+58+fHy1xJfHPr5/uvD5dDwfjvvjea79fHvYbf9du/9hyJf96ev+fHP33IxHu3/9dnU+/Ha6uvtyOj4Hn27+PBx35yd/+uH19PPLq9fXy4KEAyA8Et+8WiQaRsCG/GLp08t7azAaEoOWYHdjc+qBKTUypASnmQFaD8xKJFa5ggeYU2jTYk4XgyzB6KSQ0QOLO0rpCh5CAk7NzVMycKESbBZk6E1wMNebxyMMIqIJNmQIrXwsA5ScRZpgTlatdCwDGcADe2BnB0QvwVNrytkDBwWQcwlWFnbtci9RW3JNLk5ugpHZo947F2P2tiemh2uLg0SxK+NQo1oSkUrGTWxSAnDtiHR2hubWJSi6RgHWAWoi2t06peDKwToQRISbUefMDFAbjCrYTvIWjpBVAtKBgZrYzMUmDGY1mJiEsCliTTalKpx1kCtL12JFh8jax+SWIE1RiKSt+ZgkgbqqYFOhrFLmVEWiZzPwIKemah2DKUQ3A4FAnSl0AFMgtQIaRtoaWEaSp0cXDLie23Ca3BIFjGBN9hrsRKbW6q5guPoMrpWyRN22DYZRWqxYLB6K2spBMPDSwNZNkEMCc9NiZEIqCykPU0rqxQcMnN0IWAlWMsOuKlCmk6scxIMzux3stBgxsfYxP1TDHhhCVaz2MSGB9Wo0DHBanxIkXbWVg6bF6z035OxCu3Ij1KiHBHhobrvxAZBepXka6ZcC0gPTQ8qtZ1L0xGy6mOZ0iFV8zCnaRbBV8WAwqdZjDQ0VEu71QTAYjbBU2wT7HP+a4HBd2zwJUcJmfMilqlVyoyGCkdIE66omWI3TmlgDt3r4oMFIKtHMQOZr8x3NLsisy01AtnrngBlBm55wIXeuEhCOVAPoZraYeY2r6jFnqaa1YULqFXS6gcyaERcegjUWBVWpmS1j+rZ0Ag0yIuhy09m4lhl7okIzQ6SstFU0FBi81wi2jjI3a1fPfvJ/n6tiDIH1rlTp0pw0/iXG4P84jxJLFOjoE2NQOIPU51Hi3R5vglNXT2GEbdbkHliY5vlnDUaZbmqCp8ErmyeqataRfk8V6xLdvPx0v3l8/7S53/wDuRSkCT4ZAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/taiwan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaTaiwan50m {
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

/// Widget for rendering the asia/taiwan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Taiwan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Taiwan50mWidget extends StatelessWidget {
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

  /// Creates a Taiwan50mWidget.
  const Taiwan50mWidget({
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
      geoJson: asiaTaiwan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
