import 'dart:convert' show utf8;
import 'dart:math' as math;
import 'dart:ui' show Color, Offset, Rect;

import 'dm_viz_format.dart';
import 'dm_viz_series.dart';

enum DmVizChartKind { line, bar, scatter }

typedef VizDomain = (double, double);
typedef VizPoint = ({
  DmVizDatum datum,
  Offset position,
  Rect? rect,
  Color color,
});
typedef VizSeries = ({
  DmVizSeries source,
  Color color,
  bool visible,
  List<VizPoint> points,
  List<List<VizPoint>> segments,
});
typedef VizXYLayout = ({
  List<DmVizIssue> issues,
  Object? xDomain,
  VizDomain? yDomain,
  List<Object> xTicks,
  List<Object> yTicks,
  List<VizSeries> series,
  double? baseline,
});
typedef VizCell = ({
  DmVizHeatmapDatum? cell,
  DmVizCategory row,
  DmVizCategory column,
  Rect rect,
  Color color,
});
typedef VizHeatmapLayout = ({
  List<DmVizIssue> issues,
  VizDomain? domain,
  List<VizCell> cells,
});

final _datePattern = RegExp(
  r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d{1,3})?(?:Z|([+-])(\d{2}):(\d{2}))$',
);

double? normalizeVizTime(Object value) {
  if (value is DateTime) return value.millisecondsSinceEpoch.toDouble();
  if (value is num) {
    return value.isFinite &&
            value.abs() <= 8640000000000000 &&
            value == value.truncateToDouble()
        ? value.toDouble()
        : null;
  }
  if (value is! String) return null;
  final date = _datePattern.firstMatch(value);
  if (date == null || date.end != value.length) return null;
  int number(int group) => int.parse(date[group]!);
  final utcDate = DateTime.utc(number(1), number(2), number(3));
  if (utcDate.month != number(2) ||
      utcDate.day != number(3) ||
      number(4) > 23 ||
      number(5) > 59 ||
      number(6) > 59 ||
      (date[7] != null && (number(8) > 23 || number(9) > 59))) {
    return null;
  }
  return DateTime.tryParse(value)?.millisecondsSinceEpoch.toDouble();
}

int vizSeriesHash(String id) {
  var hash = 2166136261;
  for (final byte in utf8.encode(id)) {
    final mixed = hash ^ byte;
    // Split the product so Flutter Web can compute it exactly in binary64.
    hash = ((mixed & 65535) * 16777619 +
            (((mixed >>> 16) * 16777619) % 65536) * 65536) %
        4294967296;
  }
  return hash;
}

VizDomain? _continuousDomain(
  List<double> values, {
  bool includeZero = false,
  bool time = false,
  bool nice = false,
}) {
  if (values.isEmpty) return null;
  var low = values.reduce(math.min);
  var high = values.reduce(math.max);
  if (includeZero) {
    low = math.min(low, 0);
    high = math.max(high, 0);
  }
  if (low == high) {
    final padding = time
        ? 1000.0
        : low == 0
            ? 1.0
            : low.abs() * 0.05;
    low -= padding;
    high += padding;
  }
  if (nice && low.isFinite && high.isFinite) {
    final requested = math.max(
      time ? 1.0 : double.minPositive,
      high / 5 - low / 5,
    );
    final exponent = (math.log(requested) / math.ln10).floor();
    final power = math.pow(10, exponent).toDouble();
    if (power > 0) {
      final step = [1, 2, 5, 10]
          .map((factor) => factor * power)
          .firstWhere((candidate) => candidate >= requested);
      low = (low / step).floorToDouble() * step;
      high = (high / step).ceilToDouble() * step;
    }
  }
  return low.isFinite && high.isFinite && low < high ? (low, high) : null;
}

double vizPosition(double value, VizDomain domain) {
  final (low, high) = domain;
  final span = high - low;
  return span.isFinite
      ? (value - low) / span
      : (value / 2 - low / 2) / (high / 2 - low / 2);
}

Object? normalizeVizAxisValue(Object value, DmVizAxis axis) =>
    switch (axis.type) {
      DmVizAxisType.numeric =>
        value is num && value.isFinite ? value.toDouble() : null,
      DmVizAxisType.category => value is String ? value : null,
      DmVizAxisType.time => normalizeVizTime(value),
    };

void _recordId(
  Set<String> ids,
  String id,
  String path,
  List<DmVizIssue> issues,
) {
  if (id.isEmpty) issues.add(DmVizIssue('invalidShape', path));
  if (id.runes.any((rune) => rune >= 0xd800 && rune <= 0xdfff)) {
    issues.add(DmVizIssue('invalidId', path));
  }
  if (!ids.add(id)) issues.add(DmVizIssue('duplicateId', path));
}

