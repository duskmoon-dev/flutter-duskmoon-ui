// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:duskmoon_highlight/duskmoon_highlight.dart';

final langDns = Mode(
    refs: {},
    name: "DNS Zone",
    aliases: ["bind", "zone"],
    caseInsensitive: true,
    keywords: [
      "A",
      "AAAA",
      "AFSDB",
      "APL",
      "CAA",
      "CDNSKEY",
      "CDS",
      "CERT",
      "CNAME",
      "DHCID",
      "DLV",
      "DNAME",
      "DNSKEY",
      "DS",
      "HIP",
      "IPSECKEY",
      "KEY",
      "KX",
      "LOC",
      "MX",
      "NAPTR",
      "NS",
      "NSEC",
      "NSEC3",
      "NSEC3PARAM",
      "PTR",
      "RRSIG",
      "RP",
      "SIG",
      "SOA",
      "SRV",
      "SSHFP",
      "TA",
      "TKEY",
      "TLSA",
      "TSIG",
      "TXT"
    ],
    contains: <Mode>[
      Mode(
          scope: 'comment',
          begin: ";",
          end: "\$",
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
          relevance: 0),
      Mode(match: [
        "\\bCAA\\b",
        "[ \\t]+",
        "\\d+",
        "[ \\t]+",
        "\\b(?:issuewild|issue|iodef|contactemail|contactphone|issuevmc|issuemail)\\b"
      ], scope: <int, String>{
        1: 'keyword',
        3: 'number',
        5: 'attr',
      }),
      Mode(
          scope: 'string',
          begin: "\"",
          end: "\"",
          illegal: "\\n",
          contains: <Mode>[
            Mode(scope: 'char.escape', match: "\\\\(?:\\d{3}|[^\\d\\n])")
          ]),
      Mode(match: [
        "\\bTXT\\b",
        "\\s+",
        "(?!\")(?:\\\\(?:\\d{3}|[^\\d\\n])|[^\\s;\"()\\\\])+"
      ], scope: <int, String>{
        1: 'keyword',
        3: 'string',
      }),
      Mode(className: 'meta', begin: "^\\\$(TTL|GENERATE|INCLUDE|ORIGIN)\\b"),
      Mode(scope: 'punctuation', match: "[()]"),
      Mode(scope: 'type', match: "\\b(?:IN|CH|HS)\\b"),
      Mode(
          className: 'number',
          begin:
              "(?:(?:[0-9A-Fa-f]{1,4}:){7}(?:[0-9A-Fa-f]{1,4}|:)|(?:[0-9A-Fa-f]{1,4}:){6}(?::[0-9A-Fa-f]{1,4}|(?:(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(?:\\.(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:)|(?:[0-9A-Fa-f]{1,4}:){5}(?:(?::[0-9A-Fa-f]{1,4}){1,2}|:(?:(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(?:\\.(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:)|(?:[0-9A-Fa-f]{1,4}:){4}(?:(?::[0-9A-Fa-f]{1,4}){1,3}|(?::[0-9A-Fa-f]{1,4})?:(?:(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(?:\\.(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:)|(?:[0-9A-Fa-f]{1,4}:){3}(?:(?::[0-9A-Fa-f]{1,4}){1,4}|(?::[0-9A-Fa-f]{1,4}){0,2}:(?:(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(?:\\.(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:)|(?:[0-9A-Fa-f]{1,4}:){2}(?:(?::[0-9A-Fa-f]{1,4}){1,5}|(?::[0-9A-Fa-f]{1,4}){0,3}:(?:(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(?:\\.(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:)|(?:[0-9A-Fa-f]{1,4}:)(?:(?::[0-9A-Fa-f]{1,4}){1,6}|(?::[0-9A-Fa-f]{1,4}){0,4}:(?:(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(?:\\.(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:)|(?::(?:(?::[0-9A-Fa-f]{1,4}){1,7}|(?::[0-9A-Fa-f]{1,4}){0,5}:(?:(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(?:\\.(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:)))(?![0-9A-Fa-f:])"),
      Mode(
          className: 'number',
          begin:
              "(?:(?:25[0-5]|(?:2[0-4]|1?\\d)?\\d)\\.){3}(?:25[0-5]|(?:2[0-4]|1?\\d)?\\d)\\b"),
      Mode(scope: 'number', begin: "\\b\\d+[dhwm]?", relevance: 0)
    ]);
