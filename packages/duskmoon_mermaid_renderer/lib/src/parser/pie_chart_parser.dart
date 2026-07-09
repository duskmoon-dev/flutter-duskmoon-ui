import '../error/mermaid_error.dart';
import '../ir/charts.dart';
import '../ir/diagram_kind.dart';
import '../ir/graph.dart';
import 'parser.dart';

ParseOutput parsePieChart(String source) {
  final lines = source
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !line.startsWith('%%'))
      .toList();

  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }

  final header = lines.first.toLowerCase();
  if (!header.startsWith('pie')) {
    throw MermaidParseError('Expected pie header, got: ${lines.first}');
  }

  final showData = header.split(RegExp(r'\s+')).contains('showdata');
  String? title;
  final slices = <PieSlice>[];

  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('title')) {
      title = _parseTextValue(line.substring('title'.length));
      continue;
    }

    final match =
        RegExp(r'^(.+?)\s*:\s*([+-]?\d+(?:\.\d+)?)$').firstMatch(line);
    if (match == null) continue;

    final label = _stripQuotes(match.group(1)!);
    final value = double.tryParse(match.group(2)!);
    if (label.isEmpty || value == null || value < 0) {
      throw MermaidParseError('Invalid pie slice: $line');
    }
    slices.add(PieSlice(label: label, value: value));
  }

  if (slices.isEmpty || slices.every((slice) => slice.value == 0)) {
    throw const MermaidParseError('pie requires at least one positive slice');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.pie,
      pieChart: PieChart(
        title: title,
        showData: showData,
        slices: slices,
      ),
    ),
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
