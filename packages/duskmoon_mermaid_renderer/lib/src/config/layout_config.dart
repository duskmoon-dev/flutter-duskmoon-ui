import 'package:flutter/foundation.dart';

@immutable
class MermaidLayoutConfig {
  const MermaidLayoutConfig({
    this.nodeSpacing = 50,
    this.rankSpacing = 80,
    this.padding = 16,
    this.fontSize = 16,
    this.lineHeight = 1.25,
    this.nodeHorizontalPadding = 18,
    this.nodeVerticalPadding = 12,
    this.minNodeWidth = 64,
    this.minNodeHeight = 44,
    this.preferredAspectRatio,
  });

  final double nodeSpacing;
  final double rankSpacing;
  final double padding;
  final double fontSize;
  final double lineHeight;
  final double nodeHorizontalPadding;
  final double nodeVerticalPadding;
  final double minNodeWidth;
  final double minNodeHeight;
  final double? preferredAspectRatio;

  @override
  bool operator ==(Object other) {
    return other is MermaidLayoutConfig &&
        other.nodeSpacing == nodeSpacing &&
        other.rankSpacing == rankSpacing &&
        other.padding == padding &&
        other.fontSize == fontSize &&
        other.lineHeight == lineHeight &&
        other.nodeHorizontalPadding == nodeHorizontalPadding &&
        other.nodeVerticalPadding == nodeVerticalPadding &&
        other.minNodeWidth == minNodeWidth &&
        other.minNodeHeight == minNodeHeight &&
        other.preferredAspectRatio == preferredAspectRatio;
  }

  @override
  int get hashCode => Object.hash(
        nodeSpacing,
        rankSpacing,
        padding,
        fontSize,
        lineHeight,
        nodeHorizontalPadding,
        nodeVerticalPadding,
        minNodeWidth,
        minNodeHeight,
        preferredAspectRatio,
      );
}
