import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/dm_chat_attachment.dart';

/// Opens the platform file picker and forwards selected files as attachments.
class AttachButton extends StatelessWidget {
  const AttachButton({super.key, required this.onPicked});

  final ValueChanged<List<DmChatAttachment>> onPicked;

  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );
    if (result == null) return;
    final attachments = <DmChatAttachment>[];
    for (final f in result.files) {
      attachments.add(
        DmChatAttachment(
          id: f.identifier ??
              '${f.name}:${DateTime.now().microsecondsSinceEpoch}',
          name: f.name,
          sizeBytes: f.size,
          mimeType: _mimeFromExtension(f.extension),
          bytes: f.bytes == null ? null : Uint8List.fromList(f.bytes!),
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
        onPressed: _pick,
        icon: const Icon(Icons.attach_file),
      );
}
