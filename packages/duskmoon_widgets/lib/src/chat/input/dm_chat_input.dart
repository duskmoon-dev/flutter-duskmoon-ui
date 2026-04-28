import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../markdown_input/dm_markdown_input.dart';
import '../../markdown_input/dm_markdown_input_controller.dart';
import '../bubble/blocks/_attachment_block_view.dart';
import '../models/dm_chat_attachment.dart';
import '../models/dm_chat_block.dart';
import '../theme/dm_chat_theme.dart';
import '_attach_button.dart';
import '_send_button.dart';
import 'dm_chat_submit_shortcut.dart';

/// Signature of the send callback — current markdown text and the set of
/// completed pending attachments.
typedef DmChatSendCallback = void Function(
  String markdown,
  List<DmChatAttachment> attachments,
);

/// Chat composer — wraps [DmMarkdownInput] with Send/Stop/Attach controls.
class DmChatInput extends StatefulWidget {
  const DmChatInput({
    super.key,
    required this.onSend,
    this.onStop,
    this.onAttach,
    this.uploadAdapter,
    this.controller,
    this.isStreaming = false,
    this.pendingAttachments = const [],
    this.onRemoveAttachment,
    this.placeholder,
    this.leading,
    this.trailing,
    this.minLines = 1,
    this.maxLines = 8,
    this.submitShortcut = DmChatSubmitShortcut.cmdEnter,
  });

  final DmChatSendCallback onSend;
  final VoidCallback? onStop;
  final ValueChanged<List<DmChatAttachment>>? onAttach;
  final DmChatUploadAdapter? uploadAdapter;
  final DmMarkdownInputController? controller;
  final bool isStreaming;
  final List<DmChatAttachment> pendingAttachments;
  final ValueChanged<DmChatAttachment>? onRemoveAttachment;
  final String? placeholder;
  final Widget? leading;
  final Widget? trailing;
  final int minLines;
  final int maxLines;
  final DmChatSubmitShortcut submitShortcut;

  @override
  State<DmChatInput> createState() => _DmChatInputState();
}

class _DmChatInputState extends State<DmChatInput> {
  late DmMarkdownInputController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = DmMarkdownInputController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  bool get _anyUploading => widget.pendingAttachments
      .any((a) => a.status == DmChatAttachmentStatus.uploading);

  bool get _canSend =>
      !widget.isStreaming && !_anyUploading && _controller.text.isNotEmpty;

  void _submit() {
    if (!_canSend) return;
    final text = _controller.text;
    final ready = widget.pendingAttachments
        .where((a) => a.status == DmChatAttachmentStatus.done)
        .toList();
    widget.onSend(text, ready);
    _controller.clear();
  }

  bool _isSubmitShortcut(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    switch (widget.submitShortcut) {
      case DmChatSubmitShortcut.enter:
        if (key != LogicalKeyboardKey.enter) return false;
        if (HardwareKeyboard.instance.isShiftPressed) return false;
        return true;
      case DmChatSubmitShortcut.cmdEnter:
        if (key != LogicalKeyboardKey.enter) return false;
        final isMac = defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.iOS;
        final modifier = isMac
            ? HardwareKeyboard.instance.isMetaPressed
            : HardwareKeyboard.instance.isControlPressed;
        return modifier;
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (_isSubmitShortcut(event)) {
      _submit();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          padding: theme.inputPadding,
          decoration: BoxDecoration(
            color: theme.inputSurface,
            borderRadius: theme.inputRadius,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.pendingAttachments.isNotEmpty) ...[
                DmChatAttachmentBlockView(
                  block: DmChatAttachmentBlock(
                    attachments: widget.pendingAttachments,
                  ),
                  onCancel: widget.onRemoveAttachment,
                  onRetry: widget.onRemoveAttachment,
                ),
                const SizedBox(height: 8),
              ],
              Focus(
                onKeyEvent: _onKey,
                child: DmMarkdownInput(
                  controller: _controller,
                  showPreview: false,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  if (widget.leading != null) widget.leading!,
                  if (widget.onAttach != null)
                    AttachButton(onPicked: widget.onAttach!),
                  const Spacer(),
                  if (widget.trailing != null) widget.trailing!,
                  SendButton(
                    isStreaming: widget.isStreaming,
                    onSend: _submit,
                    onStop: widget.onStop ?? () {},
                    enabled: !widget.isStreaming && !_anyUploading,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
