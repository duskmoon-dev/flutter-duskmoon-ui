// Generated from: assets/asia/china.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/china.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51cS49Y523d61cMtA4Ivh/ZFQGKblp0XwSFkKqJAEcyZGVhBP7vxbmO3djiLEwthJm5M5xvePk8PPz+/ubl5e2X7799//b3L2//9f27L3/7/P4Pn7755v2fvnz49PHt7/D4f3/88ndvf//yX29eXl5e/v78//UPPt/+PPj286dv33/+8uH5oZ++/eXl7cd3f31+4A9/+fDx3c/f/vLy9sN3n/77nT6P/uOrr9vz9X/7xYM/ffr45cPH9x+/4Nm/fPfh3dt/PPvh50P8+f2nv77/8vn7Xx7hpzP/+9+++fLhPz998/2f//F3/iz40+f/+fDx3Zd/+oN//PfPH//6s68/f3kRHvIK5cnfff2wSaaKeX716I+//t5FsDCZjXTNKjirbUJugqM4PbcTD2lE1+hFsBALc4itgnNidI6qqM4Irq8FKxNXhXncBKtITO+ChUXDD3J5SGQ4Yldxq7D15cDclJoqFatgy+qui4ohOEK5V2MLruyLSdy8481rn/3iV/5WV20mjZnhxTxdyXxmxn77H9mMl+3GvsoVtXGu3y63msItk5cA4ELRqq4HI6om6ZLJXa50mMTBhipp2L19sU0X4kzvo9zQtFxM05lcazwPcbCCPKt1FxupXHqwhnKqyk7drIHJMl3jIteoVdVtCVU21GNTdrEGo0lmMVnlZjJzH2JgGWWF1SzeZkNuopYXazAa7Q7VRS4iVbSc9OukUSG+nbcpOYNP53Xq9JbY3luTVbfn7bytMx2L/VrRDPMp6DhNM7MuTmxFLgigN2+TaNbajytmbJcyqYJ6sqcWd7OkzGw+RYckGW3vzRzwO9vZLm5R1FYeW6K1IB9nnltQH1HNXoK6OZnK2MnMmlqEOzd7MApOmT6IHVLuHlnqAlOacRvPk1ypFO1NvUreVnU6b5NHu69qUEppSb+YQ1NZ92w504RCYm7mO1QqllvSNKZuLfFDeGghEdHILVswSZv3xY1bKDSaVz0gyWvJ5bhKphWim5mhbAvNPqi3jcxKJBY16JCnlcnBfNsQWWbLmTpkyqoXa2gnNY+arc1papseu6g3iEXSesnF2pSuVQen6KBWM5kllmmTskVdlJs04SGbEoqmXFMOoaGbRNl9bU6LujL8ZLsIDWyb6WoTd3aePBgB3dV78TQt0plb9d9Pp9fCuy2wa0Uf5A4TS7RuiQ3GMOmnVnoY6g1Z6gYcN33CLscV0ugOWwLvowZO8UMeHqGczNgSkBZVSfnFekcp2ERW9dZTW9WlbhgjFzOv3XzTOXUOsWGcImNma7Z1CAHHLhF9gpy9WffQyyYleQg6kyRSWSvCNOShzQdgZZKiE8XBKxGdpy5l5CSpd5vtbuEibBftFvKwiL3ixAkPPwSzKRqR6doTm1mMXzDSaVJPtQ16gbd5qcrFepuyNYe3uqEouFv0Yg5NJcqz6jep3MIuQR3nLek1mAUBnOYLAjVFpb4CWxrEbWl10UJRspesZQ4qq3K+pExoIVlz64nVidO0L6GhUeyVz5YxjcQVVnaQOxQonjaERJXGh60vqWJInVGfrnJF2m6pbWjQN6x6ECrXsTy8NmEmlwxbo4NQRLddcpCwkASzbblCqH2mL83gIxfgS+yC3TLqoGDI1QKmsytCWTLkNDUQalQPq8cJSQG/PpgaBGcoyzb8UiWTlrnYsLCSFLttsJkqeXrFJcNBcHG+6nXFXbdxHQNl8RDfUj0EW8WlMhF28sqO3nK9UstIXKA+4SDTUZ5NsJGFctrJjgNglHq9Etkqe/TkeEml4btHK9W45m2slhRZWms9paTSyn4SXMRuvofMRj1/abYwBuRg6W1G9oRMtTqNcLkpVFt0c2ihklC5jFswYex07xWDELIJvrndUGplrBCPEHPrpWJ9ztvTuQ3JlUlbPS6gCWbZ7s62gkdM5gIw4Sa4OjxjK3+g4RK/tMrgC7Rb7CETxsZ+gqVEjNSF65XsAYZC1okvYNScgJBXweFtNqcTO0lo+IbXIk6oVZ5isTgVALraIxvGIzdrwwyEy9ZSRQlz1bITiaRIWzBuW5NHqgfL6d2B4ZBdK+LjFF42N6LOUHT4Ok/XoHKu5suJ4bWDc206LuIwPY0kBaWZRqbsWJ1YZJ2KIBXKdgBye5+vASz+JnisXdcoP4SMpafMj3Aw+goyMdSmobeXJwDWQtb5N6O7GzllfhTs4BCsE0+mrNQ8uTQKh5GRrWwzRt9ocfI8vDxu8XVUDVxTpU79ElShw+LbNArFPJv0JRwrUypbzibYyCrrlv2R4bVC/ZUxbTLmHrcgJCHKvZ3YaXg65pRAwAHxSNkH1gmgkU8uzZRWzOvEGqgpqoqjuQm75ObSoASEmJ4cTylAf/CNyZE0doT2IdiixjZSHzgXAVLVJZc+hbVo9Db+LHI0UxcSA95dPxPF/cRdGPdc2nMZKgYkvsWgIom0Pnm0gB8habnRhoqg4bwVsU1dLb4NK6GKKTvxvSCYY3K2XGqYUIlXnAqhojCtddRhGDpWWpxe3o9jPt9mHQbCBx7ejILVPDebAF9ZzU7VCkKbTbLu1Lee5rig5nCPhwK4sVDALRyzPtFpUV85W2w24UjRaX1qz4HfZsfscl3VT1RTHBjJciW/DVWwppxCJvivMbPmUfCgucOOhSaHR6xElH5mCHWqjJXExFZe0jyQZFzGt5Db0O82DwV906r6QpYQddKM1A12tAEH0+eWO4K4ZnwrKB7i7bSeun5NeuC0DbEBr5nL7MKegeDO4d76MAfalpEX4rhokbnVxjH0p32Qo1GAJNNuG6fXhTyz6kJPgmAOVYkli7qAtqd9oe2JDsWArLkECldy9embKuY5VW6QsSsNmBqnHhqtlmFjYD8xcEc9VYOPYOvc0h1OzMZy0rEJiXuuC0UQDDbxCbwyITCyV6jUHZV8yFUwa8h2XqfJmqMaus1jw84dkwuRPDmHGfHUhql4QPMncMmMKid9MwY0STmnPtTwWtS2dF+kon7xNXMKXjtQL4rq04qWBbGmiWxnbfJqvS2VPX28xWyohPdDZT3x9sRAqcp1u6aoum9WyzRdGxkQQodPVZTxs0U0a2JrKgX765TjB2OBlo3t70PujJWTW8bMFfnyoUq+YTJAnMtjK1IDLMGpOY3dFaDAyMrZCyEL67n19Zgqum0tZwhVu8apMwSnxxNUjEUwxqBac2G6PDVfNmDWRbCRpGBx7CLYKMBkX8V6nCgCmLdgBrflSUg1qSuGzWzcvjhFGGmIs5ycgkmquLfiCa8trDtPdsYYi9cr5hCSqhdu6CN3JY2H0KSfldDr/mqgabYbVAJG6cqqiyd03takB+WS50YYj2cy0K0n/AXI26ivxcJQCINndRGcWDdvXjdRMc/GyuhRsMwzu1kFi3nMhc2L8aR3rOMifwZc1rdZOOZ5ig2uPRFrht820ZOMe0K3dqKoA/P7kybA6cfq/H7ixAb2bTDwsOTBUlx1zJng198EdyLLb1XJQ749zRsALZe2bt7sYNM03/LFMyExzS0de2K8daLAPcCym671aVJzuFzoobAIVynekjHOC7rSaUAiSSXVueIZScA8+TSklUCjzrMVUh5UWnpZfQY5wp+J22bCges3Wm7vzrADNpybYKfG6uMNslawQHmlIvuP21geJ+8Q6jKMsPb2lZXrxJUVIcPa5doPOaHQurVZIgQcyzZmiztxmdRtjCHYrI5emxcDmV7kshEPwYKWas12Rs55TM/gOeNKkf1iiy5RO4HhDMb3ay3yMw310+462IvlXns/izVdCTm9O06o2GS7eAV3cZib1om2B8DJZ60FgdVit+DU2LODGKm9olwPccL8xn43MlF9DV0eLj/e6SLUZuyv3HcS4n1jqTO1Y6tpi22gqlnzhSaCfQiJXu/MwXnVcy68lsFoXmqHI5TKu0946iTuorHXvK400i4T5Qkq0Oe2mZnDWMb90tBMkHF2xaYHBxPTTlc7jFN2j64zAQeN/MaVwWpiYxi0y50Kr9PeDeKL9Ww9KFKo4Balg1jMdSNsu0LJg7QTf8tJbnTUXq0FYY1KLuMynLe4V/Y/6tZuOd3XMyBHc+sa2tHIWPilkcFCdLjOtiX09DHgrt0WrVmsbc32TRhe56XN76LnRoO1PRrSqdONHF1kMVPr7VhDKj7NF7lJuF+t1todN1wN7s44yEU0a7VtoQBzgYiKS58Iucq+7jw6Ir5OXmhpHSTpui4uo/3EtS9xMTPDztir5zVjNjlE9Vbgp7O3n0GIR34peFpovLheiZImxXrh5tfQZAqvY1OnkYqTFzPACF3p6P6o3i7QKu6Ma5bYbkt4ZrHMp4Wj2x13b1777P8//umjH9789P8f3/zw5v8ABpfx8VpUAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/china.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaChina110m {
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

/// Widget for rendering the asia/china.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// China110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class China110mWidget extends StatelessWidget {
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

  /// Creates a China110mWidget.
  const China110mWidget({
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
      geoJson: asiaChina110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
