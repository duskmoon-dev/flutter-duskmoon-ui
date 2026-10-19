// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:duskmoon_highlight/duskmoon_highlight.dart';

final langJson = Mode(
    refs: {},
    name: "JSON",
    aliases: ["jsonc", "json5"],
    keywords: {
      "literal": ["true", "false", "null"]
    },
    contains: <Mode>[
      Mode(
          className: 'attr',
          begin:
              "((\"(\\\\.|[^\\\\\"\\r\\n])*\")|('(\\\\.|[^\\\\'\\r\\n])*'))(?=\\s*:)",
          relevance: 1.01),
      Mode(match: "[{}[\\],:]", className: 'punctuation', relevance: 0),
      APOS_STRING_MODE,
      QUOTE_STRING_MODE,
      Mode(scope: 'literal', beginKeywords: "true false null"),
      Mode(
          scope: 'number',
          match:
              "([-+]?)(\\b0[xX][a-fA-F0-9]+|(\\b\\d+(\\.\\d*)?|\\.\\d+)([eE][-+]?\\d+)?)|NaN|[-+]?Infinity",
          relevance: 0),
      C_LINE_COMMENT_MODE,
      C_BLOCK_COMMENT_MODE
    ],
    illegal: "\\S");
