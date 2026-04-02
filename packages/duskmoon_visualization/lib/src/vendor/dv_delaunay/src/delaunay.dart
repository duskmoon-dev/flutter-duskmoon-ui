import 'dart:math' as math;
import 'dart:typed_data';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

/// Delaunay triangulation of a set of points.
///
/// Uses the Bowyer-Watson algorithm to compute the Delaunay triangulation.
/// Provides efficient methods for finding triangles, neighbors, and point location.
class Delaunay {
  /// The input points flattened as [x0, y0, x1, y1, ...].
  final Float64List coords;

  /// Triangle indices: each group of 3 consecutive values forms a triangle.
  /// `triangleIndices[i*3]`, `triangleIndices[i*3+1]`, `triangleIndices[i*3+2]`
  /// are the indices of the vertices of triangle i.
  late final Int32List triangleIndices;

  /// Half-edge data structure for adjacency.
  /// `halfedges[i]` is the index of the opposite half-edge, or -1 if on hull.
  late final Int32List halfedges;

  /// The indices of the points on the convex hull, in counterclockwise order.
  late final List<int> hull;

  /// Number of triangles.
  late final int trianglesLength;

  /// Creates a Delaunay triangulation from a list of points.
  factory Delaunay.fromPoints(List<Point> points) {
    final coords = Float64List(points.length * 2);
    for (int i = 0; i < points.length; i++) {
      coords[i * 2] = points[i].x;
      coords[i * 2 + 1] = points[i].y;
    }
    return Delaunay(coords);
  }

  /// Creates a Delaunay triangulation from flat coordinates [x0, y0, x1, y1, ...].
  Delaunay(this.coords) {
    final n = coords.length ~/ 2;

    if (n < 3) {
      triangleIndices = Int32List(0);
      halfedges = Int32List(0);
      hull = [];
      trianglesLength = 0;
      return;
    }

    _triangulate();
  }

  /// Number of input points.
  int get pointsLength => coords.length ~/ 2;

  /// Gets the x coordinate of point at index [i].
  double getX(int i) => coords[i * 2];

  /// Gets the y coordinate of point at index [i].
  double getY(int i) => coords[i * 2 + 1];

  /// Gets the point at index [i].
  Point getPoint(int i) => Point(coords[i * 2], coords[i * 2 + 1]);

  /// Returns an iterable of all triangle indices.
  /// Each triangle is represented by 3 point indices.
  Iterable<List<int>> triangles() sync* {
    for (int i = 0; i < trianglesLength; i++) {
      yield [
        triangleIndices[i * 3],
        triangleIndices[i * 3 + 1],
        triangleIndices[i * 3 + 2],
      ];
    }
  }

  /// Returns the three point indices for triangle [t].
  List<int> triangleVertices(int t) {
    return [
      triangleIndices[t * 3],
      triangleIndices[t * 3 + 1],
      triangleIndices[t * 3 + 2],
    ];
  }

  /// Returns the three points forming triangle [t].
  List<Point> trianglePoints(int t) {
    return [
      getPoint(triangleIndices[t * 3]),
      getPoint(triangleIndices[t * 3 + 1]),
      getPoint(triangleIndices[t * 3 + 2]),
    ];
  }

  /// Returns the neighboring triangle indices for each triangle.
  /// Returns -1 for edges on the convex hull (no neighbor).
  Iterable<List<int>> neighbors() sync* {
    for (int i = 0; i < trianglesLength; i++) {
      yield [
        _triangleOfEdge(halfedges[i * 3]),
        _triangleOfEdge(halfedges[i * 3 + 1]),
        _triangleOfEdge(halfedges[i * 3 + 2]),
      ];
    }
  }

  /// Returns the neighbor triangles for triangle [t].
  /// Returns -1 for edges on the convex hull.
  List<int> triangleNeighbors(int t) {
    return [
      _triangleOfEdge(halfedges[t * 3]),
      _triangleOfEdge(halfedges[t * 3 + 1]),
      _triangleOfEdge(halfedges[t * 3 + 2]),
    ];
  }

