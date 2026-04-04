import 'package:flutter/painting.dart';
import '../lezer/highlight/highlight.dart';
import 'default_highlight.dart';

class EditorTheme {
  const EditorTheme({
    required this.background,
    required this.foreground,
    required this.gutterBackground,
    required this.gutterForeground,
    required this.gutterActiveForeground,
    required this.selectionBackground,
    required this.cursorColor,
    this.cursorWidth = 2.0,
    required this.lineHighlight,
    required this.highlightStyle,
    required this.searchMatchBackground,
    required this.searchActiveMatchBackground,
    required this.matchingBracketBackground,
    required this.matchingBracketOutline,
    required this.scrollbarThumb,
    required this.scrollbarTrack,
    this.foldPlaceholderForeground,
    this.selectionForegroundMatch,
  });

  final Color background, foreground;
  final Color gutterBackground, gutterForeground, gutterActiveForeground;
  final Color selectionBackground;
  final Color? selectionForegroundMatch;
  final Color cursorColor;
  final double cursorWidth;
  final Color lineHighlight;
  final Color? foldPlaceholderForeground;
  final HighlightStyle highlightStyle;
  final Color scrollbarThumb, scrollbarTrack;
  final Color searchMatchBackground, searchActiveMatchBackground;
  final Color matchingBracketBackground, matchingBracketOutline;

  factory EditorTheme.light() => EditorTheme(
        background: const Color(0xFFFFFFFF),
        foreground: const Color(0xFF1E1E1E),
        gutterBackground: const Color(0xFFF5F5F5),
        gutterForeground: const Color(0xFF999999),
        gutterActiveForeground: const Color(0xFF333333),
        selectionBackground: const Color(0xFFBBDEFB),
        cursorColor: const Color(0xFF1E1E1E),
        lineHighlight: const Color(0x0A000000),
        searchMatchBackground: const Color(0xFFFFF9C4),
        searchActiveMatchBackground: const Color(0xFFFFCC80),
        matchingBracketBackground: const Color(0x3300CC00),
        matchingBracketOutline: const Color(0xFF00CC00),
        scrollbarThumb: const Color(0x33000000),
        scrollbarTrack: const Color(0x0A000000),
        highlightStyle: defaultLightHighlight,
      );

  factory EditorTheme.dark() => EditorTheme(
        background: const Color(0xFF1E1E1E),
        foreground: const Color(0xFFD4D4D4),
        gutterBackground: const Color(0xFF252526),
        gutterForeground: const Color(0xFF858585),
        gutterActiveForeground: const Color(0xFFC6C6C6),
        selectionBackground: const Color(0xFF264F78),
        cursorColor: const Color(0xFFD4D4D4),
        lineHighlight: const Color(0x0AFFFFFF),
        searchMatchBackground: const Color(0x55FFCC00),
        searchActiveMatchBackground: const Color(0xAAFFCC00),
        matchingBracketBackground: const Color(0x3300CC00),
        matchingBracketOutline: const Color(0xFF00CC00),
        scrollbarThumb: const Color(0x33FFFFFF),
        scrollbarTrack: const Color(0x0AFFFFFF),
        highlightStyle: defaultDarkHighlight,
      );
}
