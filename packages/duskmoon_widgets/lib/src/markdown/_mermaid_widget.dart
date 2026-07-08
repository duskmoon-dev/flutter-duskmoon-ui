import 'package:flutter/material.dart';
import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';

import '_code_block_widget.dart';

/// Renders Mermaid source as a diagram when enabled, otherwise as code.
class MermaidWidget extends StatelessWidget {
  /// Creates a mermaid widget.
  const MermaidWidget({
    super.key,
    required this.source,
    this.enabled = false,
    this.options = const MermaidRenderOptions(),
  });

  /// The Mermaid diagram source code.
  final String source;

  /// Whether Mermaid rendering is enabled. When `false`, renders as a
  /// syntax-highlighted code block instead.
  final bool enabled;

  /// Render options passed to the native Mermaid renderer.
  final MermaidRenderOptions options;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return CodeBlockWidget(code: source, language: 'mermaid');
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: DmMermaidView(
        source: source,
        options: options,
      ),
    );
  }
}
