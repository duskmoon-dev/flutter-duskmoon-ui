import 'dart:math' as math;
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_delaunay/dv_delaunay.dart';

/// A Voronoi diagram computed from a Delaunay triangulation.
///
/// The Voronoi diagram is the dual of the Delaunay triangulation.
/// Each Voronoi cell corresponds to an input point and contains
/// all locations closer to that point than any other.
class Voronoi {
  /// The underlying Delaunay triangulation.
  final Delaunay delaunay;

  /// The circumcenters of the Delaunay triangles (Voronoi vertices).
  late final List<Point> circumcenters;

  /// The bounding box for clipping Voronoi cells.
  final double xmin;
  final double ymin;
  final double xmax;
  final double ymax;

  /// Maps each point to the edges of its Voronoi cell.
  late final List<List<int>> _pointToEdges;

  /// Creates a Voronoi diagram from a Delaunay triangulation.
  ///
  /// The [bounds] parameter specifies the clipping rectangle as [xmin, ymin, xmax, ymax].
  /// If not provided, it's computed from the input points with padding.
  Voronoi(this.delaunay, {List<double>? bounds})
      : xmin = bounds?[0] ?? double.negativeInfinity,
        ymin = bounds?[1] ?? double.negativeInfinity,
        xmax = bounds?[2] ?? double.infinity,
        ymax = bounds?[3] ?? double.infinity {
    _computeCircumcenters();
    _buildPointToEdges();
  }

  /// Creates a Voronoi diagram from a list of points.
  factory Voronoi.fromPoints(List<Point> points, {List<double>? bounds}) {
    final delaunay = Delaunay.fromPoints(points);

    // Compute bounds from points if not provided
    List<double>? computedBounds = bounds;
    if (computedBounds == null && points.isNotEmpty) {
      double minX = double.infinity;
      double minY = double.infinity;
      double maxX = double.negativeInfinity;
      double maxY = double.negativeInfinity;

      for (final p in points) {
        if (p.x < minX) minX = p.x;
        if (p.y < minY) minY = p.y;
        if (p.x > maxX) maxX = p.x;
        if (p.y > maxY) maxY = p.y;
      }

      // Add padding
      final dx = maxX - minX;
      final dy = maxY - minY;
      final padding = math.max(dx, dy) * 0.1;

      computedBounds = [
        minX - padding,
        minY - padding,
        maxX + padding,
        maxY + padding,
      ];
    }

    return Voronoi(delaunay, bounds: computedBounds);
  }

  void _computeCircumcenters() {
    circumcenters = delaunay.circumcenters();
  }

  void _buildPointToEdges() {
    final n = delaunay.pointsLength;
    _pointToEdges = List.generate(n, (_) => <int>[]);

    for (int e = 0; e < delaunay.triangleIndices.length; e++) {
      final p = delaunay.triangleIndices[e];
      _pointToEdges[p].add(e);
    }
  }

  /// Returns the number of cells (same as number of input points).
  int get cellCount => delaunay.pointsLength;

  /// Returns an iterable of all Voronoi cell polygons.
  /// Each polygon is a list of points forming the cell boundary.
  Iterable<List<Point>> cellPolygons() sync* {
    for (int i = 0; i < cellCount; i++) {
      final polygon = cellPolygon(i);
      if (polygon != null) {
        yield polygon;
      }
    }
  }

  /// Returns the Voronoi cell polygon for point [i].
  /// Returns null if the cell is degenerate or empty.
  List<Point>? cellPolygon(int i) {
    if (i < 0 || i >= cellCount) return null;

    final edges = _pointToEdges[i];
    if (edges.isEmpty) return null;

    // For points on the convex hull, we need special handling
    final isOnHull = delaunay.hull.contains(i);

    if (isOnHull) {
      return _computeHullCellPolygon(i);
    }

    // For interior points, trace around the cell
    final vertices = <Point>[];
    final visited = <int>{};

    // Start from any edge
    int e = edges.first;
    final start = e;

    do {
      if (visited.contains(e)) break;
      visited.add(e);

      final t = e ~/ 3;
      if (t < circumcenters.length) {
        vertices.add(circumcenters[t]);
      }

      // Move to the next edge around point i
      final opposite = delaunay.halfedges[e];
      if (opposite < 0) {
        // Reached hull - need to handle boundary
        break;
      }

      e = _nextEdgeAroundPoint(opposite);
    } while (e != start && vertices.length < 100);

    if (vertices.length < 3) return null;

    return _clipPolygon(vertices);
  }

