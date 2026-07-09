import '../error/mermaid_error.dart';
import '../ir/charts.dart';
import '../ir/diagram_kind.dart';
import '../ir/graph.dart';
import 'parser.dart';

ParseOutput parseQuadrantChart(String source) {
  final lines = source
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !line.startsWith('%%'))
      .toList();

  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }

  final header = lines.first.toLowerCase();
  if (!header.startsWith('quadrantchart')) {
    throw MermaidParseError(
        'Expected quadrantChart header, got: ${lines.first}');
  }

  String? title;
  var xAxis = const QuadrantAxis();
  var yAxis = const QuadrantAxis();
  final quadrants = <int, String>{};
  final points = <QuadrantPoint>[];

  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('title')) {
      title = _parseTextValue(line.substring('title'.length));
    } else if (lower.startsWith('x-axis')) {
      xAxis = _parseAxis(line.substring('x-axis'.length));
    } else if (lower.startsWith('y-axis')) {
      yAxis = _parseAxis(line.substring('y-axis'.length));
    } else if (lower.startsWith('quadrant-')) {
      final match = RegExp(r'^quadrant-([1-4])\s+(.+)$', caseSensitive: false)
          .firstMatch(line);
      if (match != null) {
        quadrants[int.parse(match.group(1)!)] = _stripQuotes(match.group(2)!);
      }
    } else {
      final point = _parsePoint(line);
      if (point != null) points.add(point);
    }
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.quadrant,
      quadrantChart: QuadrantChart(
        title: title,
        xAxis: xAxis,
        yAxis: yAxis,
        quadrants: quadrants,
        points: points,
      ),
    ),
  );
}

QuadrantAxis _parseAxis(String source) {
  final trimmed = source.trim();
  if (trimmed.isEmpty) return const QuadrantAxis();

  final arrow = trimmed.indexOf('-->');
  if (arrow >= 0) {
    return QuadrantAxis(
      start: _parseTextValue(trimmed.substring(0, arrow)),
      end: _parseTextValue(trimmed.substring(arrow + 3)),
    );
  }

  return QuadrantAxis(start: _parseTextValue(trimmed));
}

QuadrantPoint? _parsePoint(String line) {
  final match = RegExp(
    r'^(.+?)\s*:\s*\[\s*([+-]?\d+(?:\.\d+)?)\s*,\s*([+-]?\d+(?:\.\d+)?)\s*\]$',
  ).firstMatch(line);
  if (match == null) return null;

  final x = double.tryParse(match.group(2)!);
  final y = double.tryParse(match.group(3)!);
  if (x == null || y == null || x < 0 || x > 1 || y < 0 || y > 1) {
    throw MermaidParseError(
        'quadrantChart point must be in the 0..1 range: $line');
  }

  return QuadrantPoint(
    label: _stripQuotes(match.group(1)!),
    x: x,
    y: y,
  );
}

String? _parseTextValue(String source) {
  final trimmed = source.trim();
  if (trimmed.isEmpty) return null;
  return _stripQuotes(trimmed);
}

String _stripQuotes(String value) {
  final trimmed = value.trim();
  if (trimmed.length >= 2 && trimmed.startsWith('"') && trimmed.endsWith('"')) {
    return trimmed.substring(1, trimmed.length - 1);
  }
  return trimmed;
}
