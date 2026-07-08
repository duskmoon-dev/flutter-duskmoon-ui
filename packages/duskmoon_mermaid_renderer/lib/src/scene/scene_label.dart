import 'package:flutter/material.dart';

class SceneLabel {
  const SceneLabel({
    required this.text,
    required this.bounds,
    required this.textColor,
    this.backgroundColor,
  });

  final String text;
  final Rect bounds;
  final Color textColor;
  final Color? backgroundColor;
}
