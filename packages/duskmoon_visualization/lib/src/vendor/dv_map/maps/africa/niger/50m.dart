// Generated from: assets/africa/niger.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/niger.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51cy2pl1xGd91dcNDZFvR+ehZAMQ8g0mNA4ihHYLdNWBsb430Pt625sn7qEcg+EWlda7Eed2qtWrX1+ene7Pb39+P3z05e3p78+v3/778fnP79+++3z128vrx+evuiP/3P/8Q9PX97++e52u91+Ol+vf3h+/Xzw/cfX758/vr2cP/r067fb04f3350/+NvLN88fP//67fb08sPrv97z+egvl5/L/ef/+PUHX79+eHv58PzhrT/7038+vnz9/umXT3/+PIxvnl+/e377+ONvB/Fp1H9//fbHb36Z5GfU14//fvnw/u1Xs73/+/X3v//f7UYCji4a8cX1k0C1rPzNB1998f/wDC2crngKJKosWzzVZGUe8CTRXWk7PhIPqgFPzYzCl3jec+Ic8FywV2KJlxjEOY2v3IlEVngKFMnM1/0w0NRw281XQTzK8zpfgzAkdVvihbpHXcfnQOouWCs8AyYmLB3wXCTTd/thoKFCPuEVplTqEs/IveoazwGKqeW7eDYwJ2O5ji+gJNhsu35WZhjX/U0QCXTc7a+BS1gN+SUh6SzgFi+4dFi/AkaPjO36eaXL8PwWaBmTbscXYmjpA16hovE2/sK9A3rCSzZfx19pJif9Ho8RBIVimZ8NyoVSLvNtPHUqWo+Pi8sv8228qjRZx5+n2iX8GDuQxJfp1MAypvTCCCEiiNvlM0WRSzQzQoYW8nZ4jiGsE16ZSul29bjEjeWCR6B08s46O1syjnh+Eu0Sj5JS7BotBMad7rdPG0XksB0Ejpa0Tn4UzG7Xh4OgmDFwu72YWa6XZMUMetZhtx0KFYUo1+VjqNo/vI2XhX7d3oPHWbvkrGBmTfEGvEg2qi3Z4DslG/CcOk1s4ciMY5quU3nEGg/Rp1zK4Cwhy/ATSGcvG7cDGau2XNfms5IFiMqEeImnSWwTWiKF7VIpQ/UTINPouIhtyTQYNDO8pvEpkjvuZktQh55cg7lrkvPJEk+noXHPdBl4CCXM7FPgFQaH7fIAgpKK2XV8DI6Mu5UrODlPr2cuA5cH5+qxKJA4Z/iUlIsUfTW6hHQsietcCTydhFdhlyAqXdYOcJKYyxQfcE+T04GLYZa78iD6iQ3JK1zzFcHaZdAAdpG4FrvNzuoU/hs4h8oaww5BA7uq2cHF2YmJKrMmqq/WzsG4B3HNTwh4r2l2cA/WjgpSnZRXyd2B5slSQQjVcisMUrpumeA0igyXcKEpUmOVJsrLFGAgll50LZoLxLrqW8Ihtqg01qRF6DvWreBHAZrWjvnw0x2cqgXKBNecZzlZ7TG4+LWgLyDliF1J0HCzPpVQfgS+LdzIaClbzpQlxTtwlXjJKJSghLbMd4d/dgof4KiLM1lRgIajkitfpIAU3GqZDcdB1+qCAiyZlnS24WR8yAI4s0NlC6fu18F5lxay1PWaarfOMMmOdSfNOzgqGlUah6ik2j4UlDyKwA6WtBW5FIjnhOIgFrHUuBSQNPVKtFuyLQ7WVdgJVJdkgyLvgGK2PGYFSqMr6wtcS1/mpqudlUOAB2pM1rQ0eccWBbJilC/7xIzKXI7uVChDbm81vkvTVdwJpPIjcR8pdlq8QJLblItbxFVcikfdjyqbN9aVWlPfwRnjKHR3Y0QIbXUsdt9LJ92SmmycDtsOjltIuRbHDVe0bQMJoCPZVZjpyXJQxRaOq8+rEU63Iq0AEvZzPsFhbkVVaTqGcRVBe+0Uy30Fx+D3+nOC42oxfQenjInXMuDAodKuOOaWBCf9veFOXbpBI0ibatkDtn3+CcxPPT2gcbrG7pwgEMSplG24u8y6g3t0KBoQO+2Ud4RyHNs+CnVKjdWJjX2IqQ98ouHOuHdwQTnJ+A1nug1hBO1Ox5A6PwvKOzhOZxlIdk92LQRiVxSTvnM66Kf3v4Sj0KkEUCiibRQjMLaOMwVKntNyGSiMfcpfk5O2Qt7y6g6Ocu5eKrgdwryEO8x8Mm9oBdMuEyNwD+7a7WlXQnkrjjs4sWNwGeA4E2XHshHkrrVNcGq5PMXO6HI2lpAUkiy3Qu6Ua4DDU8+vjh0E5aLJxtB0nom2YWx8mrEDXEqF7lwR2N0cmsSsJpGitNyJ00EeiKeApynutCyE0AgbaLE0LTbaOYYQIh3Fpp1wQ9RcTjaPnDbCcfPsJdqDckfAaU1P+lh0ywnN8rSjl2gRY+4UsCOa7xoygDT2d7rP5fv+DpxGzlB4CiixbI0QwEhjlS2tAaxbqUCBWQMplibFa9tg56AclPuGU4zYaZQIle1tm9ZOmspvc2eFhw18pyf7B57YCsGp3JFeVXHahnG3XnRycKJSbj0fgBhFOD1keNoeu94i4GmET8kTkZY0u2uAWbhnSDnq8w7uniCvg2PwcPWl+QvMtXQcncv6oKDuA+DQ0KZjL2hX7A4u+oF9ACfNFXdwqVg0onFkbmvFuvsYB7joWn5H2rlz8ejKZQg6frol3EG7pvaGa+q5lAAIZ+LZk6VWn5dwfVBcXUYn7Fx5Vz8xMM2OUgaTtW7PwHwE9QFO3bfNsYajrikmuKM9r05ZfliOtaNq7aTonR31EwYpyaUIyIB9KA6ZnUH2TVQGtGNYnuAsamcF4E9N6wltzewY8EhF0/PPERW7Bi8DlerUGWMgWUtP3KYMmfp21D2FWpq2GSSLfDhiqfny1hZ4InWyefXoqtq8vhydn9NgWrt9367hjvY87SxTLS+EdNIoGRyfDecctVw66yNxfGC5zp7v4O7kcoY7NGgJlzTezWEQ2s+1nVLzRog161zCJZ4G0wSX0s2sJZzN6m7nOvHcFZ4MGZO3sNE89i1K0vLpUgkD0dqkIMA+s5PjQNsy9rY3dvf5yk7aZdzd3eXopDPaoJ8SZLuedp7qvsBVOZUn3WxYV9kCJqMDjZrftnyy7QKW6VTtEPjesdySi0xhR22iymU6EfBzVE0bG877ubrGKLIRRFULK0s4mm5W9L4eG9Ay6pyOZjdG3alvl3BH75j2tc5hud1XHbuxBLWv2AVcZqW4GR9Z7IrihlOartA1u6W+M7id66GqEyXGP+Ap8AcX/Bjsbq7awYU3ZxhLdt52FI5ZJI2mMzHCtuKpAspoGW9z+nEvLdHyaPaTdNK+mF0iViBtx+8oKP4RFxAVTld5jq1/3aLsHglTDtSpnRWnnb+D0wdl4smChjt9si+ilMbgUuyGwmEAOzj32UElfYuMcesDTJbRHSsQd2lgB1dM4xMrEHqYxgbOgBBzMio33NouZsB3UXOc7LFq7eDEaTQqd+fJu2u+g9P5glvDWXWWXsKdLtskxuah88vJpsxmkU6rJkvRzts/zLO26/tOuwNr0ODwlHPnd/fEOpyzZVTF3TocV0HsIOfm0xQmjuviycFoJhSdPNdKcbtCaxSe+6pS0fISvXenz+bRHT1xe48iH1jjBAjDdw+sQ55b6NPgUIWXL1zwc0sex+bJOd5WYRKAx1M4CcVV5zLjEs58LHZ6dKdc3sFRr9zcKeqLCrtsEkAP+1h4f1p2cBzt3J2ihHj7IoNoSXNUAE7Qbc3sAdGvjpjbp3Iuve7gslduMNqefmftDAoBZfM7V7o/ye012MAlYB0tZoDjoj4td3BqD6POtm7M7LeMjB6gvqqYtLR3J9RZuUnsTDvxuIHrd1DQmDkZst8lsSuKC5xs7rFlXyva6UT16NUK/UiI8TJMCAFP73siJ4y+tWNQm8/GGx4CHKeYX8Lx3Ygw4SUhLt+M0ncI7QGPFUFe8ti+dGuZc4kiQSa7a1503sjQRtMJb6/vEn2qu+Yc1ULAEu8u3E8khSsCbXv/uY7VdJovNdPe3Rs5Uu78ZiMBrGYwO+NDa/SFOp7de0H7dEvHF62c4W193gxG84WAXrx146PFF2slZQyWO5lc4sUDEVr6GrRszVTdD3hU0+p5z8rOmtFcc+70tEC9vlR5Vn0W3QTszrKWeMKzY6GLqfOeqSWe8nzR6AggsSwJ9q+dezd9/+m7n999+vrVu5/f/Q8H7+vYG1AAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/niger.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaNiger50m {
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

/// Widget for rendering the africa/niger.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Niger50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Niger50mWidget extends StatelessWidget {
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

  /// Creates a Niger50mWidget.
  const Niger50mWidget({
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
      geoJson: africaNiger50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
