import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/dm_chat_attachment.dart';

/// Opens the platform file picker and forwards selected files as attachments.
class AttachButton extends StatelessWidget {
  const AttachButton({
    super.key,
    required this.onPicked,
    this.enabled = true,
  });

  final ValueChanged<List<DmChatAttachment>> onPicked;
  final bool enabled;

  Future<void> _pick() async {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty) return;
    final attachments = <DmChatAttachment>[];
    for (final f in files) {
      final size = await f.length();
      final bytes = await f.readAsBytes();
      attachments.add(
        DmChatAttachment(
          id: f.path ?? '${f.name}:${DateTime.now().microsecondsSinceEpoch}',
          name: f.name,
          sizeBytes: size,
          mimeType: _mimeFromExtension(f.extension),
          bytes: bytes,
          status: DmChatAttachmentStatus.idle,
        ),
      );
    }
    onPicked(attachments);
  }

  String? _mimeFromExtension(String? ext) {
    if (ext == null) return null;
    return switch (ext.toLowerCase()) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'pdf' => 'application/pdf',
      'txt' => 'text/plain',
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: 'Attach',
        onPressed: enabled ? _pick : null,
        icon: const Icon(Icons.attach_file),
      );
}
