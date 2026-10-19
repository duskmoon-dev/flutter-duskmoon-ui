// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:duskmoon_highlight/duskmoon_highlight.dart';

final langGherkin = Mode(
    refs: {
      '~contains~3~contains~0': Mode(scope: 'variable', begin: "<[^>\\s]+>")
    },
    name: "Gherkin",
    aliases: ["feature"],
    contains: <Mode>[
      Mode(scope: 'comment', begin: "^[ \\t]*#", end: "\$"),
      Mode(begin: [
        "^[ \\t]*",
        "@[^@\\s]+(?:[ \\t]+@[^@\\s]+)*"
      ], beginScope: <int, String>{
        2: 'meta',
      }),
      Mode(scope: 'string', variants: <Mode>[
        Mode(begin: "^[ \\t]*\"\"\"\\w*", end: "^[ \\t]*\"\"\"[ \\t]*\$"),
        Mode(begin: "^[ \\t]*```\\w*", end: "^[ \\t]*```[ \\t]*\$")
      ]),
      Mode(
          begin: [
            "^[ \\t]*",
            "(Feature|Business Need|Ability|Rule|Examples?|Scenario(?:s| Outline| Template)?|Background)",
            ":"
          ],
          beginScope: <int, String>{
            2: 'keyword',
            3: 'punctuation',
          },
          end: "\$",
          contains: <Mode>[
            Mode(ref: '~contains~3~contains~0'),
            QUOTE_STRING_MODE
          ]),
      Mode(
          begin: ["^[ \\t]*", "\\b(?:Given|When|Then|And|But)\\b"],
          beginScope: <int, String>{
            2: 'keyword',
          },
          end: "\$",
          contains: <Mode>[
            Mode(ref: '~contains~3~contains~0'),
            QUOTE_STRING_MODE
          ]),
      Mode(
          begin: ["^[ \\t]*", "\\*(?=[ \\t])"],
          beginScope: <int, String>{
            2: 'keyword',
          },
          end: "\$",
          contains: <Mode>[
            Mode(ref: '~contains~3~contains~0'),
            QUOTE_STRING_MODE
          ]),
      Mode(begin: "^[ \\t]*\\|", end: "\$", contains: <Mode>[
        Mode(ref: '~contains~3~contains~0'),
        Mode(scope: 'string', match: "[^|<\\n]+")
      ])
    ]);