  /// Returns the triangle containing the given point, or -1 if not found.
  /// Uses walking algorithm starting from the given triangle (default: 0).
  int find(double x, double y, [int startTriangle = 0]) {
    if (trianglesLength == 0) return -1;

    int current = startTriangle.clamp(0, trianglesLength - 1);
    final visited = <int>{};

    while (!visited.contains(current)) {
      visited.add(current);

      final i0 = triangleIndices[current * 3];
      final i1 = triangleIndices[current * 3 + 1];
      final i2 = triangleIndices[current * 3 + 2];

      final x0 = coords[i0 * 2], y0 = coords[i0 * 2 + 1];
      final x1 = coords[i1 * 2], y1 = coords[i1 * 2 + 1];
      final x2 = coords[i2 * 2], y2 = coords[i2 * 2 + 1];

      // Check if point is inside the triangle
      final d0 = _orient(x, y, x0, y0, x1, y1);
      final d1 = _orient(x, y, x1, y1, x2, y2);
      final d2 = _orient(x, y, x2, y2, x0, y0);

      if (d0 >= 0 && d1 >= 0 && d2 >= 0) {
        return current;
      }

      // Move to neighbor triangle
      int next = -1;
      if (d0 < 0) {
        final e = halfedges[current * 3];
        if (e >= 0) next = e ~/ 3;
      }
      if (next < 0 && d1 < 0) {
        final e = halfedges[current * 3 + 1];
        if (e >= 0) next = e ~/ 3;
      }
      if (next < 0 && d2 < 0) {
        final e = halfedges[current * 3 + 2];
        if (e >= 0) next = e ~/ 3;
      }

      if (next < 0) {
        // Point is outside the triangulation
        return -1;
      }

      current = next;
    }

    return -1;
  }

  /// Finds the triangle containing point [p].
  int findPoint(Point p, [int startTriangle = 0]) {
    return find(p.x, p.y, startTriangle);
  }

  /// Returns the circumcenter of triangle [t].
  Point circumcenter(int t) {
    final i0 = triangleIndices[t * 3];
    final i1 = triangleIndices[t * 3 + 1];
    final i2 = triangleIndices[t * 3 + 2];

    final ax = coords[i0 * 2], ay = coords[i0 * 2 + 1];
    final bx = coords[i1 * 2], by = coords[i1 * 2 + 1];
    final cx = coords[i2 * 2], cy = coords[i2 * 2 + 1];

    final dx = bx - ax, dy = by - ay;
    final ex = cx - ax, ey = cy - ay;

    final bl = dx * dx + dy * dy;
    final cl = ex * ex + ey * ey;
    final d = 0.5 / (dx * ey - dy * ex);

    final x = ax + (ey * bl - dy * cl) * d;
    final y = ay + (dx * cl - ex * bl) * d;

    return Point(x, y);
  }

  /// Returns all circumcenters.
  List<Point> circumcenters() {
    return List.generate(trianglesLength, circumcenter);
  }

  /// Returns the edges of the triangulation as pairs of point indices.
  Iterable<(int, int)> edges() sync* {
    for (int e = 0; e < triangleIndices.length; e++) {
      if (e > halfedges[e]) {
        final p = triangleIndices[e];
        final q = triangleIndices[_nextEdge(e)];
        yield (p, q);
      }
    }
  }

  /// Returns the convex hull points.
  List<Point> hullPoints() {
    return hull.map(getPoint).toList();
  }

  /// Returns the indices of triangles adjacent to point [i].
  List<int> trianglesAdjacentToPoint(int i) {
    final result = <int>[];

    // Find an edge starting from point i
    for (int e = 0; e < triangleIndices.length; e++) {
      if (triangleIndices[e] == i) {
        result.add(e ~/ 3);
      }
    }

    return result;
  }

  /// Returns the indices of points adjacent to point [i].
  Set<int> pointsAdjacentToPoint(int i) {
    final result = <int>{};

    for (int e = 0; e < triangleIndices.length; e++) {
      if (triangleIndices[e] == i) {
        result.add(triangleIndices[_nextEdge(e)]);
        result.add(triangleIndices[_prevEdge(e)]);
      }
    }

    return result;
  }

  // Private implementation

  int _triangleOfEdge(int e) => e >= 0 ? e ~/ 3 : -1;

  int _nextEdge(int e) => (e % 3 == 2) ? e - 2 : e + 1;

  int _prevEdge(int e) => (e % 3 == 0) ? e + 2 : e - 1;

  double _orient(
      double px, double py, double ax, double ay, double bx, double by) {
    return (ay - py) * (bx - px) - (ax - px) * (by - py);
  }

