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
    if (isStreaming) {
      return IconButton(
        tooltip: 'Stop',
        onPressed: onStop,
        icon: const Icon(Icons.stop),
      );
    }
    return IconButton(
      tooltip: 'Send',
      onPressed: enabled ? onSend : null,
      icon: const Icon(Icons.send),
    );
  }
}
