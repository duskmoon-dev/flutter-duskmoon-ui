/// Prebuilt Natural Earth GeoJSON maps packaged for Flutter.
///
/// ## Using Generated Widgets
///
/// Each map file exports both data and a widget class:
/// ```dart
/// import 'package:dv_map/maps/world/110m.dart';
/// import 'package:dv_map/maps/asia/china/110m.dart';
/// import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
///
/// // Use the generated widgets (clean names, no continent prefix!)
/// World110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Colors.blue,
/// )
///
/// China110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Colors.red,
/// )
/// ```
///
/// ## Accessing Raw Data
///
/// Each map file also exports the raw GeoJSON data:
/// ```dart
/// import 'package:dv_map/maps/world/110m.dart';
///
/// final GeoJsonFeatureCollection data = world110m;
/// print('${data.features.length} features');
/// ```
library dv_map;

// Export all generated maps
export 'maps/maps.dart';

// Export base map widget (used internally by generated widgets)
export 'src/map_widget.dart';
