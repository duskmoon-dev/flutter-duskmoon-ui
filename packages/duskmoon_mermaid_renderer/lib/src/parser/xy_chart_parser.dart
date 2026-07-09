import '../error/mermaid_error.dart';
import '../ir/diagram_kind.dart';
import '../ir/graph.dart';
import '../ir/xy_chart.dart';
import 'parser.dart';

ParseOutput parseXyChart(String source) {
  final lines = source
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !line.startsWith('%%'))
      .toList();

  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }

  final header = lines.first.toLowerCase();
  if (!header.startsWith('xychart')) {
    throw MermaidParseError('Expected xychart header, got: ${lines.first}');
  }

  final orientation = header.contains('horizontal')
      ? XyChartOrientation.horizontal
      : XyChartOrientation.vertical;
  String? title;
  XyChartAxis xAxis = const XyChartAxis();
  XyChartAxis yAxis = const XyChartAxis();
  final series = <XyChartSeries>[];

  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('title')) {
      title = _parseTextValue(line.substring('title'.length));
    } else if (lower.startsWith('x-axis')) {
      xAxis = _parseAxis(
        line.substring('x-axis'.length),
        allowCategories: true,
      );
    } else if (lower.startsWith('y-axis')) {
      yAxis = _parseAxis(
        line.substring('y-axis'.length),
        allowCategories: false,
      );
    } else if (lower.startsWith('bar')) {
      series.add(_parseSeries(
        line.substring('bar'.length),
        XyChartSeriesType.bar,
      ));
    } else if (lower.startsWith('line')) {
      series.add(_parseSeries(
        line.substring('line'.length),
        XyChartSeriesType.line,
      ));
    }
  }

  if (series.isEmpty) {
    throw const MermaidParseError('xychart requires at least one line or bar');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.xyChart,
      xyChart: XyChart(
        orientation: orientation,
        title: title,
        xAxis: xAxis,
        yAxis: yAxis,
        series: series,
      ),
    ),
  );
}

XyChartAxis _parseAxis(String source, {required bool allowCategories}) {
  final trimmed = source.trim();
  if (trimmed.isEmpty) return const XyChartAxis();

  final listStart = trimmed.indexOf('[');
  final listEnd = trimmed.lastIndexOf(']');
  if (listStart >= 0 && listEnd > listStart) {
    if (!allowCategories) {
      throw const MermaidParseError('y-axis does not support categories');
    }
    final title = _parseTextValue(trimmed.substring(0, listStart));
    final categories = _splitCommaList(
      trimmed.substring(listStart + 1, listEnd),
    ).map(_stripQuotes).where((value) => value.isNotEmpty).toList();
    return XyChartAxis(
      title: title,
      categories: categories,
    );
  }

  final arrow = trimmed.indexOf('-->');
  if (arrow >= 0) {
    final left = trimmed.substring(0, arrow).trim();
    final max = _parseNumber(trimmed.substring(arrow + 3).trim(), 'axis max');
    final tokens = _tokenize(left);
    if (tokens.isEmpty) {
      throw const MermaidParseError('Axis range is missing a minimum value');
    }
    final min = _parseNumber(tokens.last, 'axis min');
    final title = _parseTextValue(tokens.take(tokens.length - 1).join(' '));
    return XyChartAxis(
      title: title,
      min: min,
      max: max,
    );
  }

  return XyChartAxis(title: _parseTextValue(trimmed));
}

XyChartSeries _parseSeries(String source, XyChartSeriesType type) {
  final trimmed = source.trim();
  final listStart = trimmed.indexOf('[');
  final listEnd = trimmed.lastIndexOf(']');
  if (listStart < 0 || listEnd <= listStart) {
    throw const MermaidParseError('xychart series must use [value, ...]');
  }

  final values = _splitCommaList(trimmed.substring(listStart + 1, listEnd))
      .map(_parseSeriesValue)
      .toList();
  if (values.isEmpty) {
    throw const MermaidParseError('xychart series cannot be empty');
  }

  return XyChartSeries(type: type, values: values);
}

XyChartValue _parseSeriesValue(String source) {
  final trimmed = source.trim();
  final match = RegExp(
    r'^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?',
  ).firstMatch(trimmed);
  if (match == null) {
    throw MermaidParseError('Invalid xychart value: $source');
  }

  final value = _parseNumber(match.group(0)!, 'series value');
  final rest = trimmed.substring(match.end).trim();
  return XyChartValue(
    value: value,
    label: rest.isEmpty ? null : _parseTextValue(rest),
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

double _parseNumber(String source, String label) {
  final token = source.trim().split(RegExp(r'\s+')).first;
  final value = double.tryParse(token);
  if (value == null) {
    throw MermaidParseError('Invalid xychart $label: $source');
  }
  return value;
}

List<String> _splitCommaList(String source) {
  final values = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;

  for (var i = 0; i < source.length; i++) {
    final char = source[i];
    if (char == '"') {
      inQuotes = !inQuotes;
      buffer.write(char);
    } else if (char == ',' && !inQuotes) {
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

List<String> _tokenize(String source) {
  final tokens = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;

  void flush() {
    if (buffer.isEmpty) return;
    tokens.add(buffer.toString());
    buffer.clear();
  }

  for (var i = 0; i < source.length; i++) {
    final char = source[i];
    if (char == '"') {
      inQuotes = !inQuotes;
      buffer.write(char);
    } else if (RegExp(r'\s').hasMatch(char) && !inQuotes) {
      flush();
    } else {
      buffer.write(char);
    }
  }
  flush();

  return tokens;
}
