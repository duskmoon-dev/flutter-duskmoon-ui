// @dart = 3.0

import 'package:duskmoon_widgets/src/vendor/flutter_math/ast.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/src/vendor/flutter_math/src/encoder/tex/encoder.dart';

void main() {
  group('StretchyOp encoding test', () {
    test('general encoding', () {
      final node1 = StretchyOpNode(
        symbol: '\u2192',
        above: EquationRowNode(children: []),
        below: EquationRowNode(children: []),
      );
      expect(node1.encodeTeX(), '\\xrightarrow{}');

      final node2 = StretchyOpNode(
        symbol: '\u2192',
        above: EquationRowNode(children: [SymbolNode(symbol: 'a')]),
        below: EquationRowNode(children: []),
      );
      expect(node2.encodeTeX(), '\\xrightarrow[a]{}');
    });
  });
}
