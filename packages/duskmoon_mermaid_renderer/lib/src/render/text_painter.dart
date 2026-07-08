import 'package:flutter/material.dart';

import '../config/layout_config.dart';
import '../scene/scene_label.dart';

class MermaidTextPainter {
  const MermaidTextPainter({
    required this.config,
    required this.textDirection,
    required this.textScaler,
  });

  final MermaidLayoutConfig config;
  final TextDirection textDirection;
  final TextScaler textScaler;

  void paint(Canvas canvas, SceneLabel label) {
    final backgroundColor = label.backgroundColor;
    if (backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(label.bounds, const Radius.circular(4)),
        backgroundPaint,
      );
    }

    final painter = TextPainter(
      text: TextSpan(
        text: label.text,
        style: TextStyle(
          color: label.textColor,
          fontSize: config.fontSize,
          height: config.lineHeight,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: null,
    )..layout(maxWidth: label.bounds.width);

    painter.paint(
      canvas,
      Offset(
        label.bounds.left + (label.bounds.width - painter.width) / 2,
        label.bounds.top + (label.bounds.height - painter.height) / 2,
      ),
    );
  }
}
