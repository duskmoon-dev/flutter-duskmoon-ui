// Generated from: assets/oceania/kiribati.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/kiribati.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WcTWucyRHH7/oUg86rpqvrtfcaCIQQEnINS1C8yiLwSkarPZjF3z1UPyPjtasD+mvHB2FpND/1U11VXW89v12dTtfPHz/cXX9/uv7z3e3zr093f3p8//7u3fP948P1d/nyf48f/3L9/elfV6fT6fTb+vrtG9evrxc+PD1+uHt6vl9vevn10+n64fbn9Ya/3j/d/+f2+f7zO06n6/tfHv99O9arf/nm53z8/J9fvvDu8eH5/uHu4Tlf+/u7u9uH+9vr88ufPi/lp7vHn++enz7+fiEvK//br++f7//x+P7jT+en/cx+fPrx/uH2+YvHPv59+f+vv/v2+9OJfLRp00bM7755kRuNSXOOr1754etf3XHH6F5iZXFhrNbQcJ+MQSOc+pSS22nYVHCxfbPaPjVmCCqC1+7Y1e673/1FRHtCZHBw+YxKqQHojvThXO5IV1ZS+8N3ujtPF5SbSsJUc6lPBuXg7iwcJZc5wlCudonNvjF3NVAO7p1po/M0VCJA+b5azy6l8/kg4cUTUgvRfHzQqoNUigekFtOmD3Cjp02SbhV3Ls8GusypvU8v/Du1yUMJdpksblqvV9g7occRDycpDInaHDqHw/I161SuN0Kld8jJc+uDjUe53hhDNSADfb3yXtCMxuQp5VqcnGNAroJbFx2bnXYhVcySkjvMteZ6uE50vexphuWedEkR/fEa1CcPgywpuR48avE6E77cLtRr7nCZHTX8fFQqHZUT91AoEEXU94KmxCPKU5daJyYWVDU7Z/BScoem/0f3pHeeRbT0Ju7/WW/PPznNYDnMaZfgpiPXDXd2H9DhzK2b1vLtmT+hh37qWahLYaO9TRIXQ2Mfm3NQKYeQkSEwqmdExIVr7S1YRbDcNuVLMqqjIOWggwU99H3KHLV8xYZgPpBbD8tVldzMLxz12a/2O5fygdK0R4a6367lprfo5OqQkUqTqfXBdNObD7VgKBSTJi7RpTiZbnozGRmogWCODClq8DC1AYJ5Sq9ylJvedJJPg85SaRzUdSOJN4Gle62gSxLTQyGLkiaa5Yla20y8e4dcbCrFtDJCT23zFdGBYJO6GrXsQ9BCX67Y2Ly2jxjrpMfAgEVfzr2485DKNd9QG0STBDr7pPkugbyhRke1CgSL1Jl/giVVCVRRJ0uLrMHMuWfoiqlTlfsvUaz8FAVHHnL15rHlWQ6CVadWfovaUBPBAq3UtpjdKk9LbRizB2hTgBpfyqZWOJlPUoUPLKMHnFEbOUWZ+bKk9MCUj7qx1DUvVu/RIRfAjWzloRsuWkvjRlnxqg4paowr0eJuikjsSmLocpV59LIQwuFo7ThbQ8xa1fyTS7mjoJqNsDK7yG0Lx6N1ooyrS+5hMSD31eZ2IdO32VSpl5lknu3Ozh1RogXWunGUYDUVxCMnl8O8SlGTK4bF6sndlQDWekeGVih4ZDJZg9EcILlCma1vdk6nQ60jTCUuo583WToYJKq9OENupCktC339Y76Qs1JSkzu44wf5qM+UZJlTiVAyTR9ktTTeSra0rA15Zd74mkPLwDrJS4nhHaxHGxY4i8KAjznAI+oTcKlGtmdg8lGWqskjMwUgdjnEHBEUO3KmCrBqRK+D67TAjOhRC6TJMa1KB5JsHZouOFtgcN96jUzt3+A1XuuPLuYdqfXIEYxKUbkRWlk9k6n38jzM6ZYO+4Mkb/psSaZVMEfJk7xqOK4lg+2MM9h8RKWoKWbDig5nYcysNddkWR0zmPxq1bigoo6VUtSHrWQ2h0QrZzJFlLue1cHVh4LJuzKrNDmKOihZB8+xORIlPR9MNpo2Kn1K8hwEOr5FdvPNmjPcBJ11SkNUdqqxOmgoWLjTbskW3QwokKHqfDHjynMne+D1OWqOOz5pysS7E9p0CjQOdZClxy7EMl3VMZxsXo3qJfmoSMHSYOq6kYZl1QQFD+5SVnJzA6UPpPF6Vo2V5dTkWKVRmGz1YZtgCwJtK4UxxxZMhnrdJeWoqoYLPE2QOeADvBRuo8uTs+cLk6kPrYN6S/MDj81FprFZcoDFLdQZXco1qrSpda9NMgydEdDGLG7Pwd2avJoRKHhXJE0wHhqsJe/T5c6r8YuSw7ZBx3lUBSJr67QZoFnSiHSaMFl0ztox9qxxY3WllEaOiFTl3SSvGXSYfEywb9RZg5FGzVk3ZudqmDDJkwOqzWMGeDFnQM0jg9iy6UYZd6MFh0TvJpwWmoRVoYNWc0h0M+iZ6EwjHOmaHujV4NiiwYGPM3oz774E0nPQG/O9idYc9dugmQg8b5eszaI8vBKt4BWks4asMYod2oKRCVhYry9mZtrCeFOJ1Bx7MsNKR4s8WLnaHm12KBxK9jHK6w6LvMwEJE/qXm67NutwBrXA6ZgrM0gy2K4+yLuG6kFOXYPJPsesTrAUcygag6Q0lo+tyQynDakau6tqBxm2W8hQLma2nr1n4iinKkJVwWJJgsduTGEavuWeni3Kyf+xptehOYUDPDcrTvAc6KHojU1TyUtRiGG3Ew/w5EFVBJ63qjyljIqCV1hZKkWmn2DA5DlUWFfQ1n0tm1jFI8FMMqtyYooiJYGKQj2mag3uo2uH1W10Ko/vPNnBeZsFHpLz8eWdOOe8G4OFSd7WzGcVNyZ45owfqsev9kEXc4izMW/vjc8Vh2Cn4Gxss+wrcDva4TD3uANTgWNONWSWZ4Glb9JDzomQHGREV+xe5zacwzzGWO9mgZlmfW89ois55rdmY10j2hcAj9WRKMErzIDBOyUOdIjtwBLXg1icF2NzsAmW8JrZK8GEFtmXOY/hVS2VW6xiHuYNZxsuOX9cgX2aBrrgoet2aL11c+C28Wq/dikn69RsuvVyVmrkSL50w2rnefszNtMlSSZs2PwgjzVduyF7OKHjAD7WJY6a7ELjDeTdJafRHJ2+fZEzWdm/zTWvTBIl981Uf4KZ0N4VZYcjb6huyJPw/rutmLgqxaSY4Y5Dki2DzM2aZ6DhSJLX563U5EA/euhMDq3bV2Od7+hMGjXTHO3YrHmFoKhxmwfXdbqUhsAjlunqUpob8EBzqQW2TV8gyeDNyLOhOO+8RqD39s5i7lb30teHzAjjaz7uVNVkvJCR5BFCVcFtgUORG2Jn8N7th4CfOvNi29nYrsnZAcZyguWPZM7yOm56OlWwNYeFBPsA5err/326evn6w9Wnq/8B2weIYdxOAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/kiribati.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaKiribati50m {
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

/// Widget for rendering the oceania/kiribati.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Kiribati50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Kiribati50mWidget extends StatelessWidget {
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

  /// Creates a Kiribati50mWidget.
  const Kiribati50mWidget({
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
      geoJson: oceaniaKiribati50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
