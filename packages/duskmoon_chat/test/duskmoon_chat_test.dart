import 'package:duskmoon_chat/duskmoon_chat.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exports chat message models from the package library', () {
    final msg = DmChatMessage(
      id: 'msg-1',
      role: DmChatRole.user,
      blocks: [DmChatTextBlock(text: 'Hello')],
    );

    expect(msg.role, DmChatRole.user);
    expect((msg.blocks.single as DmChatTextBlock).text, 'Hello');
  });
}
