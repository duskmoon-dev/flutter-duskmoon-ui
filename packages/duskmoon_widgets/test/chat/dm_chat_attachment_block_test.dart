import 'dart:typed_data';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatAttachmentBlockView', () {
    testWidgets('renders file chip with name and size', (tester) async {
      await pumpThemed(
        tester,
        const DmChatAttachmentBlockView(
          block: DmChatAttachmentBlock(
            attachments: [
              DmChatAttachment(id: 'a1', name: 'report.pdf', sizeBytes: 2048),
            ],
          ),
        ),
      );
      expect(find.text('report.pdf'), findsOneWidget);
      expect(find.textContaining('2.0 KB'), findsOneWidget);
    });

    testWidgets('renders image thumbnail when bytes provided and mime is image',
        (tester) async {
      final bytes = Uint8List.fromList([
        // Minimal valid PNG (1x1 transparent)
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
        0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
        0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41,
        0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00,
        0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
        0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
        0x42, 0x60, 0x82,
      ]);
      await pumpThemed(
        tester,
        DmChatAttachmentBlockView(
          block: DmChatAttachmentBlock(
            attachments: [
              DmChatAttachment(
                id: 'a1',
                name: 'photo.png',
                mimeType: 'image/png',
                bytes: bytes,
              ),
            ],
          ),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows linear progress while uploading', (tester) async {
      await pumpThemed(
        tester,
        const DmChatAttachmentBlockView(
          block: DmChatAttachmentBlock(
            attachments: [
              DmChatAttachment(
                id: 'a1',
                name: 'big.zip',
                status: DmChatAttachmentStatus.uploading,
                uploadProgress: 0.4,
              ),
            ],
          ),
        ),
      );
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, 0.4);
    });

    testWidgets('error state shows retry button calling onRetry', (tester) async {
      var retries = 0;
      await pumpThemed(
        tester,
        DmChatAttachmentBlockView(
          block: const DmChatAttachmentBlock(
            attachments: [
              DmChatAttachment(
                id: 'a1',
                name: 'fail.bin',
                status: DmChatAttachmentStatus.error,
                errorMessage: 'upload failed',
              ),
            ],
          ),
          onRetry: (a) => retries++,
        ),
      );
      expect(find.text('upload failed'), findsOneWidget);
      await tester.tap(find.byTooltip('Retry'));
      expect(retries, 1);
    });
  });
}
