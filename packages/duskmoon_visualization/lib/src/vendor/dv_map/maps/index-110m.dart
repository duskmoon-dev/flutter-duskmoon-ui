// Generated from: assets/index-110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for index-110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE8WdS3PjNhaF9/0rWF7NVEXxZGYxNdlRtCzJelgtUnbsqakUJMES2xSp5sOOncp/n+LDsgmeS11GhLNJOfaB+nwgBFwAF+DvXwzjLFoJT579bJz99NM/dmc/pL9aBYkfn/1s/PTvf7//f+jK6Oxn479fDMMwfs/+axhnvthlhU1vI0NXZOWzP7hR8Kv4Z/qni3vlt//Kf2u+/3oV+LHry+wfPTMfQnclwB9/jbxkkypERZH6e3n/u2pGRJHMPjv7ITrPP+C80P2Ykv/4LQr8s6zAHz8QjP4m8CCieY0Qzf61PkTFC0WYybiAXem7PuLrXiG+bm+qjW9ZtkLgZSo2XRBHz8KHD7B7CwFv9bXRZcUNxVgI2ZhJ+Oj6wrgUUQBRLyHqpUbU3FHnoeSIwv0gboCc+GsX0g4h7cVQJ23ZDA2a6riMltjJMAjg19OaIEhrMtcGuaq4ISjfhGxM6ceh8Izcom/M5T5Zeu4KYsOWbJmX+rBzd51c53fCijuqGoiC7GrZijWqAucCVYFjXeirgpITCncr1ly0C7kLVqGI3dXhYRvBgxFvpWEF/gb2YRbEtq71Ya8PLg/PrhM8dOKt7KzKLokqOfYB7Or65i6DJIad3QUcpi+u9HV264obCr8QcjF7m5d9jBh7fcTY699pY5RlKwRgpmLTfU9EHISu8Ix+4voSxiT9r4i0P/2qj/Rgq7NRbFHUagl2DYRuHGLu3hw+4bm+VixVMxRtrmMzxls32ONJUc+BkM5AH2TFDUVZCLmYfbHEYUnfhA3Y7Gpj3JStEICZik+3W+JH2IdRV3+iE6/sheRLZWzALTEn6g8g30DfRGGz5UyIMhWbju5epxBvqG9Oy+xTm3WkOWCn60aRSCAnnNr2pxqbaW5pqViqxS3UXOrhUxC+GFYgIhgkWHDWZw1vtDG7qaHOqmyIIP6g5fKOpP8CW/Goh0hHGldmHstWCMZMxaUbyyiItzDSH9uIb2zrW1nzVDMEYaFjM7pLaoF0DAOecVff9N1TzVCMua4BI26l4ztMqC9o98pWaD5+K52ItdiIaCVChDiB85LJRV8b4g74ITjfpXxYTzzDSeYEjieTW33h+U7xQkKmsgaAGG8M8cZa8VhwDdCS0I2Fj3ubCextJnNHI2DVD4n5JmXDBmGwWsGxYwLnHxNTX7+6U81QmLmOz/iahvTfEwkx4f7a5PpeI2bVD0n6JuXCTsXOJWZcU/hAp+ZEG6mvmiEwCx2b0d1IOIpMYTg37elrsn7ZCsWXqhrREU8QjpLTvr45pa+aqSPkP0H+UjUktq71xQV/bn36pEXp+bPw1/CBz2G0MNe4sRoqXijeTMYFtKUvN8JDhDZcR7A1zsAi1QyBWOjYjK4MQ2GMZeDDccaGkZE97ukDzRx1vLIjivaDmI0cpHEVbLg2TOmwr/WNNZFqhgLNdc0YPeHDDcTOf/6DOEu/1sJZNlSLmkr5tEm8NVST77z3MIS417hnHKWOOqqKBH4XN0O2k7WAq/A2XEGxbX17pTlEVDZUC5xp2bwkKdwVti809sQ8xiZ0ToDjCAfGEY7GFLM4YIQNqYiNlvhuhHtbBw6izkLfo4tVMxRgruMyLjZUJLSAD3ChMfRNNqxIKJexAX03lutSqoYj/FdqtcGBk1NHY/JnkhksJ1lUDFJVQZfl1s+tjGIZ+oYttiLEW79wX61n69v6fc49dSLFE1ELZTkX/J7cKL2HG6X3GjdKX3kbpa+NNkrv3d1SLJ9hbHwPpzn3t/pi49eKGwqyEHIxpf0sYteHi6M2/Dbbt/qWmmSkuqGyFgohP5k7FuEqJsJEE+bemA7ZbYFPA7BQpSZ2VzUV5IPmw49s8Id0A92NYhxEmTCp0rwk1ytKgyhgVv6u0CIzFdzIFecflGzScCeJYcmEXZI5J2d3p1GqRjBhrmLTvcpwKdxvxGOE31TznuyQTgMEXjDjQcjO7Rb+xhNrGW0RZheG/N0+Obk5CXMJvEDMdyEbc5sQX8guzBTrOmRofBqi4gPjZSI2Wpj4Eifnw6i/O9eEpvjAaJmoQVL+MljjLmYEw7zRQE8Xs6o4gXhvMn7euYuTwyz46KyBnke3KtvAaKmGzfWyD5MIgsFUBetupgdM8YHJMhE761REseG4uwBuMDlwEdf5mGbTIp4UUdyJy14g4ruQnfcmg3BDJGbCTbR+j1wqOYlxoxqBgIWKnd/mE73KEH7vhlM9A57rH+9SMk0DrsCXxCLQEA7mQ3r97lQ21QrFl+vYjCEeyIcw8WKoabRzw6PDeCppAPUdQsGJ0nBOHlI4Fer7cajvbKgoFBJu6g1hNzm0yX3407AUHxgsE3HRrsQet8KrGSK7mulphd/KNiBYpmFzBSGx+n8FN+yurvU8sm+KD0yWidg5vuJVPG6pefkITuhGJrn0chLeI/ACEd+FbMzkWbgwa3sEF9FGt2Rm2mmIig+Ml4nYaC/h5uWVfIJwA2DU1/QEgReMeBCy03xFAEPnMdxbHZt64i6v5AKipRJ+DvpS+Pgc07gLubp6ukxPNYLRclWTdN4XIuyawBnP5E7PlGBXcQL53mT8FMn0pgsCEMbMk6meJc1dxQkGLGRswBfh74jUc7iYOaGP/5/GpxrBeLmKnTIo9zi7agrDlelsrIXNL9uAZJmGzRWE8dYYBcRR1xGkm81HeuhSM53HoP6oa8b4rmxEmm580ksrzXONTsdN9zFZiyyKmot9vcOD/TX8Tl5P9IwZwe7oMJ9KuFAz8UjuD81GsMmaeprsvuIEwr3J+ICejFIjkBAmTM1sPVsn+6oVArHQsRm3rufu964v4ZdxBpenZwM9HesemcGc70ou6VcR44HxKwxIv5p6JhTfyzYgXaZhJ7qJZO0aZiiIvAob4tnmQgtelLrpCMUNpPwobZbFSI+UcPFspGl2n2clckbKD0o2aegaY+E/Qs4x7F7HIzLx4DTO0O14ZSuY8k3HZnwhDoDYcLJh32l6ji/1Rz8ytpcGxz4c4T7jcdGadhy4fuHc6hnzY8UKhMtFfLpvLj3yO/B2IedKz8gfAy8E4puQjbkVZD68A4dFh7704jTIihOMWMj4ibbho3yBeLAbdRZ6vn6x4gPDZaImaGmaDNlIYdztjPTsusfQDYn5Jm2Ya5tGAEZv54YixrGcCTc8zbmeiLVIkk2H946suILwqAi7El6Xku6UFnBZfHFP5paehg68YOCDkIt548rYFzvEeAPXr26metr0k2oEAhYqLt2d3En4/O5g073r6WF7KduAZJmGnYTnLanMdxNuIZpjqmX2kjDYyzo2WVGo1x4v67Pc8w84L3RsxiSKiWjOhLlp5oKaYLXAqJqhGHMd/+ZjTxCrVl0YsXbH1JB5OuNSNUMwFroGjBs3gT1MF34Luz1qMaAVxrIZmjHV8e94jnxXGMJfGwMZvspN8EQksHXh5Lk7pE5htICceesIf93ZIm9UDcBi/KuRvY0gvr1duCHZ7Wts2RU3FHQhZOfzhYGIMeUAhryDOXUX2OmUK9UMAVno2IyvcrXFjBaMgiwy27sFRtUMxZjr+JcBp7tGj4jxAq6MXEyp6efpjGvVDMFY6NgJmlEcEDFDD/bDPVvfeCpVMwRjoeMyXro+NcO+hHfzXZL3Lp7O+KCaIRgLHZsxFP4K7iA03uhqgVExQyFmMn6ObbgTPlxIuIAt9aJHrT2fTrhRzRCIhY7NGEqJn2IfDhz9uaUPUfFCEWYyLuAg8TcihA9xsECEA/LU9emEW9UMgVjo2ImcK0l1N0O4mze09YW2rmqGYCx0/AxcmhF+GYdzjYyqGYoxbMYYCw+21CGcaA7J85gtEJatUHypip0eGETBE7zc4S8YMB4VMwRgLuNnBsZPOLIZ3yDA8Y2+B+gpXgjAXMa/4TTeJtSKzxg20rGjb0z0qnYozDclmzT5Te6WQRJuICocOcaLX/ShAj8U60HKzx701sETTh6Eh1ImF/oa7k41Q2AWugYZknF6IViI78qEQ8hkqm8GuQN+SNI3KT+fME3mSoceuKY3hWuz0zF1iup0Wh8ZInA/aJvlGU7ESq6pueUEzp8nI43MWRbhrmqK4i7rG7A/Cxg1/AXDqq+YoVGfBTtwmAVU5DeDDXl2rS/y2weswC+X8QHDOCHuV5zBUXVG3lfcBqLqhoTMhX/m0lBbhkRa1xxf2DbXt3H08b6jSPFFoFeLsCshzUQlyOERrvm1vgAqVM1QuLmOzZhExGGLOQyc5gvqsEULiIoXijCTsfO7vOBJPBIpXnCgsW/0LdRGFTcE5JuwCSZ1hYwN1zHtG32LJ1HFTQ1mk6tk7L3A733twa6oZ1OXIbTAWLZCAaYqNt2zXOPkAxsGvTZ5a1cLeIoXii+T8QHd+DUPGBGlBVParIFOSmCIRD1o2RlBj6EgcvcXcFd3MdK3pZmoZgjOQtcw9Wvk+pt1APfs+/BUYp98a0wLqHkW16PqiSIuyRtkKbiv8Nl24SZnd0ydn83nROZOHruDLp93iKqwkrJQcqZilz7mPFfzLxLyBb421IIt2jKpYaZt6pXirJ46V7OpgygWxpy4g8+C+y8W+R7I1slTd536a5sV+kMJdg0kS8wOw0RrQc0BWmcv+TpCnSz5+/vBzvWPvtj5As4DLsi719umX7+5ZLzguVwX1ZLsrADPsIX3JNb43iYbrp/bYyqLpe0qkV4nqtirr4sPRZpsxpKJA3241tEnd7naroJN1Vx9BRwK8N/lKGKZnnyH+HAdpO981pdiUzV3BP+tAHunWrj4vdYDiD5wPmsk2JaN1WNnYjZy4K+TUMBF6gFM+x6QV321Tl3xdgS80POvKNoJYui/gqc4rsgXPbWN/k21Vk9eyNk7MfI3l3hj2S+Ie9KjttXa5t4pzuqxczX/rVArEYpNAh/4FC6mTIdUrk3b4H7VXD37oQD/yLkvdpB9BiP82adF+HvFWT14rmZTJzKMgzTEh+19BkP82aeF+PvMXhqxsxv9hyL884bS6Iqt2OF+vgsX2boDakm47UpI3/a1VO3VV8KHIuxKCF3fXYt1lpvvBEtBvOYEDvWOQ90h1XplFDazfPtYsXmkUqpFG6722HF6MC7dHaoAfVjigs1lYVMJCW3XULGsE2Ve0+2fSon6aqLKNzqORL21y4TzZpPcXrleyfL+T7VagqoEHEmqf3NX8RnnByk/j/objIgv4Vnsyyuq42yD86HkhUJMVfwsjWfDEh6dszC1EObUoqZ8bWD68rmzqpqieEvyJuD3UlAz3Slc6Zze68Z+VS3VQRdifvyzT4SRgvcT18eXfMzggaQZeVFbG9z71FcnBdoovih4tQT/hhMv2AW+MYzIvCQbrunb5JnRNiogym11XNUWxa8UYB9wFn4i4gRh38Be+4Y8RtoG9pNqh8IthPxTIdJfbY3sOpv0OrQ03Dm8HSa99wU/eQe/dsWh3ktoyyfpG5EUkfG3YC99I7P797oqidIinbRIJy3RyUrUdPcZSCcqQLKo5vC2mc6RtgL/rXPGR/Lf7bKRKSCOAuC0wpxT/Ujx0sjjIVLxesZjIZKomqtU0MdPOj8U4J9z9Vwi07oLF8+7ZEpY2/BL1Vo9eiHnv0xEvLowT6wLH3p3TsXFrXMrzo5gZ+oGr+Hw4J6oBdfELfIWt7ahV2Vj9cyZmL836AXUC+Us2MStT2viq4q3I+CFnr0XtEqofaAejIh7FpUi1za6VK3Vkxdy9uApvMd0GKiLkS5hetnlmEova7sGHgqPxwOmclWo5fibQi8CD3N9eDNFf3H3STWxUZzV8+dq/nQhW12Fad0zyD2bfxb3vuKtnvxNz2aXIQyTZzBdbdajMn5a5y75OsIsQ3bIbCehm/2MZkRwVLfJC8vaZo4q3uq53/Tslb8woZr5Ajbzxac180S1Vk9eyNnTQenL10Tive4b2NJvetSWSNvoT1Vz9fCHAhX8L4bxvy9/fPk/BQ8EBGujAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for index-110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get index110m {
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

/// Widget for rendering the index-110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Index110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Index110mWidget extends StatelessWidget {
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

  /// Creates a Index110mWidget.
  const Index110mWidget({
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
      geoJson: index110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