String _invalidAxisValue(Object value, DmVizAxis axis) {
  if (value is num && !value.isFinite) return 'invalidNumber';
  return axis.type == DmVizAxisType.time ? 'invalidTime' : 'invalidShape';
}

VizDomain? _axisDomain(
  List<double> values,
  DmVizAxis axis,
  String path,
  List<DmVizIssue> issues, {
  bool forceZero = false,
}) {
  final explicit = axis.domain;
  if (explicit != null) {
    if (explicit.length != 2) {
      issues.add(DmVizIssue('invalidDomain', path));
      return null;
    }
    final ends = <double>[];
    for (final (index, value) in explicit.indexed) {
      final normalized = normalizeVizAxisValue(value, axis);
      if (normalized is double) {
        ends.add(normalized);
      } else {
        issues.add(DmVizIssue(_invalidAxisValue(value, axis), '$path/$index'));
      }
    }
    if (ends.length != 2) return null;
    if (ends.first >= ends.last) {
      issues.add(DmVizIssue('invalidDomain', path));
      return null;
    }
    return (ends.first, ends.last);
  }
  final domain = _continuousDomain(
    values,
    includeZero: axis.includeZero || forceZero,
    time: axis.type == DmVizAxisType.time,
    nice: axis.nice,
  );
  if (domain == null && values.isNotEmpty) {
    issues.add(DmVizIssue('invalidNumber', path));
  }
  return domain;
}

List<Object> _axisTicks(
  DmVizAxis axis,
  Object? domain,
  String path,
  List<DmVizIssue> issues,
) {
  final ticks = axis.tickValues;
  if (ticks == null) return domain is List<String> ? domain : const [];
  final result = <Object>[];
  for (final (index, value) in ticks.indexed) {
    final normalized = normalizeVizAxisValue(value, axis);
    if (normalized == null) {
      issues.add(DmVizIssue(_invalidAxisValue(value, axis), '$path/$index'));
    } else if ((domain is List<String> && domain.contains(normalized)) ||
        (domain is VizDomain &&
            normalized is double &&
            normalized >= domain.$1 &&
            normalized <= domain.$2)) {
      result.add(normalized);
    }
  }
  return result;
}

typedef _Normalized = ({DmVizDatum datum, Object? x, double? y});
List<List<VizPoint>> _segments(
  List<_Normalized> entries,
  VizPoint? Function(_Normalized) project,
  double Function(Object) sortKey,
  bool sortX,
  bool connectMissing,
) {
  final result = <List<VizPoint>>[];
  var segment = <VizPoint>[];
  final run = <_Normalized>[];
  void finishSegment() {
    if (segment.isNotEmpty) result.add(segment);
    segment = [];
  }

  void finishRun() {
    final indices = List.generate(run.length, (index) => index);
    if (sortX) {
      indices.sort((a, b) {
        final comparison = sortKey(run[a].x!).compareTo(sortKey(run[b].x!));
        return comparison == 0 ? a.compareTo(b) : comparison;
      });
    }
    for (final index in indices) {
      final entry = run[index];
      final point = project(entry);
      if (point != null) {
        segment.add(point);
      } else if (entry.y != null || !connectMissing) {
        finishSegment();
      }
    }
    finishSegment();
    run.clear();
  }

  for (final entry in entries) {
    if (entry.x == null) {
      finishRun();
    } else {
      run.add(entry);
    }
  }
  finishRun();
  return result;
}

