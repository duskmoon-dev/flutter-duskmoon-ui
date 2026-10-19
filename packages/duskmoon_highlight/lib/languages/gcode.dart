// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:duskmoon_highlight/duskmoon_highlight.dart';
import 'lib/gcode.dart';

final langGcode = Mode(
    refs: {},
    name: "G-code (ISO 6983)",
    aliases: ["nc"],
    caseInsensitive: true,
    disableAutodetect: true,
    keywords: {
      "\$pattern": "[A-Z]+|%",
      "keyword": [
        "THEN",
        "ELSE",
        "ENDIF",
        "IF",
        "GOTO",
        "DO",
        "WHILE",
        "WH",
        "END",
        "CALL",
        "SUB",
        "ENDSUB",
        "EQ",
        "NE",
        "LT",
        "GT",
        "LE",
        "GE",
        "AND",
        "OR",
        "XOR",
        "%"
      ],
      "built_in": [
        "ATAN",
        "ABS",
        "ACOS",
        "ASIN",
        "COS",
        "EXP",
        "FIX",
        "FUP",
        "ROUND",
        "LN",
        "SIN",
        "SQRT",
        "TAN",
        "EXISTS"
      ]
    },
    contains: <Mode>[
      Mode(scope: 'comment', begin: "\\(", end: "\\)", contains: <Mode>[
        Mode(
            scope: 'doctag',
            begin: "[ ]*(?=(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):)",
            end: "(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):",
            excludeBegin: true,
            relevance: 0),
        Mode(
            begin:
                "[ ]+((?:I|a|is|so|us|to|at|if|in|it|on|[A-Za-z]+['](d|ve|re|ll|t|s|n)|[A-Za-z]+[-][a-z]+|[A-Za-z][a-z]{2,})[.]?[:]?([.][ ]|[ ])){3}")
      ]),
      Mode(scope: 'comment', begin: ";", end: "\$", contains: <Mode>[
        Mode(
            scope: 'doctag',
            begin: "[ ]*(?=(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):)",
            end: "(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):",
            excludeBegin: true,
            relevance: 0),
        Mode(
            begin:
                "[ ]+((?:I|a|is|so|us|to|at|if|in|it|on|[A-Za-z]+['](d|ve|re|ll|t|s|n)|[A-Za-z]+[-][a-z]+|[A-Za-z][a-z]{2,})[.]?[:]?([.][ ]|[ ])){3}")
      ]),
      APOS_STRING_MODE,
      QUOTE_STRING_MODE,
      C_NUMBER_MODE,
      Mode(scope: 'title.function', variants: <Mode>[
        Mode(match: "\\b[GM]\\s*\\d+(\\.\\d+)?"),
        Mode(begin: "[GM]\\s*\\d+(\\.\\d+)?", onBegin: callbackOnBegin),
        Mode(match: "\\bT\\s*\\d+"),
        Mode(begin: "T\\s*\\d+", onBegin: callbackOnBegin)
      ]),
      Mode(scope: 'symbol', variants: <Mode>[
        Mode(match: "\\bO\\s*\\d+"),
        Mode(begin: "O\\s*\\d+", onBegin: callbackOnBegin),
        Mode(match: "\\bO<.+>"),
        Mode(begin: "O<.+>", onBegin: callbackOnBegin),
        Mode(match: "\\*\\s*\\d+\\s*\$")
      ]),
      Mode(scope: 'operator', match: "^N\\s*\\d+"),
      Mode(scope: 'variable', match: "-?#\\s*\\d+"),
      Mode(scope: 'property', variants: <Mode>[
        Mode(match: "\\b[ABCUVWXYZ]\\s*[+-]?((\\.\\d+)|(\\d+)(\\.\\d*)?)"),
        Mode(
            begin: "[ABCUVWXYZ]\\s*[+-]?((\\.\\d+)|(\\d+)(\\.\\d*)?)",
            onBegin: callbackOnBegin)
      ]),
      Mode(scope: 'params', variants: <Mode>[
        Mode(match: "\\b[FHIJKPQRS]\\s*[+-]?((\\.\\d+)|(\\d+)(\\.\\d*)?)"),
        Mode(
            begin: "[FHIJKPQRS]\\s*[+-]?((\\.\\d+)|(\\d+)(\\.\\d*)?)",
            onBegin: callbackOnBegin)
      ])
    ]);
