// Generated from: assets/asia/bhutan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/bhutan.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52ZTWubRxDH7/4UDzqHZd5fcmsLPZYeeiuhmFRNDI4UbOVgQr572VUdkmhEGfsgZK30Y3fn7T/zfL7Ztt3p6eN+93rb/bq/PX162P9yvL/fvz3dHQ+7V3P5n/PHj7vX258327Ztn9fr5Q/X19fCx4fjx/3D6W796Pnr27Y73H5YP/j5/afT7eHr97dtd/d4/OuW1tofF5/z+fPfvl14ezyc7g77w2mu/fR4d7v7b+3L11282x8/7E8PT9/v4XnTvx/vn94dD98zjw9/3x1uT98c9vz37fsf/9u2xGGMyWyvflghH66ZBvndwptX/8uj5BQteAEQHm2eYNS8JCYh6vJA1UwqnqK3jyvJrFniAj0cmzw2Vw+84MUAQuP2/hgsWLPimQCyN3nkDGIlz4Mtu+cl0ukUJQ9JoGtelEwgLu9vXW2TB+7OUtrXRYy69gCCGQclD8BCWjwYaVTGRooG9IwBI8FM4DIXrMvTrrPAcFQn8tq4TqFNnjHAleDwUJMuT6Ztud4fhKQ1eaxUOksMCCCSNo8ZQS/tGwOSM6VrX2b2yOr+EBMFXnBelKjOixZo/f0ZZUQVvISmwL1gg8ESs0JUPJlFips8uhK8MeicJpo8BJEs98dAoNBKVpGz5IBK5c+MiIEt+0aOSA/FKh9QStdfJg+trOUxSJfpmzyXDCjPixEY3N2fXY1f1GBo20NnQZQy3sCFsOXPkUNiJugy//W1WuTg1MgifqcWClRpxUfkICdTu4xfH8H8Ah7aCpBKmyKSZ5sHVOZ7H5o0ZVeTB6RS5SsfurRfjxcjxVWj0uLSF2sRI1ZSr+6P0aBZLydvJvVCH/igdOn6Xww34Cq/+CAMRG2Jv8njcMtKD+G8WO3vT2t5hSzUlC/z+pDVpTIHLNHaKh+Tx4pamhdM1a17faFu6Jc8G2ko3pMv053PoqLiMRFZNz2DQOJl9bURSxx0oxevqAObdQqNujxmQipaGRshYUzd6sEh6HmZrWwELcfsVo8VopfZ3kYAC7aLmyjW3uJp3c5t8sKQqTKve6Rq1xwGeeX63Iigl0snzlCLxtKGCyJytxYZrIpd8TCF29rFEZL9MllNHmdb+rlxWG1dwBc4XwpjJV1sOHGS9vpyGEiUlTSw4SpT1TR5BFZK5xm8rtDnCXGU3hwqqNBtFVhqqWYjEph7YxIYIl4qtbm92WJ3OyPVDOMyOtI0utszAsai8trwFzXSzmlVozpzC5pnd7ARukplyes3gjiQOcJK72un5jlUC1Pi8rgxxwbd7cl5dFZWXodusOGQJcZKZ7bVITZ5ivXQdF6fzyFxk2eOGqUwAIL2SNKVZ3KucAzTjZq8EJp3XsYuzY69y8ulTkprAGj0gg1nqi/rUBgEt30lM5ivnHa2/73T0gBJhzLSXEK5jVsTxOq4OUdjzZEpDTgPziqeK2ZzZEUDGMpQ86mmg6DHW+YoncUHeFJadx6eORupKz3RbIq65wVSLkacPlCcrSfT1v1hKftmiyoMvR5m8pY3V/aghKasWt4sSXiZW3ywiaX3zbucoppAKLTdD0cqpFs50ehP1GauUqS6wxcOa3oLDl8mrKwhQkq9AdMsHBrlwN7nc8I57OgWthSn8vqmAGk6Hw49h2iBM0TpivC5vTUhqXju/UJpV54F+nCejx27hbL5aPumev/87svN8+ubmy83/wJDDQ0kfiAAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/bhutan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaBhutan50m {
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

/// Widget for rendering the asia/bhutan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Bhutan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Bhutan50mWidget extends StatelessWidget {
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

  /// Creates a Bhutan50mWidget.
  const Bhutan50mWidget({
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
      geoJson: asiaBhutan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
