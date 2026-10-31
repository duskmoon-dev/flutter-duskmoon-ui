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
    this.isEnabled,
  });

  /// The icon to display.
  final IconData icon;

  /// Tooltip shown on hover.
  final String tooltip;

  /// Callback when pressed. `null` renders the button in a disabled state.
  final VoidCallback? onPressed;

  /// Optional predicate evaluated dynamically by [DmCodeEditorToolbar].
  final bool Function()? isEnabled;

  /// Undo the last edit.
  factory DmEditorAction.undo(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.undo,
      tooltip: 'Undo',
      isEnabled: () => !controller.view.readOnly && controller.canUndo,
      onPressed: () {
        if (controller.view.readOnly) return;
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
      isEnabled: () => !controller.view.readOnly && controller.canRedo,
      onPressed: () {
        if (controller.view.readOnly) return;
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
        controller.view.toggleSearch();
      },
    );
  }

  /// Copy the current selection to the clipboard.
  factory DmEditorAction.copy(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.copy,
      tooltip: 'Copy',
      isEnabled: () => !controller.selection.main.isEmpty,
      onPressed: () {
        final text = ClipboardCommands.getSelectedText(controller.state);
        if (text.isNotEmpty) {
          Clipboard.setData(ClipboardData(text: text));
        }
      },
    );
  }

  /// Cut the current selection to the clipboard.
  factory DmEditorAction.cut(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.cut,
      tooltip: 'Cut',
      isEnabled: () =>
          !controller.view.readOnly && !controller.selection.main.isEmpty,
      onPressed: () {
        ClipboardCommands.cutCommand()(controller.view);
      },
    );
  }

  /// Paste text from the clipboard.
  factory DmEditorAction.paste(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.paste,
      tooltip: 'Paste',
      isEnabled: () => !controller.view.readOnly,
      onPressed: () {
        ClipboardCommands.pasteCommand()(controller.view);
      },
    );
  }
}
