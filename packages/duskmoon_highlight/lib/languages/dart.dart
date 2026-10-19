// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:duskmoon_highlight/duskmoon_highlight.dart';

final langDart = Mode(
    refs: {
      '~contains~0': Mode(className: 'string', variants: <Mode>[
        Mode(begin: "r'''", end: "'''"),
        Mode(begin: "r\"\"\"", end: "\"\"\""),
        Mode(begin: "r'", end: "'", illegal: "\\n"),
        Mode(begin: "r\"", end: "\"", illegal: "\\n"),
        Mode(begin: "'''", end: "'''", contains: <Mode>[
          BACKSLASH_ESCAPE,
          Mode(
              className: 'subst',
              variants: <Mode>[Mode(begin: "\\\$[A-Za-z0-9_]+")]),
          Mode(
              className: 'subst',
              variants: <Mode>[Mode(begin: "\\\$\\{", end: "\\}")],
              keywords: "true false null this is new super",
              contains: <Mode>[
                Mode(className: 'number', relevance: 0, variants: <Mode>[
                  Mode(
                      match:
                          "\\b[0-9][0-9_]*(\\.[0-9][0-9_]*)?([eE][+-]?[0-9][0-9_]*)?\\b"),
                  Mode(match: "\\b0[xX][0-9A-Fa-f][0-9A-Fa-f_]*\\b")
                ]),
                Mode(ref: '~contains~0')
              ])
        ]),
        Mode(begin: "\"\"\"", end: "\"\"\"", contains: <Mode>[
          BACKSLASH_ESCAPE,
          Mode(ref: '~contains~0~variants~4~contains~1'),
          Mode(ref: '~contains~0~variants~4~contains~2')
        ]),
        Mode(begin: "'", end: "'", illegal: "\\n", contains: <Mode>[
          BACKSLASH_ESCAPE,
          Mode(ref: '~contains~0~variants~4~contains~1'),
          Mode(ref: '~contains~0~variants~4~contains~2')
        ]),
        Mode(begin: "\"", end: "\"", illegal: "\\n", contains: <Mode>[
          BACKSLASH_ESCAPE,
          Mode(ref: '~contains~0~variants~4~contains~1'),
          Mode(ref: '~contains~0~variants~4~contains~2')
        ])
      ]),
      '~contains~0~variants~4~contains~1': Mode(
          className: 'subst',
          variants: <Mode>[Mode(begin: "\\\$[A-Za-z0-9_]+")]),
      '~contains~0~variants~4~contains~2': Mode(
          className: 'subst',
          variants: <Mode>[Mode(begin: "\\\$\\{", end: "\\}")],
          keywords: "true false null this is new super",
          contains: <Mode>[
            Mode(className: 'number', relevance: 0, variants: <Mode>[
              Mode(
                  match:
                      "\\b[0-9][0-9_]*(\\.[0-9][0-9_]*)?([eE][+-]?[0-9][0-9_]*)?\\b"),
              Mode(match: "\\b0[xX][0-9A-Fa-f][0-9A-Fa-f_]*\\b")
            ]),
            Mode(ref: '~contains~0')
          ]),
      '~contains~0~variants~4~contains~2~contains~0':
          Mode(className: 'number', relevance: 0, variants: <Mode>[
        Mode(
            match:
                "\\b[0-9][0-9_]*(\\.[0-9][0-9_]*)?([eE][+-]?[0-9][0-9_]*)?\\b"),
        Mode(match: "\\b0[xX][0-9A-Fa-f][0-9A-Fa-f_]*\\b")
      ])
    },
    name: "Dart",
    keywords: {
      "keyword": [
        "abstract",
        "as",
        "assert",
        "async",
        "await",
        "base",
        "break",
        "case",
        "catch",
        "class",
        "const",
        "continue",
        "covariant",
        "default",
        "deferred",
        "do",
        "dynamic",
        "else",
        "enum",
        "export",
        "extends",
        "extension",
        "external",
        "factory",
        "false",
        "final",
        "finally",
        "for",
        "Function",
        "get",
        "hide",
        "if",
        "implements",
        "import",
        "in",
        "interface",
        "is",
        "late",
        "library",
        "mixin",
        "new",
        "null",
        "on",
        "operator",
        "part",
        "required",
        "rethrow",
        "return",
        "sealed",
        "set",
        "show",
        "static",
        "super",
        "switch",
        "sync",
        "this",
        "throw",
        "true",
        "try",
        "typedef",
        "var",
        "void",
        "when",
        "while",
        "with",
        "yield"
      ],
      "built_in": [
        "Comparable",
        "DateTime",
        "Duration",
        "Function",
        "Iterable",
        "Iterator",
        "List",
        "Map",
        "Match",
        "Object",
        "Pattern",
        "RegExp",
        "Set",
        "Stopwatch",
        "String",
        "StringBuffer",
        "StringSink",
        "Symbol",
        "Type",
        "Uri",
        "bool",
        "double",
        "int",
        "num",
        "Element",
        "ElementList",
        "Comparable?",
        "DateTime?",
        "Duration?",
        "Function?",
        "Iterable?",
        "Iterator?",
        "List?",
        "Map?",
        "Match?",
        "Object?",
        "Pattern?",
        "RegExp?",
        "Set?",
        "Stopwatch?",
        "String?",
        "StringBuffer?",
        "StringSink?",
        "Symbol?",
        "Type?",
        "Uri?",
        "bool?",
        "double?",
        "int?",
        "num?",
        "Element?",
        "ElementList?",
        "Never",
        "Null",
        "dynamic",
        "print",
        "document",
        "querySelector",
        "querySelectorAll",
        "window"
      ],
      "\$pattern": "[A-Za-z][A-Za-z0-9_]*\\??"
    },
    contains: <Mode>[
      Mode(ref: '~contains~0'),
      Mode(
          scope: 'comment',
          begin: "\\/\\*\\*(?!\\/)",
          end: "\\*\\/",
          contains: <Mode>[
            Mode(
                scope: 'doctag',
                begin: "[ ]*(?=(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):)",
                end: "(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):",
                excludeBegin: true,
                relevance: 0),
            Mode(
                begin:
                    "[ ]+((?:I|a|is|so|us|to|at|if|in|it|on|[A-Za-z]+['](d|ve|re|ll|t|s|n)|[A-Za-z]+[-][a-z]+|[A-Za-z][a-z]{2,})[.]?[:]?([.][ ]|[ ])){3}")
          ],
          subLanguage: "markdown",
          relevance: 0),
      Mode(scope: 'comment', begin: "\\/{3,} ?", end: "\$", contains: <Mode>[
        Mode(subLanguage: "markdown", begin: ".", end: "\$", relevance: 0),
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
      C_LINE_COMMENT_MODE,
      C_BLOCK_COMMENT_MODE,
      Mode(
          className: 'class',
          beginKeywords: "class interface",
          end: "\\{",
          excludeEnd: true,
          contains: <Mode>[
            Mode(beginKeywords: "extends implements"),
            UNDERSCORE_TITLE_MODE
          ]),
      Mode(
          match:
              "\\b_?(?:(?:[A-Z]+[a-z0-9]+)+|(?:[A-Z]+[a-z0-9]+)+[A-Z]+)(?![A-Za-z0-9_])",
          scope: 'title.class'),
      Mode(
          match:
              "\\b(?!(?:assert|catch|for|if|switch|while)\\b)[a-z_][A-Za-z0-9_]*(?=\\()",
          scope: 'title.function'),
      Mode(ref: '~contains~0~variants~4~contains~2~contains~0'),
      Mode(className: 'meta', begin: "@[A-Za-z]+")
    ]);
