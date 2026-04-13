import 'package:flutter/material.dart';

import '../../duskmoon_code_engine.dart';

/// Default bottom bar for [DmCodeEditor].
///
/// Displays cursor position (Ln/Col), language name, total line count,
/// and selection character count. Reactively updates via [ListenableBuilder]
/// listening to [EditorView].
class DmCodeEditorStatusBar extends StatelessWidget {
  const DmCodeEditorStatusBar({
    super.key,
    required this.controller,
    this.languageName,
    this.decoration,
  });

  /// The editor controller, used to read state and listen for changes.
  final EditorViewController controller;

  /// Optional language name displayed in the status bar.
  final String? languageName;

  /// Optional custom decoration. When null, uses [EditorTheme] gutter colors.
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = controller.theme;
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = theme?.gutterBackground ?? colorScheme.surfaceContainerLow;
    final fgColor = theme?.gutterForeground ?? colorScheme.onSurfaceVariant;
    final borderColor = theme != null
        ? Color.lerp(theme.gutterBackground, theme.foreground, 0.15)!
        : colorScheme.outlineVariant;

    final effectiveDecoration = decoration ??
        BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: borderColor)),
        );

    return ListenableBuilder(
      listenable: controller.view,
      builder: (context, _) {
        final state = controller.state;
        final doc = state.doc;
        final selection = state.selection.main;

        final line = doc.lineAtOffset(selection.head);
        final col = selection.head - line.from + 1;
        final lineCount = doc.lineCount;
        final selectionLength =
            selection.isEmpty ? 0 : (selection.to - selection.from);

        final textStyle = TextStyle(fontSize: 11, color: fgColor);

        return DecoratedBox(
          decoration: effectiveDecoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Text('Ln ${line.number}, Col $col', style: textStyle),
                if (languageName != null) ...[
                  const SizedBox(width: 16),
                  Text(languageName!, style: textStyle),
                ],
                const Spacer(),
                Text('$lineCount lines', style: textStyle),
                if (selectionLength > 0) ...[
                  const SizedBox(width: 16),
                  Text('$selectionLength selected', style: textStyle),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
