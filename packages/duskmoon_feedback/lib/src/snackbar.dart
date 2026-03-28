import 'package:flutter/material.dart';

/// Shows a snackbar with the given [message] widget.
void showDmSnackbar({
  required BuildContext context,
  required Widget message,
  Duration duration = const Duration(seconds: 5),
  bool showCloseIcon = false,
  String? actionLabel,
  VoidCallback? onActionPressed,
}) {
  final snackBar = SnackBar(
    content: message,
    duration: duration,
    showCloseIcon: showCloseIcon,
    action: actionLabel != null && onActionPressed != null
        ? SnackBarAction(label: actionLabel, onPressed: onActionPressed)
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

/// Shows a snackbar with an undo action button.
///
/// The [undoLabel] defaults to `'Undo'` and can be overridden for
/// localization without requiring an `app_locale` dependency.
void showDmUndoSnackbar({
  required BuildContext context,
  required VoidCallback onUndoPressed,
  required Widget message,
  String undoLabel = 'Undo',
  Duration duration = const Duration(seconds: 5),
  bool showCloseIcon = true,
}) {
  final snackBar = SnackBar(
    duration: duration,
    showCloseIcon: showCloseIcon,
    content: message,
    action: SnackBarAction(label: undoLabel, onPressed: onUndoPressed),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
