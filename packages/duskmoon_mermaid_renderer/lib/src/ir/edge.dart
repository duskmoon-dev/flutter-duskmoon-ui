import 'style.dart';

class Edge {
  const Edge({
    required this.from,
    required this.to,
    this.label,
    this.style = EdgeStyle.solid,
    this.arrowStart = false,
    this.arrowEnd = true,
  });

  final String from;
  final String to;
  final String? label;
  final EdgeStyle style;
  final bool arrowStart;
  final bool arrowEnd;
}
