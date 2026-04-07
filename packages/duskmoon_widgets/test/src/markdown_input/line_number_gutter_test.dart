import 'package:duskmoon_widgets/src/markdown_input/_line_number_gutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('computeGutterWidth', () {
    const baseStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 14,
      height: 1.5,
    );

    testWidgets('grows when line numbers need more digits', (tester) async {
      final twoDigitWidth = computeGutterWidth(
        lineCount: 99,
        textStyle: baseStyle,
        textScaler: TextScaler.noScaling,
      );
      final threeDigitWidth = computeGutterWidth(
        lineCount: 999,
        textStyle: baseStyle,
        textScaler: TextScaler.noScaling,
      );

      expect(threeDigitWidth, greaterThan(twoDigitWidth));
    });

    testWidgets('grows with larger text metrics', (tester) async {
      final compactWidth = computeGutterWidth(
        lineCount: 128,
        textStyle: baseStyle,
        textScaler: TextScaler.noScaling,
      );
      final largeWidth = computeGutterWidth(
        lineCount: 128,
        textStyle: baseStyle.copyWith(fontSize: 20),
        textScaler: TextScaler.noScaling,
      );

      expect(largeWidth, greaterThan(compactWidth));
    });
  });
}
