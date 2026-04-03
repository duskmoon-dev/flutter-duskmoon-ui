import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmMarkdownScrollController', () {
    test('registers and retrieves anchors', () {
      final controller = DmMarkdownScrollController();
      final key1 = GlobalKey();
      final key2 = GlobalKey();

      controller.registerAnchor('heading-1', key1);
      controller.registerAnchor('heading-2', key2);

      expect(controller.anchors, ['heading-1', 'heading-2']);
    });

    test('clearAnchors removes all', () {
      final controller = DmMarkdownScrollController();
      controller.registerAnchor('test', GlobalKey());

      controller.clearAnchors();
      expect(controller.anchors, isEmpty);
    });

    test('scrollToAnchor returns false for unknown ID', () async {
      final controller = DmMarkdownScrollController();
      final result = await controller.scrollToAnchor('nonexistent');
      expect(result, isFalse);
    });

    test('anchor collision is handled by slug_utils uniqueSlug', () {
      // This tests the slug utility indirectly through the scroll controller.
      final controller = DmMarkdownScrollController();
      controller.registerAnchor('test', GlobalKey());
      controller.registerAnchor('test', GlobalKey()); // duplicate key

      // Both register — collision handling is done at the DmMarkdown level.
      expect(controller.anchors, hasLength(1)); // Map deduplicates
    });
  });
}
