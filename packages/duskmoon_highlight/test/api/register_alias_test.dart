import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_highlight/languages/all.dart';

import 'package:duskmoon_highlight/duskmoon_highlight.dart';

void main() {
  final Highlight highlight = Highlight();
  highlight.registerLanguages(builtinAllLanguages);

  group('.registerAliases()', () {
    test('should get an existing language by alias', () {
      highlight.registerAliases('jquery', 'javascript');
      expect(highlight.getLanguage('jquery') != null, true);
    });

    test('should get an existing language by aliases', () {
      highlight.registerAliases(['jquery', 'jqueryui'], 'javascript');
      expect(highlight.getLanguage('jquery') != null, true);
    });
  });
}
