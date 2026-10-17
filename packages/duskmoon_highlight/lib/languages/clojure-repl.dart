// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:duskmoon_highlight/duskmoon_highlight.dart';

final langClojureRepl = Mode(
    refs: {},
    name: "Clojure REPL",
    contains: <Mode>[
      Mode(
          className: 'meta.prompt',
          begin: "^([\\w.-]+|\\s*#_)?=>",
          starts: Mode(end: "\$", subLanguage: "clojure"))
    ]);
