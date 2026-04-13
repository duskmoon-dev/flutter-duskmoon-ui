import 'package:flutter/material.dart';

import '../../duskmoon_code_engine.dart';

/// Default top bar for [DmCodeEditor].
///
/// Renders a [title] on the left and action [IconButton]s on the right.
/// Colors are derived from the [EditorTheme] on [controller], falling back
/// to [Theme.of(context)] colors.
class DmCodeEditorToolbar extends StatelessWidget {
  const DmCodeEditorToolbar({
    super.key,
    this.title,
    this.actions = const [],
    required this.controller,
    this.decoration,
  });

  /// Title text shown on the left side of the toolbar.
  final String? title;

  /// Action buttons shown on the right side of the toolbar.
  final List<DmEditorAction> actions;

  /// The editor controller, used to derive theme colors.
  final EditorViewController controller;

  /// Optional custom decoration. When null, uses [EditorTheme] gutter colors.
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = controller.theme;
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = theme?.gutterBackground ?? colorScheme.surfaceContainerLow;
    final fgColor = theme?.gutterForeground ?? colorScheme.onSurfaceVariant;
    final titleColor = theme?.foreground ?? colorScheme.onSurface;
    final borderColor = theme != null
        ? Color.lerp(theme.gutterBackground, theme.foreground, 0.15)!
        : colorScheme.outlineVariant;

    final effectiveDecoration = decoration ??
        BoxDecoration(
          color: bgColor,
          border: Border(bottom: BorderSide(color: borderColor)),
        );

    return DecoratedBox(
      decoration: effectiveDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            if (title != null)
              Expanded(
                child: Text(
                  title!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: titleColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              const Spacer(),
            for (final action in actions)
              IconButton(
                icon: Icon(action.icon, size: 18),
                tooltip: action.tooltip,
                onPressed: action.onPressed,
                color: fgColor,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
                splashRadius: 16,
              ),
          ],
        ),
      ),
    );
  }
}
