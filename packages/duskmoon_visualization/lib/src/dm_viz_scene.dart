import 'dart:math' as math;
import 'dart:ui';

import 'dm_geo_models.dart';
import 'dm_network_models.dart';
import 'dm_viz_interaction.dart';
import 'dm_viz_series.dart';

typedef VizMapFeature = ({
  GeoJsonFeature source,
  String id,
  Offset? point,
  List<List<List<Offset>>> polygons,
});
typedef VizNetworkScene = ({
  List<DmVizIssue> issues,
  Rect? bounds,
  DmVizViewport? viewport,
  Map<String, DmVizNetworkNode> nodes,
  List<DmVizNetworkEdge> edges,
});
typedef VizMapScene = ({
  List<DmVizIssue> issues,
  Rect? bounds,
  DmVizViewport? viewport,
  List<VizMapFeature> features,
});

void _id(Set<String> ids, Object? value, String path, List<DmVizIssue> issues) {
  if (value is! String || value.isEmpty) {
    issues.add(DmVizIssue('invalidShape', path));
    return;
  }
  if (RegExp(r'[\uD800-\uDFFF]', unicode: true).hasMatch(value)) {
    issues.add(DmVizIssue('invalidId', path));
  }
  if (!ids.add(value)) issues.add(DmVizIssue('duplicateId', path));
}

Rect? _bounds(Iterable<Offset> points) {
  double left = double.infinity, top = double.infinity;
  double right = double.negativeInfinity, bottom = double.negativeInfinity;
  for (final point in points) {
    left = math.min(left, point.dx);
    top = math.min(top, point.dy);
    right = math.max(right, point.dx);
    bottom = math.max(bottom, point.dy);
  }
  return left.isFinite ? Rect.fromLTRB(left, top, right, bottom) : null;
}

VizNetworkScene vizNetworkScene(
  List<DmVizNetworkNode> nodes,
  List<DmVizNetworkEdge> edges,
) {
  final issues = <DmVizIssue>[];
  final nodeIds = <String>{};
  final edgeIds = <String>{};
  for (final (index, node) in nodes.indexed) {
    _id(nodeIds, node.id, '/nodes/$index/id', issues);
    if (node.x == null || !node.x!.isFinite)
      issues.add(DmVizIssue('invalidNumber', '/nodes/$index/x'));
    if (node.y == null || !node.y!.isFinite)
      issues.add(DmVizIssue('invalidNumber', '/nodes/$index/y'));
  }
  for (final (index, edge) in edges.indexed) {
    _id(edgeIds, edge.id, '/edges/$index/id', issues);
    if (!nodeIds.contains(edge.source))
      issues.add(DmVizIssue('unknownReference', '/edges/$index/source'));
    if (!nodeIds.contains(edge.target))
      issues.add(DmVizIssue('unknownReference', '/edges/$index/target'));
  }
  final bounds = issues.isEmpty
      ? _bounds(nodes.map((node) => Offset(node.x!, node.y!)))
      : null;
  return (
    issues: issues,
    bounds: bounds,
    nodes: {for (final node in nodes) node.id: node},
    edges: edges,
    viewport:
        bounds == null ? null : DmVizViewport.network(_midpoint(bounds), 1),
  );
}

const _radians = math.pi / 180;

Offset projectVizMercator(Offset point) {
  final tangent = math.tan(point.dy * _radians);
  final magnitude = math.log(tangent.abs() + math.sqrt(tangent * tangent + 1));
  return Offset(point.dx * _radians, tangent < 0 ? magnitude : -magnitude);
}

Offset unprojectVizMercator(Offset point) => Offset(
      point.dx / _radians,
      (2 * math.atan(math.exp(-point.dy)) - math.pi / 2) / _radians,
    );

Offset _midpoint(Rect bounds) => Offset(
      bounds.left / 2 + bounds.right / 2,
      bounds.top / 2 + bounds.bottom / 2,
    );

bool _validPosition(List<double> point) =>
    point.length == 2 &&
    point.every((value) => value.isFinite) &&
    point[0].abs() <= 180 &&
    point[1].abs() <= 85;

bool _validRing(List<List<double>> ring) {
  if (ring.length < 4 || !ring.every(_validPosition)) return false;
  if (ring.first[0] != ring.last[0] || ring.first[1] != ring.last[1])
    return false;
  for (var index = 1; index < ring.length; index++) {
    if ((ring[index][0] - ring[index - 1][0]).abs() > 180) return false;
  }
  return true;
}

