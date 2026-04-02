import 'package:duskmoon_visualization/src/vendor/dv_heatmap/src/heatmap.dart';
import 'package:duskmoon_visualization/src/vendor/dv_xychart/src/scatter_series.dart';
import 'package:duskmoon_visualization/src/vendor/dv_xychart/src/xy_chart.dart';

/// Public data model for DuskMoon XY-based charts.
class DmVizPoint {
  final Object? x;
  final double y;
  final Map<String, dynamic>? metadata;

  const DmVizPoint({
    required this.x,
    required this.y,
    this.metadata,
  });

  XYDataPoint toRaw() => XYDataPoint(x: x, y: y, metadata: metadata);
}

/// Public data model for DuskMoon heatmap charts.
class DmVizHeatmapCell {
  final int row;
  final int column;
  final double value;
  final Map<String, dynamic>? metadata;

  const DmVizHeatmapCell({
    required this.row,
    required this.column,
    required this.value,
    this.metadata,
  });

  HeatmapDataPoint toRaw() => HeatmapDataPoint(
        row: row,
        column: column,
        value: value,
        metadata: metadata,
      );
}

/// Marker shapes for DuskMoon scatter charts.
enum DmVizMarkerShape {
  circle,
  square,
  triangle,
  diamond,
  cross,
  plus,
  star,
}

extension DmVizMarkerShapeRaw on DmVizMarkerShape {
  MarkerShape toRaw() {
    switch (this) {
      case DmVizMarkerShape.circle:
        return MarkerShape.circle;
      case DmVizMarkerShape.square:
        return MarkerShape.square;
      case DmVizMarkerShape.triangle:
        return MarkerShape.triangle;
      case DmVizMarkerShape.diamond:
        return MarkerShape.diamond;
      case DmVizMarkerShape.cross:
        return MarkerShape.cross;
      case DmVizMarkerShape.plus:
        return MarkerShape.plus;
      case DmVizMarkerShape.star:
        return MarkerShape.star;
    }
  }
}
