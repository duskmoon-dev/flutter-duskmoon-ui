import 'dart:convert';
import 'dart:ui' show Offset;

import 'package:flutter/foundation.dart' show ValueChanged, listEquals;

typedef DmVizRange = (double, double);

enum DmVizTargetKind { datum, cell, node, edge, feature }

class DmVizTarget {
  final DmVizTargetKind kind;
  final String id;
  final String? seriesId;

  const DmVizTarget.datum(String this.seriesId, this.id)
    : kind = DmVizTargetKind.datum;
  const DmVizTarget.cell(this.id)
    : kind = DmVizTargetKind.cell,
      seriesId = null;
  const DmVizTarget.node(this.id)
    : kind = DmVizTargetKind.node,
      seriesId = null;
  const DmVizTarget.edge(this.id)
    : kind = DmVizTargetKind.edge,
      seriesId = null;
  const DmVizTarget.feature(this.id)
    : kind = DmVizTargetKind.feature,
      seriesId = null;

  Map<String, Object?> toJson() => {
    'kind': kind.name,
    if (seriesId case final series?) ...{
      'seriesId': series,
      'datumId': id,
    } else
      'id': id,
  };

  @override
  bool operator ==(Object other) =>
      other is DmVizTarget &&
      kind == other.kind &&
      id == other.id &&
      seriesId == other.seriesId;

  @override
  int get hashCode => Object.hash(kind, id, seriesId);
}

enum DmVizViewportKind { line, scatter, network, map }

class DmVizViewport {
  final DmVizViewportKind kind;
  final DmVizRange? x;
  final DmVizRange? y;
  final Offset? center;
  final double? zoom;

  const DmVizViewport.line(DmVizRange this.x)
    : kind = DmVizViewportKind.line,
      y = null,
      center = null,
      zoom = null;
  const DmVizViewport.scatter(DmVizRange this.x, DmVizRange this.y)
    : kind = DmVizViewportKind.scatter,
      center = null,
      zoom = null;
  const DmVizViewport.network(Offset this.center, double this.zoom)
    : kind = DmVizViewportKind.network,
      x = null,
      y = null;
  const DmVizViewport.map(Offset this.center, double this.zoom)
    : kind = DmVizViewportKind.map,
      x = null,
      y = null;

  bool get valid => center == null
      ? _validRange(x) && (y == null || _validRange(y))
      : center!.isFinite && zoom!.isFinite && zoom! > 0;

  Map<String, Object?> toJson() => {
    'kind': kind.name,
    if (x case final value?) 'x': _rangeJson(value),
    if (y case final value?) 'y': _rangeJson(value),
    if (center case final value?) 'center': [value.dx, value.dy],
    'zoom': ?zoom,
  };

  @override
  bool operator ==(Object other) =>
      other is DmVizViewport &&
      kind == other.kind &&
      x == other.x &&
      y == other.y &&
      center == other.center &&
      zoom == other.zoom;
  @override
  int get hashCode => Object.hash(kind, x, y, center, zoom);
}

enum DmVizSelectionMode { single, multiple }

sealed class DmVizEvent {
  const DmVizEvent();
  Map<String, Object?> toJson();
}

class DmVizTooltipEvent extends DmVizEvent {
  final DmVizTarget target;
  final Map<String, Object?> raw;
  final String display;
  final String? unit;
  const DmVizTooltipEvent({
    required this.target,
    required this.raw,
    required this.display,
    this.unit,
  });

  @override
  Map<String, Object?> toJson() => {
    'type': 'tooltip',
    'target': target.toJson(),
    'raw': raw,
    'display': display,
    'unit': ?unit,
  };
}

enum DmVizSelectionReason { select, toggle, clear, reset }

class DmVizSelectionEvent extends DmVizEvent {
  final List<DmVizTarget> ids;
  final DmVizSelectionReason reason;
  const DmVizSelectionEvent(this.ids, this.reason);
  @override
  Map<String, Object?> toJson() => {
    'type': 'selection',
    'ids': ids.map((id) => id.toJson()).toList(),
    'reason': reason.name,
  };
}