  void _triangulate() {
    final n = coords.length ~/ 2;

    // Find the bounding box
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    final ids = Int32List(n);

    for (int i = 0; i < n; i++) {
      final x = coords[i * 2];
      final y = coords[i * 2 + 1];
      if (x < minX) minX = x;
      if (y < minY) minY = y;
      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;
      ids[i] = i;
    }

    final cx = (minX + maxX) / 2;
    final cy = (minY + maxY) / 2;

    // Find the point closest to the center
    double minDist = double.infinity;
    int i0 = 0;

    for (int i = 0; i < n; i++) {
      final d = _dist(cx, cy, coords[i * 2], coords[i * 2 + 1]);
      if (d < minDist) {
        i0 = i;
        minDist = d;
      }
    }

    final i0x = coords[i0 * 2];
    final i0y = coords[i0 * 2 + 1];

    // Find the point closest to the seed
    minDist = double.infinity;
    int i1 = 0;

    for (int i = 0; i < n; i++) {
      if (i == i0) continue;
      final d = _dist(i0x, i0y, coords[i * 2], coords[i * 2 + 1]);
      if (d < minDist && d > 0) {
        i1 = i;
        minDist = d;
      }
    }

    double i1x = coords[i1 * 2];
    double i1y = coords[i1 * 2 + 1];

    // Find the third point that forms the smallest circumcircle
    double minRadius = double.infinity;
    int i2 = 0;

    for (int i = 0; i < n; i++) {
      if (i == i0 || i == i1) continue;
      final r =
          _circumradius(i0x, i0y, i1x, i1y, coords[i * 2], coords[i * 2 + 1]);
      if (r < minRadius) {
        i2 = i;
        minRadius = r;
      }
    }

    double i2x = coords[i2 * 2];
    double i2y = coords[i2 * 2 + 1];

    if (minRadius.isInfinite) {
      // Collinear points
      triangleIndices = Int32List(0);
      halfedges = Int32List(0);
      hull = [];
      trianglesLength = 0;
      return;
    }

    // Swap to ensure counterclockwise orientation
    if (_orient(i0x, i0y, i1x, i1y, i2x, i2y) < 0) {
      final ti = i1;
      i1 = i2;
      i2 = ti;
      final tx = i1x;
      i1x = i2x;
      i2x = tx;
      final ty = i1y;
      i1y = i2y;
      i2y = ty;
    }

    final center = _circumcenter(i0x, i0y, i1x, i1y, i2x, i2y);

    // Sort points by distance from circumcenter
    final dists = Float64List(n);
    for (int i = 0; i < n; i++) {
      dists[i] = _dist(coords[i * 2], coords[i * 2 + 1], center.$1, center.$2);
    }

    _quicksort(ids, dists, 0, n - 1);

    // Initialize the hull
    final hullStart = i0;

    final hullPrev = Int32List(n);
    final hullNext = Int32List(n);
    final hullTri = Int32List(n);
    final hullHash = Int32List(n);

    for (int i = 0; i < n; i++) {
      hullHash[i] = -1;
    }

    hullNext[i0] = hullPrev[i2] = i1;
    hullNext[i1] = hullPrev[i0] = i2;
    hullNext[i2] = hullPrev[i1] = i0;

    hullTri[i0] = 0;
    hullTri[i1] = 1;
    hullTri[i2] = 2;

    final hashSize = (math.sqrt(n)).ceil();

    int _hashKey(double x, double y) {
      return ((math.atan2(y - center.$2, x - center.$1) / math.pi * hashSize)
              .floor() %
          hashSize);
    }

    hullHash[_hashKey(i0x, i0y)] = i0;
    hullHash[_hashKey(i1x, i1y)] = i1;
    hullHash[_hashKey(i2x, i2y)] = i2;

    final maxTriangles = math.max(2 * n - 5, 0);
    final triangles = Int32List(maxTriangles * 3);
    final halfedgesList = Int32List(maxTriangles * 3);

    for (int i = 0; i < maxTriangles * 3; i++) {
      halfedgesList[i] = -1;
    }

    int trianglesLen = 0;

    void _addTriangle(int i0, int i1, int i2, int a, int b, int c) {
      final t = trianglesLen;
      triangles[t] = i0;
      triangles[t + 1] = i1;
      triangles[t + 2] = i2;
      halfedgesList[t] = a;
      halfedgesList[t + 1] = b;
      halfedgesList[t + 2] = c;
      if (a >= 0) halfedgesList[a] = t;
      if (b >= 0) halfedgesList[b] = t + 1;
      if (c >= 0) halfedgesList[c] = t + 2;
      trianglesLen += 3;
    }

    _addTriangle(i0, i1, i2, -1, -1, -1);

    double xp = 0, yp = 0;

    for (int k = 0; k < n; k++) {
      final i = ids[k];
      final x = coords[i * 2];
      final y = coords[i * 2 + 1];

      // Skip near-duplicate points
      if (k > 0 && (x - xp).abs() <= 1e-10 && (y - yp).abs() <= 1e-10) continue;
      xp = x;
      yp = y;

      // Skip seed triangle points
      if (i == i0 || i == i1 || i == i2) continue;

      // Find a visible edge on the hull
      int start = 0;
      final key = _hashKey(x, y);
      for (int j = 0; j < hashSize; j++) {
        start = hullHash[(key + j) % hashSize];
        if (start >= 0 && start != hullNext[start]) break;
      }

      if (start < 0) continue;

      var e = start;
      var q = hullNext[e];

      while (_orient(x, y, coords[e * 2], coords[e * 2 + 1], coords[q * 2],
              coords[q * 2 + 1]) >=
          0) {
        e = q;
        if (e == start) {
          e = -1;
          break;
        }
        q = hullNext[e];
      }

      if (e < 0) continue;

      // Add first triangle
      _addTriangle(e, i, hullNext[e], -1, -1, hullTri[e]);
      hullTri[i] = trianglesLen - 3;
      hullTri[e] = trianglesLen - 3;

      // Walk forward through the hull
      var next = hullNext[e];
      q = hullNext[next];

      while (_orient(x, y, coords[next * 2], coords[next * 2 + 1],
              coords[q * 2], coords[q * 2 + 1]) <
          0) {
        _addTriangle(next, i, q, hullTri[i], -1, hullTri[next]);
        hullTri[i] = trianglesLen - 3;
        hullNext[next] = next;
        next = q;
        q = hullNext[next];
      }

      // Walk backward through the hull
      if (e == start) {
        q = hullPrev[e];
        while (_orient(x, y, coords[q * 2], coords[q * 2 + 1], coords[e * 2],
                coords[e * 2 + 1]) <
            0) {
          _addTriangle(q, i, e, -1, hullTri[e], hullTri[q]);
          hullTri[q] = trianglesLen - 3;
          hullNext[e] = e;
          e = q;
          q = hullPrev[e];
        }
      }

      // Update hull
      hullPrev[i] = e;
      hullNext[e] = i;
      hullPrev[next] = i;
      hullNext[i] = next;

      // Update hull hash
      hullHash[_hashKey(x, y)] = i;
      hullHash[_hashKey(coords[e * 2], coords[e * 2 + 1])] = e;
    }

    // Build the hull
    final hullList = <int>[];
    var e = hullStart;
    do {
      hullList.add(e);
      e = hullNext[e];
    } while (e != hullStart);

    hull = hullList;
    triangleIndices = Int32List.sublistView(triangles, 0, trianglesLen);
    halfedges = Int32List.sublistView(halfedgesList, 0, trianglesLen);
    trianglesLength = trianglesLen ~/ 3;
  }

