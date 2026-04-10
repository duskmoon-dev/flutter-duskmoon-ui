// Generated from: assets/europe/italy.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/italy.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VZy2ocVxDdz1c0szZFvR/ehZBAFoEssgsmCGdiBLJGyKOFMPr3cEeWsKXywgWZxTDdt/tM9el6nbqfd9u2P93fHPZvt/2vh4vT3e3h5+PV1eH96fJ4vX+zlv99PP1p/3b7a7dt2/b5/P36xvPl54Wb2+PN4fZ0eb7p6fJt219ffDzf8Nvp4ur++fJt219+Ov59weelP1+dl8fzP3298P54fbq8Plyf1tovd+v/9l9WH57N+HA4fjycbu+/NeLJ6t/vrk6Xfxyv7j98edJn6OPtP5fXF6evHvnx8/Xvl0evj7eNEFQ5kOzNqzV1yBJTlxdL715e2+KKi0RSi6spFjTALSjmFO/NFdKs0gksJWdS9NYqMmn8OGxCuQtatrAoXkI1gV2Paaw9LBoZjmCF3Ll6EsjFle3HYQPCrIo7TzBIVi2kCSyHpGG1sBFeGoNX5pAqVtKiVhGp+wgVWcy4NxbTonLCAZa7cRcNBiKClQNHcAitMutJQE6jmbEY5tyhKrBpuI9gTcvKu2BQII5CGrmXilFqF7oCXpKqA2oD0jDcvYUND9KYZQROc+ysVWAh5hyQkJCZpd65rYK4izhPsm0ga2YPi+IcOfAEQmBE5OxSgkCtxYmHEYIRlUaHy1BC6pPESARUVNi6LoOYKduk9jIQuid3TkYQqCY64YGXO2BSxwMBm2DWhAcB56i0rkIQUCZnTHhQQEcP6qICIdJnNCgECnt2iQzBUc1wZm5VallXfxEouDQHFY0MlMSprRIIuHqxUVgYBGWSNLhSYKoYPOjFyIGwRLpCIaujUpv0YmSQRZXUZB1JCMMatTdk4Bnl3Lw2SWBSK57R66mY3kSbBBRmag2S75leLMfO3oBKyxq5mYOLYXZhIXnuqmLEbwAap2KTzZY7IGfQhIcAiqUXOh4KlNVr0pPR0gsZKk02k4IoU8QZv+mr0WmjWJVZdNCZUkBISmJXjBE4Vk8ygE3gEsk+NyRhhE5yw5I+yPqdFOmZPlKrCbK6z+hTpJg5T7o9CjAq8uztzQhSmcSEQ6QhtnqVgKIcbeIMBpkl2pYgAlPC5Am/Sz5WVvQVPhS5RvwaFDtVD1tOQrOMTsrmbagRlBlJTSJYAbmyFcIM4YQYk4QjYOzV5UcVsIzgmIQag2WxtO9MAYvEbfLOGNhJrWsbVMERNXmScRhWHmtDWCHTJHTWTAuntW3D0thJERNpRQKk5NhOsgxC3GuiskmgJFzafG5gRUij17ZEb1I/zkPyMQuJrmH9PM+wBH3oDOGa7cDFl842qxkuLZnTKYoAIpOSSS9CQK7JrcJ0KCWLkbKi1d6bWY8bRmI5wR1NjXffO/rmH394gq0rdbJW39eTSoZMaqFAKJF16lwSULTcJtwxWGCp9P0ssUtOBlbEoEKI0usFp1ViZ4Gf7CHdNEECaE0TaFJfFESMueuNxKHW5HxCgwFWVTtcEgenqtkwweA8Te1CdNEgyjQKUQNyZO1UU4CqrnHCCNYYJXonYyEym7A7Crb/J/ATYr3pTseu3no5wURiJJCd721hyxAxBik+QTLZpJdZEik027NRTsFuK0hqCdyc7VslekknA86S250meyu1piGrYWqNZUUNGe0JupdRm0gWB7FagQlsYlW0LQTC8gOcbK4sEhCpHUoS8HLpSTodRcP3A3P38tfD7un73e5h9x/1FmLllR8AAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/italy.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeItaly110m {
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

/// Widget for rendering the europe/italy.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Italy110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Italy110mWidget extends StatelessWidget {
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

  /// Creates a Italy110mWidget.
  const Italy110mWidget({
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
      geoJson: europeItaly110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
