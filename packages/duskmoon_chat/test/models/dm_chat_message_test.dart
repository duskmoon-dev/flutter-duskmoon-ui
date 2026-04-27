import 'dart:typed_data';

import 'package:duskmoon_chat/src/models/dm_chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DmChatMessage instantiates correctly', () {
    final msg = DmChatMessage(
      id: 'msg-1',
      role: DmChatRole.user,
      blocks: [DmChatTextBlock(text: 'Hello')],
      status: DmChatMessageStatus.done,
    );

    expect(msg.id, 'msg-1');
    expect(msg.role, DmChatRole.user);
    expect(msg.blocks.length, 1);
    expect(msg.status, DmChatMessageStatus.done);
    expect((msg.blocks.first as DmChatTextBlock).text, 'Hello');
  });

  test('text and thinking blocks validate content source at runtime', () {
    expect(() => DmChatTextBlock(), throwsArgumentError);
    expect(
      () => DmChatTextBlock(text: 'Hello', stream: Stream.value('Hello')),
      throwsArgumentError,
    );
    expect(() => DmChatThinkingBlock(), throwsArgumentError);
    expect(
      () => DmChatThinkingBlock(
        text: 'Thinking',
        stream: Stream.value('Thinking'),
      ),
      throwsArgumentError,
    );
  });

  test('collection getters cannot mutate model state directly', () {
    final bytes = Uint8List.fromList([1, 2, 3]);
    final attachment =
        DmChatAttachment(id: 'file-1', name: 'file.txt', bytes: bytes);
    final attachments = DmChatAttachmentBlock(attachments: [attachment]);
    final toolCall = DmChatToolCallBlock(
      toolName: 'search',
      input: {'query': 'duskmoon'},
    );
    final msg = DmChatMessage(
      id: 'msg-2',
      role: DmChatRole.assistant,
      blocks: [attachments, toolCall],
    );

    expect(
      () => msg.blocks.add(DmChatTextBlock(text: 'mutated')),
      throwsUnsupportedError,
    );
    expect(
      () => attachments.attachments.add(
        DmChatAttachment(id: 'file-2', name: 'other.txt'),
      ),
      throwsUnsupportedError,
    );
    expect(() => toolCall.input['extra'] = true, throwsUnsupportedError);
    expect(() => attachment.bytes![0] = 9, throwsUnsupportedError);
  });

  test('caller-owned mutable inputs cannot mutate model state', () {
    final blocks = <DmChatBlock>[DmChatTextBlock(text: 'Hello')];
    final msg = DmChatMessage(
      id: 'msg-3',
      role: DmChatRole.user,
      blocks: blocks,
    );

    blocks.add(DmChatTextBlock(text: 'mutated'));

    expect(msg.blocks.length, 1);
    expect((msg.blocks.single as DmChatTextBlock).text, 'Hello');

    final input = <String, Object?>{'query': 'duskmoon'};
    final toolCall = DmChatToolCallBlock(toolName: 'search', input: input);

    input['query'] = 'mutated';
    input['extra'] = true;

    expect(toolCall.input, {'query': 'duskmoon'});

    final bytes = Uint8List.fromList([1, 2, 3]);
    final attachment =
        DmChatAttachment(id: 'file-1', name: 'file.txt', bytes: bytes);

    bytes[0] = 9;

    expect(attachment.bytes, [1, 2, 3]);

    final attachmentList = <DmChatAttachment>[attachment];
    final attachmentBlock = DmChatAttachmentBlock(attachments: attachmentList);

    attachmentList.add(DmChatAttachment(id: 'file-2', name: 'other.txt'));

    expect(attachmentBlock.attachments.length, 1);
    expect(attachmentBlock.attachments.single.id, 'file-1');
  });

  test('nested tool input values are deeply immutable', () {
    final nestedList = <Object?>[
      'alpha',
      <String, Object?>{'count': 1},
    ];
    final nestedMap = <String, Object?>{
      'tags': nestedList,
      'bytes': Uint8List.fromList([1, 2, 3]),
    };
    final input = <String, Object?>{
      'nested': nestedMap,
      'set': <Object?>{'a', 'b'},
    };
    final toolCall = DmChatToolCallBlock(toolName: 'search', input: input);

    nestedList.add('mutated');
    (nestedList[1]! as Map<String, Object?>)['count'] = 2;
    (nestedMap['bytes']! as Uint8List)[0] = 9;
    nestedMap['extra'] = true;

    final frozenNested = toolCall.input['nested']! as Map<Object?, Object?>;
    final frozenTags = frozenNested['tags']! as List<Object?>;
    final frozenTagMap = frozenTags[1]! as Map<Object?, Object?>;
    final frozenBytes = frozenNested['bytes']! as Uint8List;
    final frozenSet = toolCall.input['set']! as Set<Object?>;

    expect(frozenTags.length, 2);
    expect(frozenTagMap['count'], 1);
    expect(frozenBytes, [1, 2, 3]);
    expect(frozenNested.containsKey('extra'), isFalse);
    expect(frozenSet, {'a', 'b'});

    expect(() => frozenTags.add('blocked'), throwsUnsupportedError);
    expect(() => frozenTagMap['count'] = 3, throwsUnsupportedError);
    expect(() => frozenBytes[0] = 4, throwsUnsupportedError);
    expect(() => frozenSet.add('c'), throwsUnsupportedError);
  });

  test('supported custom block data is deeply immutable', () {
    final customBytes = Uint8List.fromList([4, 5, 6]);
    final customData = <String, Object?>{
      'items': <Object?>[
        <String, Object?>{'name': 'first'},
      ],
      'bytes': customBytes,
    };
    final block = DmChatCustomBlock(kind: 'metadata', data: customData);

    ((customData['items']! as List<Object?>).single!
        as Map<String, Object?>)['name'] = 'mutated';
    customBytes[0] = 9;

    final frozenData = block.data! as Map<Object?, Object?>;
    final frozenItems = frozenData['items']! as List<Object?>;
    final frozenItem = frozenItems.single! as Map<Object?, Object?>;
    final frozenBytes = frozenData['bytes']! as Uint8List;

    expect(frozenItem['name'], 'first');
    expect(frozenBytes, [4, 5, 6]);
    expect(() => frozenItems.add('blocked'), throwsUnsupportedError);
    expect(() => frozenItem['name'] = 'blocked', throwsUnsupportedError);
    expect(() => frozenBytes[0] = 7, throwsUnsupportedError);
  });

  test('structured error values are deeply immutable', () {
    final messageErrorBytes = Uint8List.fromList([1, 2, 3]);
    final messageError = <String, Object?>{
      'details': <Object?>[
        <String, Object?>{'code': 'message'},
      ],
      'bytes': messageErrorBytes,
    };
    final msg = DmChatMessage(
      id: 'msg-4',
      role: DmChatRole.assistant,
      blocks: [DmChatTextBlock(text: 'Failed')],
      status: DmChatMessageStatus.error,
      error: messageError,
    );

    ((messageError['details']! as List<Object?>).single!
        as Map<String, Object?>)['code'] = 'mutated';
    messageErrorBytes[0] = 9;

    final frozenMessageError = msg.error! as Map<Object?, Object?>;
    final frozenMessageDetails =
        frozenMessageError['details']! as List<Object?>;
    final frozenMessageDetail =
        frozenMessageDetails.single! as Map<Object?, Object?>;
    final frozenMessageBytes = frozenMessageError['bytes']! as Uint8List;

    expect(frozenMessageDetail['code'], 'message');
    expect(frozenMessageBytes, [1, 2, 3]);
    expect(
      () => frozenMessageDetail['code'] = 'blocked',
      throwsUnsupportedError,
    );
    expect(() => frozenMessageBytes[0] = 4, throwsUnsupportedError);

    final toolError = <String, Object?>{
      'items': <Object?>['tool'],
    };
    final toolCall = DmChatToolCallBlock(
      toolName: 'search',
      input: const {},
      status: DmChatToolCallStatus.error,
      error: toolError,
    );

    (toolError['items']! as List<Object?>).add('mutated');

    final frozenToolError = toolCall.error! as Map<Object?, Object?>;
    final frozenToolItems = frozenToolError['items']! as List<Object?>;

    expect(frozenToolItems, ['tool']);
    expect(() => frozenToolItems.add('blocked'), throwsUnsupportedError);

    final uploadError = <String, Object?>{
      'bytes': Uint8List.fromList([4, 5, 6]),
    };
    final attachment = DmChatAttachment(
      id: 'file-3',
      name: 'file.txt',
      uploadStatus: DmChatUploadStatus.error,
      uploadError: uploadError,
    );

    (uploadError['bytes']! as Uint8List)[0] = 9;

    final frozenUploadError = attachment.uploadError! as Map<Object?, Object?>;
    final frozenUploadBytes = frozenUploadError['bytes']! as Uint8List;

    expect(frozenUploadBytes, [4, 5, 6]);
    expect(() => frozenUploadBytes[0] = 7, throwsUnsupportedError);
  });
}
