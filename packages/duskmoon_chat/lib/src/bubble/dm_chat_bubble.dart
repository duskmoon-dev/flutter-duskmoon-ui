import 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmMarkdownConfig;
import 'package:flutter/material.dart';

import '../models/dm_chat_message.dart';
import 'blocks/dm_chat_text_block_view.dart';
import 'blocks/dm_chat_thinking_block_view.dart';
import 'blocks/dm_chat_tool_call_block_view.dart';

class DmChatBubble extends StatelessWidget {
  const DmChatBubble({
    super.key,
    required this.message,
    this.markdownConfig = const DmMarkdownConfig(),
    this.avatar,
  });

  static const userBubbleKey = ValueKey<String>('dm-chat-user-bubble');

  final DmChatMessage message;
  final DmMarkdownConfig markdownConfig;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == DmChatRole.user;
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final foregroundColor = colorScheme.onPrimaryContainer;
    final userTextTheme = _textThemeWithColor(theme.textTheme, foregroundColor);
    final userTheme = theme.copyWith(
      colorScheme: colorScheme.copyWith(
        onSurface: foregroundColor,
        onSurfaceVariant: foregroundColor,
        primary: foregroundColor,
        tertiary: foregroundColor,
      ),
      textTheme: userTextTheme,
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: message.blocks.map((block) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildBlock(
            block,
            themeData: isUser ? userTheme : null,
            markdownPadding: isUser ? EdgeInsets.zero : null,
          ),
        );
      }).toList(),
    );

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth * 0.8;
            final preferredWidth = _preferredUserBubbleWidth(
              context,
              maxWidth: maxWidth,
            );

            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SizedBox(
                width: preferredWidth,
                child: Container(
                  key: userBubbleKey,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: const Radius.circular(4),
                    ),
                  ),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(color: foregroundColor),
                    child: Theme(
                      data: userTheme,
                      child: content,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatar != null) ...[
          avatar!,
          const SizedBox(width: 12),
        ],
        Expanded(child: content),
      ],
    );
  }

  Widget _buildBlock(
    DmChatBlock block, {
    ThemeData? themeData,
    EdgeInsets? markdownPadding,
  }) {
    return switch (block) {
      DmChatTextBlock b => DmChatTextBlockView(
          block: b,
          config: markdownConfig,
          themeData: themeData,
          markdownPadding: markdownPadding,
        ),
      DmChatThinkingBlock b => DmChatThinkingBlockView(
          block: b,
          config: markdownConfig,
          themeData: themeData,
          markdownPadding: markdownPadding,
        ),
      DmChatToolCallBlock b => DmChatToolCallBlockView(
          block: b,
          config: markdownConfig,
          themeData: themeData,
          markdownPadding: markdownPadding,
        ),
      DmChatAttachmentBlock b => _DmChatUnsupportedBlockPlaceholder(
          label: 'Attachments are not supported yet',
          detail: '${b.attachments.length} attachment(s)',
        ),
      DmChatCustomBlock b => _DmChatUnsupportedBlockPlaceholder(
          label: 'Custom block is not supported yet',
          detail: b.kind,
        ),
    };
  }

  double? _preferredUserBubbleWidth(
    BuildContext context, {
    required double maxWidth,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final textDirection = Directionality.of(context);
    final contentWidth = message.blocks
        .map((block) => _preferredBlockWidth(
              block,
              textTheme: textTheme,
              textDirection: textDirection,
            ))
        .whereType<double>()
        .fold<double>(0, (max, width) => width > max ? width : max);

    if (contentWidth == 0) {
      return null;
    }

    final preferredWidth = contentWidth + 32;
    if (maxWidth < 48) {
      return preferredWidth < maxWidth ? preferredWidth : maxWidth;
    }

    return preferredWidth.clamp(48, maxWidth).toDouble();
  }
}

double? _preferredBlockWidth(
  DmChatBlock block, {
  required TextTheme textTheme,
  required TextDirection textDirection,
}) {
  final style = textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
  final text = switch (block) {
    DmChatTextBlock(text: final text?) => text,
    DmChatThinkingBlock(text: final text?) => text,
    DmChatToolCallBlock(toolName: final toolName) => toolName,
    DmChatAttachmentBlock(attachments: final attachments) =>
      'Attachments are not supported yet: ${attachments.length} attachment(s)',
    DmChatCustomBlock(kind: final kind) => 'Custom block is not supported yet: '
        '$kind',
    DmChatTextBlock(stream: _) || DmChatThinkingBlock(stream: _) => null,
  };

  if (text == null) {
    return null;
  }

  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: textDirection,
    maxLines: 1,
  )..layout();

  return textPainter.width;
}

TextTheme _textThemeWithColor(TextTheme textTheme, Color color) {
  return textTheme.copyWith(
    displayLarge: textTheme.displayLarge?.copyWith(color: color),
    displayMedium: textTheme.displayMedium?.copyWith(color: color),
    displaySmall: textTheme.displaySmall?.copyWith(color: color),
    headlineLarge: textTheme.headlineLarge?.copyWith(color: color),
    headlineMedium: textTheme.headlineMedium?.copyWith(color: color),
    headlineSmall: textTheme.headlineSmall?.copyWith(color: color),
    titleLarge: textTheme.titleLarge?.copyWith(color: color),
    titleMedium: textTheme.titleMedium?.copyWith(color: color),
    titleSmall: textTheme.titleSmall?.copyWith(color: color),
    bodyLarge: textTheme.bodyLarge?.copyWith(color: color),
    bodyMedium: textTheme.bodyMedium?.copyWith(color: color),
    bodySmall: textTheme.bodySmall?.copyWith(color: color),
    labelLarge: textTheme.labelLarge?.copyWith(color: color),
    labelMedium: textTheme.labelMedium?.copyWith(color: color),
    labelSmall: textTheme.labelSmall?.copyWith(color: color),
  );
}

class _DmChatUnsupportedBlockPlaceholder extends StatelessWidget {
  const _DmChatUnsupportedBlockPlaceholder({
    required this.label,
    required this.detail,
  });

  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: label,
      value: detail,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Text(
          '$label: $detail',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
