// Generated from: assets/africa/western-sahara.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/western-sahara.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE62cS2tlxxGA9/MrLlo7Tb2ry7sQErIMeJFFMEE4sj1gS4NGWRjj/x7qyGNs3zoKVb6zEJp7dD/6UV3vPj++u1zuXn748HD3+eXubw/3L/99fvjL03ffPXz18v7p8e6zfPz168cf7z6//Ovd5XK5/Hj8vP7i8efHgw/PTx8enl/eH1/69OeXy93j/ffHF/758PHl4fnx8sX9t/fP979873K5e//x6d/3lH/z179ffc7H51/85sFXT48v7x8fHl/y2Z+/fn7/1f3dz09/+mU83zw8ff/w8vzDb0fzafj/ePruh29+nu0v1Kfn/7x/vH/51bRf//3699//73L5014b3Z3ls989IV+mGrDpNw++/Oz/8zjQKhzyNu/ifIs6cMFThq0hXZ4Lm1LBEwMVi/b4dpjsioemSt5dPiDbqgWPDYJdu+ML22TVfBk2AePN1o8UdGt7/ZS3eiV+GAiodjueQri1eSHbK/FDAu8v394BRtX2IggC9oYXCwADpBofBAhFT/xiwRYhrsR5xqME1uuXQ1fu8rZqqJfj2yTUUy+xWCl8V/sx4wkysGPF21u64hcrhQ+knK8CB3R5ase0rni2Ig590OSZM3Ncy4utQPD++jkra2E+bO2B+ou0btvxej9sbZ3IXwCwYDXfIW9DrnvFCyCWnnlDWMDkWNij2YYk0CxNcAWE7Tt6GhBhITGIRTXlDWK7p2ISuEOUyz0eyAzCIkWpbPoYyCrBpVQH9I0SwhLfoVpNOQZeDMJSRbK41oMzvYCwTIVKtwig7yYgLFd341IREiA2/UqEtRnAd6mpEVIHdYFBtIHKEU6AuPIwVK6brUjPg5piiOkBnSivkL6vhbjI2OjauA91DS4O0mpPUjWkmWlqQ1xsSB7VCD1YVZq6BhfjmTZ0EafuSX4LaFvQmw5XAtnTx6yAPFvDiDRFBVA3a3B7hOKH51wBJ0cZlyKaRWVRZHZQVBm98IJtyURfY65UbLmOSmwU1SEuYyeopIZCFXy3eVuUsNL/hNz2WxMYQbirJURLS9M0KLgcNyFVmzyJnBKosjdVI4RtStw+KHsfCYkK6LAHJy8M9t7VLk+cf6QFDG5YAgfJlASqpX99BdQVYczeNPO0wCC2XSsbnfkhtGAjaBFA6QqC/kl5C7i9nxFAWggIpNdio+mimEkfyLUc6nI+xt4GOmyJa5Oiy2QQpNBKNV9YFJ0ZAFrEUCUFdMlsj8khqqyFLjJgaCb1kBbjmVgjDvQ/pdnYVdwtM9+Q0rBlNFcAR1EZLWFELTZZpmKtr6a3ALqPpEYt/fJr/1qm58T4UA4F0DIy6FoUWv4qHBWQR5uyCbycsU4sFK1ARC5sqExPcojvKv8jS8LJuiEKrQhEo2sLJTPfkBecSs3IN+SFlLtcrSHDwMrzQjvbFKLRlE/Uq4xywsnbtRsis1ieT9Urr9iDk8yLD8EugZNImZfscgl5Finz0hMvhGdeCC8zhH3tM/BMW3Pq5NKE8vKjAtLlbQH3IkDh5YO6UwJPt9gGhSfkFYypGSrgoFSUwJPcMM+U63G6IuxaF/KSiRTKAoEwu9Y0vFgGmkEOX9iL8gSPykUJPFGuNEuUykJBMLneZZodPDmc6yhOHi23QdpQFgZsi+tdpqUTdf0WUNK5xrbY0IlbQ4tna0iEGFitIR9HuT9Cr08KLZJBGCrrVTdcCzaNytwJ3LWvSaPCNMoSgShywxnwDgyAZDtFmbyg1BptA3A4lOWW4JEZsG4dSg4TCnod8eDMJh8+eRl346xsJMtOlBemH99312UZghcHGWc2VJZJbUNxFvDIspNMAy6b6X/XOmjEDCcnU96v578ADpVhOKJQNUKZuJqaVZ4ykh8DKWorP5yypmoo9f8YeCrXoxhPD6khv9ZduGSShTxyjSdyPRJDW/C6lbcDnhl5XDIJoewN9ToEeh2FDjfZVmiZhMQlPNBdWdiuW4kws5CuTaFOXmbrr12GV17bwicwDMstZj/8nTYwtlfVVVhbbW9p5l19geyyNQTWBstsYhtoXHZnwtqRxZ/+GmZ3XJFbwQWwoZ1qzk3RMsjDhULCXfc/G0BEFaoRMgV198TWZmMqavIHj0Pa584O4a1mzBTG3aSmpfQ6F8XVAxiDJUTZUtsnZiCStgWNjE6KmvwB7OdxddkOD6mUK7+W+AYmWauTl8CBttZFjAT1LjNS7KYc6mmn6wHUwCYwqwZkUHQKH8C+9pKlwlSlNRNISLvtazLW2usACmEbCFtqR45fuwZ7PF5blavuygMY/ZyckZWl0OQxdU1opnHNqTTJzKwi7QGiuVSNfAew3wzJC/AI8mpgtii1gZQRT+kmmXl0E16cDaVEdQTlhx/SBgp6KdSOvLEb1PICRap6YXBtzWpSW2rAwKRI8WWmQduOXPJCN1TJJKSdfUZtoNfnmLI8LRL9EW5z8+s9psV7cu4ghLnw/WlJaGZx2ucOnKu29SzijuonWF8joLSsWfDoKwbLlpwC6JoHqF2BQk2VXOaZJz0NWWY8yzPvI6fR1wsoIVUxAQBI+vX9/SoaFTCbnaHdxeF8EAsgBnnbjaOs4whCVZ0gx0m3k2qZB+FMuUyandgpAKoqHuMG9PaMKR0avBZrTqdbAtr1fdjMVSKElxwGuQ8kLn11XmKezcRtIGYetxqhuuW1gNsBLTy363bAzQLM/TU8BYYDtf3Cc2AW+IzF230r50DKawbQbnc6B7JvM7qZ2MhSlIzVbge0wUXGN4HZwgmD5s9TYBC37869AdQFOmmSO+dhqOrtllAzZLQdNxyhHI21NxNDXQaS7US3A7oAst3sKGf/rHHb/38LGKFpr3vArNalM1f1zw6BtqEMk8dACalSIWMeZ29NEZONgUjHZf8TYP/2V7BilauZ8lzqzPWUp0aiRbZrymO3ukF6hsOTdOGUB9mYUlSfRrzjki7uwocb4s7q8AeuHTrFEsnrpSebO+CRHi9euBkPHKO6sz/j5TsKtMx/THm26wzSH+BlNvWKlzeBQrz9yo1zHjljNCuBB69MVlj2MDto950ReQsUveI5MUqzAnPwtmF5bZP6YWzyskRQvtMCg7b351vHiJ5vfxi8AuWcJ4M79m/x7Dg4vbD9eAPPpkLb/wFe540+76rfP/3207tPP79899O7/wEW6l3/f0kAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/western-sahara.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaWesternSahara50m {
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

/// Widget for rendering the africa/western-sahara.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// WesternSahara50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class WesternSahara50mWidget extends StatelessWidget {
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

  /// Creates a WesternSahara50mWidget.
  const WesternSahara50mWidget({
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
      geoJson: africaWesternSahara50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
