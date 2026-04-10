// Generated from: assets/north-america/saint-vincent-and-the-grenadines.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/saint-vincent-and-the-grenadines.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VXXWvVQBB9v79iuc96mc+dGd9E0CdFUHwRkUsbNdAm5TY+FOl/l+TaUttNoSPmIWSzuydnZ+ec2fzalLKdri667Yuyfd3tp5+H7tV4dtadTP04bJ/N3d+Ory+3L8rnTSml/FruDycuw5eOi8N40R2mfpl0M7yU7bA/XyZ82PfDVD71w0k3TGU/nJbpR1feHLphf9oP3eUtUinb/nL8uqd51qdXD97z8f3Hux0n4zD1QzdMc9+78TD9KC/Pu0N/st/+GXR9S/R7N5530+Hqb5o363r782zq349nV9//xOL2C+PhtB/2052gHK+7z/dbD9ulPK+4QxNFtGcPOpF3qI6geq/ry/2xK8AsSqhNYAJyh0gCkwCxtIFDQDhL2KOKN3FZ3QQoCeyE5LECrKGWwyUSMOI2LkOtgkng6qLtlCC3GpqMMJlRSDsQBKEGWWDggErtJBYi1+zWPV0dm7XWX5/MSJWoEkGLDO0ipJInFUXgoLU2VwkkBskExWBrGwCwk2N2U8JCor3bIFgj0sDBWNvOAksi5IEdpJ1GIG4MSZMlQDRsKwqUlCNrAUgu2DZDEKaKWdMSqLSSFKTGJFncWK0KgOZEWW8RDbG2ywLSP7ghB6mthBiUDbN7x8GqrRjPPmFUtWbrAkGFNWAy4+zmLUUF1xhz5XTFeQTYw4PSoVDmlgXNhAE9e2oiVSJpWfFM2NE5S1iWjV8B5irpSAgR15Y+aBdWZ4Fk01gMa0sfR8aBaat4hPE/AT+9QP+/0wKztKsv7WoooXhukTwf3b2dSAaIWZ9l0tlCVnDD0x7AS5Fsa9VQlSwLjOLCK4yJVD0pKcZqUVtVnXbGWD0rKcbwZimbcVUke3Biqg7NA+QMLI6SJczqHG0PsGMiZoErk7cLg2GkfyKZRYhXCCMQaLKoM4dJXSEMXDEtD501uypnw+RPBSsrrhScGo6SzgkRZWzrucZc5tI58VTHXHfvzf2n683N/cvmevMb5xYqMvoSAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/saint-vincent-and-the-grenadines.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaSaintVincentAndTheGrenadines50m {
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

/// Widget for rendering the north-america/saint-vincent-and-the-grenadines.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SaintVincentAndTheGrenadines50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SaintVincentAndTheGrenadines50mWidget extends StatelessWidget {
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

  /// Creates a SaintVincentAndTheGrenadines50mWidget.
  const SaintVincentAndTheGrenadines50mWidget({
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
      geoJson: northAmericaSaintVincentAndTheGrenadines50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
