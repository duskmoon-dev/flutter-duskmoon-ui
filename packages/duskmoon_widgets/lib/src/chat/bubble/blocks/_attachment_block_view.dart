import 'package:flutter/material.dart';

import '../../models/dm_chat_attachment.dart';
import '../../models/dm_chat_block.dart';
import '../../theme/dm_chat_theme.dart';

/// Renders a [DmChatAttachmentBlock] — image thumbnails for image MIME types,
/// file chips otherwise, with upload progress and retry affordances.
class DmChatAttachmentBlockView extends StatelessWidget {
  const DmChatAttachmentBlockView({
    super.key,
    required this.block,
    this.onTap,
    this.onRetry,
    this.onCancel,
  });

  final DmChatAttachmentBlock block;
  final ValueChanged<DmChatAttachment>? onTap;
  final ValueChanged<DmChatAttachment>? onRetry;
  final ValueChanged<DmChatAttachment>? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final a in block.attachments)
          _AttachmentTile(
            attachment: a,
            theme: theme,
            onTap: onTap,
            onRetry: onRetry,
            onCancel: onCancel,
          ),
      ],
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.attachment,
    required this.theme,
    this.onTap,
    this.onRetry,
    this.onCancel,
  });

  final DmChatAttachment attachment;
  final DmChatTheme theme;
  final ValueChanged<DmChatAttachment>? onTap;
  final ValueChanged<DmChatAttachment>? onRetry;
  final ValueChanged<DmChatAttachment>? onCancel;

  bool get _isImage =>
      attachment.mimeType != null && attachment.mimeType!.startsWith('image/');

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final content = _isImage && attachment.bytes != null
        ? _imageThumb()
        : _fileChip(context);

    return InkWell(
      onTap: onTap == null ? null : () => onTap!(attachment),
      borderRadius: BorderRadius.circular(8),
      child: content,
    );
  }

  Widget _imageThumb() {
    final size = theme.attachmentImageThumbSize;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            attachment.bytes!,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
        if (attachment.status == DmChatAttachmentStatus.uploading)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              value: attachment.uploadProgress ?? 0,
              minHeight: 3,
            ),
          ),
        if (attachment.status == DmChatAttachmentStatus.error)
          Positioned.fill(
            child: _errorOverlay(),
          ),
      ],
    );
  }

  Widget _fileChip(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.attachmentChipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.insert_drive_file, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (attachment.status == DmChatAttachmentStatus.error)
                IconButton(
                  tooltip: 'Retry',
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh),
                  onPressed:
                      onRetry == null ? null : () => onRetry!(attachment),
                ),
              if (attachment.status == DmChatAttachmentStatus.uploading)
                IconButton(
                  tooltip: 'Cancel',
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close),
                  onPressed:
                      onCancel == null ? null : () => onCancel!(attachment),
                ),
            ],
          ),
          if (attachment.sizeBytes != null)
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(
                _formatSize(attachment.sizeBytes!),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          if (attachment.status == DmChatAttachmentStatus.uploading)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: LinearProgressIndicator(
                value: attachment.uploadProgress ?? 0,
                minHeight: 3,
              ),
            ),
          if (attachment.status == DmChatAttachmentStatus.error &&
              attachment.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 4),
              child: Text(
                attachment.errorMessage!,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  Widget _errorOverlay() => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: IconButton(
            tooltip: 'Retry',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: onRetry == null ? null : () => onRetry!(attachment),
          ),
        ),
      );
}
