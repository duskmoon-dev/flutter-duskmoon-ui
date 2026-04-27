import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';

import '../../models/dm_chat_message.dart';

class DmChatTextBlockView extends StatelessWidget {
  const DmChatTextBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
    this.themeData,
    this.markdownPadding,
  });

  final DmChatTextBlock block;
  final DmMarkdownConfig config;
  final ThemeData? themeData;
  final EdgeInsets? markdownPadding;

  @override
  Widget build(BuildContext context) {
    if (block.text != null) {
      return DmMarkdown(
        data: block.text,
        config: config,
        themeData: themeData,
        padding: markdownPadding,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      );
    }

    return DmMarkdown(
      stream: block.stream,
      config: config,
      themeData: themeData,
      padding: markdownPadding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