class DmVizVisibilityEvent extends DmVizEvent {
  final String seriesId;
  final bool visible;
  final bool reset;
  const DmVizVisibilityEvent(this.seriesId, this.visible, {this.reset = false});
  @override
  Map<String, Object?> toJson() => {
    'type': 'visibility',
    'seriesId': seriesId,
    'visible': visible,
    'reason': reset ? 'reset' : 'toggle',
  };
}

enum DmVizViewportReason { zoom, pan, reset }

class DmVizViewportEvent extends DmVizEvent {
  final DmVizViewport viewport;
  final DmVizViewportReason reason;
  const DmVizViewportEvent(this.viewport, this.reason);
  @override
  Map<String, Object?> toJson() => {
    'type': 'viewport',
    'viewport': viewport.toJson(),
    'reason': reason.name,
  };
}

enum DmVizBrushReason { brush, clear, reset }

class DmVizBrushEvent extends DmVizEvent {
  final DmVizRange? range;
  final DmVizBrushReason reason;
  const DmVizBrushEvent(this.range, this.reason);
  @override
  Map<String, Object?> toJson() => {
    'type': 'brush',
    'range': range == null ? null : _rangeJson(range!),
    'reason': reason.name,
  };
}

class DmVizNodeMoveEvent extends DmVizEvent {
  final String id;
  final Offset position;
  const DmVizNodeMoveEvent(this.id, this.position);
  @override
  Map<String, Object?> toJson() => {
    'type': 'nodeMove',
    'id': id,
    'position': [position.dx, position.dy],
  };
}

List<double> _rangeJson(DmVizRange range) => [range.$1, range.$2];
bool _validRange(DmVizRange? range) =>
    range != null &&
    range.$1.isFinite &&
    range.$2.isFinite &&
    range.$1 < range.$2;

class DmVizInteraction {
  final List<DmVizTarget>? selection;
  final List<DmVizTarget> defaultSelection;
  final Set<String>? hiddenSeriesIds;
  final DmVizViewport? viewport;
  final DmVizSelectionMode selectionMode;
  final ValueChanged<DmVizEvent>? onEvent;

  const DmVizInteraction({
    this.selection,
    this.defaultSelection = const [],
    this.hiddenSeriesIds,
    this.viewport,
    this.selectionMode = DmVizSelectionMode.single,
    this.onEvent,
  });
}

typedef VizInteractionState = ({
  List<DmVizTarget> ids,
  Set<String> hidden,
  DmVizViewport? viewport,
  DmVizRange? brush,
  DmVizTooltipEvent? tooltip,
});

enum VizActionType {
  focus,
  blur,
  activate,
  clearSelection,
  toggleSeries,
  zoom,
  pan,
  brush,
  clearBrush,
  reset,
  cancel,
  dragNode,
}

typedef VizAction = ({
  VizActionType type,
  DmVizTarget? target,
  String? id,
  DmVizTooltipEvent? tooltip,
  DmVizViewport? viewport,
  DmVizRange? range,
  Offset? position,
});

VizAction vizAction(
  VizActionType type, {
  DmVizTarget? target,
  String? id,
  DmVizTooltipEvent? tooltip,
  DmVizViewport? viewport,
  DmVizRange? range,
  Offset? position,
}) => (
  type: type,
  target: target,
  id: id,
  tooltip: tooltip,
  viewport: viewport,
  range: range,
  position: position,
);

VizInteractionState vizInitial({
  List<DmVizTarget> ids = const [],
  Set<String> hidden = const {},
  DmVizViewport? viewport,
}) =>
    (ids: ids, hidden: hidden, viewport: viewport, brush: null, tooltip: null);

