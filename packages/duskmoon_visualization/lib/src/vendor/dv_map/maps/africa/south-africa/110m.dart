// Generated from: assets/africa/south-africa.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/south-africa.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE61ZTYsUZxC+769o5myK+v7wJgHPgdwSJCxmNAu6I+t4EPG/h7fXldWpCCXZwzDTb/ez9V1PVX+62rbD+eO74+Hpdnh+vD5/uDv+enrz5vjyfHO6PTxZx6/uL78/PN3+vNq2bfu0f14+uN++H7y7O7073p1v9ocebt+2w+312/2B308fzv9sz17d3by8/vrUth1u3p/+uuZ1xx/PLq7L/fXnjw9enm7PN7fH2/M6+4L35fTzV2leH09vj+e7j9/K8iD8b6c3H19/0fUr6unu75vb6/Mjpe//Hn///te2kYOoVng++e7kF06w8ED75uDFkx/jBaBzUdglXkGGlUmNAVXJqQdMVxrimXtRXCosCMEWTDPABGYKp0uNhcCdXGSKp1FYjYAMykVCOtS42KiwEZDBibgwpxIaYiJfAgpwksocUFWrLn0sAukRRj4ElAglrEtABRI3xhgCKqurtCpXRQZPVU4zIfVOQlUVtFniFVAJR2oL6Gw1y7sCJ1e0xicKSUXuozBkBAziJo9FIcpIfGRBRvAsNG7yREEpKGwmIIEpRxuFCmyZkjMJGSyULKQPa8XkkY+ZoTIpswlrgSKfJh4LWCmqNEEjEKUaOrOhgkek/Uee5HLKTEIDCk6nxstLQk+jmQ0NItE5W6eUqquP6j8bFJa7toDugYqjBsAOSqXGPSBp2awnc8DSCrOv1+zlMnNKAlOFWROHDBFUNquGnKtFmXFTDXkFAOqsKQsCmgV5ozIBKbLXyIaC4MxJ0jgFQVkibNRRBKGQwjk6XlNYNcQjEDZzutSYCxSpIkY9VAiMCZEuawMXsIXkTEAGRpHMRuGEMFbUUYdabMiZpAkaThAkJOIhoCWy62VYrxQKJBuakCEFiRvmxQ6hTEVTG2KQu/WAIsk4yxOC9ETHy7DmAIoojlHxEgJOjpCGrgdwWkaNOspKvLRyapyybCipNpMQwcMds7WhVGLkFLC03LsRygF5BdTQhKiKUU1cG4TQag3T0iCygrcDdMc1G0yjRiIiGp8YpK7/Nqr/QvcFoPOJgaZyzqZGIShBy2x8oiBeSj6thh4ozVDGAm5ZPpWPihQbrskMbGRY03biVunWVGsGMjKPacMT5sym4S0Jg5xmPl7TuhSKN0HDQMhMPqM1BSpM2TA5ZsA1J49ZCFKwNGnCsIqayShmVgWlUuwSWdZoILM8XvVuTQ3edFAFVvTCmYAOmhYdW19Enlx4liWLCyu5cRPWCotnhszmCYNwS+3yeE0Gmjobk/eCp+7e5MmqNJ40pv/IRtH1eIOg8pi15OVKIvbOy7aKENNwhJLFDMy72mUghcQzLswCQozVNTwD9vSc7Rr29FIOajLZwBDVZlxzn7zLhFob1j7YTidvQitvJm924ES2WaIQOK6u0ZIadhOZKYyQWd7su9ghOU1nlQZhpUg0G75VMyLUZktNRghLx2oAbVHQtZMbApJbcMeEFYpiMcYJIBVkrX13Y0KF8IjC0TSxA2pIsxfgBHUi1NnKsACRiZt10pqfg1VlurlW1+wWXlyAajq1YUCKkzVOXutOl4gpnmRoRQsYKUbj5T9TFvczqJiVDpf1K7sUKZp2koDJ5MPN9fh9zKNf32D/+L3PHjHJ3g/PZWY1bP219g9rNv1/1gUrAim1DaZac1/4sOQmpKZUXfp+bYsC0YbsKYGL0KtZnuJaqzH5TOUEwrXrarZgCKYWwjMqERBa0mvsaquljfAcqorbWfynXu5xgK2oaQvQzghwhpeAoSLNS5C9ApF6Tn1sSoHYSJjgGoazDc5P5N1V9/3h2+erh88XV5+v/gWebf9DHB8AAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/south-africa.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSouthAfrica110m {
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

/// Widget for rendering the africa/south-africa.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SouthAfrica110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SouthAfrica110mWidget extends StatelessWidget {
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

  /// Creates a SouthAfrica110mWidget.
  const SouthAfrica110mWidget({
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
      geoJson: africaSouthAfrica110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
