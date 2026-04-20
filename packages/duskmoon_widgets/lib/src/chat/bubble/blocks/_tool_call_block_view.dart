import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../markdown/dm_markdown.dart';
import '../../../markdown/dm_markdown_config.dart';
import '../../models/dm_chat_block.dart';
import '../../theme/dm_chat_theme.dart';

/// Compact status chip for a tool call. Tap expands to show input/output.
class DmChatToolCallBlockView extends StatefulWidget {
  const DmChatToolCallBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
  });

  final DmChatToolCallBlock block;
  final DmMarkdownConfig config;

  @override
  State<DmChatToolCallBlockView> createState() =>
      _DmChatToolCallBlockViewState();
}

class _DmChatToolCallBlockViewState extends State<DmChatToolCallBlockView> {
  bool _expanded = false;

  Color _chipColor(DmChatTheme t) => switch (widget.block.status) {
        DmChatToolCallStatus.pending => t.toolCallChipColor,
        DmChatToolCallStatus.running => t.toolCallChipRunningColor,
        DmChatToolCallStatus.done => t.toolCallChipDoneColor,
        DmChatToolCallStatus.error => t.toolCallChipErrorColor,
      };

  IconData _icon() => switch (widget.block.status) {
        DmChatToolCallStatus.pending => Icons.schedule,
        DmChatToolCallStatus.running => Icons.autorenew,
        DmChatToolCallStatus.done => Icons.check_circle,
        DmChatToolCallStatus.error => Icons.error,
      };

  String _encode(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } on Object {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    final chipColor = _chipColor(theme);
    final outputText = _encode(widget.block.output);
    final inputText = _encode(widget.block.input);
    final error = widget.block.errorMessage;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: chipColor.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
        color: chipColor.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_icon(), size: 16, color: chipColor),
                  const SizedBox(width: 6),
                  Text(widget.block.name, style: theme.toolCallLabelStyle),
                  const SizedBox(width: 6),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: chipColor,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (inputText.isNotEmpty) ...[
                    Text('Input', style: theme.toolCallLabelStyle),
                    const SizedBox(height: 4),
                    DmMarkdown(
                      data: '```json\n$inputText\n```',
                      config: widget.config,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                  if (outputText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Output', style: theme.toolCallLabelStyle),
                    const SizedBox(height: 4),
                    DmMarkdown(
                      data: outputText,
                      config: widget.config,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      error,
                      style: theme.toolCallLabelStyle
                          .copyWith(color: theme.toolCallChipErrorColor),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
