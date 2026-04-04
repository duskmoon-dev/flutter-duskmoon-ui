import 'package:flutter/material.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';

abstract final class DmEditorTheme {
  /// Build an EditorTheme from a Flutter ThemeData.
  static EditorTheme fromTheme(ThemeData themeData) {
    final cs = themeData.colorScheme;
    final dmExt = themeData.extension<DmColorExtension>();
    final isDark = themeData.brightness == Brightness.dark;

    return EditorTheme(
      background: cs.surface,
      foreground: cs.onSurface,
      gutterBackground: cs.surfaceContainerLow,
      gutterForeground: cs.onSurfaceVariant,
      gutterActiveForeground: cs.onSurface,
      selectionBackground: cs.primaryContainer,
      cursorColor: cs.primary,
      lineHighlight: cs.surfaceContainerHighest.withValues(alpha: 0.5),
      searchMatchBackground: cs.tertiaryContainer,
      searchActiveMatchBackground: cs.secondaryContainer,
      matchingBracketBackground:
          (dmExt?.success ?? cs.primary).withValues(alpha: 0.2),
      matchingBracketOutline: dmExt?.success ?? cs.primary,
      scrollbarThumb: cs.onSurface.withValues(alpha: 0.2),
      scrollbarTrack: cs.onSurface.withValues(alpha: 0.04),
      highlightStyle: _buildHighlightStyle(cs, dmExt, isDark),
    );
  }

  /// Sunshine theme EditorTheme.
  static EditorTheme sunshine() => fromTheme(DmThemeData.sunshine());

  /// Moonlight theme EditorTheme.
  static EditorTheme moonlight() => fromTheme(DmThemeData.moonlight());

  static HighlightStyle _buildHighlightStyle(
    ColorScheme cs,
    DmColorExtension? dmExt,
    bool isDark,
  ) {
    return HighlightStyle([
      TagStyle(Tag.keyword,
          TextStyle(color: cs.primary, fontWeight: FontWeight.bold)),
      TagStyle(Tag.string, TextStyle(color: cs.tertiary)),
      TagStyle(Tag.comment,
          TextStyle(color: cs.onSurfaceVariant, fontStyle: FontStyle.italic)),
      TagStyle(Tag.number, TextStyle(color: cs.secondary)),
      TagStyle(Tag.typeName, TextStyle(color: dmExt?.info ?? cs.primary)),
      TagStyle(Tag.function_, TextStyle(color: cs.onSurface)),
      TagStyle(Tag.variableName, TextStyle(color: cs.onSurface)),
      TagStyle(Tag.operator_, TextStyle(color: cs.onSurfaceVariant)),
      TagStyle(Tag.punctuation, TextStyle(color: cs.onSurface)),
      TagStyle(Tag.bool_, TextStyle(color: cs.primary)),
      TagStyle(Tag.null_, TextStyle(color: cs.primary)),
      TagStyle(Tag.meta, TextStyle(color: cs.onSurfaceVariant)),
      TagStyle(
          Tag.annotation_, TextStyle(color: dmExt?.accent ?? cs.secondary)),
      TagStyle(Tag.invalid,
          TextStyle(color: cs.error, decoration: TextDecoration.lineThrough)),
    ]);
  }
}
