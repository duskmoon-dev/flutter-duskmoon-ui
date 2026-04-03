import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

void main() {
  group('Point', () {
    test('constructor creates point', () {
      final p = Point(3, 4);
      expect(p.x, equals(3));
      expect(p.y, equals(4));
    });

    test('zero creates origin point', () {
      expect(Point.zero.x, equals(0));
      expect(Point.zero.y, equals(0));
    });

    test('fromPolar creates point from polar coordinates', () {
      final p = Point.fromPolar(1, 0);
      expect(p.x, closeTo(1, 1e-10));
      expect(p.y, closeTo(0, 1e-10));

      final p2 = Point.fromPolar(1, math.pi / 2);
      expect(p2.x, closeTo(0, 1e-10));
      expect(p2.y, closeTo(1, 1e-10));
    });

    test('fromMap creates point from map', () {
      final p = Point.fromMap({'x': 3, 'y': 4});
      expect(p.x, equals(3));
      expect(p.y, equals(4));
    });

    test('fromList creates point from list', () {
      final p = Point.fromList([3, 4]);
      expect(p.x, equals(3));
      expect(p.y, equals(4));
    });

    test('addition works', () {
      final p1 = Point(1, 2);
      final p2 = Point(3, 4);
      final result = p1 + p2;
      expect(result.x, equals(4));
      expect(result.y, equals(6));
    });

    test('subtraction works', () {
      final p1 = Point(5, 7);
      final p2 = Point(2, 3);
      final result = p1 - p2;
      expect(result.x, equals(3));
      expect(result.y, equals(4));
    });

    test('scalar multiplication works', () {
      final p = Point(3, 4);
      final result = p * 2;
      expect(result.x, equals(6));
      expect(result.y, equals(8));
    });

    test('scalar division works', () {
      final p = Point(6, 8);
      final result = p / 2;
      expect(result.x, equals(3));
      expect(result.y, equals(4));
    });

    test('negation works', () {
      final p = Point(3, -4);
      final result = -p;
      expect(result.x, equals(-3));
      expect(result.y, equals(4));
    });

    test('distanceTo calculates distance', () {
      final p1 = Point(0, 0);
      final p2 = Point(3, 4);
      expect(p1.distanceTo(p2), equals(5));
    });

    test('squaredDistanceTo is more efficient', () {
      final p1 = Point(0, 0);
      final p2 = Point(3, 4);
      expect(p1.squaredDistanceTo(p2), equals(25));
    });

    test('manhattanDistanceTo calculates manhattan distance', () {
      final p1 = Point(0, 0);
      final p2 = Point(3, 4);
      expect(p1.manhattanDistanceTo(p2), equals(7));
    });

    test('magnitude returns vector length', () {
      final p = Point(3, 4);
      expect(p.magnitude, equals(5));
    });

    test('angle returns angle from origin', () {
      expect(Point(1, 0).angle, equals(0));
      expect(Point(0, 1).angle, closeTo(math.pi / 2, 1e-10));
      expect(Point(-1, 0).angle, closeTo(math.pi, 1e-10));
    });

    test('normalized returns unit vector', () {
      final p = Point(3, 4);
      final n = p.normalized;
      expect(n.magnitude, closeTo(1, 1e-10));
      expect(n.x, closeTo(0.6, 1e-10));
      expect(n.y, closeTo(0.8, 1e-10));
    });

    test('dot product works', () {
      final p1 = Point(1, 2);
      final p2 = Point(3, 4);
      expect(p1.dot(p2), equals(11));
    });

    test('cross product works', () {
      final p1 = Point(1, 0);
      final p2 = Point(0, 1);
      expect(p1.cross(p2), equals(1));
    });

    test('lerp interpolates', () {
      final p1 = Point(0, 0);
      final p2 = Point(10, 10);
      final mid = p1.lerp(p2, 0.5);
      expect(mid.x, equals(5));
      expect(mid.y, equals(5));
    });

    test('rotate rotates point', () {
      final p = Point(1, 0);
      final rotated = p.rotate(math.pi / 2);
      expect(rotated.x, closeTo(0, 1e-10));
      expect(rotated.y, closeTo(1, 1e-10));
    });

    test('rotateAround rotates around center', () {
      final p = Point(2, 0);
      final center = Point(1, 0);
      final rotated = p.rotateAround(center, math.pi);
      expect(rotated.x, closeTo(0, 1e-10));
      expect(rotated.y, closeTo(0, 1e-10));
    });

    test('midpointTo returns midpoint', () {
      final p1 = Point(0, 0);
      final p2 = Point(4, 4);
      final mid = p1.midpointTo(p2);
      expect(mid.x, equals(2));
      expect(mid.y, equals(2));
    });

    test('clamp constrains point', () {
      final p = Point(10, -5);
      final clamped = p.clamp(minX: 0, maxX: 5, minY: 0, maxY: 5);
      expect(clamped.x, equals(5));
      expect(clamped.y, equals(0));
    });

    test('copyWith creates modified copy', () {
      final p = Point(3, 4);
      final modified = p.copyWith(x: 10);
      expect(modified.x, equals(10));
      expect(modified.y, equals(4));
    });

    test('toMap converts to map', () {
      final p = Point(3, 4);
      final map = p.toMap();
      expect(map['x'], equals(3));
      expect(map['y'], equals(4));
    });

    test('toList converts to list', () {
      final p = Point(3, 4);
      final list = p.toList();
      expect(list, equals([3, 4]));
    });

    test('equality works', () {
      final p1 = Point(3, 4);
      final p2 = Point(3, 4);
      final p3 = Point(4, 5);
      expect(p1 == p2, isTrue);
      expect(p1 == p3, isFalse);
    });
  });

  group('PointListExtensions', () {
    test('centroid calculates center of mass', () {
      final points = [Point(0, 0), Point(4, 0), Point(4, 4), Point(0, 4)];
      final c = points.centroid;
      expect(c.x, equals(2));
      expect(c.y, equals(2));
    });

    test('bounds returns bounding box', () {
      final points = [Point(1, 2), Point(5, 8), Point(3, 4)];
      final bounds = points.bounds;
      expect(bounds?.$1.x, equals(1));
      expect(bounds?.$1.y, equals(2));
      expect(bounds?.$2.x, equals(5));
      expect(bounds?.$2.y, equals(8));
    });

    test('polylineLength calculates total length', () {
      final points = [Point(0, 0), Point(3, 0), Point(3, 4)];
      expect(points.polylineLength, equals(7));
    });

    test('polygonArea calculates area', () {
      final square = [Point(0, 0), Point(2, 0), Point(2, 2), Point(0, 2)];
      expect(square.polygonArea.abs(), equals(4));
    });
  });

  group('Helper functions', () {
    test('distance calculates distance', () {
      expect(distance(Point(0, 0), Point(3, 4)), equals(5));
    });

    test('angleBetween calculates angle', () {
      expect(angleBetween(Point(0, 0), Point(1, 0)), equals(0));
      expect(
          angleBetween(Point(0, 0), Point(0, 1)), closeTo(math.pi / 2, 1e-10));
    });

    test('pointAt creates point at distance and angle', () {
      final p = pointAt(Point(0, 0), 5, 0);
      expect(p.x, closeTo(5, 1e-10));
      expect(p.y, closeTo(0, 1e-10));
    });

    test('areCollinear detects collinear points', () {
      expect(areCollinear(Point(0, 0), Point(1, 1), Point(2, 2)), isTrue);
      expect(areCollinear(Point(0, 0), Point(1, 1), Point(2, 3)), isFalse);
    });
  });
}
