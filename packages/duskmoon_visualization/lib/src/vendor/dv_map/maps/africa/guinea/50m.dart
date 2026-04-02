// Generated from: assets/africa/guinea.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/guinea.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51dTYumVxHdz69oZh0vt76r3ImguBH3IjLEjgzEmTCOiyD571L3yUSTp17kvFkMnX67D/ezbtWpU9X/fvPy8vbz99+9vv31y9vfvb77/K9Pr7/9+O23r19/fv/xw9uv+uNvrm//8+2vX/785uXl5eXf59/7L54fPx989+njd6+fPr8/v/Tlx19e3n5494/zC7//1/sPr+9++vmXl7fv//nxr+/4fPbH2/flfP8PP/vg648fPr//8Prhc3/2m28+vf/63dsfP/3hp3H8/fXjP14/f/r+56P4Muw/ffz2+7//OMufUD9++tv7D+8+/890r//+9+tf/t/Ly69oL07hLfTVLz7KpWlkzj/7/l+++v94ItvcJ7xMSkXxSEOJh/EZVbA7ircr3JwHvG1pBY9vh3nKNF9Xq8LH5ypmNuBxZXJCeLVya4jLuHyUZSBcJFWyDnASXiYonCc7xQSnFhuGE7OyAU5NyoxQOPIsnbbCMtMDhdtEQTXdDKYIFM5TehATnCoLelDcxUKHe6EhJobZgVquwsTTZMX3E3C0aby1ulkUnqyZ1J7gJNJJ0HNn9OAYi/ouQXfWmJk873Dse++CJ7tTywcLSuHssAnQVJI97CyZt21A4YJIebCftJ+CczXbw9pt442a41pqRDxYz83CyugpViUzvp2TWOVRVAXDuQwWIFZdO47CiQvn7ZzESnevQicrpcV3cxcrSp0Tnax4ke7bOYkVW3InurFyTPttZ2N5vxQbvWOSUqm3dzGWBWXAV4za6xnman2EN3xO7Pg8dzhVNi7U2vWpoxzmqmTphR87ox0DXK+owGsnRW57hDvnEYUzE75bgFi6e66oeeJzxW4PTyyJCFEYjozy7izGEhHZ8Cmm4DQaDgpHKsFookl39ykWX642CkdhMZknJit4cNvabxhsJ7NpJnYncl1BxThX3FXM1Zc87157b0R7FNgxyVWSyjFN1p2csRubK7NcJwPAx59A1y7NjGI4dcKcm9G1S47iGiYrRaWCrl08enfUPcqxU5wrjsM6Gc/qgAfdipB2PAd7Yh1FKrp2waUqw+h8Gwe+djvbCg1wT90Kf/SOeaYE6FHk8h3txE1wUQL6xbksMm16xzxiox5FLnPVrZODwrYLjBbzxBTj2lmaKXyMNV3Zhp01w13Pw21U7sF8+u73Dd0KsfNWDKOrbQFyWrlYKFPHyXoI/FbwnkiKMzhGXYBcRKajuQvfgYYoDRc5+jvJx3KhcOw5sFkdU0SwYl57rh2SY4hST3AeubZQ798U3lWzZijcebQnuDhcKgpHHvdTl4sUd2RzbU27v9m5yHEaNdeu8yBMcEYCW/Z+Ye/eUy5KUoUdCqYgyYGOYSpHibZcbE5bhtGxSRAYjeVi1cmhaCorijZunLx8JNrM3BW1xHxFmANcCoO0XZ+GE9YMaLXbdMJnuIhpylWUCTH2TMS6fmlAeyIWa4uWMYF5wDF2W1sZb6t6eBi2brEij9s5wHEnUbALESvkBAB3OAnr0w3CeR2SdISD48T23oj3PcTOpX2LCbN0PbpdPpGxHe+hC0dluYfz6yqbAh1apG6RYabB2zfoNfV16NzYYJgiPcnR+1Cmk0+XK+MEGShck05Tnq2iIkHL1BTpsXS/hKu1KXaCHHusiDOKAS43nFVsirQ6cXeHI7ItIMUWK6WmWKIWGTkRapyKcrvfrFMtyjQ2eGfvQPIEuRYry6loGNczxGST8ofNGOC2dKSHPl5Ce9s02Ys8QuE6gL7T682n7ifefZrdiHqSlyD1rTrAtUu7YV6C9ISVd7hMeiICoyac7tFrrQqhwoMccR/ckk7mM280jd3hQuTdrB9tAG6bOo6QvpUDHuH0f6yqyVdvNPxBrFAdTl3LSLgM9iQqzevubjYcTmB3PBcc48IJw1mdQyNo6XRMVKJwzpndp0xH46V1JAriyUmxTzvrF/WO4rFO3jrtFVpGhBoBYfK4Mx20Vx5DDY9vu+idFW+8wtP2uYQ4dNzf0goDHdlcIqPX3njnCoJw2gaZ72aFmu0oAR3jjpI09n31qJkGyYQJSn9kpaqaaYfJ4u1TGNB4eZ46FE9H5+LaDY1Et8OvpPq0frsUDcoarzOfE5xYJ6fh7ehc4DQ8itgwS2GtMRxsCy0WKzTL23HwfFpoce4geHevRPgAJ5d+Dr5rexIFNt7liqOmoLI1WBOee0tK4PE9urySzgH6BG0L2s25mz5aSu0CwYdvoFIaLHLj9H37ZoPCqPHySA/gm9bP+HT2jLQKvhtHAHX3Ron63Y0nsm4itO+ce+PhF63j2kE/2mCasASqs7O8mcbBBS6pary+atNmHDsAJwWbZKA7a0G0ijvxhtrRopZo3W8uL9ppquj4yjqner9p3MIFmC3LVZU1HT5eopYF6rVr7Sv8HPCeU2oSb70HzQ2nVUaoKI2PAO9+nLlFuC39BPFGpNotqkeRfJTyNF7rGcAMbbMKJk7j+FxbvgHjidvgjfZOMKNPZC3RnbwnPHHfaLaslgjZneJqOJaQDcvIdD/YDk4OhzW9YjkaZV5spk9oP/fIrh68k2FC8S6Od7Qr6ahGqJZljMEQL0pudwHEcxulJI2nQgQLyuMoLKfxbWVN+LyE6d4yGapnoqvqd230qJ4bX3NHtF3varxeQGrNNLbBh+45ZNQEeLYerqTh0PZypyNI7OrwlEX6cbs7frzoCRPdgM0HjZtMAdNVzdO4PbCBx2sAc/y0l2XZnsKEem7CTlkTZUWrmtsBc98NqBJTVN7ulXU6HQZsB/mePGz/r0eO70nsYr5ncg5gwg9JA8rJWk9Tfu7ixZUsHNewNTUwYG4fiUleW1o3ij3tDRg+VTr1uTZcz9UUi4xFim0a9qHyMcDmWNTGGfMOI1D713iPb3LsRJXYzbJw8T3F3ltStp8YII9Z7PM8HasL4/keqXbupd0oI3GIljEn04CXwg0FVNJJpXwir/NWw4DFKgPFxovcYWVx0wW75RfjoWn6Hqz1PPyIms9OoXYxI4ynrcCYZixUjObdzp6MmeMGjGilIHxqcsxsn3BTpRQG1EvSOQE+kQTpTQ5pz3oCZBe4ILp5jUeRhPT7BOZWG/DolieK4shLwPTl5aG2THMaYcsawFD2ejU6vzMeG4cFDH0d6ngvY7TYJQcwoFTtGKNj0b0z4CmrhYymQSIF1TIQd0H16NY0YB9r0DXk5XzetXGTT6YEBQySLTFtsl6xPQzY2fwx4lGjQkl44nUaGAysPnd6A3+UeZWcXMUEKNypZxjQd4v5J0A6bQVgwLQHUaNedXYYoKxNfTbGXY5wVDncgE6dsBgZvYLZ+AaMytGxMcFTI2eAYyFHA7YhR+21rD2XwfSdfEId1oDJLTyeAEVgjpqko1cdlIQHsAKOUKQ5qE78zIB4lw3pSP6BZ+OHNoV3Wbuw5N4CoAG9mXl4DeNRAOAhzdjDeHOlWB/D4i75QAH96gsx3mS83KEBkx88eXXIYnjGl55+9F7xOsWzhHsPFaiHEz5OGQz48Cazs8BRmazUGvVUBxCWGDXglIjtcMJR/RPJKn30IDMZXPp0ADMHAU8H3UcXCOPNHVoOycwZBNut9Eev3a6TpYUByVsbOwHakffgZ/pIz8Y4vhmDJ+5Iq08ncupo0vBLx+2CjHycnEYkTxjCzt8MgPFEa5o+Ne2s3bt6dEr7mRZQuoh5vCe0/AqEUEB2s+n5bMDqUAgFFB4VqrSccTE+6dIrZzUAmh0ZFwroR5I1jdCoK97hGXtyDXlo+tJdB8UL3jyfQk0qEfjQxJUlngD3qa9HAUtVZdQw7WCYTNJ1nPFRnFuFy2nJjtRg4sFbb7nhIsQGtCNWGgDziXZkDUj8QMGZWxsSXsPhNW4wQcXNjcU61Zic5cMLTEnXKUjIu8u6V/mh/WBACbVZwumnSwd+R6yGPhgnwUCuG790M0uzV/opwYKtTIlYTXcklGBRRAM+SI/t7pnQRXwooJXYUMXSI3yiS1QDzrWJ/02cwVMm8RHPr9J2/Ck5FTADYBe4wU66Nu9bEyGwF2sKKtVtfyG2ToFOF3jg7exI175EoCPgExlGXVtP0moCVGLDp/yjqGICJLwA/QDSFOrsdRwJUL5xnMJukzVU8JVnwA6NtB6EhvC9K6ACFdieyPOUrg9wcfwSGO9SaAzTZe6+WyieZ0VN9WNtv2EhQ3MBW4cwp1YawT0Qe3ynoHAoNbxITHy+dsSqd7xW9cMJDlleJEMzmlomFjhDaHOf1uo2Q89QMyqjgamlV50AjLdPs4M7nvhRPaF4Mpek1xI6+lYUj+toae94TNnPKYznpUMb3u7gdlYCnm9f+nsnyerOJXi2qefLPhZYbj2+Pow3Z696fMcsonh0TWvA851o7VLjXb2Zp/meDDqKt6M7cQ3mYHfpEihqb7wrqzmcly3NrmB43Krx1icMeOqF9uFpPMvIaT/Yu5EhnO1MoallSxeWM+6/8LoaUUz2JbpPBwrnV7eiwfylElrqdnIW5H53AGvZxT/CeGP/4Vq+u2QS3l3fJ6UyPW7nWqN4x5ZOy+dXL2EYz07X5+Exv0TWMB5ra+UHvCd8NV62j5Jp8F2cydDHt3UnD3pVZJ12SygeX+1yJl/tCTLwcO1y54naNT1duzG4U7cziXbrywcwHtGenvIqvIdLk87dFeLO6Deewg36jwbsSLMmPFPU06DFIbOlr3IT1BFvHaJN+YFuvYA3XWqd5NVfZdpdw1kx6vCxBWDD6WvtH2pKuxj6dGydbMFpBYzhNfMlPeHB9vkTvHYTVToHWvakOLkfytFzbqoEjaN3t1+aCraOJ84W4P427cVBkzHlLFwg03gxB77cujRUwrlX8OGMB8+qVNF2+FerhRo41DpJJjgd13gx1W9W65Jx4qDnOzaI7MZJ/dc38P0gm4TO3fC5cNdqd+PbSdfRbacSbjt/4TndfYPshpi4vHQvm1uddt/i8xdZYLy9bVDhZR90nHJvvLnHnvsWtLdzLx+nzt3Yrg6yMN7Mj58Kfria9lSPMA2i81ziyni5TByZ6gTX7Q9Q36Wt1YNmkT/2VoHxbOQNenwb7hd9bsdYRde9VeoZ62cWk7VvPIP7T3bBVp2/zjRt79koFE9qzLF2t83OOsBwPvqSpz+mbfyxxP422Jvp6y9f/fDmy79/efPDm/8APxdWIcFtAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/guinea.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaGuinea50m {
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

/// Widget for rendering the africa/guinea.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Guinea50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Guinea50mWidget extends StatelessWidget {
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

  /// Creates a Guinea50mWidget.
  const Guinea50mWidget({
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
      geoJson: africaGuinea50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
