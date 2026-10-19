// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:duskmoon_highlight/duskmoon_highlight.dart';

final langFreedesktop = Mode(
    refs: {},
    name: "FreeDesktop config",
    aliases: ["desktop", "systemd"],
    caseInsensitive: false,
    contains: <Mode>[
      Mode(scope: 'comment', begin: "#", end: "\$"),
      Mode(
          scope: 'section',
          begin:
              "^\\[(wifi-security|wifi|vpn|ipv6|ipv4|connection|Unit|Timer|Swap|Socket|Slice|Service|Scope|Path|Mount|Manager|Journal|Install|Desktop Entry|Desktop Action\\s+[A-Za-z0-9_-]+|Bridge|Automount|802-3-ethernet|802-11-wireless-security|802-11-wireless)\\]\$"),
      Mode(
          begin: "^[A-Za-z0-9_-]+(\\[[A-Za-z0-9_@.]+\\])?(?=\\s*=)",
          beginScope: 'attr',
          end: "\$",
          contains: <Mode>[
            Mode(scope: 'operator', match: "="),
            Mode(
                scope: 'string',
                begin: "\"",
                end: "\"",
                contains: <Mode>[BACKSLASH_ESCAPE]),
            Mode(
                scope: 'literal',
                match:
                    "\\b(Application|Link|Directory|forking|oneshot|OneShot|true|false|True|False)\\b"),
            Mode(scope: 'variable', match: "%[a-zA-Z]")
          ])
    ]);
