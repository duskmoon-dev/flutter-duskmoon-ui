import 'package:flutter/material.dart';

/// Toggles between Send and Stop based on [isStreaming].
class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.isStreaming,
    required this.onSend,
    required this.onStop,
    required this.enabled,
  });

  final bool isStreaming;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isStreaming) {
      return IconButton.filled(
        tooltip: 'Stop',
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
          disabledBackgroundColor: colorScheme.surfaceContainerHighest,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
        ),
        onPressed: onStop,
        icon: const Icon(Icons.stop),
      );
    }
    return IconButton.filled(
      tooltip: 'Send',
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
      ),
      onPressed: enabled ? onSend : null,
      icon: const Icon(Icons.arrow_upward),
    );
  }
}
