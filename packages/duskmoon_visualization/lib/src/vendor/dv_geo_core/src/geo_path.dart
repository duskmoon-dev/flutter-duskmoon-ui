import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import 'projection.dart';
import 'geojson.dart';

/// Generates path data from GeoJSON geometries using a projection.
class GeoPath {
  /// The projection to use.
  Projection projection;

  /// Creates a GeoPath with the given projection.
  GeoPath(this.projection);

  /// Generates a list of paths (list of points) from a GeoJSON object.
  List<List<Point>> generate(dynamic geoJson) {
    if (geoJson is GeoJsonFeatureCollection) {
      return geoJson.features.expand((f) => generate(f)).toList();
    } else if (geoJson is GeoJsonFeature) {
      return geoJson.geometry != null ? generate(geoJson.geometry) : [];
    } else if (geoJson is GeoJsonGeometry) {
      return _generateFromGeometry(geoJson);
    }
    return [];
  }

  List<List<Point>> _generateFromGeometry(GeoJsonGeometry geometry) {
    switch (geometry.type) {
      case 'Point':
        return _generatePoint(geometry as GeoJsonPoint);
      case 'MultiPoint':
        return _generateMultiPoint(geometry as GeoJsonMultiPoint);
      case 'LineString':
        return _generateLineString(geometry as GeoJsonLineString);
      case 'MultiLineString':
        return _generateMultiLineString(geometry as GeoJsonMultiLineString);
      case 'Polygon':
        return _generatePolygon(geometry as GeoJsonPolygon);
      case 'MultiPolygon':
        return _generateMultiPolygon(geometry as GeoJsonMultiPolygon);
      case 'GeometryCollection':
        return (geometry as GeoJsonGeometryCollection)
            .geometries
            .expand((g) => _generateFromGeometry(g))
            .toList();
      default:
        return [];
    }
  }

  List<List<Point>> _generatePoint(GeoJsonPoint point) {
    final projected = projection.project(point.longitude, point.latitude);
    if (projected.hasNaN) return [];
    return [
      [projected]
    ];
  }

  List<List<Point>> _generateMultiPoint(GeoJsonMultiPoint multiPoint) {
    return multiPoint.coordinates.expand((coord) {
      final projected = projection.project(coord[0], coord[1]);
      if (projected.hasNaN) return <List<Point>>[];
      return [
        [projected]
      ];
    }).toList();
  }

  List<List<Point>> _generateLineString(GeoJsonLineString lineString) {
    final points = _projectCoordinates(lineString.coordinates);
    return points.isEmpty ? [] : [points];
  }

  List<List<Point>> _generateMultiLineString(
      GeoJsonMultiLineString multiLineString) {
    return multiLineString.coordinates
        .map((line) => _projectCoordinates(line))
        .where((line) => line.isNotEmpty)
        .toList();
  }

  List<List<Point>> _generatePolygon(GeoJsonPolygon polygon) {
    return polygon.coordinates
        .map((ring) => _projectCoordinates(ring))
        .where((ring) => ring.isNotEmpty)
        .toList();
  }

  List<List<Point>> _generateMultiPolygon(GeoJsonMultiPolygon multiPolygon) {
    return multiPolygon.coordinates
        .expand((poly) => poly.map((ring) => _projectCoordinates(ring)))
        .where((ring) => ring.isNotEmpty)
        .toList();
  }

  List<Point> _projectCoordinates(List<List<double>> coordinates) {
    final points = <Point>[];
    for (final coord in coordinates) {
      final projected = projection.project(coord[0], coord[1]);
      if (!projected.hasNaN) {
        points.add(projected);
      }
    }
    return points;
  }

  /// Calculates the centroid of a geometry.
  Point? centroid(dynamic geoJson) {
    final paths = generate(geoJson);
    if (paths.isEmpty) return null;

    final allPoints = paths.expand((path) => path).toList();
    if (allPoints.isEmpty) return null;

    double sumX = 0, sumY = 0;
    for (final point in allPoints) {
      sumX += point.x;
      sumY += point.y;
    }

    return Point(sumX / allPoints.length, sumY / allPoints.length);
  }

  /// Calculates the bounding box of a geometry.
  (Point, Point)? bounds(dynamic geoJson) {
    final paths = generate(geoJson);
    if (paths.isEmpty) return null;

    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

    for (final path in paths) {
      for (final point in path) {
        if (point.x < minX) minX = point.x;
        if (point.y < minY) minY = point.y;
        if (point.x > maxX) maxX = point.x;
        if (point.y > maxY) maxY = point.y;
      }
    }

    return (Point(minX, minY), Point(maxX, maxY));
  }

  /// Calculates the area of a polygon geometry.
  double area(dynamic geoJson) {
    final paths = generate(geoJson);
    if (paths.isEmpty) return 0;

    double totalArea = 0;
    for (final path in paths) {
      totalArea += path.polygonArea.abs();
    }

    return totalArea;
  }

  /// Measures the length of a line geometry.
  double measure(dynamic geoJson) {
    final paths = generate(geoJson);
    if (paths.isEmpty) return 0;

    double totalLength = 0;
    for (final path in paths) {
      totalLength += path.polylineLength;
    }

    return totalLength;
  }
}

/// Creates a GeoPath generator.
GeoPath geoPath(Projection projection) => GeoPath(projection);
