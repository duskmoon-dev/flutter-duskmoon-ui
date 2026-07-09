import 'package:flutter/material.dart';

class ScenePath {
  const ScenePath({
    required this.path,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.5,
  });

  final Path path;
  final Color? fillColor;
  final Color? strokeColor;
  final double strokeWidth;
}