VizMapScene vizMapScene(
  GeoJsonFeatureCollection collection, {
  Offset? center,
  double padding = 16,
}) {
  final issues = <DmVizIssue>[];
  final ids = <String>{};
  final features = <VizMapFeature>[];
  final points = <Offset>[];
  if (center != null && !_validPosition([center.dx, center.dy])) {
    issues.add(const DmVizIssue('unsupportedGeometry', '/options/center'));
  }
  if (!padding.isFinite || padding < 0)
    issues.add(const DmVizIssue('invalidShape', '/options/padding'));
  for (final (index, source) in collection.features.indexed) {
    final path = '/geoJson/features/$index';
    final id = source.id;
    _id(ids, id, '$path/id', issues);
    if (id is! String) continue;
    final value = source.properties['value'];
    if (value != null && (value is! num || !value.isFinite)) {
      issues.add(DmVizIssue('invalidNumber', '$path/properties/value'));
    }
    final geometry = source.geometry;
    final coordinates = '$path/geometry/coordinates';
    if (geometry is GeoJsonPoint) {
      if (!_validPosition(geometry.coordinates)) {
        issues.add(DmVizIssue('unsupportedGeometry', coordinates));
        continue;
      }
      final point = projectVizMercator(
        Offset(geometry.coordinates[0], geometry.coordinates[1]),
      );
      points.add(point);
      features.add((source: source, id: id, point: point, polygons: const []));
      continue;
    }
    final polygons = switch (geometry) {
      GeoJsonPolygon(:final coordinates) => [coordinates],
      GeoJsonMultiPolygon(:final coordinates) => coordinates,
      _ => null,
    };
    if (polygons == null) {
      issues.add(DmVizIssue('unsupportedGeometry', '$path/geometry'));
      continue;
    }
    if (polygons.isEmpty)
      issues.add(DmVizIssue('unsupportedGeometry', coordinates));
    final projected = <List<List<Offset>>>[];
    for (final (polygonIndex, polygon) in polygons.indexed) {
      final polygonPath = geometry is GeoJsonPolygon
          ? coordinates
          : '$coordinates/$polygonIndex';
      if (polygon.isEmpty)
        issues.add(DmVizIssue('unsupportedGeometry', polygonPath));
      final rings = <List<Offset>>[];
      for (final (ringIndex, ring) in polygon.indexed) {
        if (!_validRing(ring)) {
          issues.add(
            DmVizIssue('unsupportedGeometry', '$polygonPath/$ringIndex'),
          );
          continue;
        }
        final positions = ring
            .map((point) => projectVizMercator(Offset(point[0], point[1])))
            .toList();
        if (ringIndex == 0) points.addAll(positions);
        rings.add(positions);
      }
      if (rings.isNotEmpty) projected.add(rings);
    }
    if (projected.isNotEmpty)
      features.add((source: source, id: id, point: null, polygons: projected));
  }
  final bounds = issues.isEmpty ? _bounds(points) : null;
  final viewport = bounds == null
      ? null
      : DmVizViewport.map(center ?? unprojectVizMercator(_midpoint(bounds)), 1);
  return (
    issues: issues,
    bounds: bounds,
    viewport: viewport,
    features: features,
  );
}

double? fitVizScene(
  Rect bounds,
  DmVizViewport initial,
  Size size, {
  double padding = 0,
}) {
  final map = initial.kind == DmVizViewportKind.map;
  final center = map ? projectVizMercator(initial.center!) : initial.center!;
  final width = 2 * math.max(center.dx - bounds.left, bounds.right - center.dx);
  final height =
      2 * math.max(center.dy - bounds.top, bounds.bottom - center.dy);
  final scale = math.min(
    (size.width - 2 * padding) / (width == 0 ? (map ? 1 : 2) : width),
    (size.height - 2 * padding) / (height == 0 ? (map ? 1 : 2) : height),
  );
  return scale.isFinite && scale > 0 ? scale : null;
}

class VizSceneTransform {
  final Offset origin;
  final Offset center;
  final double scale;

  VizSceneTransform(Rect plot, double fit, DmVizViewport viewport)
      : origin = plot.center,
        center = viewport.kind == DmVizViewportKind.map
            ? projectVizMercator(viewport.center!)
            : viewport.center!,
        scale = fit * viewport.zoom!;

  Offset forward(Offset point) => (point - center) * scale + origin;
  Offset inverse(Offset point) => (point - origin) / scale + center;
}

double distanceToVizSegment(Offset point, Offset start, Offset end) {
  final delta = end - start;
  final length = delta.distance;
  if (length <= 0 || !length.isFinite) return (point - start).distance;
  final relative = point - start;
  final unit = delta / length;
  final along = (relative.dx * unit.dx + relative.dy * unit.dy).clamp(
    0.0,
    length,
  );
  return (relative - unit * along).distance;
}

bool _inside(Offset point, List<Offset> ring) {
  var inside = false;
  for (var i = 1; i < ring.length; i++) {
    final a = ring[i - 1];
    final b = ring[i];
    if (distanceToVizSegment(point, a, b) <= 1e-12) return true;
    if ((a.dy > point.dy) != (b.dy > point.dy) &&
        point.dx < a.dx + (b.dx - a.dx) * (point.dy - a.dy) / (b.dy - a.dy))
      inside = !inside;
  }
  return inside;
}

VizMapFeature? hitVizMap(VizMapScene scene, Offset point, double pointRadius) {
  for (final feature in scene.features.reversed) {
    if (feature.point case final position?
        when (position - point).distance <= pointRadius) return feature;
  }
  for (final feature in scene.features.reversed) {
    if (feature.polygons.any(
      (ring) =>
          _inside(point, ring.first) &&
          !ring.skip(1).any((hole) => _inside(point, hole)),
    )) return feature;
  }
  return null;
}