({VizInteractionState state, List<DmVizEvent> events}) transitionViz(
  VizInteractionState state,
  VizAction action, {
  required VizInteractionState initial,
  List<String> series = const [],
  DmVizSelectionMode mode = DmVizSelectionMode.single,
}) {
  var (:ids, :hidden, :viewport, :brush, :tooltip) = state;
  final events = <DmVizEvent>[];

  void select(List<DmVizTarget> values, DmVizSelectionReason reason) {
    if (ids.length == values.length && ids.toSet().containsAll(values)) return;
    ids = List.unmodifiable(values);
    events.add(DmVizSelectionEvent(ids, reason));
  }

  void visibility(String id, bool visible, {bool reset = false}) {
    if (hidden.contains(id) != visible) return;
    hidden = {...hidden};
    if (visible) {
      hidden.remove(id);
    } else {
      hidden.add(id);
      if (tooltip?.target.seriesId == id) tooltip = null;
    }
    events.add(DmVizVisibilityEvent(id, visible, reset: reset));
  }

  void moveViewport(DmVizViewport? value, DmVizViewportReason reason) {
    if (value == null || !value.valid || viewport == value) return;
    viewport = value;
    tooltip = null;
    events.add(DmVizViewportEvent(value, reason));
  }

  void brushTo(DmVizRange? value, DmVizBrushReason reason) {
    if (value == brush || (value != null && !_validRange(value))) return;
    brush = value;
    events.add(DmVizBrushEvent(value, reason));
  }

  switch (action.type) {
    case VizActionType.focus:
      final next = action.tooltip!;
      if (!hidden.contains(next.target.seriesId) &&
          (tooltip == null ||
              jsonEncode(tooltip!.toJson()) != jsonEncode(next.toJson()))) {
        tooltip = next;
        events.add(next);
      }
    case VizActionType.blur || VizActionType.cancel:
      tooltip = null;
    case VizActionType.activate:
      final target = action.target!;
      if (hidden.contains(target.seriesId)) break;
      if (mode == DmVizSelectionMode.multiple) {
        select(
          ids.contains(target)
              ? ids.where((id) => id != target).toList()
              : [...ids, target],
          DmVizSelectionReason.toggle,
        );
      } else {
        select([target], DmVizSelectionReason.select);
      }
    case VizActionType.clearSelection:
      select([], DmVizSelectionReason.clear);
    case VizActionType.toggleSeries:
      final id = action.id!;
      if (series.contains(id)) visibility(id, hidden.contains(id));
    case VizActionType.zoom:
      moveViewport(action.viewport, DmVizViewportReason.zoom);
    case VizActionType.pan:
      moveViewport(action.viewport, DmVizViewportReason.pan);
    case VizActionType.brush:
      brushTo(action.range, DmVizBrushReason.brush);
    case VizActionType.clearBrush:
      brushTo(null, DmVizBrushReason.clear);
    case VizActionType.reset:
      select(initial.ids, DmVizSelectionReason.reset);
      for (final id in series) {
        visibility(id, !initial.hidden.contains(id), reset: true);
      }
      moveViewport(initial.viewport, DmVizViewportReason.reset);
      brushTo(null, DmVizBrushReason.reset);
      tooltip = null;
    case VizActionType.dragNode:
      final position = action.position!;
      if (position.isFinite)
        events.add(DmVizNodeMoveEvent(action.id!, position));
  }
  return (
    state: (
      ids: ids,
      hidden: hidden,
      viewport: viewport,
      brush: brush,
      tooltip: tooltip,
    ),
    events: events,
  );
}

VizInteractionState reconcileVizState(
  VizInteractionState state,
  Set<String> series,
  Set<DmVizTarget> targets,
) {
  final ids = state.ids.where(targets.contains).toList();
  final hidden = state.hidden.intersection(series);
  final target = state.tooltip?.target;
  return (
    ids: listEquals(ids, state.ids) ? state.ids : ids,
    hidden: hidden.length == state.hidden.length ? state.hidden : hidden,
    viewport: state.viewport,
    brush: state.brush,
    tooltip:
        target != null &&
            targets.contains(target) &&
            !hidden.contains(target.seriesId)
        ? state.tooltip
        : null,
  );
}

DmVizRange zoomVizDomain(
  DmVizRange domain,
  double anchor,
  double factor, {
  bool integer = false,
}) {
  final (low, high) = domain;
  final center = low * (1 - anchor) + high * anchor;
  double zoom(double value) {
    final result = center + (value - center) * factor;
    return integer && result.isFinite ? result.roundToDouble() : result;
  }

  final next = (zoom(low), zoom(high));
  return _validRange(next) ? next : domain;
}
