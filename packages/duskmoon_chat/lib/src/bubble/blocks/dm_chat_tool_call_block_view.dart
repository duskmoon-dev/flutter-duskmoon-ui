import 'dart:convert';
import 'dart:typed_data';

import 'package:duskmoon_widgets/duskmoon_widgets.dart'
    show DmCard, DmChip, DmMarkdown, DmMarkdownConfig;
import 'package:flutter/material.dart';

import '../../models/dm_chat_message.dart';

class DmChatToolCallBlockView extends StatefulWidget {
  const DmChatToolCallBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
    this.themeData,
    this.markdownPadding,
  });

  static const headerKey = ValueKey<String>('dm-chat-tool-call-block-header');

  final DmChatToolCallBlock block;
  final DmMarkdownConfig config;
  final ThemeData? themeData;
  final EdgeInsets? markdownPadding;

  @override
  State<DmChatToolCallBlockView> createState() =>
      _DmChatToolCallBlockViewState();
}

class _DmChatToolCallBlockViewState extends State<DmChatToolCallBlockView> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          key: DmChatToolCallBlockView.headerKey,
          button: true,
          expanded: _expanded,
          label: '${widget.block.toolName} tool call',
          value: _statusText,
          onTap: _toggleExpanded,
          child: ExcludeSemantics(
            child: DmChip(
              label: Text(widget.block.toolName),
              avatar: Icon(_statusIcon, size: 16),
              selected: _expanded,
              onSelected: (_) => _toggleExpanded(),
            ),
          ),
        ),
        if (_expanded)
          DmCard(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Input', style: textTheme.titleSmall),
                const SizedBox(height: 8),
                DmMarkdown(
                  data: '```json\n$_formattedInput\n```',
                  config: widget.config,
                  themeData: widget.themeData,
                  padding: widget.markdownPadding,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                if (widget.block.output != null) ...[
                  const SizedBox(height: 16),
                  Text('Output', style: textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DmMarkdown(
                    data: widget.block.output,
                    config: widget.config,
                    themeData: widget.themeData,
                    padding: widget.markdownPadding,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
                if (widget.block.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _safeToString(widget.block.error),
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  IconData get _statusIcon {
    return switch (widget.block.status) {
      DmChatToolCallStatus.done => Icons.check,
      DmChatToolCallStatus.error => Icons.error_outline,
      DmChatToolCallStatus.running => Icons.build_circle_outlined,
    };
  }

  String get _statusText {
    return switch (widget.block.status) {
      DmChatToolCallStatus.done => 'done',
      DmChatToolCallStatus.error => 'error',
      DmChatToolCallStatus.running => 'running',
    };
  }

  String get _formattedInput {
    final normalized = _normalizeJsonLike(widget.block.input);

    try {
      return const JsonEncoder.withIndent('  ').convert(normalized);
    } on Object {
      return _safeToString(widget.block.input);
    }
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }
}

Object? _normalizeJsonLike(Object? value) {
  return switch (value) {
    null || String() || bool() => value,
    double(isFinite: false) => value.toString(),
    num() => value,
    DateTime() => value.toIso8601String(),
    Duration() => value.toString(),
    Uri() => value.toString(),
    Enum() => value.name,
    Uint8List() => value.toList(growable: false),
    Map() => _normalizeMap(value),
    Set() => value.map(_normalizeJsonLike).toList(growable: false),
    Iterable() => value.map(_normalizeJsonLike).toList(growable: false),
    _ => _safeToString(value),
  };
}

Map<String, Object?> _normalizeMap(Map<dynamic, dynamic> value) {
  return value.map(
    (key, value) => MapEntry(
      key is String ? key : _safeToString(key),
      _normalizeJsonLike(value),
    ),
  );
}

String _safeToString(Object? value) {
  try {
    return value.toString();
  } on Object {
    return '<unprintable ${value.runtimeType}>';
  }
}
