import 'dart:async';
import 'dart:typed_data';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmChatAttachment', () {
    test('defaults status to idle', () {
      const a = DmChatAttachment(id: 'a1', name: 'f.png');
      expect(a.status, DmChatAttachmentStatus.idle);
      expect(a.uploadProgress, isNull);
    });

    test('copyWith overrides selected fields', () {
      const a = DmChatAttachment(id: 'a1', name: 'f.png');
      final b = a.copyWith(
        status: DmChatAttachmentStatus.uploading,
        uploadProgress: 0.5,
      );
      expect(b.status, DmChatAttachmentStatus.uploading);
      expect(b.uploadProgress, 0.5);
      expect(b.name, 'f.png');
    });

    test('equality compares by value including bytes', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final a = DmChatAttachment(id: 'a1', name: 'f.png', bytes: bytes);
      final b = DmChatAttachment(id: 'a1', name: 'f.png', bytes: bytes);
      expect(a, equals(b));
    });
  });

  group('DmChatUploadAdapter', () {
    test('adapter interface is implementable', () async {
      final adapter = _FakeAdapter();
      const local = DmChatAttachment(id: 'a1', name: 'f.png');
      final progress = <double>[];
      await for (final update in adapter.upload(local)) {
        if (update.uploadProgress != null) progress.add(update.uploadProgress!);
        if (update.status == DmChatAttachmentStatus.done) break;
      }
      expect(progress, [0.5, 1.0]);
    });
  });
}

class _FakeAdapter implements DmChatUploadAdapter {
  @override
  Stream<DmChatAttachment> upload(DmChatAttachment local) async* {
    yield local.copyWith(
      status: DmChatAttachmentStatus.uploading,
      uploadProgress: 0.5,
    );
    yield local.copyWith(
      status: DmChatAttachmentStatus.done,
      uploadProgress: 1.0,
      url: Uri.parse('https://example.com/${local.name}'),
    );
  }

  @override
  Future<void> cancel(String attachmentId) async {}
}
