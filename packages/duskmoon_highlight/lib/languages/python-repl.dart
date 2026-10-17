// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:duskmoon_highlight/duskmoon_highlight.dart';

final langPythonRepl = Mode(refs: {}, aliases: [
  "pycon"
], contains: <Mode>[
  Mode(
      className: 'meta.prompt',
      starts: Mode(end: " |\$", starts: Mode(end: "\$", subLanguage: "python")),
      variants: <Mode>[
        Mode(begin: "^>>>(?=[ ]|\$)"),
        Mode(begin: "^\\.\\.\\.(?=[ ]|\$)")
      ])
]);
