import 'package:flutter/widgets.dart';

/// Utility class for text style operations in charts.
class TextStyleUtil {
  TextStyleUtil._();

  /// Creates a default chart label style.
  static TextStyle label({
    Color color = const Color(0xFF333333),
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    String? fontFamily,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  /// Creates a chart title style.
  static TextStyle title({
    Color color = const Color(0xFF000000),
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.bold,
    String? fontFamily,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  /// Creates an axis label style.
  static TextStyle axisLabel({
    Color color = const Color(0xFF666666),
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.normal,
    String? fontFamily,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  /// Creates a tick label style.
  static TextStyle tickLabel({
    Color color = const Color(0xFF888888),
    double fontSize = 10,
    FontWeight fontWeight = FontWeight.normal,
    String? fontFamily,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  /// Creates a tooltip text style.
  static TextStyle tooltip({
    Color color = const Color(0xFFFFFFFF),
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    String? fontFamily,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  /// Creates an annotation text style.
  static TextStyle annotation({
    Color color = const Color(0xFF444444),
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.italic,
    String? fontFamily,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontFamily: fontFamily,
    );
  }

  /// Creates a legend text style.
  static TextStyle legend({
    Color color = const Color(0xFF333333),
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.normal,
    String? fontFamily,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  /// Measures the size of text with the given style.
  static Size measureText(String text, TextStyle style, {double? maxWidth}) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: maxWidth != null ? null : 1,
    );
    textPainter.layout(maxWidth: maxWidth ?? double.infinity);
    return Size(textPainter.width, textPainter.height);
  }

  /// Calculates the optimal font size to fit text within bounds.
  static double fitFontSize(
    String text,
    TextStyle style,
    Size bounds, {
    double minFontSize = 8,
    double maxFontSize = 24,
  }) {
    double fontSize = maxFontSize;

    while (fontSize >= minFontSize) {
      final size = measureText(text, style.copyWith(fontSize: fontSize));
      if (size.width <= bounds.width && size.height <= bounds.height) {
        return fontSize;
      }
      fontSize -= 1;
    }

    return minFontSize;
  }

  /// Truncates text to fit within a width, adding ellipsis.
  static String truncateText(
    String text,
    TextStyle style,
    double maxWidth, {
    String ellipsis = '...',
  }) {
    final fullSize = measureText(text, style);
    if (fullSize.width <= maxWidth) return text;

    final ellipsisSize = measureText(ellipsis, style);
    final availableWidth = maxWidth - ellipsisSize.width;

    if (availableWidth <= 0) return ellipsis;

    // Binary search for the right truncation point
    int low = 0;
    int high = text.length;

    while (low < high) {
      final mid = (low + high + 1) ~/ 2;
      final truncated = text.substring(0, mid);
      final size = measureText(truncated, style);

      if (size.width <= availableWidth) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }

    if (low == 0) return ellipsis;
    return '${text.substring(0, low)}$ellipsis';
  }
}

/// Extension methods for TextStyle.
extension TextStyleExtension on TextStyle {
  /// Creates a copy with reduced opacity.
  TextStyle withOpacity(double opacity) {
    return copyWith(
      color: color?.withValues(alpha: (color?.a ?? 1.0) * opacity),
    );
  }

  /// Creates a copy scaled by the given factor.
  TextStyle scaled(double factor) {
    return copyWith(
      fontSize: (fontSize ?? 14) * factor,
    );
  }

  /// Creates a bold version.
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Creates an italic version.
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Creates a light weight version.
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
}
