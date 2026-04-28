import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmChatMessage', () {
    test('constructs with required fields', () {
      const msg = DmChatMessage(
        id: 'm1',
        role: DmChatRole.user,
        blocks: [],
      );
      expect(msg.id, 'm1');
      expect(msg.role, DmChatRole.user);
      expect(msg.status, DmChatMessageStatus.complete);
      expect(msg.error, isNull);
      expect(msg.createdAt, isNull);
    });

    test('copyWith overrides selected fields and keeps the rest', () {
      const msg = DmChatMessage(
        id: 'm1',
        role: DmChatRole.assistant,
        blocks: [],
        status: DmChatMessageStatus.streaming,
      );
      final copy = msg.copyWith(status: DmChatMessageStatus.complete);
      expect(copy.id, 'm1');
      expect(copy.role, DmChatRole.assistant);
      expect(copy.status, DmChatMessageStatus.complete);
    });

    test('equality compares by value', () {
      const a = DmChatMessage(id: 'm1', role: DmChatRole.user, blocks: []);
      const b = DmChatMessage(id: 'm1', role: DmChatRole.user, blocks: []);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
  });
}
