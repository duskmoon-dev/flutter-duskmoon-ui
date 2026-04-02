// Generated from: assets/africa/mauritania.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/mauritania.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7WdS2+lx3GG9/MriFk7jbpXtXdBgOwMGEF2gREMlLExgDwjjEcLwdB/N6qPpMhSNQO9ZGYxIHnIh83++lKXt+r8/c3T09sv333z/u3vn97++/t3X779/P7fPn399fuvvnz49PHt7/rlPz++/Le3v3/6rzdPT09Pfz////oHz7efF775/Omb95+/fDg/9OO3Pz29/fjur+cH/vDu288fvrz7+OHdTz/z9PT2w98+/fc7Oa//x6++ro+v/+fPX/jq08cvHz6+//ilX/vXP3/+8NW7tz+8+v1PY/nL+09/ff/l83f/PJIfh/6Hb7/+8uGPn77+7i8//Lk/oT99/p8PH999+dnf/fj3849/+dmvP396+heOpamqu373qxd5r6Qwc/3FS3/65fdewKbhoiO4IoRpg+CtEpwz2LZEBgY2IY6YucTblUFuJpHMM8ykzuh4w3fE/OjCQisSBGu61QVMWzLRNfHbF9ub22f/9Ct/+8qXJUXBPj0XW0WbVAX5K2UxWVT6CE5zDYamTxYVu007ylZGqKeBXGGv20TYVmyB8tpGm6enbasqNhu0oXhVSjlPO9XW3s4BjrdMRGOaYF8sW7c5CJZKH9e9LzErbD/xyl29V0eumqQYOBMZxB7TkvBl4q4JPrpIr6w9gp2FgsAp9h29KmZwqphAu5mXk0T5DA6N4oB2HS9zF7FpFfsKcd0EPjwND7nMhEaC9yMvjq3q87NTrzABwURpwjNYRDYRNMW0tlU/+HlDO7NA+45WbQ+6rAl2sioUzE6Vl5koTkXBqbxLbH5227YwZI3Rih3z3dEHhYQHOGCv8BzNR1+mVqEg+Nxnxhfwzm3gTBhzHwYXcG7d0NFGS46xfAHzOakxMO/r5bGDDJ0Ilu2XCdbSvvcB7l7b2OhyJ2lq5kZWxF7pTlmXBUFsYQVxPbP0sjM0xR2Z3r3MYovOtoR5CUFuSnPb4r1czByx0eFmks+z62nliuyKvUzut1yIkgU2Xu0Rjbalr4gMQXyqvdTJ63J3RqZu6O7cS9XN9uWxiUcpxpWtSXzhkhTkG+3FGUWjj+3LdtBWZK/V2pVtOr46N0v5dtG/hOu52064cRkzpWppegcqXp3LyWJjDOMl3FwPo/31uRmqNzfjJVz365X5Eqy6W4wBlwcXuzKzbVxnnUJlL+HG2pbudd3GMDdNg/Q+vyjXdYfVfbuhXO2Yy8W/eAmXlbPyYpLs6K0IcH1tuZskO6Q2Yjr4StHK6yqDsc6X+/0lUHO/RP18ZW0jQ6zIthTVw6bxxqI+7sFHpr43y7QUYklJYcHEvsTP+hy5ZkJQbK5NrxPbH7Ee1RkBjHsx9qJDtZ4EUssyfDrHcpGXOPbMkpVLZ6xSVEEeha80jj0ae30zuQcUivKVeUl8ZMd/BR3trlCZLrVa5LJlI6a0r5Kkvafh1tITtkQ8Cl/1mMGR605i4JaoMhojJNVTVInNwp4Px73I0mljj2wb9wSOXIHvM187TiRu5Doa//a1T7Tmklnb7XIhPmAskrDJBRRaZMKVyALra8Cqpg0htGRTZ0QwbnVSbZhdobZ8HLp5YvEtniW0soox1zIWXwINwov0XBEYNqq308iVagMbWwy8U8Y7Qni5Gid0jMUSOWmJkZvwxR5L3Hi8JEQWaScQMWxJsk3TezKpnI4cObGUmcdbQmS5VGFJzTbNLya/yMpM2+Cu6IzPaD+K9rmBpRRa1DCH0UWXpBUZtshMTjZi5LqcMDrG7SDZuCl0ZQoHthjshC+nabBFQkWEcZ1pjpKJLXncTRhXq1fZyPVzemInukfqfFOcTH9u8CzzW0ZeOnFu7VWBh0MKDQ7gA9s5OOx+9108+VQP7k7CbKcwyuQbF9QP+OI8qcob1jAX0FaJBOWV25lIaLxk23kSUokvfsSVIa5METLpr1v/PojpHNt0moPOM6LJn46923UOnMMIOiB9VcgsoZL2kVsPBpqQlzSC+EpN35A3EUtaLDZl4MVXWfFW7IA0iaQZu48QBDsfgy0thiiDxKJeKKBpWiezMWI59y5InBJrP4z7kSubPANZDbk4a48ZUYnOXHJCSf1c2tm+KawpfZUyqCA5MYo50yqx4kivkM2WHTa+2GSxUmVDbmCufahDMkVilXXMHtlstZg7gTtz+5pwSO7SwY+U9OmMzEVxdgzEtZa+TtEG6SXYPhCWBItStSmQI9keW2daUO6ctOvx8paCxGvNPV7Z/NyEVRNZZ4cbnJflK8oGyQ4Pt3Vv8/GwT1oe5bJMybU+zlpoBF0Wz3NbAJNQ7v1wRab4Zt9C+5xJELfKW7L8yty9KHlWeLyQKw91yKtzrXXbo9f2Mm4olU+6pxdyi5NHffaDa9B1wbSIbk7xy7hcJ8756lzNDle8OtZDzO/LAeamVZv5r87d6jy7Vy/h8mLhtqpfnavtvI5BB3+Bm9mC5JP9fH1uFGny9dzBwRURo4rmZWBZxH323Hfy/wu4MpQLLeF4BpxGrFgt0PPgICNSaBk/D7Zo+QNUYvA8WJWjMB3u82DeJ3v4+mBC7eBnuba2wDURz4P7ydF+9WVsK5x2vv4Ud6TWUNX382DNI4Z4fbB0Uh6rlHkezBRqUAzpWbCunSQMCQn+D3Cp4ZV6z4FjJ1p48jzYM0BN+SnV07niS7RPTc9Cl9vVGddlcDC4yyzbuR1Di7oUTsSxLL2G23Upd0oSPCtuIs/OxW1qHwrjRquqJhHtSfKh8QOWlbp9VMSILt5wGaB0ndPeY5xVF1W7YNAy1k5E255qRBpMqNaGdbFQzVoI+UGIA3JdZU4ZySoh0BdtcJuwOm0PWekqAgU9zoh9++R9yIraSthNqospL1ElWd55Ksyo0EUdtx9zG9IhyF6IILhO0eMI1lJM5dfcLBvr71sSceqnUHBsL5p2hyx+lAGiYLpErLj9moRnwlnmBDCvcsuCwcY5urrcIssC3aU+f24hQV7euWzsjG8JSFup80wYnLlvMJ8qwBHcTRUUSgKfA6jTJ/NU6KmiALed3iqyH2AH6wt1hQTJmOc4YHg/16lrn7Zdc8E0Etui2zFxsAmaxbaU9aI+OWADa3ptuV06rDzAjMlEuktF3pQMDWZQGM2+iHjPsasD9g2lqLroWlnGOrgHWHaBYAtqSeINTFhysasJr9HiBlMGpMDgVhzvLsC9gbvnCQJuQeili8UDLKD52u1mMtUuy0022tgkVvQFcVsVskPRqShtyfzlCMI7kMTaYW2t38CYxr+rJMj3qG4XXmxi4BRnC60vErjuF1EEGtydCb+dmt3XoQXa0H3XIy6adzStR6shsGvS3pcuFkcxvWOj7Zh2cpcszmA8StHZ8OzyjnlV4NG26Bh5exjziDs5L+CIU05ngtd/eCFtEc7LLWD5+KmmkhhLfRtMqIqkwWpzxVmDHY74N5hamj6Ck7YLg4eb5b5I3unH6xAEy86xPPlMRYfiwOXWhvVYTy3dR8TBUpAuCbwqnWnJY1eCYGMeC/uEFhuLQyVHDVa9qBI6ow6H/FuUfCmL6eqgym55Bq6KU7E0ci1RuU4vCnLJSePaVVIsYYGCs032qShzr45IOrqj7VGaMIK7fxVUidcnBR9JycwN3iHwgC/B6C5wqxbXoqbmzQ7i3bHDIhQsfFQwI5jo7B0MzE5zpKLrEuHaha52rtMZYwS7MFhE2GC7tXirJbBOrsHa8aBpR+eqgjs3RUcIZ4FuF+ya90SBq4LScgq4cXbEH00DddfWDlJN4LbquiwS3HihMc5wO1OnSQXIreODj2BzsHb52Cq3zg59scBd/w64z9sB7Ku0Ot4GgqnTEHMPkc2pkCjzzDBd2mPFoo3Wep1r9FZs3OvbHD1/WsRkU+ajudL5RrR7rdelGVCf/8mJJc77h0XGkM1ZxIyqgtq22jT3f+mFCEevTrGtjtLMBvfJBN9K7cKNfacaDOuY+ii2zp3PYIaTNaeOZdcUZOqH17JwLBbkK48e+rIq6mgWMXA8KinnqaDAg6V+2sRdHp6/AKyP4psZXKezJQYWvkRhD/jI8jEwC3eFyOXC6xbQ0AbxxQ9HYAYb3MjTFz0KkWawp2JBphaw3drc9oCpO5iDYLnI5A84LbAG811TSbdmM5GxsQ5BzfUT47iAj6UIgk9dysW6elRqY+DsqsCa74+wc/BhYL/FP86IW7iAcZVuTk3vZ2r3GgPTrdajD+NOXGF3fwvjLhX6/FNvBBB8jNRL4yjPTn+DYL2UKx27Taqwfaerom52G1uh7p12h6i5jLzBesTpGDi7X9CUEWtwCtiGp8FHHTXbFD/0OcHAcUlFN1fgo61T8tqOzQzmU4+HgbutFU/anbMowG5tzaW49MPuNeGC1caxLttnpV5mgpRQPZdVdNzr5ocRGD3XdpOZxo63De4jCJzjx+U+c32jmQ9d+kz3yZ1oUxNudeeZxtk3dwV70TTYjxM9grMTKlirf13yeNOUERxd6oCemXxLvzYYDzu2fPAW5O5+0O1Do8qrh157Bj+CLiC4syajj+Av8Rxb3FaXQ/O0uAzFLlLp3ijXN2o41gZmU8jat4rM03u8zzZQGl23ZOZ5IxMyMG0lq/wiDDpvqHBaROEjnv0w74b9BkaZesQdFp57v4qJC9TppMHXrpT9Lhvn/sbAecQwl3fD6Bo9qHX80bXfY6XcvxLD9ttmza1PfbW8vwisofBHU4gZ/AjFYWDz7qU5v/PTTgswlSnLTmOSaUP3WzS9YMR6sorTHNuq08UULSf57e/a9eb22f9+/ONH37/58f8/vfn+zT8Au5MPCYNwAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/mauritania.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMauritania50m {
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

/// Widget for rendering the africa/mauritania.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Mauritania50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Mauritania50mWidget extends StatelessWidget {
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

  /// Creates a Mauritania50mWidget.
  const Mauritania50mWidget({
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
      geoJson: africaMauritania50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
