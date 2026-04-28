import 'package:flutter/material.dart';

import '../../../markdown/dm_markdown.dart';
import '../../../markdown/dm_markdown_config.dart';
import '../../models/dm_chat_block.dart';

/// Renders a [DmChatTextBlock] via [DmMarkdown], picking stream vs data mode.
class TextBlockView extends StatelessWidget {
  const TextBlockView({
    super.key,
    required this.block,
    required this.config,
  });

  final DmChatTextBlock block;
  final DmMarkdownConfig config;

  @override
  Widget build(BuildContext context) {
    if (block.stream != null) {
      return DmMarkdown(
        stream: block.stream,
        config: config,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
      );
    }
    return DmMarkdown(
      data: block.text ?? '',
      config: config,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
    );
  }
}