  /// Returns the cell polygon for a hull point, clipped to bounds.
  List<Point>? _computeHullCellPolygon(int i) {
    final edges = _pointToEdges[i];
    if (edges.isEmpty) return null;

    final vertices = <Point>[];

    // Collect interior circumcenters
    for (final e in edges) {
      final t = e ~/ 3;
      if (t < circumcenters.length) {
        vertices.add(circumcenters[t]);
      }
    }

    // For hull cells, add projections to the bounding box
    final point = delaunay.getPoint(i);

    // Find hull neighbors
    final hullIndex = delaunay.hull.indexOf(i);
    final prevHullIndex =
        (hullIndex - 1 + delaunay.hull.length) % delaunay.hull.length;
    final nextHullIndex = (hullIndex + 1) % delaunay.hull.length;

    final prevPoint = delaunay.getPoint(delaunay.hull[prevHullIndex]);
    final nextPoint = delaunay.getPoint(delaunay.hull[nextHullIndex]);

    // Add boundary points
    final farPoint1 = _projectToBox(point, prevPoint);
    final farPoint2 = _projectToBox(point, nextPoint);

    if (farPoint1 != null) vertices.add(farPoint1);
    if (farPoint2 != null) vertices.add(farPoint2);

    // Add corner points if needed
    _addCornerPoints(vertices, point);

    if (vertices.length < 3) return null;

    // Sort vertices around the cell center
    return _sortPolygon(vertices, point);
  }

  Point? _projectToBox(Point cellPoint, Point neighbor) {
    // Project perpendicular bisector to box edge
    final mid = cellPoint.midpointTo(neighbor);
    final dx = neighbor.x - cellPoint.x;
    final dy = neighbor.y - cellPoint.y;

    // Perpendicular direction
    final px = -dy;
    final py = dx;

    // Ray from midpoint in perpendicular direction, towards exterior
    final len = math.sqrt(px * px + py * py);
    if (len < 1e-10) return null;

    final dirX = px / len;
    final dirY = py / len;

    // Determine which direction is "outward" from the cell
    final outward = (cellPoint.x - mid.x) * dirX + (cellPoint.y - mid.y) * dirY;
    final signedDirX = outward > 0 ? -dirX : dirX;
    final signedDirY = outward > 0 ? -dirY : dirY;

    // Find intersection with bounding box
    double t = double.infinity;

    if (signedDirX > 0 && xmax.isFinite) {
      final tt = (xmax - mid.x) / signedDirX;
      if (tt > 0 && tt < t) t = tt;
    } else if (signedDirX < 0 && xmin.isFinite) {
      final tt = (xmin - mid.x) / signedDirX;
      if (tt > 0 && tt < t) t = tt;
    }

    if (signedDirY > 0 && ymax.isFinite) {
      final tt = (ymax - mid.y) / signedDirY;
      if (tt > 0 && tt < t) t = tt;
    } else if (signedDirY < 0 && ymin.isFinite) {
      final tt = (ymin - mid.y) / signedDirY;
      if (tt > 0 && tt < t) t = tt;
    }

    if (t.isInfinite || t > 1e6) {
      // Use a large but finite distance
      t = 1e6;
    }

    return Point(mid.x + signedDirX * t, mid.y + signedDirY * t);
  }

  void _addCornerPoints(List<Point> vertices, Point cellPoint) {
    // Add bounding box corners that belong to this cell
    final corners = [
      Point(xmin, ymin),
      Point(xmax, ymin),
      Point(xmax, ymax),
      Point(xmin, ymax),
    ];

    for (final corner in corners) {
      if (!corner.isFinite) continue;
      if (contains(cellPoint, corner.x, corner.y)) {
        vertices.add(corner);
      }
    }
  }

  List<Point> _sortPolygon(List<Point> vertices, Point center) {
    // Sort vertices counterclockwise around the center
    vertices.sort((a, b) {
      final angleA = math.atan2(a.y - center.y, a.x - center.x);
      final angleB = math.atan2(b.y - center.y, b.x - center.x);
      return angleA.compareTo(angleB);
    });

    return vertices;
  }

  int _nextEdgeAroundPoint(int e) {
    // Given an edge e pointing to a vertex, find the next edge
    // around that vertex in counterclockwise order
    final next = (e % 3 == 2) ? e - 2 : e + 1;
    return next;
  }

