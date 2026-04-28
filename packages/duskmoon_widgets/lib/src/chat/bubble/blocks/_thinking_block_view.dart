import 'dart:async';

import 'package:flutter/material.dart';

import '../../../markdown/dm_markdown.dart';
import '../../../markdown/dm_markdown_config.dart';
import '../../models/dm_chat_block.dart';
import '../../theme/dm_chat_theme.dart';
import '../_bubble_stream_coordinator.dart';

/// Collapsible thinking block. Auto-expands while streaming; auto-collapses
/// when the sibling text block starts emitting; user taps override auto.
class DmChatThinkingBlockView extends StatefulWidget {
  const DmChatThinkingBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
  });

  final DmChatThinkingBlock block;
  final DmMarkdownConfig config;

  @override
  State<DmChatThinkingBlockView> createState() =>
      _DmChatThinkingBlockViewState();
}

class _DmChatThinkingBlockViewState extends State<DmChatThinkingBlockView> {
  bool _expanded = true;
  bool _userToggled = false;
  StreamSubscription<String>? _sub;
  final StringBuffer _buffer = StringBuffer();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  bool get _isStreaming => widget.block.stream != null;

  @override
  void initState() {
    super.initState();
    if (_isStreaming) {
      _stopwatch.start();
      _sub = widget.block.stream!.listen((chunk) {
        if (!mounted) return;
        setState(() => _buffer.write(chunk));
      });
      _ticker = Timer.periodic(const Duration(milliseconds: 500), (_) {
        if (mounted) setState(() {});
      });
      _expanded = true;
    } else {
      _expanded = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final coord = BubbleStreamScope.maybeOf(context);
    if (coord != null && coord.textStarted && !_userToggled && _expanded) {
      _stopwatch.stop();
      _ticker?.cancel();
      setState(() => _expanded = false);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _ticker?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      _userToggled = true;
      _expanded = !_expanded;
    });
  }

  Duration get _elapsedDuration {
    if (widget.block.elapsed != null) return widget.block.elapsed!;
    return _stopwatch.elapsed;
  }

  String get _body => widget.block.stream != null
      ? _buffer.toString()
      : (widget.block.text ?? '');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    final seconds = _elapsedDuration.inSeconds;
    final summary = seconds <= 0
        ? 'Thinking…'
        : (widget.block.elapsed != null
            ? 'Thought for ${seconds}s'
            : 'Thinking… ${seconds}s');

    return AnimatedContainer(
      duration: theme.thinkingCollapseAnimation,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: theme.thinkingSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 18,
                    color: theme.thinkingForeground,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    summary,
                    style: theme.thinkingTextStyle
                        .copyWith(color: theme.thinkingForeground),
                  ),
                ],
              ),
              if (_expanded && _body.isNotEmpty) ...[
                const SizedBox(height: 8),
                DefaultTextStyle.merge(
                  style: theme.thinkingTextStyle
                      .copyWith(color: theme.thinkingForeground),
                  child: DmMarkdown(
                    data: _body,
                    config: widget.config,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
