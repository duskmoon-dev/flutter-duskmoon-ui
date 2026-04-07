import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';

/// Derives an [EditorTheme] from the ambient DuskMoon theme.
///
/// Falls back to [EditorTheme.light] or [EditorTheme.dark] (based on
/// brightness) when [DmColorExtension] is not present in the theme tree.
abstract final class DmCodeEditorTheme {
  /// Builds an [EditorTheme] from [Theme.of(context)] and [DmColorExtension].
  static EditorTheme fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<DmColorExtension>();

    if (ext == null) {
      return theme.brightness == Brightness.dark
          ? EditorTheme.dark()
          : EditorTheme.light();
    }

    final isDark = theme.brightness == Brightness.dark;

    return EditorTheme(
      background: cs.surface,
      foreground: cs.onSurface,
      gutterBackground: ext.base200,
      gutterForeground: ext.baseContent.withValues(alpha: 0.5),
      gutterActiveForeground: ext.baseContent,
      selectionBackground: cs.primary.withValues(alpha: 0.2),
      cursorColor: cs.primary,
      lineHighlight: ext.base200.withValues(alpha: 0.5),
      highlightStyle: isDark ? defaultDarkHighlight : defaultLightHighlight,
      searchMatchBackground: ext.warning.withValues(alpha: 0.3),
      searchActiveMatchBackground: ext.warning.withValues(alpha: 0.6),
      matchingBracketBackground: ext.accent.withValues(alpha: 0.2),
      matchingBracketOutline: ext.accent,
      scrollbarThumb: cs.onSurface.withValues(alpha: 0.3),
      scrollbarTrack: Colors.transparent,
    );
  }
}