VizXYLayout layoutVizXY({
  required DmVizChartKind kind,
  required List<DmVizSeries> series,
  required DmVizAxis xAxis,
  required DmVizAxis yAxis,
  required List<Color> palette,
  DmVizOptions options = const DmVizOptions(),
  Set<String>? hiddenSeriesIds,
  bool sortX = false,
  bool connectMissing = false,
  DmVizBarOrientation orientation = DmVizBarOrientation.vertical,
}) {
  final issues = <DmVizIssue>[];
  if (!validVizFormat(xAxis))
    issues.add(const DmVizIssue('invalidFormat', '/xAxis/format'));
  if (!validVizFormat(yAxis))
    issues.add(const DmVizIssue('invalidFormat', '/yAxis/format'));
  final hidden = hiddenSeriesIds ?? options.hiddenSeriesIds;
  final seriesIds = <String>{};
  final categories = <String>{};
  final xValues = <double>[];
  final yValues = <double>[];
  if (yAxis.type != DmVizAxisType.numeric) {
    issues.add(const DmVizIssue('invalidShape', '/yAxis/type'));
  }
  if ((kind == DmVizChartKind.bar && xAxis.type != DmVizAxisType.category) ||
      (kind == DmVizChartKind.scatter && xAxis.type != DmVizAxisType.numeric)) {
    issues.add(const DmVizIssue('invalidShape', '/xAxis/type'));
  }
  final normalized = series.indexed.map((entry) {
    final (index, source) = entry;
    final path = '/series/$index';
    _recordId(seriesIds, source.id, '$path/id', issues);
    final ids = <String>{};
    final barKeys = <String>{};
    final include = !options.domainAfterHide || !hidden.contains(source.id);
    return source.data.indexed.map((item) {
      final (itemIndex, datum) = item;
      final itemPath = '$path/data/$itemIndex';
      _recordId(ids, datum.id, '$itemPath/id', issues);
      final rawX = datum.x;
      final x = rawX == null ? null : normalizeVizAxisValue(rawX, xAxis);
      final y = datum.y;
      if (rawX != null && x == null) {
        issues.add(DmVizIssue(_invalidAxisValue(rawX, xAxis), '$itemPath/x'));
      }
      if (y != null && !y.isFinite) {
        issues.add(DmVizIssue('invalidNumber', '$itemPath/y'));
      }
      if (kind == DmVizChartKind.scatter && (rawX == null || y == null)) {
        issues.add(DmVizIssue('missingCoordinate', itemPath, warning: true));
      }
      if (x is String) {
        if (include) categories.add(x);
        if (kind == DmVizChartKind.bar && !barKeys.add(x)) {
          issues.add(DmVizIssue('duplicatePosition', '$itemPath/x'));
        }
      }
      if (include && x != null && y != null && y.isFinite) {
        if (x is double) xValues.add(x);
        yValues.add(y);
      }
      return (datum: datum, x: x, y: y);
    }).toList();
  }).toList();

  for (final (index, id) in hidden.indexed) {
    if (!seriesIds.contains(id)) {
      issues.add(
        DmVizIssue('unknownReference', '/options/hiddenSeriesIds/$index'),
      );
    }
  }
  final isCategory = xAxis.type == DmVizAxisType.category;
  final xDomain = isCategory
      ? (xAxis.domain?.cast<String>() ?? categories.toList())
      : _axisDomain(xValues, xAxis, '/xAxis/domain', issues);
  final yDomain = _axisDomain(
    yValues,
    yAxis,
    '/yAxis/domain',
    issues,
    forceZero: kind == DmVizChartKind.bar,
  );
  final xTicks = _axisTicks(xAxis, xDomain, '/xAxis/tickValues', issues);
  final yTicks = _axisTicks(yAxis, yDomain, '/yAxis/tickValues', issues);
  final colors = options.seriesColors ?? palette;
  if (colors.isEmpty)
    issues.add(const DmVizIssue('invalidShape', '/options/theme/seriesColors'));
  if (issues.any((issue) => !issue.warning)) {
    return (
      issues: issues,
      xDomain: null,
      yDomain: null,
      xTicks: [],
      yTicks: [],
      series: [],
      baseline: null,
    );
  }

  final categoryIndex = isCategory
      ? {for (final (index, id) in (xDomain as List<String>).indexed) id: index}
      : const <String, int>{};
  final horizontal = orientation == DmVizBarOrientation.horizontal;
  final zero = yDomain == null ? 0.0 : vizPosition(0, yDomain).clamp(0.0, 1.0);
  final visibleCount = series.length - hidden.length;
  var nextSlot = 0;
  final result = <VizSeries>[];
  for (final (index, source) in series.indexed) {
    final visible = !hidden.contains(source.id);
    final slot = visible ? nextSlot++ : 0;
    final color = source.color ??
        colors[
            (source.paletteSlot ?? vizSeriesHash(source.id)) % colors.length];

    VizPoint? project(_Normalized entry) {
      final (:datum, :x, :y) = entry;
      if (!visible ||
          x == null ||
          y == null ||
          xDomain == null ||
          yDomain == null) return null;
      final category = x is String ? categoryIndex[x] : null;
      if (x is String && category == null) return null;
      final xRatio = category == null
          ? vizPosition(x as double, xDomain as VizDomain)
          : (category + 0.5) / categoryIndex.length;
      final yRatio = vizPosition(y, yDomain);
      final datumColor = datum.color ?? color;
      if (kind != DmVizChartKind.bar) {
        return (
          datum: datum,
          position: Offset(xRatio, 1 - yRatio),
          rect: null,
          color: datumColor,
        );
      }

      final width = 1 / categoryIndex.length / visibleCount;
      final categoryStart = (category! * visibleCount + slot) * width;
      final end = yRatio.clamp(0.0, 1.0);
      final start = math.min(zero, end);
      final length = (end - zero).abs();
      final rect = horizontal
          ? Rect.fromLTWH(start, categoryStart, length, width)
          : Rect.fromLTWH(
              categoryStart,
              1 - math.max(zero, end),
              width,
              length,
            );
      final point = horizontal
          ? Offset(end, categoryStart + width / 2)
          : Offset(categoryStart + width / 2, 1 - end);
      return (datum: datum, position: point, rect: rect, color: datumColor);
    }

    double sortKey(Object x) =>
        x is double ? x : categoryIndex[x]?.toDouble() ?? double.infinity;
    final segments = kind == DmVizChartKind.line && visible
        ? _segments(normalized[index], project, sortKey, sortX, connectMissing)
        : <List<VizPoint>>[];
    final points = kind == DmVizChartKind.line
        ? segments.expand((points) => points).toList()
        : normalized[index].map(project).nonNulls.toList();
    result.add((
      source: source,
      color: color,
      visible: visible,
      points: points,
      segments: segments,
    ));
  }
  final baseline =
      kind == DmVizChartKind.bar ? (horizontal ? zero : 1 - zero) : null;
  return (
    issues: issues,
    xDomain: xDomain,
    yDomain: yDomain,
    xTicks: xTicks,
    yTicks: yTicks,
    series: result,
    baseline: baseline,
  );
}

