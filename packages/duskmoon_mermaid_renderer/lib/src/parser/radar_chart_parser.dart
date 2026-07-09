import '../error/mermaid_error.dart';
import '../ir/charts.dart';
import '../ir/diagram_kind.dart';
import '../ir/graph.dart';
import 'parser.dart';

ParseOutput parseRadarChart(String source) {
  final lines = source
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !line.startsWith('%%'))
      .toList();

  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }

  final header = lines.first.toLowerCase();
  if (!header.startsWith('radar-beta')) {
    throw MermaidParseError('Expected radar-beta header, got: ${lines.first}');
  }

  String? title;
  final axes = <RadarAxis>[];
  final curves = <RadarCurve>[];
  double? min;
  double? max;
  var ticks = 5;
  var showLegend = true;
  var graticule = RadarGraticule.circle;

  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('title')) {
      title = _parseTextValue(line.substring('title'.length));
    } else if (lower.startsWith('axis')) {
      axes.addAll(_parseAxes(line.substring('axis'.length)));
    } else if (lower.startsWith('curve')) {
      curves.addAll(_parseCurves(line.substring('curve'.length), axes));
    } else if (lower.startsWith('min')) {
      min = _parseNumber(line.substring('min'.length), 'radar min');
    } else if (lower.startsWith('max')) {
      max = _parseNumber(line.substring('max'.length), 'radar max');
    } else if (lower.startsWith('ticks')) {
      ticks = _parseInt(line.substring('ticks'.length), 'radar ticks');
    } else if (lower.startsWith('showlegend')) {
      showLegend = _parseBool(line.substring('showLegend'.length));
    } else if (lower.startsWith('graticule')) {
      graticule = line.toLowerCase().contains('polygon')
          ? RadarGraticule.polygon
          : RadarGraticule.circle;
    }
  }

  if (axes.length < 3) {
    throw const MermaidParseError('radar-beta requires at least three axes');
  }
  if (curves.isEmpty) {
    throw const MermaidParseError('radar-beta requires at least one curve');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.radar,
      radarChart: RadarChart(
        title: title,
        axes: axes,
        curves: curves,
        min: min,
        max: max,
        ticks: ticks.clamp(1, 10),
        showLegend: showLegend,
        graticule: graticule,
      ),
    ),
  );
}

List<RadarAxis> _parseAxes(String source) {
  return _splitCommaList(source)
      .map(_parseAxis)
      .where((axis) => axis.id.isNotEmpty)
      .toList();
}

RadarAxis _parseAxis(String source) {
  final trimmed = source.trim();
  final labelStart = trimmed.indexOf('[');
  final labelEnd = trimmed.lastIndexOf(']');
  if (labelStart >= 0 && labelEnd > labelStart) {
    final id = trimmed.substring(0, labelStart).trim();
    final label = _stripQuotes(trimmed.substring(labelStart + 1, labelEnd));
    return RadarAxis(id: id, label: label.isEmpty ? id : label);
  }

  final id = _stripQuotes(trimmed);
  return RadarAxis(id: id, label: id);
}

List<RadarCurve> _parseCurves(String source, List<RadarAxis> axes) {
  final curves = <RadarCurve>[];
  final matches = RegExp(
    r'([A-Za-z_][A-Za-z0-9_-]*)(?:\s*\[\s*(".*?"|[^\]]+)\s*\])?\s*\{([^}]*)\}',
  ).allMatches(source);

  for (final match in matches) {
    final id = match.group(1)!.trim();
    final labelSource = match.group(2);
    final label = labelSource == null ? id : _stripQuotes(labelSource);
    final values = _parseCurveValues(match.group(3)!, axes);
    curves.add(RadarCurve(id: id, label: label, values: values));
  }

  return curves;
}

Map<String, double> _parseCurveValues(String source, List<RadarAxis> axes) {
  final entries = _splitCommaList(source);
  final values = <String, double>{};

  if (entries.any((entry) => entry.contains(':'))) {
    for (final entry in entries) {
      final separator = entry.indexOf(':');
      if (separator <= 0) continue;
      final axis = _stripQuotes(entry.substring(0, separator));
      values[axis] =
          _parseNumber(entry.substring(separator + 1), 'curve value');
    }
    return values;
  }

  for (var i = 0; i < entries.length && i < axes.length; i++) {
    values[axes[i].id] = _parseNumber(entries[i], 'curve value');
  }
  return values;
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

double _parseNumber(String source, String label) {
  final value = double.tryParse(source.trim().split(RegExp(r'\s+')).first);
  if (value == null) {
    throw MermaidParseError('Invalid $label: $source');
  }
  return value;
}

int _parseInt(String source, String label) {
  final value = int.tryParse(source.trim().split(RegExp(r'\s+')).first);
  if (value == null) {
    throw MermaidParseError('Invalid $label: $source');
  }
  return value;
}

bool _parseBool(String source) {
  return source.trim().toLowerCase() != 'false';
}

List<String> _splitCommaList(String source) {
  final values = <String>[];
  final buffer = StringBuffer();
  var bracketDepth = 0;
  var braceDepth = 0;
  var inQuotes = false;

  for (var i = 0; i < source.length; i++) {
    final char = source[i];
    if (char == '"') {
      inQuotes = !inQuotes;
      buffer.write(char);
    } else if (!inQuotes && char == '[') {
      bracketDepth++;
      buffer.write(char);
    } else if (!inQuotes && char == ']') {
      bracketDepth--;
      buffer.write(char);
    } else if (!inQuotes && char == '{') {
      braceDepth++;
      buffer.write(char);
    } else if (!inQuotes && char == '}') {
      braceDepth--;
      buffer.write(char);
    } else if (char == ',' &&
        !inQuotes &&
        bracketDepth == 0 &&
        braceDepth == 0) {
      values.add(buffer.toString().trim());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }

  final last = buffer.toString().trim();
  if (last.isNotEmpty) values.add(last);
  return values;
}
