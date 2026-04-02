// Generated from: assets/europe/moldova.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/moldova.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51ay2pcRxDd6ysGrU1T74d3IY9dIPtggrAVI7A1RpYDxvjfQ11Zxvatm1DSYhjN1Rx1d1WfOvX4dHE6Xd5/fHd9+fx0+dv11f2Hu+ufz2/eXL+8vznfXj6rx38/fPz+8vnpz4vT6XT6tL3uv7j9+fbg3d353fXd/c32pcc/P50ub6/ebl/4/fzm1fmfq69fOJ0ub96f/7qi7eEvu8/54fOfvn3w8nx7f3N7fXtfz379UP/x8svTz18X8vr6/Pb6/u7j98t4XPcf5zcfX3/Z5lfU892rm9ur+2/2+/Dz7fsffzudyJZhpCg/++GJxCLNMObvHrx49n94juyW2uEZi5tN8cIZxNv1aSDoEC8B0s06PERkiilegBt260NVoJydny9AImjhECRnq/MFAeyIDRyImxoN8VAJFGKH5ys1yX26W2IITWnwQtBlul2SQJG98/nyIKKh8/ki96TcW8OXo6eFD/GYLVH25vBlnC6GQzyRJIzOHKqMNLsbvsQkhFs4NrPMIZ6iBsGeW3yJq/HYvIYCRp15WUBp7H2Whomd91GYkE7X51ZO0Z0fkWv49PwCiHt7oAVPuc9XKAfEnvt8IYrClAzS5cD7QJiQZtuNBY7uvncXW+khOLNG8W+D5EkQQxqNRSAW3uKBcdrMELGIK+buecCWCdSVmeIRFZk3eAoBOuS9WCTCrNngiSJZTveLmQYNzdticdWYrg/r2sLekW0hhzmOPS/Tm6CrK50MXMbLY3XZm0NXBD/BHIha7NbhkSr7LGzEQpayR4PnEWE+I4K6aR0ra2nBCu9jtCxp0uCZeFl+vNteY+gyCnKcOjMkMHfGNSQXmS4PXHrf04zSBGNfwVZi6FLbLs0UrzetPsj8Ka9gCyYKwnOwA7WiS4LLjYd4jMCKnd9JhsaUBMQ3LurO7iHQTfEySw60tnCnsaMooKt3x6ey8c0U7yDx06VOgjS9FwopTt35GZaan8ZISTRozWumPqcBNWoTU13O6mOWMitrdPfWk0PG7uKUlNZxfCjBUOvFco4D6yZ7yfwhXkgqNmlzhdwwG3tLirtyp1hAMhWn60vHXvAhufGQW3JBm7fYQrdKusab5XZtFCE09pTcJEkrzoxIx/E7tyjY4cnGA2PTanBGi6chOUyac3MIoC7NkHSgIRHkQjGK7MS8kiXIjKhyYRSzdPZV4rEiyEUAHtjtV6uiNMwiC080ch84bLEni07vBhEHNcxXeJbKU/uSHq4vyYZxLReDRFAHJ2YVUaZ4nNqV0GyJKNhQZ2RtKroSny15qDYN8YQpOplW101zbF3R8P52iLLrMBXPCuOATXZQ2xWzKZyqQhd2bQm4G0+3ayjZkx9nudHUGmZy5C1o0wJpVrkiDhJ7qUL7lAtcMftChrD7sPidK9gj27yeFcaJbq7wgC5xrtAGBDrCY1jgasHt+tyDRyKDYSFs59c635ZTT/GqJthI0oq8DPO7mySMrTJQntcJciVLm9nbGu61sIQk2ijp9BTXSwzoVZAHCQ1LSuV65RANXFC5+PToHKsU1R1dBCUO9XwuzSO9nByB4yik2wI710sTwDGPqoVpK9IyzSmm7qIPzccdXtWqXWEchhQVuAlrviCrjzh1P0XITtT7Qto4bIon1aDa29cXhqrY1J1VsqWC6rlZ0NiflSsd39+P6rlBzkW9Iljf+aMEp7HqE62cqLMvPUlEBrc5jC9+knmZuVVVvtjVmabXlwA0Gl1QLUaRGOMd1XD98WCneCw1i9DhRVqOzw+JUrJzP+WtYz7eL5TM7fBiqz5P8cKAtVuflZ3GdEoILtThOaOOU9QvoxIdnI/T5yz/6pYWTwq8SMqdhvSKRKWlh3hQdbS2y5mu47J1LjicAUitdu+4fONc3NLhMVfqP8UjPpihqIrduOwadjQDkKk2db1Y7n21YGsKasC47gpoXSCKhSIc49qccvWK9+aovtZ4HCiW2Na9auAg5yMPsUQwsyGCWAhRjjnFqyJ4ozPq+KplPoTjrui6NaEQhiQaj0MhvWmFedoxYbI22a314XhcpNbnaJ2nEG5BaAhHB5WRGjeI6kcP8fCgclN4nhFT14OIVoLXJJ8Dj0v0ENCWbuokNGBI9LGAj9ZXwywx7OhUuNlEWofHrCLjaaBsmwixuDIlmd0OX0EAXfEhqrJE08JcTcRJO9NSnLP1eoZ46uxdGTy2MbWk6Syf2sFgpTjINIH2Soja4afCc5+bQw66HHV8XJWJKR70s15l3mlp6T8mF6PqxY7zSU0K7cmKHYV1uj6ArRXU3o4gG3rfNibcJkTb+pJ4OiYcNeTRyKAt5I37p9ucmHSTqUV+Mh7zGI+BX3TvH999vnh8fXHx+eJfIcUb9a0vAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/moldova.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeMoldova50m {
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

/// Widget for rendering the europe/moldova.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Moldova50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Moldova50mWidget extends StatelessWidget {
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

  /// Creates a Moldova50mWidget.
  const Moldova50mWidget({
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
      geoJson: europeMoldova50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
