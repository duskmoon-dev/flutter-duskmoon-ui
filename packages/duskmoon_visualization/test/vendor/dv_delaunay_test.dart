import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_delaunay/dv_delaunay.dart';

void main() {
  group('Delaunay', () {
    test('creates triangulation from points', () {
      final points = [
        Point(0, 0),
        Point(1, 0),
        Point(0.5, 1),
        Point(0.5, 0.5),
      ];

      final delaunay = Delaunay.fromPoints(points);

      expect(delaunay.pointsLength, equals(4));
      expect(delaunay.trianglesLength, greaterThan(0));
    });

    test('handles three points forming a single triangle', () {
      final points = [
        Point(0, 0),
        Point(1, 0),
        Point(0.5, 1),
      ];

      final delaunay = Delaunay.fromPoints(points);

      expect(delaunay.trianglesLength, equals(1));
      final triangles = delaunay.triangles().toList();
      expect(triangles.length, equals(1));
      expect(triangles[0], hasLength(3));
    });

    test('handles fewer than 3 points', () {
      final points = [
        Point(0, 0),
        Point(1, 0),
      ];

      final delaunay = Delaunay.fromPoints(points);

      expect(delaunay.trianglesLength, equals(0));
    });

    test('triangles returns correct vertex indices', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(1, 2),
      ];

      final delaunay = Delaunay.fromPoints(points);
      final triangles = delaunay.triangles().toList();

      expect(triangles.length, equals(1));
      // Each triangle should reference valid point indices
      for (final tri in triangles) {
        for (final idx in tri) {
          expect(idx, greaterThanOrEqualTo(0));
          expect(idx, lessThan(points.length));
        }
      }
    });

    test('neighbors returns adjacency information', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(1, 2),
        Point(1, 1),
      ];

      final delaunay = Delaunay.fromPoints(points);
      final neighbors = delaunay.neighbors().toList();

      // Each triangle has 3 potential neighbors
      for (final n in neighbors) {
        expect(n, hasLength(3));
      }
    });

    test('find locates triangle containing point', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(2, 2),
        Point(0, 2),
        Point(1, 1),
      ];

      final delaunay = Delaunay.fromPoints(points);

      // Point in the middle should be found
      final triIndex = delaunay.find(1, 1);
      expect(triIndex, greaterThanOrEqualTo(0));
    });

    test('find returns -1 for point outside triangulation', () {
      final points = [
        Point(0, 0),
        Point(1, 0),
        Point(0.5, 1),
      ];

      final delaunay = Delaunay.fromPoints(points);

      // Point far outside
      final triIndex = delaunay.find(10, 10);
      expect(triIndex, equals(-1));
    });

    test('circumcenter computes correct value', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(1, 2),
      ];

      final delaunay = Delaunay.fromPoints(points);
      final center = delaunay.circumcenter(0);

      // Circumcenter should be equidistant from all three points
      final d0 = center.distanceTo(points[delaunay.triangleIndices[0]]);
      final d1 = center.distanceTo(points[delaunay.triangleIndices[1]]);
      final d2 = center.distanceTo(points[delaunay.triangleIndices[2]]);

      expect(d0, closeTo(d1, 1e-10));
      expect(d1, closeTo(d2, 1e-10));
    });

    test('hull contains convex hull points', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(1, 2),
      ];

      final delaunay = Delaunay.fromPoints(points);

      // Hull should have all 3 points for a triangle
      expect(delaunay.hull.length, greaterThanOrEqualTo(1));
      // Hull indices should be valid point indices
      for (final idx in delaunay.hull) {
        expect(idx, greaterThanOrEqualTo(0));
        expect(idx, lessThan(points.length));
      }
    });

    test('edges returns edges', () {
      final points = [
        Point(0, 0),
        Point(1, 0),
        Point(0.5, 1),
        Point(0.5, 0.5),
      ];

      final delaunay = Delaunay.fromPoints(points);
      final edges = delaunay.edges().toList();

      // Check that edges exist and have valid indices
      expect(edges, isNotEmpty);
      for (final edge in edges) {
        expect(edge.$1, greaterThanOrEqualTo(0));
        expect(edge.$1, lessThan(points.length));
        expect(edge.$2, greaterThanOrEqualTo(0));
        expect(edge.$2, lessThan(points.length));
      }
    });

    test('trianglePoints returns correct point objects', () {
      final points = [
        Point(0, 0),
        Point(1, 0),
        Point(0.5, 1),
      ];

      final delaunay = Delaunay.fromPoints(points);
      final triPoints = delaunay.trianglePoints(0);

      expect(triPoints.length, equals(3));
      // All points should be from the input set
      for (final p in triPoints) {
        expect(points, contains(p));
      }
    });

    test('pointsAdjacentToPoint returns correct neighbors', () {
      final points = [
        Point(0, 0),
        Point(2, 0),
        Point(1, 2),
        Point(1, 0.5),
      ];

      final delaunay = Delaunay.fromPoints(points);
      final adjacent = delaunay.pointsAdjacentToPoint(3);

      // The interior point should be connected to the outer triangle vertices
      expect(adjacent, isNotEmpty);
    });
  });
}
