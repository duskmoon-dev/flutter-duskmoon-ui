import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/layout_config.dart';
import '../ir/edge.dart';
import '../ir/node.dart';

class MermaidTextStyle {
  const MermaidTextStyle({
    required this.fontSize,
    required this.lineHeight,
  });

  final double fontSize;
  final double lineHeight;
}

abstract interface class MermaidTextMeasurer {
  Size measure(String text, MermaidTextStyle style);
}

class FlutterTextMeasurer implements MermaidTextMeasurer {
  const FlutterTextMeasurer({
    required this.textDirection,
    required this.textScaler,
  });

  final TextDirection textDirection;
  final TextScaler textScaler;

  @override
  Size measure(String text, MermaidTextStyle style) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: style.fontSize,
          height: style.lineHeight,
        ),
      ),
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: null,
    )..layout();
    return painter.size;
  }
}

class HeuristicTextMeasurer implements MermaidTextMeasurer {
  const HeuristicTextMeasurer();

  @override
  Size measure(String text, MermaidTextStyle style) {
    final lines = text.split('\n');
    final width = lines.fold<double>(0, (maxWidth, line) {
      return math.max(maxWidth, _measureLine(line, style.fontSize));
    });
    return Size(width, lines.length * style.fontSize * style.lineHeight);
  }

  double _measureLine(String line, double fontSize) {
    var width = 0.0;
    for (final codeUnit in line.runes) {
      if (codeUnit == 0x20) {
        width += fontSize * 0.32;
      } else if (_isWide(codeUnit)) {
        width += fontSize;
      } else {
        width += fontSize * 0.56;
      }
    }
    return width;
  }

  bool _isWide(int codeUnit) {
    return (codeUnit >= 0x1100 && codeUnit <= 0x11FF) ||
        (codeUnit >= 0x2E80 && codeUnit <= 0xA4CF) ||
        (codeUnit >= 0xAC00 && codeUnit <= 0xD7AF) ||
        (codeUnit >= 0xF900 && codeUnit <= 0xFAFF) ||
        (codeUnit >= 0x1F300 && codeUnit <= 0x1FAFF);
  }
}

class NodeLayout {
  const NodeLayout({
    required this.node,
    required this.rect,
    required this.labelSize,
  });

  final Node node;
  final Rect rect;
  final Size labelSize;
}

class EdgeLayout {
  const EdgeLayout({
    required this.edge,
    required this.points,
    this.labelBounds,
  });

  final Edge edge;
  final List<Offset> points;
  final Rect? labelBounds;
}

Size measureNode(
  Node node,
  MermaidLayoutConfig config,
  MermaidTextMeasurer textMeasurer,
) {
  final textSize = textMeasurer.measure(
    node.label,
    MermaidTextStyle(
      fontSize: config.fontSize,
      lineHeight: config.lineHeight,
    ),
  );

  final width = math.max(
    config.minNodeWidth,
    textSize.width + config.nodeHorizontalPadding * 2,
  );
  final height = math.max(
    config.minNodeHeight,
    textSize.height + config.nodeVerticalPadding * 2,
  );
  return Size(width, height);
}
