// Generated from: assets/asia/saudi-arabia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/saudi-arabia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYS4sbRxC+768YdF6Kej98M4acAyGnYIJiK0Zgr5Zd+bCY/e+hpV1juxtCzUGMpqe/qXd91d9utm13fro/7N5su98O+/PXh8O70+fPhw/n4+ludzuW/70+fty92f662bZt+3b5nTdeXr8s3D+c7g8P5+Nl0+vr27a723+5bPhj//XjcXv7sP/nuP++a9t2x8fT33u+vPF2ei7X53/+uPDhdHc+3h3uzmPt7eNxv3tZe/4uy6fD6cvh/PD0sySvov9++vz06UXT75inh4/Hu/35B5Wv14/3v/7bNlEoc5Tg219WuEDMzTR+Wnh/+394KcyMNuEllIWmaBMvMiIyF3iOoRzSxHNhEacFHlqaegvOgAQpfSUeuohxE84VKWm2XoCEG6O18BxYi8R9wnOwQBLrqevgUiNcJjyDZGeOrnwl5LyIPgNHLqseXgBjaZEu8DDVlLp4ZJoUs74KaanZC74ATXHRWsBxmlYz2RKQJR1lgYeRnk33JmhxBM94Ap6pRi24AnQXnrVlsCg362lbQ1svm/EIKj3Det4oICmpmoOFgIsKNZt4ieSpc7IhiGQ6t4qBIrCOnJ+TA4FCXbQVzIpQUqI0eZcKNF2zZz8lYCYpmuSjBA+yqlb0KUGYSs5wASmC6j3zMXBgZkzhQgEaGkwt9yqDaFTW1DkoAMMSe8mmDK5lwVPrIIcY7m26gyGiRObkJR+SZ1EPT4ApJWyF5+5ZTTQii4opOYb1MlV7nU0FJDFKZ+liFJdKbxUXFYgio1zJJ1QVTTwFdHaSVTQroVj2os+Ayd0WyRagIsI9dxhIjWsFJ+PqlXp1EHe3pflYRKgZzA6hVWv3copI9uQLwHHNnZccanypevIFqLuXzskbQOSe1CsGCZQiKhPxowTy8ale8auLFEGzPxJ8AEZLPuOr/WrWt64rPVpvCsPmSROxorqsVA/ORkVyW7TyF8GpFS5mwJiiNE8JDIEprWAxA0TPBUtj0PLSHmm++iJEVixtaGo9XmAEThE4l+bBIkmZerlhNAqwUa5IM6tpRc8ZBJLlGPOMpeAckr1QJiBiJZtjRcHMRbBVSg0hCQlzRcLDNJR77kBwRzNfmW/kTFkXzy5GmmdKA+FI7A0xhsBSaYuJfMxsidqjfYZAJIKLcDYolQpuy0dcsvCvA0cge9e/ZKy8GIocPGtMOM3SrIFFc6nnAMJ+KyrgKjNd4akTU/bkS0gMW7Q2jou+3CMuCUqOpfMUk2DGiNrtvIPV2/KAydjRuUfUAtQqmWZ1R2djo14rUgfzDJI5/AqwCrl3JKQKMY40FtW0gCKzeq1NCTKrEicmJARUiJg9++GVSc5MTa5fqt6YNabyMvWc7CcM5ITYI87j1AA10yb7CQMSMvUOIQaRZHKbmqUQGKb2hiwJqMrUnL2BF7iqVrGSgME9qWZtL2cQ7s0zkgAbs8qUvIKAKBG9mVwGrUfjRSsvSDduMitxMCSmRXEpMDQ26Z5vomfpnBwj2Sq0msfD7dP1m9X9693zzevv+5vnm/8AUEgktgcZAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/saudi-arabia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaSaudiArabia110m {
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

/// Widget for rendering the asia/saudi-arabia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SaudiArabia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SaudiArabia110mWidget extends StatelessWidget {
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

  /// Creates a SaudiArabia110mWidget.
  const SaudiArabia110mWidget({
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
      geoJson: asiaSaudiArabia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