  double _dist(double ax, double ay, double bx, double by) {
    final dx = ax - bx;
    final dy = ay - by;
    return dx * dx + dy * dy;
  }

  double _circumradius(
      double ax, double ay, double bx, double by, double cx, double cy) {
    final dx = bx - ax;
    final dy = by - ay;
    final ex = cx - ax;
    final ey = cy - ay;

    final bl = dx * dx + dy * dy;
    final cl = ex * ex + ey * ey;
    final d = 0.5 / (dx * ey - dy * ex);

    final x = (ey * bl - dy * cl) * d;
    final y = (dx * cl - ex * bl) * d;

    return x * x + y * y;
  }

  (double, double) _circumcenter(
      double ax, double ay, double bx, double by, double cx, double cy) {
    final dx = bx - ax;
    final dy = by - ay;
    final ex = cx - ax;
    final ey = cy - ay;

    final bl = dx * dx + dy * dy;
    final cl = ex * ex + ey * ey;
    final d = 0.5 / (dx * ey - dy * ex);

    final x = ax + (ey * bl - dy * cl) * d;
    final y = ay + (dx * cl - ex * bl) * d;

    return (x, y);
  }

  void _quicksort(Int32List ids, Float64List dists, int left, int right) {
    if (right - left <= 20) {
      for (int i = left + 1; i <= right; i++) {
        final temp = ids[i];
        final tempDist = dists[temp];
        int j = i - 1;
        while (j >= left && dists[ids[j]] > tempDist) {
          ids[j + 1] = ids[j];
          j--;
        }
        ids[j + 1] = temp;
      }
    } else {
      final median = (left + right) >> 1;
      int i = left + 1;
      int j = right;
      _swap(ids, median, i);
      if (dists[ids[left]] > dists[ids[right]]) _swap(ids, left, right);
      if (dists[ids[i]] > dists[ids[right]]) _swap(ids, i, right);
      if (dists[ids[left]] > dists[ids[i]]) _swap(ids, left, i);

      final temp = ids[i];
      final tempDist = dists[temp];

      while (true) {
        do {
          i++;
        } while (dists[ids[i]] < tempDist);
        do {
          j--;
        } while (dists[ids[j]] > tempDist);
        if (j < i) break;
        _swap(ids, i, j);
      }
      ids[left + 1] = ids[j];
      ids[j] = temp;

      if (right - i + 1 >= j - left) {
        _quicksort(ids, dists, i, right);
        _quicksort(ids, dists, left, j - 1);
      } else {
        _quicksort(ids, dists, left, j - 1);
        _quicksort(ids, dists, i, right);
      }
    }
  }

  void _swap(Int32List ids, int i, int j) {
    final temp = ids[i];
    ids[i] = ids[j];
    ids[j] = temp;
  }
}
