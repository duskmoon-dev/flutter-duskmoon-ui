import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';

import '../../models/dm_chat_message.dart';

class DmChatTextBlockView extends StatelessWidget {
  const DmChatTextBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
  });

  final DmChatTextBlock block;
  final DmMarkdownConfig config;

  @override
  Widget build(BuildContext context) {
    if (block.text != null) {
      return DmMarkdown(
        data: block.text,
        config: config,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      );
    }

    return DmMarkdown(
      stream: block.stream,
      config: config,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
