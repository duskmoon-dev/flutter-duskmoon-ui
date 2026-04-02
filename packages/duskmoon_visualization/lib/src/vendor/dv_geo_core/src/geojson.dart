/// GeoJSON types and parsing utilities.

/// A GeoJSON geometry object.
abstract class GeoJsonGeometry {
  /// The type of this geometry.
  String get type;

  /// Converts to a GeoJSON map.
  Map<String, dynamic> toJson();

  /// Parses a GeoJSON geometry from a map.
  static GeoJsonGeometry? fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case 'Point':
        return GeoJsonPoint.fromJson(json);
      case 'MultiPoint':
        return GeoJsonMultiPoint.fromJson(json);
      case 'LineString':
        return GeoJsonLineString.fromJson(json);
      case 'MultiLineString':
        return GeoJsonMultiLineString.fromJson(json);
      case 'Polygon':
        return GeoJsonPolygon.fromJson(json);
      case 'MultiPolygon':
        return GeoJsonMultiPolygon.fromJson(json);
      case 'GeometryCollection':
        return GeoJsonGeometryCollection.fromJson(json);
      default:
        return null;
    }
  }
}

/// A GeoJSON Point geometry.
class GeoJsonPoint implements GeoJsonGeometry {
  /// The coordinates [longitude, latitude, altitude?].
  final List<double> coordinates;

  GeoJsonPoint(this.coordinates);

  @override
  String get type => 'Point';

  /// Longitude in degrees.
  double get longitude => coordinates[0];

  /// Latitude in degrees.
  double get latitude => coordinates[1];

  /// Altitude in meters (optional).
  double? get altitude => coordinates.length > 2 ? coordinates[2] : null;

  factory GeoJsonPoint.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List;
    return GeoJsonPoint(coords.cast<num>().map((n) => n.toDouble()).toList());
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

/// A GeoJSON MultiPoint geometry.
class GeoJsonMultiPoint implements GeoJsonGeometry {
  /// List of point coordinates.
  final List<List<double>> coordinates;

  GeoJsonMultiPoint(this.coordinates);

  @override
  String get type => 'MultiPoint';

  factory GeoJsonMultiPoint.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List;
    return GeoJsonMultiPoint(
      coords
          .map((c) => (c as List).cast<num>().map((n) => n.toDouble()).toList())
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

/// A GeoJSON LineString geometry.
class GeoJsonLineString implements GeoJsonGeometry {
  /// List of position coordinates.
  final List<List<double>> coordinates;

  GeoJsonLineString(this.coordinates);

  @override
  String get type => 'LineString';

  factory GeoJsonLineString.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List;
    return GeoJsonLineString(
      coords
          .map((c) => (c as List).cast<num>().map((n) => n.toDouble()).toList())
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

/// A GeoJSON MultiLineString geometry.
class GeoJsonMultiLineString implements GeoJsonGeometry {
  /// List of line string coordinates.
  final List<List<List<double>>> coordinates;

  GeoJsonMultiLineString(this.coordinates);

  @override
  String get type => 'MultiLineString';

  factory GeoJsonMultiLineString.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List;
    return GeoJsonMultiLineString(
      coords
          .map((line) => (line as List)
              .map((c) =>
                  (c as List).cast<num>().map((n) => n.toDouble()).toList())
              .toList())
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

/// A GeoJSON Polygon geometry.
class GeoJsonPolygon implements GeoJsonGeometry {
  /// List of linear rings (first is exterior, rest are holes).
  final List<List<List<double>>> coordinates;

  GeoJsonPolygon(this.coordinates);

  @override
  String get type => 'Polygon';

  /// The exterior ring.
  List<List<double>> get exterior => coordinates.first;

  /// The hole rings.
  List<List<List<double>>> get holes =>
      coordinates.length > 1 ? coordinates.sublist(1) : [];

  factory GeoJsonPolygon.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List;
    return GeoJsonPolygon(
      coords
          .map((ring) => (ring as List)
              .map((c) =>
                  (c as List).cast<num>().map((n) => n.toDouble()).toList())
              .toList())
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

/// A GeoJSON MultiPolygon geometry.
class GeoJsonMultiPolygon implements GeoJsonGeometry {
  /// List of polygon coordinates.
  final List<List<List<List<double>>>> coordinates;

  GeoJsonMultiPolygon(this.coordinates);

  @override
  String get type => 'MultiPolygon';

  factory GeoJsonMultiPolygon.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List;
    return GeoJsonMultiPolygon(
      coords
          .map((poly) => (poly as List)
              .map((ring) => (ring as List)
                  .map((c) =>
                      (c as List).cast<num>().map((n) => n.toDouble()).toList())
                  .toList())
              .toList())
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

/// A GeoJSON GeometryCollection.
class GeoJsonGeometryCollection implements GeoJsonGeometry {
  /// The geometries in this collection.
  final List<GeoJsonGeometry> geometries;

  GeoJsonGeometryCollection(this.geometries);

  @override
  String get type => 'GeometryCollection';

  factory GeoJsonGeometryCollection.fromJson(Map<String, dynamic> json) {
    final geos = json['geometries'] as List;
    return GeoJsonGeometryCollection(
      geos
          .map((g) => GeoJsonGeometry.fromJson(g as Map<String, dynamic>))
          .whereType<GeoJsonGeometry>()
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'geometries': geometries.map((g) => g.toJson()).toList(),
      };
}

/// A GeoJSON Feature.
class GeoJsonFeature {
  /// The geometry of this feature.
  final GeoJsonGeometry? geometry;

  /// Properties associated with this feature.
  final Map<String, dynamic> properties;

  /// Optional feature ID.
  final dynamic id;

  GeoJsonFeature({
    this.geometry,
    this.properties = const {},
    this.id,
  });

  factory GeoJsonFeature.fromJson(Map<String, dynamic> json) {
    final props = json['properties'];
    return GeoJsonFeature(
      geometry: json['geometry'] != null
          ? GeoJsonGeometry.fromJson(json['geometry'] as Map<String, dynamic>)
          : null,
      properties: props != null ? Map<String, dynamic>.from(props as Map) : {},
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': 'Feature',
        if (id != null) 'id': id,
        'geometry': geometry?.toJson(),
        'properties': properties,
      };
}

/// A GeoJSON FeatureCollection.
class GeoJsonFeatureCollection {
  /// The features in this collection.
  final List<GeoJsonFeature> features;

  GeoJsonFeatureCollection(this.features);

  factory GeoJsonFeatureCollection.fromJson(Map<String, dynamic> json) {
    final feats = json['features'] as List;
    return GeoJsonFeatureCollection(
      feats
          .map((f) => GeoJsonFeature.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': 'FeatureCollection',
        'features': features.map((f) => f.toJson()).toList(),
      };
}

/// Parses a GeoJSON object from a map.
dynamic parseGeoJson(Map<String, dynamic> json) {
  final type = json['type'] as String?;
  switch (type) {
    case 'FeatureCollection':
      return GeoJsonFeatureCollection.fromJson(json);
    case 'Feature':
      return GeoJsonFeature.fromJson(json);
    default:
      return GeoJsonGeometry.fromJson(json);
  }
}
