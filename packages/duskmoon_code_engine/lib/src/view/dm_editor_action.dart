import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../commands/commands.dart';
import '../commands/clipboard.dart';
import 'editor_view_controller.dart';

/// An action button displayed in [DmCodeEditorToolbar].
///
/// Use the built-in factories ([DmEditorAction.undo], [DmEditorAction.redo],
/// [DmEditorAction.search], [DmEditorAction.copy]) for common operations, or
/// create custom actions with any [icon], [tooltip], and [onPressed] callback.
class DmEditorAction {
  const DmEditorAction({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  /// The icon to display.
  final IconData icon;

  /// Tooltip shown on hover.
  final String tooltip;

  /// Callback when pressed. `null` renders the button in a disabled state.
  final VoidCallback? onPressed;

  /// Undo the last edit.
  factory DmEditorAction.undo(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.undo,
      tooltip: 'Undo',
      onPressed: () {
        final spec = EditorCommands.undo(controller.state);
        if (spec != null) controller.dispatch(spec);
      },
    );
  }

  /// Redo the last undone edit.
  factory DmEditorAction.redo(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.redo,
      tooltip: 'Redo',
      onPressed: () {
        final spec = EditorCommands.redo(controller.state);
        if (spec != null) controller.dispatch(spec);
      },
    );
  }

  /// Toggle the search panel.
  factory DmEditorAction.search(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.search,
      tooltip: 'Search',
      onPressed: () {
        // Search toggle is handled by DmCodeEditor via onSearchToggle callback.
        // This factory provides the icon/tooltip; DmCodeEditor overrides onPressed.
      },
    );
  }

  /// Copy the current selection to the clipboard.
  factory DmEditorAction.copy(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.copy,
      tooltip: 'Copy',
      onPressed: () {
        final text = ClipboardCommands.getSelectedText(controller.state);
        if (text.isNotEmpty) {
          Clipboard.setData(ClipboardData(text: text));
        }
      },
    );
  }
}
