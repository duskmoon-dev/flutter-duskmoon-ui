// Generated from: assets/europe/montenegro.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/montenegro.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51ZTW8bRwy9+1csdDYG/P7INUhvLXovgsJI1cCAIxmOcjAC//diRrGRxBQKxgdhtaN9Jofk4xvu16tt250e7/e7N9vut/3N6cvD/u3x7m7/4XR7POyu5/K/59ufd2+2v662bdu+rs/XD66fr4X7h+P9/uF0ux56/vm27Q43n9YDvx8Pp/1h//Hh+PLMtu1uPx//vqG1/u7VfV73//hh4cPxcLo97A+nufbuy/ynu2+rTy+2fNwfP+1PD48/WvJs+p/Hu8eP3zx9QT0+/HN7uDl95/L57/vrn79tG+bAFGbN659WhIcyM0D8sPD++n/xTFhVSzwVSeriIXlyBUfuLNKEgwDwwAoP3Umsi0fBBKV9TIqpLbwY6UIYUeEJMffcjZEKFmzl9pkZ9KIRIwWIRQo8SXOKvrscVIZDhOZSNxxsXm8fqzNJN/vgvEsFHiUJYy9dpr/hCFW1UagAtOPLYla6yynK2ISLVIOyeFkCs51+oQgu1faxGLNnE88lL1QHxWKXJp5drDZiCIRuOpta1GSKuQLSxaPMgCoeqGxG3fgaYXgJR2KQ3fAasTFV2wfkFtrdPokQt4qtAAk1umwlBqj2mpxpZHr2q02EQ9wrPAtR78Kplr2IRohAYo/8prvL3wLPV2vrZosKk2HlrrmgZbfaVDQyXjcPGiZo0CZTZUkryJSGESB6O10uaAMa6onZlC4zvpxQpp+aaLv3yiq20jxNR2unCwdEQVY0lCi7Si3GLN2qV9KQQATusoGiS0V+NIQpsb1/qqx1eQjFXOni5UraCk8Eoy397GJ5iFBbmsYwZr6AR4wibfswQaps5gyO6LKfnYNY4XmAWze8kVMxVvaRpBj12CoHEpGV6QIGku1zUZiQvu6VOFJiFnYTj8/6uMALy3bzmHirG1X24WzLvfDmYEOstAHO3uvK3XCwEkqZzUDrUNK3r4zHDO8v7R9PMq3sQ0pK6/pLAWZSsT06qUb3oMqUAFyxPUmSeRsvZ++t/OVJfk12ySGmyFaJDUHlgO7+qczzT0UHknPm0c0XTZdabKipUHbrw9YwpKI/o5j6oInnMPe91FbebuY5nDy4tI5FCdvWCThRKSXBkrmbfc5eTYWmdFEUa5t3MRiSlsRdMvCYU40y+dzQsZvMoel1Lzr3jp6yz5FTmFIlrRTMmtKFYICoA5fSVDKBWufeiWecJlU2q/jsyl28aV3trzoEtPZv4kWSFs1ylgeq9N3VS9URGtzTGhNvyfcqnX0OK7FFBhNvEpxV3OcG0OxFBLMjlmMNGn5O9C7eikaVfq5i3JOmBIPwUi/yXJXdxGOpZ+w0gjybvWPhzU2q4hu6eLuLx5mCVS+PpHDs+ktrGlKNSfqvAGZ4bU5Nq/CmhYJ22TRFqoMMDwg0gW4vCl1zgwovTbkXjdU8EJUq+xDa1TGVhkOmVTN2PNNsFw+XtKrwnIW923x1nr0LcuZBSKTt8AqKVSeFOXSmoF4zmko8g6RgUx6Cv7J/l2awIpna4+b1/m46W76RCQXon1MvTDXmGyOE7oi9/X7xqrp+vnq6ev58f/V09R8tVm+yCR4AAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/montenegro.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeMontenegro50m {
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

/// Widget for rendering the europe/montenegro.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Montenegro50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Montenegro50mWidget extends StatelessWidget {
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

  /// Creates a Montenegro50mWidget.
  const Montenegro50mWidget({
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
      geoJson: europeMontenegro50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
