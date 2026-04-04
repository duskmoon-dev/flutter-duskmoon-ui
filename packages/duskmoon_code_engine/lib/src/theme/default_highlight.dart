import 'package:flutter/painting.dart';
import '../lezer/highlight/highlight.dart';
import '../lezer/highlight/tags.dart';

final HighlightStyle defaultLightHighlight = HighlightStyle([
  TagStyle(Tag.keyword,
      const TextStyle(color: Color(0xFF0000FF), fontWeight: FontWeight.bold)),
  TagStyle(Tag.string, const TextStyle(color: Color(0xFFA31515))),
  TagStyle(Tag.comment,
      const TextStyle(color: Color(0xFF008000), fontStyle: FontStyle.italic)),
  TagStyle(Tag.number, const TextStyle(color: Color(0xFF098658))),
  TagStyle(Tag.typeName, const TextStyle(color: Color(0xFF267F99))),
  TagStyle(Tag.function_, const TextStyle(color: Color(0xFF795E26))),
  TagStyle(Tag.variableName, const TextStyle(color: Color(0xFF001080))),
  TagStyle(Tag.operator_, const TextStyle(color: Color(0xFF000000))),
  TagStyle(Tag.punctuation, const TextStyle(color: Color(0xFF000000))),
  TagStyle(Tag.bool_, const TextStyle(color: Color(0xFF0000FF))),
  TagStyle(Tag.null_, const TextStyle(color: Color(0xFF0000FF))),
  TagStyle(Tag.meta, const TextStyle(color: Color(0xFF808080))),
  TagStyle(Tag.annotation_, const TextStyle(color: Color(0xFF808080))),
  TagStyle(
      Tag.invalid,
      const TextStyle(
          color: Color(0xFFFF0000), decoration: TextDecoration.lineThrough)),
]);

final HighlightStyle defaultDarkHighlight = HighlightStyle([
  TagStyle(Tag.keyword,
      const TextStyle(color: Color(0xFF569CD6), fontWeight: FontWeight.bold)),
  TagStyle(Tag.string, const TextStyle(color: Color(0xFFCE9178))),
  TagStyle(Tag.comment,
      const TextStyle(color: Color(0xFF6A9955), fontStyle: FontStyle.italic)),
  TagStyle(Tag.number, const TextStyle(color: Color(0xFFB5CEA8))),
  TagStyle(Tag.typeName, const TextStyle(color: Color(0xFF4EC9B0))),
  TagStyle(Tag.function_, const TextStyle(color: Color(0xFFDCDCAA))),
  TagStyle(Tag.variableName, const TextStyle(color: Color(0xFF9CDCFE))),
  TagStyle(Tag.operator_, const TextStyle(color: Color(0xFFD4D4D4))),
  TagStyle(Tag.punctuation, const TextStyle(color: Color(0xFFD4D4D4))),
  TagStyle(Tag.bool_, const TextStyle(color: Color(0xFF569CD6))),
  TagStyle(Tag.null_, const TextStyle(color: Color(0xFF569CD6))),
  TagStyle(Tag.meta, const TextStyle(color: Color(0xFF808080))),
  TagStyle(Tag.annotation_, const TextStyle(color: Color(0xFF808080))),
  TagStyle(
      Tag.invalid,
      const TextStyle(
          color: Color(0xFFF44747), decoration: TextDecoration.lineThrough)),
]);
