import 'package:flutter/material.dart';

import '_code_block_widget.dart';

/// Placeholder Mermaid widget (Option C — disabled by default).
///
/// Renders mermaid source as a syntax-highlighted code block.
/// The internal structure is ready for future replacement with a native
/// Dart renderer (Option A) or WebView (Option B).
class MermaidWidget extends StatelessWidget {
  /// Creates a mermaid widget.
  const MermaidWidget({
    super.key,
    required this.source,
    this.enabled = false,
  });

  /// The Mermaid diagram source code.
  final String source;

  /// Whether Mermaid rendering is enabled. When `false`, renders as a
  /// syntax-highlighted code block instead.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      // Option C: render as plain code block with mermaid syntax label.
      return CodeBlockWidget(code: source, language: 'mermaid');
    }

    // Future: Option A (native) or Option B (WebView) would go here.
    // For now, fall back to the same code block rendering.
    return CodeBlockWidget(code: source, language: 'mermaid');
  }
}
