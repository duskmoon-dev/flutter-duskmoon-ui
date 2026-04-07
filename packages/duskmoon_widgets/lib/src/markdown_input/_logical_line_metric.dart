import 'package:flutter/foundation.dart';

@immutable
class LogicalLineMetric {
  const LogicalLineMetric({
    required this.top,
    required this.baseline,
    required this.height,
  });

  final double top;
  final double baseline;
  final double height;
}
