import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import '../markdown/dm_markdown.dart';
import '../markdown/dm_markdown_config.dart';

/// The rendered preview pane.
///
/// Thin wrapper around [DmMarkdown] rendering pre-parsed AST nodes.
class PreviewPane extends StatelessWidget {
  /// Creates a preview pane.
  const PreviewPane({
    super.key,
    required this.nodes,
    this.config = const DmMarkdownConfig(),
    this.onLinkTap,
  });

  /// The pre-parsed AST nodes to render.
  final List<md.Node> nodes;

  /// Rendering configuration.
  final DmMarkdownConfig config;

  /// Link tap callback.
  final void Function(String url, String? title)? onLinkTap;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return Center(
        child: Text(
          'Nothing to preview',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return DmMarkdown(
      nodes: nodes,
      config: config,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onLinkTap: onLinkTap,
    );
  }
}
