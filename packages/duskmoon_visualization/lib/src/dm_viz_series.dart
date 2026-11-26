import 'dart:ui' show Color;

import 'dm_chart_models.dart';

/// A stable point in a contract-based chart. Null coordinates mean missing data.
class DmVizDatum {
  final String id;
  final Object? x;
  final double? y;
  final Color? color;
  final Map<String, Object?>? metadata;

  const DmVizDatum({
    required this.id,
    required this.x,
    required this.y,
    this.color,
    this.metadata,
  });
}

class DmVizSeries {
  final String id;
  final String name;
  final List<DmVizDatum> data;
  final Color? color;
  final int? paletteSlot;

  const DmVizSeries({
    required this.id,
    required this.name,
    required this.data,
    this.color,
    this.paletteSlot,
  });
}

class DmVizCategory {
  final String id;
  final String label;

  const DmVizCategory({required this.id, required this.label});
}

enum DmVizAxisType { numeric, category, time }

enum DmVizFormatStyle { decimal, utcIso, dateTime, label }

/// Portable formatting options. Time zones use IANA identifiers.
class DmVizFormat {
  final DmVizFormatStyle style;
  final String? locale;
  final String? timeZone;
  final int? fractionDigits;

  const DmVizFormat({
    required this.style,
    this.locale,
    this.timeZone,
    this.fractionDigits,
  });
}

class DmVizAxis {
  final DmVizAxisType type;
  final List<Object>? domain;
  final List<Object>? tickValues;
  final String? label;
  final String? unit;
  final DmVizFormat? format;
  final bool includeZero;
  final bool nice;

  const DmVizAxis.numeric({
    List<num>? this.domain,
    List<num>? this.tickValues,
    this.label,
    this.unit,
    this.format,
    this.includeZero = false,
    this.nice = false,
  }) : type = DmVizAxisType.numeric;

  /// Time values are epoch milliseconds, offset-bearing ISO text, or DateTime.
  const DmVizAxis.time({
    this.domain,
    this.tickValues,
    this.label,
    this.unit,
    this.format,
    this.nice = false,
  }) : type = DmVizAxisType.time,
       includeZero = false;

  const DmVizAxis.category({
    List<String>? this.domain,
    List<String>? this.tickValues,
    this.label,
    this.unit,
    this.format,
  }) : type = DmVizAxisType.category,
       includeZero = false,
       nice = false;
}

class DmVizMarker {
  final bool? visible;
  final DmVizMarkerShape shape;
  final double radius;

  const DmVizMarker({
    this.visible,
    this.shape = DmVizMarkerShape.circle,
    this.radius = 4,
  });
}

class DmVizHeatmapDatum {
  final String id;
  final String rowId;
  final String columnId;
  final double? value;
  final Map<String, Object?>? metadata;

  const DmVizHeatmapDatum({
    required this.id,
    required this.rowId,
    required this.columnId,
    required this.value,
    this.metadata,
  });
}

class DmVizOptions {
  final String? title;
  final String? description;
  final String? summary;
  final List<Color>? seriesColors;
  final List<Color>? heatmapColors;
  final Color? missingColor;
  final Set<String> hiddenSeriesIds;
  final bool domainAfterHide;
  final bool loading;

  const DmVizOptions({
    this.title,
    this.description,
    this.summary,
    this.seriesColors,
    this.heatmapColors,
    this.missingColor,
    this.hiddenSeriesIds = const {},
    this.domainAfterHide = false,
    this.loading = false,
  });
}

enum DmVizBarOrientation { vertical, horizontal }

class DmVizIssue {
  final String code;
  final String path;
  final bool warning;

  const DmVizIssue(this.code, this.path, {this.warning = false});
}
