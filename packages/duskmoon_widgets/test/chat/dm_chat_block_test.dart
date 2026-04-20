import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmChatTextBlock', () {
    test('accepts static text', () {
      const b = DmChatTextBlock(text: 'hello');
      expect(b.text, 'hello');
      expect(b.stream, isNull);
    });

    test('accepts stream', () {
      final s = Stream<String>.value('hi');
      final b = DmChatTextBlock(stream: s);
      expect(b.text, isNull);
      expect(b.stream, same(s));
    });

    test('asserts exactly one of text/stream is non-null', () {
      expect(() => DmChatTextBlock(), throwsAssertionError);
      expect(
        () => DmChatTextBlock(text: 'x', stream: Stream.value('y')),
        throwsAssertionError,
      );
    });
  });

  group('DmChatThinkingBlock', () {
    test('stores elapsed when complete', () {
      const b = DmChatThinkingBlock(
        text: 'reasoning',
        elapsed: Duration(seconds: 3),
      );
      expect(b.elapsed, const Duration(seconds: 3));
    });

    test('asserts exactly one of text/stream', () {
      expect(() => DmChatThinkingBlock(), throwsAssertionError);
    });
  });

  group('DmChatToolCallBlock', () {
    test('has default status pending', () {
      const b = DmChatToolCallBlock(id: 't1', name: 'search');
      expect(b.status, DmChatToolCallStatus.pending);
      expect(b.input, isNull);
      expect(b.output, isNull);
    });
  });

  group('DmChatAttachmentBlock', () {
    test('wraps a list of attachments', () {
      const att = DmChatAttachment(id: 'a1', name: 'x.png');
      const b = DmChatAttachmentBlock(attachments: [att]);
      expect(b.attachments, hasLength(1));
    });
  });

  group('DmChatCustomBlock', () {
    test('stores kind and data', () {
      const b = DmChatCustomBlock(kind: 'citation', data: {'n': 1});
      expect(b.kind, 'citation');
      expect(b.data, {'n': 1});
    });
  });

  test('sealed switch is exhaustive', () {
    String describe(DmChatBlock b) => switch (b) {
          DmChatTextBlock() => 'text',
          DmChatThinkingBlock() => 'thinking',
          DmChatToolCallBlock() => 'tool',
          DmChatAttachmentBlock() => 'attachment',
          DmChatCustomBlock() => 'custom',
        };
    expect(describe(const DmChatTextBlock(text: 'a')), 'text');
  });
}
