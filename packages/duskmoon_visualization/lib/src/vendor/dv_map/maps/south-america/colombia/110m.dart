// Generated from: assets/south-america/colombia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/colombia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51ZS2tcVwze+1cMs/YIvR/ZlUBXhRa6LKG46TQ12J7gTBYh5L+XM4lDYl0oihfD9X18SEfSp9fHq91uf/7w9rh/sdv/fLw5v388vjzd3R1fn29PD/vr9fifz7ff7V/s/rja7Xa7j5ff/uHl9cuDt4+nt8fH8+3lo6fXd7v9w8395YOXp7vT/V+3N1+/2O32t+9Of97w5emv7b58vv/Ltw9enx7Otw/Hh/N69vvp/fnf3U/3x8fb1zf7Ly99+irQm+Pp/nh+/PC9OE/y/3a6+/Dmi7pfwU+Pf98+3Jy/0fvz37fXz//b7Q7ukOHCVtfPHhGwiTjad/dfXf8PXgAlcak8x2NgQ5ekKZ5qYHGHc0ROrClcYpUkdbxkdBtrKygU0sQTEEo1HWsrEuaSHc+URZmneM6U0q0rkFKaFOPjY0HiZl0FQykJmeKFqpf7czwDZiJOn+IZkwk1fQ3MPAN1bA8llWryOWCZeo7NUYYZzV0c2ENoCJfAbmhsHY5M2KexllBpQrmhLaMn6jDYCiRLo5o11ulVTrklELBEqDmfQzlK+BjOQ1mkqRuAGZE6C46gJQaFxYZ8RU7D4wsGqhRj7fKJogrO3CUYVFUz2vkFKEvkXD6N8shm3oCVUXAWu8EgjoXYzJGAyC45NC+DSqVzC7YEReOwGRcEgztqaePmBGfjjLE5IjO4Gl4BpiHHjOtDQFDLqLFBARlV1VA+AeRw1JYqC0I8AmdcHwyFxp1cCEENRXWM56Ru0c6PEJKpfsDAzGFhLd6IgDADecanixBCiqkRAhE4pgcNQ4RAhCw7YxFBhHMO640gIAl1ajYmBiKupCEnEEhVcucsYpDlTVPSIghTLNySUCUEZRgmDCxJ1aKECMrMtMa05Rwp1lh12USogoa8JaCk4VteyBxINowTBapg5i0vFEINHuY5BQ4P2wQkZBQb2lih0LOs25gAU1CnmdhAE5W3qMYpq4ZlYBi4a2xTYSiOfdBW5bH6l46nKqw5xHPAdMneNhSI+Gpspngp7tFcMMElQ2vo0QFyaSW3Mmeg4dS8ARoazK3wSDBWTh8eXwArm3vjhIAS45iaI0CFqKu76qJEpzFcmCjJRp0VWCnTxB6QSRa0UVcySwQNCWaZw91xo+71IiIfRlus3jmp04FBqsm0qY4AE2HuhaWBJefcHILh2NsQBfeocQ4O0HKO3rPqakMcfYxHHJ69rhRILZc5nhHqRtslsKr84QghVkyRaW9aGdYgAG2Il6AcTti8eSXmldGH3JfgzkRbE6LVo9twRLTwKFJ6tBGEu+LUXRKqcNFSx/Mi8RpWbAlpxpa9jAZJLJY5u5ihd33xMnrjce5wTydu4q0i37JkHm2slX0+iSBlnsORTjhYuESPNgQ2L5m6iwMXC+nG8Sk56nDCFgaJq03akA9TE6dkbyAhzH3ieUAgY5wOscKA0J218cEBAS0YpyeooOukcAvQBKfJXIGYpXq8HWjNJVKmHi3gVobS5SPgNWGYJiQBDJTqg44Dg2CW6bgRFrbIXg8dVs+lPDXxak41NgqEAwN5RdZ40qYkrt2pl8bKiTzUGCFJdGN0d1hrC0/X+ahSIzC3jjDYyHwYdwhe7MktLR0EQjmn06JFd4qdZhacu9Wwa/WCLPGNtHRQWHOE9PHwWFUJe1l0oDXL54zhdLtAGTU3nIZWiDsNB4xeYBHofV60iEaramwSvKygusYIlD/kM0hmm9xvSmuxMT5B441lCEKgk+VwfVHAxiobmc5xLTbGDsOULtFiGNdaw8OHu6SCRLXyPuYAzMKksf/lIrueOQmCNNHGu730tE7Sqw5kNRuvHk1iq+pFCXIeb7rYqio2pIvLLHq8eEQ31Nw4PBIkmi5Gp2vvq63rp6tPV0+/r64+Xf0HTc/LVKUgAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/colombia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaColombia110m {
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

/// Widget for rendering the south-america/colombia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Colombia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Colombia110mWidget extends StatelessWidget {
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

  /// Creates a Colombia110mWidget.
  const Colombia110mWidget({
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
      geoJson: southAmericaColombia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
