// Generated from: assets/south-america/bolivia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/bolivia.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51dS8ueyXHdz6/40HpS1KWrqsu7JJBVIIEsgwmDoziCsWTGcsAY//dw+p0Zxv7qSaj2YpD1SUf99K1up07/+Zu3tw9f//T7jx9+9fbhnz5+9/WPP3z8xy/ff//xN18/ffn84Vv8+L9ev/2HD796+/dv3t7e3v58/vv+L54/fn7w+x++/P7jD18/nb/00x9/e/vw+bvfnb/wD1++//Q/n777+S+8vX349Icv//Gdnh/+y7vft9fv//Mvf/CbL5+/fvr88fNX/Ozfvvzx63+//f3vPv7w6TffffjxD/3l5/H89uOX3338+sOf/no0Pw3/X798/6ff/vi1P4N/+eE/P33+7usvPvv1v1/++m//39vb30WRC5elf/u3P5Ik52Bf+Vc/+fW3/y/iKmepFjGk3MSmiOabOXeHmCmRNR6jiVnu6hBrmcSSKaJuNV3aIsbay/YUkctqub1H3MTOa+/xPHLx0soWMTnZxl8tsjlidYjCmrbWGHH58mZhNslavMbfLBoW2azLJmVdS8Yj5FLd3iNuXSo1Rtxc3i6LecTiGAMGi0c7xGWGszRGtMLsd4juzJXjI8ga2DsdYnioz/A2Ve7t2W7FLVrj47KporikuXY2FVfEcBIBuE24uRnxo6zYc0QT5u64YH4dt+0UcXvWA2CZeQ2Py6b04t1sxSIJVR7um01n1yzpAHWpbR1PYii7dzuxSCvm5mWTr9wuLaItEbHxsqySKm2n0baU2fCO2LSSpf/oxVXBw1ts0wrdxT2i6Zb5kV47WaS5GIuWL1jH8cKkazW3WJGfK3O8LlFbq92MqfCs5puxQkqaa6woF6fqfDPm1pTm1inaHj41qbjwe4+xqFht7OlszH2Utd9ckbxrPosMF/T9QisTr1VjG70pNVfx+wMIxChs/fnF6LuzBkDElcnjhUkv08bsK5OIu+Yc0Zi7AwNEOLU5PoFpy5NbRL2zWHHsfvvVxzru8dWYosbr/b0DRNtw5y9WBk5ji5ibb1YGsVm8N9TKtCRw94wRl3cGAYC+/eoqQ9z23n8CYumNu7Oqtls7jSEKWzE3MevpyITuJfMh7lys7f6Oy/s7TLa1C5Pnm3VuEQS3YIsYJeOAA2PcbayqTHvV5mkWAUZmaxNkKVOdq30Yqm5ys23ZfnSphc39xmW+qt3etRAIjtfFxHYXq6qQ4LzMb1upZG1svwq9bvY5IA5gO8S1UsPHW0d2LPVmGoVCto8TUJtEVLwJOVQo3W4uW2FpY1UV2sGx5o4oZ6Q3KS0Vqn3hLCchwu1SWqrEnjJ2UJLKrbi7G5WUF7PNEV++V4u4VTWGuwdjZOuCDlUyM1xmU8S9JW03V5nSuomAk3ZaWufoKYUxMjzzMVa1zqhS6okULxAlHhD3knEMjK+utRqnXpW2aq2LMSp7lwYGomfK1C1LOkPsTKue4df0Ck9KzjYNDMTXFE8RPausySUAsSQu1tpC1Zscz5lHl/TxPEqtne2R2XqRn0+SEwS/j6uxHRM5nqH5T2L3JdV+dDjvnF+PbOatF6XkrrpiOMagqpMbahG5dkzTRkH7IXxTJHnGGcygjFy7v8psGY+vsqB0DlvtodY49+0YUSRlN9GbkkoYT+PBoLBisR6R3VLGK+2MxFF7OYpvqz2eRwuHt9QiimXU0KEIMuxhfnAobOyhBEw83JDW51m5xinHIF0Z3OT84ZcZr3GEGaTaZkUByOpW45WWXPHgjO5j+8eIXNv3wzf7PN0RxK/wvkW8sYIOp7itP2HrSOXYz3PUefuQVemVrR4eGKfYIbu3qyJnraeILjtrt1cZIzqeFr4d2Qnc+j3ilnHc4QgFEFy0X31TsF1UpaHt3SgXJmbRftmRFvDk/IezuCgdIWa/0icwGh7BRcmn5NkiImSN4d5ZFAzPqx2j6t5jo7XIX0mN1lQn4uMp4MrE/midCSQFZDzEtfzJofc7REurXO00Zgibj7/atK0YHdc2QS0YA3KWPERadWFXF+nhCLSIwWbjQsIi5bZme0JgmXtQiwQpzD7kMJjH6RCNKkO6NKsSp/rYChrVK1JpEXXHuGZrtF87rkVEJnhqBY227PCHr0Y5YOrvGCWqUP3CsOY8iDFKiXqI+1lz7kIZRbqthodxvnppTW9bIw1ECK0VZD7u0AxRYbWQGmp927rIiyptW5pdUA3EEp0GHUpbEOj2a70ufCilXMs3t2G6+EXAqhThuq3POcoFReZE95WdS6+kNxlCRWHIxXt/4sRuY0SPhzODbPCOnJarFca6nUahZBSCx0O0jWRHn/g/Afd4YTQj2pSjEMcJIC4QvY3TGblD1CIvEE26YItpzlFTkpOAaGtQtpDRHZ8XFgQx7QDlAA4XWqie7m9GDm2e7JAz99VMIggoXCunJVGUcaJ1J6Qo1oUPJeQP8wjEU+AZrowQl1dFSw1yRcw6nEemvTfyOB3i4ZtNDwwK+xIiLR/KXv/YFJEZxY4OUCvHbpkX+eIdPcNKCxZhdjX6YUHjBmwRd6jx7KMdzIk+b4uFOWdwdggd5LylXQ7zbPAY88ocZVZGZr89hJJ7eqyBGIdc0yL62lMiJhCtavXct6o9zvoD0SujM9VMEgu8/Cli3y0BPBfONYsvgRfZpk9A2eJxCAxAFWmzHef+Hld3HP0LD9k8kOnmlBZHtTG9zZ8wsfKSYZUMiMgD9/zYyvIphfDMY193w/Y2HVcbz/aWVT1zGY70ND+IMaa29A5cEydvMV7q7INg3GRobRh6eVgY0Mp6Du+rCjxfau5L/vJTI8UUME8mtb2+GVmooV0FImaxIecBcd7FAsBXBuI94OkcGJPegWi8u4AViKd+NrSCmEY0N/TdDbLUh00n56tbtDw5raEtSFTxWooDmmLmX+uH5tfOn2aNkxJAPI5rC3gs1dBUnf496bJFQAQjZcis8kRrHwjjLaJcmFN8NEgdbY+NvPbTGHHH6lLAQATFaH6aIySioQ6cZsG0aZbjHJUHZywpUpBnnyPuljqINk4s9Xw7btOV3FzcSS7gF4/XuthbNgIQ7XRPjhEfGrTOENGMMjWor06g5lSDNXNuzCmirUTSs0P8sR4+RnwKLJP0lTOcIi45JqRD5D0nqAHRUZ5sLrOgOm7y2E9efd1SAsW42MP+pwOI9uYWMU4D83ga7YGLKIEwcFzkeCHis1vEixr12Y7s2XWGBtkr+poj+tM86rxDBIDpT9OoyPrMY9+lFl2pHx/9qsaNEasldQBQT1ZzCuiWZV1uB4igxg5t9aby1PTmKgvwzGV8YtDF11cksDCvO2mKuE16DwVLfWi4I8Rgkod6FhBv6GRMslM7MxgkNr+/g0n51GvfI/pdawMap07M3CGmXZQP+HTSds6t07qIpoPJNuhYzTQ6mWyNaecOk9sjotxIODD5PnFFh8i1zeZfvVi5XxcuHKVhcp5J0zCOFvEuYYvO+CYTI+uu++J0yLFlM4uLPA+Be4yYmuwt4hoHqsCr0NUtyyK7aVRmWk96CyBnzN1GID7QBmWR7JXjejLGeEQQWkS7kK1gWrq59SUWjc/eYrSJNfZvgTGoF5ZgKQhQzfcaleVcD+L/WGVQPbCjxojO4W0AY5QomU17Lpm8HrIIhv7OeWUMPYaP8xixzIcRejCyQd4dPyMPJIqGHy3Eme01a7Q26GDjiqVoiXNj/4zWqwFuirgEZcR2XVwv9E5OxdKz852MfMm8AVggjhBdo+kZ45o3cQo2cV/QAaLPeTYgJOPbGltgCOjGlQPUu0/fYvvVYNWNa/yoaLd+t5GuI+IxRZRTu2tH+GN9a4x4aPPtiZE7Toye7GoLuAyctSmg9TygM8ILa6Vnw7V+iRHHPD0NHtA+KYT3iEpVax5rgKN6lGN6xEsWmfc2S9HemeNbAn+t568KSHBHRWyGaMTSt64A8ZWPGyMusVYLStFvZNPEIBAfGp8ElLWLlnkjeaoRgbIm4xwCEJ+UkTDGC0kIXFggbbRjzIvESRjZir7AiOMEYbIxO3Thdmlo6UDki27GYz6hZtAh+rrQgzKw2cEhahHPvzU+M0+iJwLq34WgCBzOzW3mRGmBETZVmIKb/ThGv5EzWMQBaZN2h/sJLcedHOoPNQk0NUAqb9y/sh66lIFoF97oooUwqyuhK7KNMk7vLHI5qbwOUV902SliyEONDC2SuHDHPQhRqPO3ay0X9VB07Wxbq8tfoqGxxlpGi7YeVlILeHQm5s1UciKqFpF9ym14dWf1imdClRdyS07Mom1CVKj0yG6NEV9z1SHui/rqQYRn0yNqzYXjkK/j3h8Vyptoy6HIJRbtPOZNHyfSnhptVRmE2QthNieJB5lcoUO1nnY/Odrjep4W5rF8rOAExHOptog38l+OGkJfgBKQL8dmy5HxV+7KeEJ+UV8F4ta+uHPyAvM+N0e3d08lE5ituXAFEMECba8eOxSNoSF0spe+Z4so8OvniKm9UKeQ7nk5FIi7djX0SyAehcz5GMuCG9EzEaSCx/X+89WtPhIALzinZ6kts7cyfJM5cjJbaF18j8i0b0onjloM+IYdYsrVdlzWq/AISklzIjkQV4p0Pg9SxTnPemCM0QqpCNNaF/0h2I69QDfqKkcYewwo1gceTHoj1+WoaXUKCQLRyhizq87+PiSHDpE15iVbILZ0lqKyi/5xJ+Ne+rNon7zR/JNh+BsjWJQXLQ1n30TLSy/Ibc6LJ2drZzRpUQAekdcx4IPGclHaBRnBoWEYnZYv5vBC78QpHvza00jF05Z+p+RA60c3wNhrGm04VU8ZLMpX9+AMD5QNazMIRVtj3G0BTZuqtq+maIMhNBdjWeeUtCMEY3sqKhkowrTNzkUvzbexBFRqtZVVNEb4/BWJJDmcnfZ61bhIZkE+jPu0NxR8LyqCoFY+kEOAmHMrlWAGoOejRfSLVGiiJNg2WgLxpvgL6vOpjPTuwzx7AOZzRFsHRaF518XCpB56c4cYF3xvIG7vxcOBGPNQKI+MEnckG6YIzaloKmjKR6evBUw8QTIWs+WnPh0mPOMyl9qXB40cAO6LbMSmw4PsQiumsouVhjyuSKdoA8SbXBao1FndQgvxnFgEVuju2VlCfAp7Y0XgOA0LfajGNZfl3BS5re2nRfA339zPwvgAfCnIjRFxWLprDE3VKHePpzH3at8gEbRj3Wj37/W80q9dOkMspFVbNQRs7ptiMtrrepkKIPqF8lyBQgaPoUVcF3Jkhbcp+r42jFFyXJTHwyDWIwrJPHdXEEvt3yARshs5myJ9adW2uTu+ENovkgeBYSQs/UIgB12KD6+QgIHj43aL81JRtGJIqGxEjPv4cQYFz8O0iHpDBcJLEq5trw7Ki1ei89mH+QCMeRvMuRsfHtlBtftCA/n5fabDb7l4n2k/KWkcbeo5d3zTRpzf1TXA5rio8GMzWrYM4KNNPeewnNfH+msHus8XvIZNCNpa1pdShfr4xTWM8XgT7xGNbM/7784YHyqq4EkGWg/GF488vNBk5C+x7jHiI5EsbuQki/iZghg30v14qu10aHaILy7H+NG1StQC26UuSC9MC/w4Mmjkb8nefNH6i2P9FBUtcCjnHs+mnQ9CQ4skLmRnN86uaUeyXXgJY65DjpV5CIAXujfHJAQ4jsisPfQeXBTFcAZNOklu9EfkhSbgOYOtHNnp4ICXd/HwaPWsXeiUXkTA5zXC6J4MQ9+KjWUlAAhl3O4MohHmQqKysEEg/Nci1gX1Er7o2XQdYuTF+3UFxTTWrjK90ICwx8rmeP33aIS1iDeCqQWV2N5fXkeZZg7XN8ovGOp5o0mRGadoYw/AbLl4f6zQxNgTYhz3WI5LlYg5enV4cVID2/QiLjqhSodopvMMa5ExMsvNkUY1quZ5t0K/mbfvrTqkdsfPhUFV58FkOcVF+0GR1QN5Fb2gpxY8XpfXDf0eMUjWhRDp2Y19K1qQ3HlQYueNmg5RFaZi7oiuhybBwITETdAhtjoh0tOaLPOVOVkoTFeHaFe5vBedpO8Zf9WDx4gPevNAvEuJlh6XuEU8tbgLDyr6Ea6bXhi8la19hwTKhRfONxD7t70kyF+kvzHiiXLbrRNHenA+i768I5oEahzox56f6fMeaIeYctFUezyy3b3rCcSLendBRxrNkR3gDp5Tis9jzq3AUiJBjIfs5wYGblwr4/N6w21uAw3E+FZ/hl9v0E0R/aVS3yEKX1wSUL9b7UOh0MjhubhLHF3Z/sAkvf6tizH6bg91kt6lOjxsd2rFkrcelOtpvm4R95Un6nJesuoQV1yQD+sQXvuPdp7LkP44xPaB6yOpxu80Eb7pfv3Tr/7yzU///fU3f/nmfwHq2YNuwoYAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/bolivia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaBolivia50m {
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

/// Widget for rendering the south-america/bolivia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Bolivia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Bolivia50mWidget extends StatelessWidget {
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

  /// Creates a Bolivia50mWidget.
  const Bolivia50mWidget({
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
      geoJson: southAmericaBolivia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
