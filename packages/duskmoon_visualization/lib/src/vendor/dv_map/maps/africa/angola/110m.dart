// Generated from: assets/africa/angola.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/angola.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51Yy44TVxDd+ytaXpNSvR/sUKRkFSX7CEUjYpClwUaDWSDEv0fXMASY8qa8aHX37T6uPrfq1OPTbtv2l4/vDvvn2/63w93lw8Ph1/P9/eHV5Xg+7Z+t5ddfbr/fP9/+3m3btn26Hp++eH38uvDu4fzu8HA5Xl96fHzb9qe7t9cXXpzenO/vvj2/bfvj+/M/d3xd+/PJfbne//2HhVfn0+V4Opwu17XXD8dXd/uvq5+/2fHmcH57uDx8/NGKR7P/+HB/Of51vv/45uunfoM+P/x7PN1dvvvmL7/vz3++enq9bcRQZUbBz56s/aIQSYTCPy29/PnZFtcZwypaXJVEFh3hCqVjeIvr6Cw4sZegSMulgTVAiUqPkbmULOLV4kZWCdoIV8U9s7fXUwWlZrieiNq5gwFritPMXhdyomy3rYo4SEa4A/fd3br64R8HoSTMKtS5vAMhYvGMO+YQ7WG5VDVmsMHJldriFgcx02xLRFCxww2wcpP0Aa4Ai6twx0OCOTvXjIfiQqculBLKCotmPGSYeFmDW0DuJTKRFAFirGwVsCDcs2Jir4BkCEcnVYQgIRY5kWwBT5eoziEIIYRWohgBh2RwdB5BBFyRLjMqXCSYqANmQElXne2dEBdJyzHDktdpPghJjeycYnmMRKHlCNiWcFknsCRgGl41yzQU5pQtFQqqRSoTnWAgFkvsUg0pZKSQT3INQUSatLmGDKIkaWIwgStieettDh5CyrOaJkSpsmUiQJAya5Z1mUydOmmjACJyH0kFQ5JitlpMDqUkyjOpUGdxvsFxBTHRJD4U0NKQWnELUBZJnHiFAmMFeituAWJCiBMNSmAXwV6Ol1dUGU44XsnSKW8YHFlYE9FkAomg6OMjoARdfCCaLMuNUfOGGxsLkQ/yB/MqRzR6YIesVKNBfDBBZqRyK/MOmCg0aX+YVtGW2fY/KyorVWICrIDkJN5SwVBEqD4BlrXxxX1Erw2w1Ji4mwJGFfYZj4GKuHwQH8tiVDK5Ua4EM48SyJXjyJKWYwKW4MqBzi+LVxPQU4FQ7MmTVMoCah7V52iE9FW5TUKaISVErRU3Wjw5T3SeGRQ5qm24FxUlGDazmMwWkTcsTk2c9B/MwLg6kM7igiyNGgUerb6GkrrCrZZoBsaEYYJEyj6TJhRmoE+ig6C0SLCzN0HQCif0EoS6mnWwAcWIOcx2wWts0YVGAC8eJlMERjDS0NbPFm75qEFgBMc14+qnCFJCIxVGwCLntsRchaDgbNtwDfOiNXcVri5Ok1K7QCkMuTM3VoQrj4Ye10GBk/TDlJCkHA0RaqXlsHZWFVCZrKOWPEF9MdHjpgaSTjqOhFX5M3WFz7I3PEZDsAANbofUCehpNhr9BGBWVW+sqXlOuHVIR6pWyAKYmStmuBbSTmYdnNlVJ8w6CLtxO140yAgNnE2TJMwqbuC6so4iWABZ09u2yGDVvznatTWZMYq2pTUoN8/hmHUwbd7duvr//PHs8+7x+HL3efcf3ZcZPocbAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/angola.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaAngola110m {
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

/// Widget for rendering the africa/angola.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Angola110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Angola110mWidget extends StatelessWidget {
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

  /// Creates a Angola110mWidget.
  const Angola110mWidget({
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
      geoJson: africaAngola110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
