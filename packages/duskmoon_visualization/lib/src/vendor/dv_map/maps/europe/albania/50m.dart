// Generated from: assets/europe/albania.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/albania.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52aTW9UVwyG9/kVo1mjK39/sGurdtVF9xWqUjpFkSCDwrBAiP9e+YQg4HpUGRbRZE7mwdf28bHfMx9vDofj5cPb0/H54fjb6fby/uH0y/n169PLy935/vislv99fPvd8fnhz5vD4XD4uH7uP7j+fC28fTi/PT1c7taHnv78cDje375ZH/jp9d+393e3Xz5wOBzv3p3/uqW1+PvufX58/+evF16e7y9396f7S639+r7+x+Pn1U9fDHl1Or85XR4+fGvGk91/nF9/ePX5Mb9Qzw//3N3fXr563sd/X7/+/rfDAXNjIQ6KZ9+tCG5hCYnxzcKLZ//HEwsy9I6nhko85Km7cmLD83Adw9SCrYGZgFD6lCcaAJ3zNMsPNHVeOhtzxzOy1KnzRMBIG5yQuGpOccqC3dMyQabhFBcAHl1oiY19GgxRA5Uu8xDWyjiTkRj23oMtmRlgujM4OML29sHmCU40tY/ZO+PMODBkChMxiux4ROAwzjxOUt/nCmziQMbz4CZ6ds4TUHYc556Aku93Gmz8WCOm/ktRRup4yQ44rQSsocmt/yBcYMwjItN95SueQ8DUf2yAaq3/xB10zMtAkS6fKSSMx/kXog6dfatUwbT0hWKodvaBsM6LS5qE7OPLuYWvSE15WdVvZ1/xAIF0VA8INgCsA6fhOWS1DFMekWrs8q94CJY8tk/Tm3zm3CwTaVYPCDZk7A6P4hnanEdgwbqrp8VTVpzFt3gSJLSrL8XzYMuxfb6qehtfRMfR/iheuKZ3/nMOdRnVq+Ilh/S8qFI29R/Daj47Xpr5rPMrnrWt1eKhy3R7cEUXu3SJOi1tbF5gGdjxBD1tGl6W2vOd+yLLD1McItO+8+PcUqslnGYL4wJ2PE+RcXXhSj7r3JeJYDJ+3rVFpTs90HE4x9DqAap1bk+jFKNpeK+1zrCBqfpsjiHYlBy0mYuKFwqzwYNgs3aMgQ2CbFwKrMrRfq8JbIhes/CUZ5LSBhcVXX3MS0unLhgkxjGuBY4ejvsxq4osmevUPlc0g7bVZamzd8pzANy3Gqt1xsjxZgu4lswiKuPci76UFs48Mae81HrarjOVFI7h0YHbch534VVj9pjZhxswhGaXzkYkw8558drOqngaJjTdvhleZ043RqO7j2t9VoFrBKtKTKUcDR6FM7ky+IZkwkz/WuZdGwTDUZmnpTlrk1qXLgmM45M8HAilM6/m9fnucIGgdm7LNbBPo+uQ5O2cn/QjfbNdFZnA0Gz8vFZTb7N7cYNg0PHhptYXe9yQPMbZIhE1qXYSnZOBT8MhscaLhsdsMFOtCpfXxGtOrAZ9yiupoeUpIcU4W0pkjf0UWDwVBBxHt0ZRaHk+FnQfeQbY6uGPHdyUB9XxdP5zWF3SlFeaWqdfhxErT4uV2jX3hbPFPBxLs+rk+poBec6rq47maKMNcJ3KUx5RaBNe2tBRQua7V0Vy3/nRRsQcMe1MpWpcMybQRi6p8zGwF0mENobqGsYiyRWRmGpArLo45OFSQjr7hDSmrRpsCEtKanhKYhpT/4FxW+1pU/GpKFm8pcHuD6PijXuhEjk520GQNgWzyOl1YPQiYsVjnQNTEdsjKLDLF6kWcyaqFW9ttzZf0nIowhaP3bMzT0lRbOo+l3Vt1fCsJN3xHYqvDqXDsSjh2DxobytpM/GUnN6g2NVgGIUONaG6O06vaaqLhukP3UVXI9kmX2IONbB1/anIzXUlbYLKMb5B4XXtsp8raaswDcf8daOVANz5j6R0jWn2UYCZdMUKfd1dTO27MkfThpQ0lGDXjRvWKdE1Bz/0RQ3WGtw6+4AEaJwvbK0GW81Qru9wTHmi2mmc1VxF3Q2MeaMvutx0r59efbp5+vni5tPNf8SFzs6PJAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/albania.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeAlbania50m {
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

/// Widget for rendering the europe/albania.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Albania50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Albania50mWidget extends StatelessWidget {
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

  /// Creates a Albania50mWidget.
  const Albania50mWidget({
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
      geoJson: europeAlbania50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
