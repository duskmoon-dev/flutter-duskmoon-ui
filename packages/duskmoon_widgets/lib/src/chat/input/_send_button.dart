import 'package:flutter/material.dart';

/// Toggles between Send, Stop, and optional idle action based on [isStreaming]
/// and [enabled].
class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.isStreaming,
    required this.onSend,
    required this.onStop,
    required this.enabled,
    this.idleIcon,
    this.idleTooltip,
    this.onIdlePressed,
  });

  final bool isStreaming;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final bool enabled;
  final IconData? idleIcon;
  final String? idleTooltip;
  final VoidCallback? onIdlePressed;

  static const _buttonSize = Size(36, 36);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isStreaming) {
      return IconButton.filled(
        tooltip: 'Stop',
        style: IconButton.styleFrom(
          minimumSize: _buttonSize,
          fixedSize: _buttonSize,
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
          disabledBackgroundColor: colorScheme.surfaceContainerHighest,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
        ),
        onPressed: onStop,
        icon: const Icon(Icons.stop, size: 18),
      );
    }
    if (!enabled && onIdlePressed != null && idleIcon != null) {
      return IconButton.filled(
        tooltip: idleTooltip,
        style: IconButton.styleFrom(
          minimumSize: _buttonSize,
          fixedSize: _buttonSize,
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        onPressed: onIdlePressed,
        icon: Icon(idleIcon, size: 19),
      );
    }
    return IconButton.filled(
      tooltip: 'Send',
      style: IconButton.styleFrom(
        minimumSize: _buttonSize,
        fixedSize: _buttonSize,
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.1),
        disabledForegroundColor:
            colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
      ),
      onPressed: enabled ? onSend : null,
      icon: const Icon(Icons.arrow_upward, size: 19),
    );
  }
}
