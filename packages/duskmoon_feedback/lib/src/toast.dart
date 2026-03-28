import 'package:flutter/material.dart';

/// Shows a success toast with a checkmark icon, title, and message.
///
/// The [title] defaults to `'Success'` and can be overridden for localization.
void showDmSuccessToast({
  required BuildContext context,
  required String message,
  String title = 'Success',
  Duration duration = const Duration(seconds: 5),
  bool showCloseIcon = false,
  String? actionLabel,
  VoidCallback? onActionPressed,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final fontSize = theme.textTheme.titleMedium?.fontSize ?? 14;

  final snackBar = SnackBar(
    backgroundColor: colorScheme.primary,
    content: SingleChildScrollView(
      child: Row(
        children: [
          Icon(Icons.check, size: fontSize * 2, color: colorScheme.onPrimary),
          SizedBox(width: fontSize),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    duration: duration,
    showCloseIcon: showCloseIcon,
    action: actionLabel != null && onActionPressed != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed,
            textColor: colorScheme.onPrimaryContainer,
            backgroundColor: colorScheme.primaryContainer,
          )
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

/// Shows an error toast with an error icon and selectable message text.
///
/// Error toasts persist until manually dismissed (close icon is always shown).
/// The [title] defaults to `'Error'` and can be overridden for localization.
void showDmErrorToast({
  required BuildContext context,
  required String message,
  String title = 'Error',
  String? actionLabel,
  VoidCallback? onActionPressed,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final fontSize = theme.textTheme.titleMedium?.fontSize ?? 14;

  final snackBar = SnackBar(
    backgroundColor: colorScheme.error,
    content: SingleChildScrollView(
      child: Row(
        children: [
          Icon(Icons.error, size: fontSize * 2, color: colorScheme.onError),
          SizedBox(width: fontSize),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onError,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onError,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    duration: const Duration(days: 365),
    showCloseIcon: true,
    closeIconColor: colorScheme.onError,
    action: actionLabel != null && onActionPressed != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed,
            textColor: colorScheme.onErrorContainer,
            backgroundColor: colorScheme.errorContainer,
          )
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