  List<Point>? _clipPolygon(List<Point> polygon) {
    if (polygon.isEmpty) return null;

    // Sutherland-Hodgman clipping algorithm
    var output = polygon;

    // Clip against each edge of the bounding box
    if (xmin.isFinite) {
      output = _clipAgainstEdge(output, xmin, 0, 1, 0);
      if (output.isEmpty) return null;
    }
    if (xmax.isFinite) {
      output = _clipAgainstEdge(output, xmax, 0, -1, 0);
      if (output.isEmpty) return null;
    }
    if (ymin.isFinite) {
      output = _clipAgainstEdge(output, ymin, 1, 0, 1);
      if (output.isEmpty) return null;
    }
    if (ymax.isFinite) {
      output = _clipAgainstEdge(output, ymax, 1, 0, -1);
      if (output.isEmpty) return null;
    }

    return output.isEmpty ? null : output;
  }

  List<Point> _clipAgainstEdge(
      List<Point> polygon, double value, int axis, int nx, int ny) {
    final output = <Point>[];

    for (int i = 0; i < polygon.length; i++) {
      final current = polygon[i];
      final next = polygon[(i + 1) % polygon.length];

      final currentVal = axis == 0 ? current.x : current.y;
      final nextVal = axis == 0 ? next.x : next.y;

      final currentInside = (currentVal - value) * (nx + ny) >= 0;
      final nextInside = (nextVal - value) * (nx + ny) >= 0;

      if (currentInside) {
        output.add(current);
      }

      if (currentInside != nextInside) {
        // Compute intersection
        final t = (value - currentVal) / (nextVal - currentVal);
        output.add(Point(
          current.x + t * (next.x - current.x),
          current.y + t * (next.y - current.y),
        ));
      }
    }

    return output;
  }

  /// Returns true if point (x, y) is inside the Voronoi cell for the given [cellPoint].
  bool contains(Point cellPoint, double x, double y) {
    final i = _findNearestPoint(x, y);
    return i >= 0 &&
        delaunay.getX(i) == cellPoint.x &&
        delaunay.getY(i) == cellPoint.y;
  }

  /// Returns true if point (x, y) is inside the Voronoi cell at index [cellIndex].
  bool containsIndex(int cellIndex, double x, double y) {
    final nearest = _findNearestPoint(x, y);
    return nearest == cellIndex;
  }

  /// Finds the index of the nearest input point to (x, y).
  int _findNearestPoint(double x, double y) {
    int nearest = -1;
    double minDist = double.infinity;

    for (int i = 0; i < cellCount; i++) {
      final px = delaunay.getX(i);
      final py = delaunay.getY(i);
      final d = (x - px) * (x - px) + (y - py) * (y - py);
      if (d < minDist) {
        minDist = d;
        nearest = i;
      }
    }

    return nearest;
  }

  /// Finds the Voronoi cell containing point (x, y).
  /// Returns the index of the cell, or -1 if outside all cells.
  int find(double x, double y) {
    return _findNearestPoint(x, y);
  }

  /// Finds the Voronoi cell containing point [p].
  int findPoint(Point p) => find(p.x, p.y);

  /// Returns the centroid of cell [i].
  Point? cellCentroid(int i) {
    final polygon = cellPolygon(i);
    if (polygon == null || polygon.isEmpty) return null;

    double cx = 0, cy = 0;
    for (final p in polygon) {
      cx += p.x;
      cy += p.y;
    }
    return Point(cx / polygon.length, cy / polygon.length);
  }

  /// Returns the area of cell [i].
  double? cellArea(int i) {
    final polygon = cellPolygon(i);
    if (polygon == null || polygon.length < 3) return null;

    double area = 0;
    for (int j = 0; j < polygon.length; j++) {
      final k = (j + 1) % polygon.length;
      area += polygon[j].x * polygon[k].y;
      area -= polygon[k].x * polygon[j].y;
    }
    return area.abs() / 2;
  }

  /// Returns all Voronoi edges as pairs of points.
  Iterable<(Point, Point)> edges() sync* {
    final seen = <String>{};

    for (int t = 0; t < delaunay.trianglesLength; t++) {
      for (int j = 0; j < 3; j++) {
        final e = t * 3 + j;
        final opposite = delaunay.halfedges[e];

        if (opposite < 0) continue;
        if (opposite < e) continue; // Avoid duplicates

        final t2 = opposite ~/ 3;
        if (t >= circumcenters.length || t2 >= circumcenters.length) continue;

        final p1 = circumcenters[t];
        final p2 = circumcenters[t2];

        final key = '${t}_$t2';
        if (seen.contains(key)) continue;
        seen.add(key);

        yield (p1, p2);
      }
    }
  }

  /// Returns the neighbors of cell [i] (cells sharing an edge).
  List<int> cellNeighbors(int i) {
    return delaunay.pointsAdjacentToPoint(i).toList();
  }
}
