import 'package:flutter/foundation.dart';

import '../theme/theme.dart';
import 'layout_config.dart';

@immutable
class MermaidRenderOptions {
  const MermaidRenderOptions({
    this.layoutConfig = const MermaidLayoutConfig(),
    this.theme = MermaidTheme.modern,
  });

  final MermaidLayoutConfig layoutConfig;
  final MermaidTheme theme;

  @override
  bool operator ==(Object other) {
    return other is MermaidRenderOptions &&
        other.layoutConfig == layoutConfig &&
        other.theme == theme;
  }

  @override
  int get hashCode => Object.hash(layoutConfig, theme);
}
