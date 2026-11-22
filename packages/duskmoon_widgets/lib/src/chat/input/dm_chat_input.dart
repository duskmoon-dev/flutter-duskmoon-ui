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
    this.focusNode,
    this.isStreaming = false,
    this.pendingAttachments = const [],
    this.onRemoveAttachment,
    this.onPaste,
    this.onCancel,
    this.header,
    this.placeholder,
    this.leading,
    this.trailing,
    this.idleActionIcon,
    this.idleActionTooltip,
    this.onIdleAction,
    this.minLines = 1,
    this.maxLines = 8,
    this.submitShortcut = DmChatSubmitShortcut.cmdEnter,
  });

  final DmChatSendCallback onSend;
  final VoidCallback? onStop;
  final ValueChanged<List<DmChatAttachment>>? onAttach;
  final DmChatUploadAdapter? uploadAdapter;
  final DmMarkdownInputController? controller;
  final FocusNode? focusNode;
  final bool isStreaming;
  final List<DmChatAttachment> pendingAttachments;
  final ValueChanged<DmChatAttachment>? onRemoveAttachment;

  /// Optional async handler for paste shortcuts (Cmd+V / Ctrl+V).
  /// Return `true` if clipboard media/files were consumed; return `false` to
  /// fall back to standard plain-text paste into the composer.
  final Future<bool> Function()? onPaste;

  /// Optional handler invoked when Escape is pressed inside the composer.
  final VoidCallback? onCancel;

  /// Optional banner rendered at the top of the composer card (e.g. an
  /// editing-message indicator).
  final Widget? header;
  final String? placeholder;
  final Widget? leading;
  final Widget? trailing;
  final IconData? idleActionIcon;
  final String? idleActionTooltip;
  final VoidCallback? onIdleAction;
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

  List<DmChatAttachment> get _readyAttachments => widget.pendingAttachments
      .where((a) => a.status == DmChatAttachmentStatus.done)
      .toList();

  bool get _canSend =>
      !widget.isStreaming &&
      !_anyUploading &&
      (_controller.text.trim().isNotEmpty || _readyAttachments.isNotEmpty);

  void _submit() {
    if (!_canSend) return;
    final text = _controller.text;
    widget.onSend(text, _readyAttachments);
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

  bool _isPasteShortcut(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (event.logicalKey != LogicalKeyboardKey.keyV) return false;
    final isApple = defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.iOS;
    final primaryModifier = isApple
        ? HardwareKeyboard.instance.isMetaPressed &&
            !HardwareKeyboard.instance.isControlPressed
        : HardwareKeyboard.instance.isControlPressed &&
            !HardwareKeyboard.instance.isMetaPressed;
    return primaryModifier && !HardwareKeyboard.instance.isAltPressed;
  }

  Future<void> _handlePasteShortcut() async {
    final handler = widget.onPaste;
    if (handler != null) {
      final handled = await handler();
      if (handled || !mounted) return;
    }
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final pasted = data?.text;
    if (pasted == null || pasted.isEmpty || !mounted) return;
    final value = _controller.value;
    final text = value.text;
    final selection = value.selection;
    final start =
        selection.isValid ? selection.start.clamp(0, text.length) : text.length;
    final end =
        selection.isValid ? selection.end.clamp(0, text.length) : text.length;
    final nextText = text.replaceRange(start, end, pasted);
    _controller.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: start + pasted.length),
    );
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (widget.onCancel != null &&
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onCancel!();
      return KeyEventResult.handled;
    }
    if (_isSubmitShortcut(event)) {
      _submit();
      return KeyEventResult.handled;
    }
    if (widget.onPaste != null && _isPasteShortcut(event)) {
      _handlePasteShortcut();
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
        final colorScheme = Theme.of(context).colorScheme;
        final borderColor = theme.inputBorderColor ??
            colorScheme.outlineVariant.withValues(alpha: 0.45);

        return Padding(
          padding: theme.inputPadding,
          child: Material(
            color: theme.inputSurface,
            elevation: theme.inputElevation,
            shadowColor: colorScheme.shadow.withValues(alpha: 0.14),
            shape: RoundedRectangleBorder(
              borderRadius: theme.inputRadius,
              side: BorderSide(color: borderColor, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.header != null) widget.header!,
                if (widget.pendingAttachments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                    child: DmChatAttachmentBlockView(
                      block: DmChatAttachmentBlock(
                        attachments: widget.pendingAttachments,
                      ),
                      onCancel: widget.onRemoveAttachment,
                      onRetry: widget.onRemoveAttachment,
                      onRemove: widget.onRemoveAttachment,
                    ),
                  ),
                Focus(
                  onKeyEvent: _onKey,
                  child: DmMarkdownInput(
                    controller: _controller,
                    focusNode: widget.focusNode,
                    showPreview: false,
                    borderless: true,
                    minLines: widget.minLines,
                    maxLines: widget.maxLines,
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                      hintStyle:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.52),
                                fontWeight: FontWeight.w400,
                              ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 38),
                    child: Row(
                      children: [
                        if (widget.leading != null) widget.leading!,
                        if (widget.onAttach != null)
                          AttachButton(
                            onPicked: widget.onAttach!,
                            enabled: !widget.isStreaming,
                          ),
                        const Spacer(),
                        if (widget.trailing != null)
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: widget.trailing!,
                            ),
                          ),
                        const SizedBox(width: 8),
                        SendButton(
                          isStreaming: widget.isStreaming,
                          onSend: _submit,
                          onStop: widget.onStop ?? () {},
                          enabled: _canSend,
                          idleIcon: widget.idleActionIcon,
                          idleTooltip: widget.idleActionTooltip,
                          onIdlePressed: widget.onIdleAction,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
