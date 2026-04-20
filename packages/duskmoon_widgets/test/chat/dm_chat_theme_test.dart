import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmChatTheme.withContext', () {
    testWidgets('derives colors from ColorScheme', (tester) async {
      late DmChatTheme theme;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          ),
          home: Builder(
            builder: (ctx) {
              theme = DmChatTheme.withContext(ctx);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(
        theme.userBubbleColor,
        Theme.of(tester.element(find.byType(SizedBox)))
            .colorScheme
            .primaryContainer,
      );
      expect(theme.userBubbleRadius, BorderRadius.circular(16));
      expect(theme.userBubbleMaxWidthFraction, 0.8);
    });

    testWidgets(
        'uses DmColorExtension for thinking/tool-call colors when present',
        (tester) async {
      late DmChatTheme theme;
      await tester.pumpWidget(
        MaterialApp(
          theme: DmThemeData.sunshine(),
          home: Builder(
            builder: (ctx) {
              theme = DmChatTheme.withContext(ctx);
              return const SizedBox();
            },
          ),
        ),
      );
      final ext = Theme.of(tester.element(find.byType(SizedBox)))
          .extension<DmColorExtension>()!;
      expect(theme.toolCallChipDoneColor, ext.success);
      expect(
        theme.toolCallChipErrorColor,
        Theme.of(tester.element(find.byType(SizedBox))).colorScheme.error,
      );
    });
  });

  group('DmChatTheme.lerp', () {
    test('interpolates colors', () {
      const a = DmChatTheme(
        userBubbleColor: Color(0xFF000000),
        userBubbleOnColor: Color(0xFFFFFFFF),
        assistantSurface: Colors.transparent,
        systemSurface: Color(0xFF808080),
        userBubbleRadius: BorderRadius.zero,
        bubblePadding: EdgeInsets.zero,
        userBubbleMaxWidthFraction: 0.8,
        rowSpacing: 12,
        thinkingForeground: Color(0xFF000000),
        thinkingSurface: Color(0xFFCCCCCC),
        thinkingTextStyle: TextStyle(),
        thinkingCollapseAnimation: Duration(milliseconds: 200),
        toolCallChipColor: Color(0xFF2196F3),
        toolCallChipRunningColor: Color(0xFFFF9800),
        toolCallChipDoneColor: Color(0xFF4CAF50),
        toolCallChipErrorColor: Color(0xFFF44336),
        toolCallLabelStyle: TextStyle(),
        attachmentChipColor: Color(0xFFCCCCCC),
        attachmentImageThumbSize: 96,
        inputPadding: EdgeInsets.zero,
        inputSurface: Color(0xFFFFFFFF),
        inputElevation: 1,
        inputRadius: BorderRadius.zero,
        customBuilders: {},
      );
      final b = a.copyWith(userBubbleColor: const Color(0xFFFFFFFF));
      final mid = a.lerp(b, 0.5);
      // Color.lerp produces exact 0.5 channels, which does not equal
      // 0x80 == 128/255 ≈ 0.5020. Assert the interpolated channels directly.
      expect(mid.userBubbleColor.r, moreOrLessEquals(0.5, epsilon: 0.01));
      expect(mid.userBubbleColor.g, moreOrLessEquals(0.5, epsilon: 0.01));
      expect(mid.userBubbleColor.b, moreOrLessEquals(0.5, epsilon: 0.01));
      expect(mid.userBubbleColor.a, moreOrLessEquals(1.0, epsilon: 0.01));
    });
  });
}
