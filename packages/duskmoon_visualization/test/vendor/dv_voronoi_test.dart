import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_voronoi/dv_voronoi.dart';

void main() {
  group('Voronoi', () {
    test('creates Voronoi diagram from points', () {
      final points = [
        Point(0, 0),
        Point(1, 0),
        Point(0.5, 1),
        Point(0.5, 0.5),
      ];

      final voronoi = Voronoi.fromPoints(points);

      expect(voronoi.cellCount, equals(4));
    });

    test('cellPolygons returns polygons for each point', () {
      final points = [
        Point(0.25, 0.25),
        Point(0.75, 0.25),
        Point(0.25, 0.75),
        Point(0.75, 0.75),
      ];

      final voronoi = Voronoi.fromPoints(points, bounds: [0, 0, 1, 1]);

      final polygons = voronoi.cellPolygons().toList();

      // Should have one polygon per point
      expect(polygons.length, equals(4));

      // Each polygon should have at least 3 vertices
      for (final polygon in polygons) {
        expect(polygon.length, greaterThanOrEqualTo(3));
      }
    });

    test('cellPolygon returns polygon for specific index', () {
      final points = [
        Point(0.25, 0.25),
        Point(0.75, 0.25),
        Point(0.25, 0.75),
        Point(0.75, 0.75),
      ];

      final voronoi = Voronoi.fromPoints(points, bounds: [0, 0, 1, 1]);

      final polygon = voronoi.cellPolygon(0);

      expect(polygon, isNotNull);
      expect(polygon!.length, greaterThanOrEqualTo(3));
    });

    test('find returns correct cell for point', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(1, 2),
      ];

      final voronoi = Voronoi.fromPoints(points);

      // Point closest to first point should be in cell 0
      final cell = voronoi.find(0.1, 0.1);
      expect(cell, equals(0));

      // Point closest to second point should be in cell 1
      final cell2 = voronoi.find(1.9, 0.1);
      expect(cell2, equals(1));
    });

    test('containsIndex works correctly', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(1, 2),
      ];

      final voronoi = Voronoi.fromPoints(points);

      // Point close to first input point should be in its cell
      expect(voronoi.containsIndex(0, 0.1, 0.1), isTrue);
      expect(voronoi.containsIndex(1, 0.1, 0.1), isFalse);
    });

    test('cellCentroid returns centroid of cell', () {
      final points = [
        Point(0.25, 0.25),
        Point(0.75, 0.25),
        Point(0.25, 0.75),
        Point(0.75, 0.75),
      ];

      final voronoi = Voronoi.fromPoints(points, bounds: [0, 0, 1, 1]);

      final centroid = voronoi.cellCentroid(0);

      expect(centroid, isNotNull);
      // Centroid should be a valid point
      expect(centroid!.x.isFinite, isTrue);
      expect(centroid.y.isFinite, isTrue);
    });

    test('cellArea returns area of cell', () {
      final points = [
        Point(0.25, 0.25),
        Point(0.75, 0.25),
        Point(0.25, 0.75),
        Point(0.75, 0.75),
      ];

      final voronoi = Voronoi.fromPoints(points, bounds: [0, 0, 1, 1]);

      final area = voronoi.cellArea(0);

      expect(area, isNotNull);
      expect(area!, greaterThan(0));
      // For a grid of 4 points in unit square, each cell should be ~0.25
      expect(area, closeTo(0.25, 0.1));
    });

    test('edges returns Voronoi edges', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(1, 2),
        Point(1, 0.5),
      ];

      final voronoi = Voronoi.fromPoints(points);
      final edges = voronoi.edges().toList();

      expect(edges, isNotEmpty);
      // Each edge should be a pair of points
      for (final edge in edges) {
        expect(edge.$1.isFinite, isTrue);
        expect(edge.$2.isFinite, isTrue);
      }
    });

    test('cellNeighbors returns adjacent cells', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(1, 2),
        Point(1, 0.5),
      ];

      final voronoi = Voronoi.fromPoints(points);
      final neighbors = voronoi.cellNeighbors(3);

      expect(neighbors, isNotEmpty);
      // The center point should be adjacent to the outer triangle points
      expect(neighbors.toSet().intersection({0, 1, 2}), isNotEmpty);
    });

    test('respects bounds for clipping', () {
      // Use 4 points so we have actual Voronoi cells with interior points
      final points = [
        Point(0.25, 0.25),
        Point(0.75, 0.25),
        Point(0.25, 0.75),
        Point(0.75, 0.75),
      ];

      final voronoi = Voronoi.fromPoints(points, bounds: [0, 0, 1, 1]);

      // At least one cell should have a polygon
      bool hasValidPolygon = false;
      for (int i = 0; i < voronoi.cellCount; i++) {
        final polygon = voronoi.cellPolygon(i);
        if (polygon != null && polygon.isNotEmpty) {
          hasValidPolygon = true;
          // Cell should be clipped to bounds (with small tolerance for floating point)
          for (final p in polygon) {
            expect(p.x, greaterThanOrEqualTo(-0.1));
            expect(p.x, lessThanOrEqualTo(1.1));
            expect(p.y, greaterThanOrEqualTo(-0.1));
            expect(p.y, lessThanOrEqualTo(1.1));
          }
        }
      }
      expect(hasValidPolygon, isTrue);
    });
  });
}
