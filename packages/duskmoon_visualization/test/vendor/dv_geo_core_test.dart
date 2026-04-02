import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';

void main() {
  group('EquirectangularProjection', () {
    test('projects coordinates', () {
      final proj = geoEquirectangular(scale: 100);
      final point = proj.project(0, 0);
      expect(point.x, equals(0));
      expect(point.y, equals(0));
    });

    test('inverts coordinates', () {
      final proj = geoEquirectangular(scale: 100);
      final (lon, lat) = proj.invert(0, 0);
      expect(lon, closeTo(0, 0.01));
      expect(lat, closeTo(0, 0.01));
    });

    test('handles center offset', () {
      final proj = geoEquirectangular(center: (10, 20), scale: 100);
      final point = proj.project(10, 20);
      expect(point.x, closeTo(0, 0.01));
    });
  });

  group('MercatorProjection', () {
    test('projects coordinates', () {
      final proj = geoMercator(scale: 100);
      final point = proj.project(0, 0);
      expect(point.x, equals(0));
      expect(point.y, closeTo(0, 0.01));
    });

    test('inverts coordinates', () {
      final proj = geoMercator(scale: 100);
      final (lon, lat) = proj.invert(0, 0);
      expect(lon, closeTo(0, 0.01));
      expect(lat, closeTo(0, 0.01));
    });

    test('clamps latitude near poles', () {
      final proj = geoMercator(scale: 100);
      final point = proj.project(0, 89);
      expect(point.y.isFinite, isTrue);
    });
  });

  group('OrthographicProjection', () {
    test('projects visible hemisphere', () {
      final proj = geoOrthographic(scale: 100);
      final point = proj.project(0, 0);
      expect(point.x.isNaN, isFalse);
      expect(point.y.isNaN, isFalse);
    });

    test('returns NaN for back of globe', () {
      final proj = geoOrthographic(center: (0, 0), scale: 100);
      final point = proj.project(180, 0);
      expect(point.x.isNaN, isTrue);
    });

    test('inverts coordinates', () {
      final proj = geoOrthographic(scale: 100);
      final projected = proj.project(10, 20);
      if (!projected.hasNaN) {
        final (lon, lat) = proj.invert(projected.x, projected.y);
        expect(lon, closeTo(10, 0.1));
        expect(lat, closeTo(20, 0.1));
      }
    });
  });

  group('AlbersProjection', () {
    test('projects coordinates', () {
      final proj = geoAlbers(scale: 100);
      final point = proj.project(-96, 38);
      expect(point.x.isFinite, isTrue);
      expect(point.y.isFinite, isTrue);
    });

    test('albers usa preset', () {
      final proj = geoAlbersUsa();
      final point = proj.project(-122, 37);
      expect(point.x.isFinite, isTrue);
    });
  });

  group('GeoJSON', () {
    test('parses Point', () {
      final json = {'type': 'Point', 'coordinates': [100.0, 0.0]};
      final point = GeoJsonGeometry.fromJson(json) as GeoJsonPoint;
      expect(point.longitude, equals(100.0));
      expect(point.latitude, equals(0.0));
    });

    test('parses LineString', () {
      final json = {
        'type': 'LineString',
        'coordinates': [
          [100.0, 0.0],
          [101.0, 1.0],
        ],
      };
      final line = GeoJsonGeometry.fromJson(json) as GeoJsonLineString;
      expect(line.coordinates.length, equals(2));
    });

    test('parses Polygon', () {
      final json = {
        'type': 'Polygon',
        'coordinates': [
          [
            [100.0, 0.0],
            [101.0, 0.0],
            [101.0, 1.0],
            [100.0, 1.0],
            [100.0, 0.0],
          ],
        ],
      };
      final polygon = GeoJsonGeometry.fromJson(json) as GeoJsonPolygon;
      expect(polygon.exterior.length, equals(5));
    });

    test('parses Feature', () {
      final json = {
        'type': 'Feature',
        'geometry': {'type': 'Point', 'coordinates': [100.0, 0.0]},
        'properties': {'name': 'Test'},
      };
      final feature = GeoJsonFeature.fromJson(json);
      expect(feature.geometry, isA<GeoJsonPoint>());
      expect(feature.properties['name'], equals('Test'));
    });

    test('parses FeatureCollection', () {
      final json = {
        'type': 'FeatureCollection',
        'features': [
          {
            'type': 'Feature',
            'geometry': {'type': 'Point', 'coordinates': [100.0, 0.0]},
            'properties': {},
          },
        ],
      };
      final collection = GeoJsonFeatureCollection.fromJson(json);
      expect(collection.features.length, equals(1));
    });
  });

  group('GeoPath', () {
    test('generates path from Point', () {
      final proj = geoEquirectangular(scale: 100);
      final path = geoPath(proj);
      final point = GeoJsonPoint([10, 20]);
      final paths = path.generate(point);
      expect(paths.length, equals(1));
      expect(paths[0].length, equals(1));
    });

    test('generates path from LineString', () {
      final proj = geoEquirectangular(scale: 100);
      final path = geoPath(proj);
      final line = GeoJsonLineString([
        [0, 0],
        [10, 10],
        [20, 0],
      ]);
      final paths = path.generate(line);
      expect(paths.length, equals(1));
      expect(paths[0].length, equals(3));
    });

    test('generates path from Polygon', () {
      final proj = geoEquirectangular(scale: 100);
      final path = geoPath(proj);
      final polygon = GeoJsonPolygon([
        [
          [0, 0],
          [10, 0],
          [10, 10],
          [0, 10],
          [0, 0],
        ],
      ]);
      final paths = path.generate(polygon);
      expect(paths.length, equals(1));
      expect(paths[0].length, equals(5));
    });

    test('calculates centroid', () {
      final proj = geoEquirectangular(scale: 100);
      final path = geoPath(proj);
      final polygon = GeoJsonPolygon([
        [
          [0, 0],
          [10, 0],
          [10, 10],
          [0, 10],
          [0, 0],
        ],
      ]);
      final centroid = path.centroid(polygon);
      expect(centroid, isNotNull);
    });

    test('calculates bounds', () {
      final proj = geoEquirectangular(scale: 100);
      final path = geoPath(proj);
      final polygon = GeoJsonPolygon([
        [
          [0, 0],
          [10, 0],
          [10, 10],
          [0, 10],
          [0, 0],
        ],
      ]);
      final bounds = path.bounds(polygon);
      expect(bounds, isNotNull);
    });
  });
}
