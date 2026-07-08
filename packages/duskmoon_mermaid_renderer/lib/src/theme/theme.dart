import 'package:flutter/material.dart';

@immutable
class MermaidTheme {
  const MermaidTheme({
    required this.background,
    required this.nodeFill,
    required this.nodeStroke,
    required this.edgeStroke,
    required this.textColor,
    required this.labelBackground,
    required this.errorFill,
    required this.errorStroke,
  });

  static const modern = light;

  static const light = MermaidTheme(
    background: Color(0x00FFFFFF),
    nodeFill: Color(0xFFFFFFFF),
    nodeStroke: Color(0xFF64748B),
    edgeStroke: Color(0xFF475569),
    textColor: Color(0xFF0F172A),
    labelBackground: Color(0xFFF8FAFC),
    errorFill: Color(0xFFFFF1F2),
    errorStroke: Color(0xFFE11D48),
  );

  static const dark = MermaidTheme(
    background: Color(0x00111111),
    nodeFill: Color(0xFF1F2937),
    nodeStroke: Color(0xFF94A3B8),
    edgeStroke: Color(0xFFCBD5E1),
    textColor: Color(0xFFF8FAFC),
    labelBackground: Color(0xFF111827),
    errorFill: Color(0xFF4C0519),
    errorStroke: Color(0xFFFB7185),
  );

  final Color background;
  final Color nodeFill;
  final Color nodeStroke;
  final Color edgeStroke;
  final Color textColor;
  final Color labelBackground;
  final Color errorFill;
  final Color errorStroke;

  @override
  bool operator ==(Object other) {
    return other is MermaidTheme &&
        other.background == background &&
        other.nodeFill == nodeFill &&
        other.nodeStroke == nodeStroke &&
        other.edgeStroke == edgeStroke &&
        other.textColor == textColor &&
        other.labelBackground == labelBackground &&
        other.errorFill == errorFill &&
        other.errorStroke == errorStroke;
  }

  @override
  int get hashCode => Object.hash(
        background,
        nodeFill,
        nodeStroke,
        edgeStroke,
        textColor,
        labelBackground,
        errorFill,
        errorStroke,
      );
}
