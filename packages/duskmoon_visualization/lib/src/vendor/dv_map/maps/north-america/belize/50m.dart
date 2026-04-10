// Generated from: assets/north-america/belize.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/belize.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VYTW8cRRC9768Y7Tm06vsjN0DiBIgzKEKWWcJKttfabA4m8n9HvY5DbNcgpSL2MJqe7n5T87rqVdV+2CzL9nR3u9u+XrY/7C5O74+77w9XV7vL0/5ws301p/98ePxu+3r5bbMsy/LhfH258bz8PHF7PNzujqf9edPj8mXZ3lxcnzd8t7va//3v+mXZ7t8dfr+g89yvL57z+fmPTyYuDzen/c3u5jTnfj4cT38t317vjvvLi+3HRfefzHm7O1zvTse7p8Y8Wv/T+6vT/pfD1d3bj1/86Q2H4x/7m4vTZ5/+8Pv8/vno5XhZvokcaCgu9urFJPoIlBD2Z1Nvnq9dAXaEZC+B1YlMrQkchO41MCUSQjaBEzggS2AIMYseLgGSpRa4NgIiQ6QJjCSKVAIr+Ty9JjC5sVUU20ChIOImMHvFg45IEeamRxBTIK0AR5hj1yOQ1aUiWEcCWPQsjpHsqFEDx/SIXtTF5BGEVygGI23ai+gYlUPoSDUAbTEcIzwRsJIfG4BmCi0XjmGpaDUuiZsa9XDViEHq0KAEoWyenBgiU5TAwuyR2AQGUcEaN8J6oRyDkYVKGbZhPAWkSQQZBpqUwGkM7E0iKDmzZMIHJiFH1+KIwKgs9sFn7W9yTDajrhI2H5ykHl0qgGc+q5MzmgE2hY0cnaK22CDDuEsFobDWwK7I5s2AJnBxqMuJEJs1TA8Y0glLjmMgoXGvTokBoaRc1SmTJsNuRCMDOVduHIMVnKmpxSQ+y70VYLHwZlqiVNMy3cVgEUhslWxzc5L5msUR7M2z+y+LxUmQmhHND5tr4CAmacaHGJLnmsXm6k2OlSizDg8RnUVQEzfOCaQOjwQlb8aHCxtwJUExwL8ioAOMZaWjSdO+xaHOXh2dj6QIiKbKR3oArRiMogpNn0ghW8PltHZDAwrCZQvmIzMduk0us4rULWM6BPSImG05sZa+5iMBU7mlE61+f7M2evLKL//zwUcqaOgKfSSp2BKtmbhDWav+KgbKuc1vAmtkXYbEQJWpLk3gDOYVOUSV5F5FNjlmJqj1GwDBe4lhAicwVxxP1RLAXuE0AzIgdUUFHqSya/EXu9v/5/uhlJT1VwpRaPfAPQNFaukQz5lZm8DnbrHuGUgIo4kbZFLmax8qRs3G10cwKa6Ivn6N54emENfdk9islpr+CRQrASVkYtIkOFlm41W3kUQp2ZWAWcFBzTAFA/Rqw1ZwrEfq5vnd/ebx+mZzv/kHK49pLWwYAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/belize.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaBelize50m {
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

/// Widget for rendering the north-america/belize.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Belize50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Belize50mWidget extends StatelessWidget {
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

  /// Creates a Belize50mWidget.
  const Belize50mWidget({
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
      geoJson: northAmericaBelize50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