Color _sampleColor(List<Color> colors, double fraction) {
  final position = fraction.clamp(0.0, 1.0) * (colors.length - 1);
  final left = colors[position.floor()].toARGB32();
  final right = colors[position.ceil()].toARGB32();
  final blend = position - position.floor();
  int channel(int shift) {
    final first = (left >> shift) & 255;
    final last = (right >> shift) & 255;
    return (first + (last - first) * blend).round();
  }

  return Color.fromARGB(255, channel(16), channel(8), channel(0));
}

VizHeatmapLayout layoutVizHeatmap({
  required List<DmVizCategory> rows,
  required List<DmVizCategory> columns,
  required List<DmVizHeatmapDatum> data,
  required List<Color> colors,
  required Color missing,
  VizDomain? explicitDomain,
}) {
  final issues = <DmVizIssue>[];
  final rowIds = <String>{};
  final columnIds = <String>{};
  final cellIds = <String>{};
  for (final (index, row) in rows.indexed) {
    _recordId(rowIds, row.id, '/rows/$index/id', issues);
  }
  for (final (index, column) in columns.indexed) {
    _recordId(columnIds, column.id, '/columns/$index/id', issues);
  }
  final byPosition = <(String, String), DmVizHeatmapDatum>{};
  final values = <double>[];
  for (final (index, cell) in data.indexed) {
    final path = '/cells/$index';
    _recordId(cellIds, cell.id, '$path/id', issues);
    if (!rowIds.contains(cell.rowId))
      issues.add(DmVizIssue('unknownReference', '$path/rowId'));
    if (!columnIds.contains(cell.columnId))
      issues.add(DmVizIssue('unknownReference', '$path/columnId'));
    final position = (cell.rowId, cell.columnId);
    if (byPosition.containsKey(position))
      issues.add(DmVizIssue('duplicatePosition', '$path/columnId'));
    byPosition[position] = cell;
    final value = cell.value;
    if (value == null) continue;
    if (value.isFinite) {
      values.add(value);
    } else {
      issues.add(DmVizIssue('invalidNumber', '$path/value'));
    }
  }
  final domain = explicitDomain ?? _continuousDomain(values);
  if (explicitDomain case (final low, final high)
      when !low.isFinite || !high.isFinite || low >= high) {
    issues.add(const DmVizIssue('invalidDomain', '/options/valueDomain'));
  } else if (domain == null && values.isNotEmpty) {
    issues.add(const DmVizIssue('invalidNumber', '/options/valueDomain'));
  }
  if (colors.length < 2)
    issues.add(
      const DmVizIssue('invalidShape', '/options/theme/heatmapColors'),
    );
  if (issues.isNotEmpty) return (issues: issues, domain: null, cells: []);
  final constant = explicitDomain == null &&
      values.isNotEmpty &&
      values.every((value) => value == values.first);

  return (
    issues: issues,
    domain: domain,
    cells: [
      for (final (rowIndex, row) in rows.indexed)
        for (final (columnIndex, column) in columns.indexed)
          (() {
            final cell = byPosition[(row.id, column.id)];
            final value = cell?.value;
            final color = value == null || domain == null
                ? missing
                : _sampleColor(
                    colors,
                    constant ? 0.5 : vizPosition(value, domain),
                  );
            final rect = Rect.fromLTWH(
              columnIndex / columns.length,
              rowIndex / rows.length,
              1 / columns.length,
              1 / rows.length,
            );
            return (
              cell: cell,
              row: row,
              column: column,
              rect: rect,
              color: color,
            );
          })(),
    ],
  );
}
