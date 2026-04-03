import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dm_markdown_input_controller.dart';

/// Wraps the editor with keyboard shortcut bindings.
///
/// Maps common markdown editing shortcuts to controller methods.
class KeyboardShortcutHandler extends StatelessWidget {
  /// Creates a keyboard shortcut handler.
  const KeyboardShortcutHandler({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.child,
    this.enabled = true,
  });

  /// The markdown input controller.
  final DmMarkdownInputController controller;

  /// The focus node for the editor.
  final FocusNode focusNode;

  /// The child widget (the editor).
  final Widget child;

  /// Whether shortcuts are enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final isMacOS = Theme.of(context).platform == TargetPlatform.macOS;

    return Shortcuts(
      shortcuts: {
        // Cmd/Ctrl + B → Bold
        SingleActivator(LogicalKeyboardKey.keyB,
            meta: isMacOS, control: !isMacOS): const _WrapIntent('**'),
        // Cmd/Ctrl + I → Italic
        SingleActivator(LogicalKeyboardKey.keyI,
            meta: isMacOS, control: !isMacOS): const _WrapIntent('*'),
        // Cmd/Ctrl + E → Inline code
        SingleActivator(LogicalKeyboardKey.keyE,
            meta: isMacOS, control: !isMacOS): const _WrapIntent('`'),
        // Cmd/Ctrl + K → Link
        SingleActivator(LogicalKeyboardKey.keyK,
            meta: isMacOS, control: !isMacOS): const _LinkIntent(),
        // Cmd/Ctrl + Shift + K → Code fence
        SingleActivator(
          LogicalKeyboardKey.keyK,
          meta: isMacOS,
          control: !isMacOS,
          shift: true,
        ): const _CodeFenceIntent(),
        // Cmd/Ctrl + Shift + M → Math
        SingleActivator(
          LogicalKeyboardKey.keyM,
          meta: isMacOS,
          control: !isMacOS,
          shift: true,
        ): const _WrapIntent(r'$'),
      },
      child: Actions(
        actions: {
          _WrapIntent: CallbackAction<_WrapIntent>(
            onInvoke: (intent) {
              controller.wrapSelection(intent.marker);
              return null;
            },
          ),
          _LinkIntent: CallbackAction<_LinkIntent>(
            onInvoke: (_) {
              controller.insertLink();
              return null;
            },
          ),
          _CodeFenceIntent: CallbackAction<_CodeFenceIntent>(
            onInvoke: (_) {
              controller.insertCodeFence();
              return null;
            },
          ),
        },
        child: child,
      ),
    );
  }
}

/// Intent to wrap the selection with a marker.
class _WrapIntent extends Intent {
  const _WrapIntent(this.marker);
  final String marker;
}

/// Intent to insert a link.
class _LinkIntent extends Intent {
  const _LinkIntent();
}

/// Intent to insert a code fence.
class _CodeFenceIntent extends Intent {
  const _CodeFenceIntent();
}
