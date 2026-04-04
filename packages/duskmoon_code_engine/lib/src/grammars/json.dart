import '../language/language.dart';
import '../language/language_data.dart';
import '../lezer/common/node_type.dart';
import '../lezer/highlight/tags.dart';
import '../lezer/lr/lr_parser.dart';
import '_registry.dart';

void _ensureRegistered() {
  if (LanguageRegistry.byName('json') != null) return;
  LanguageRegistry.register(
    _jsonSupport,
    extensions: ['json'],
    mimeTypes: ['application/json'],
  );
}

LanguageSupport jsonLanguageSupport() {
  _ensureRegistered();
  return _jsonSupport;
}

Map<String, Tag> jsonHighlightMapping() => {
      'String': Tag.string,
      'Number': Tag.number,
      'Boolean': Tag.bool_,
      'Null': Tag.null_,
      '{': Tag.brace,
      '}': Tag.brace,
      '[': Tag.squareBracket,
      ']': Tag.squareBracket,
      ',': Tag.separator,
      ':': Tag.separator,
    };

final _jsonParser = LRParser.deserialize(
  nodeNames: [
    '',
    'JsonText',
    'Number',
    'String',
    'Boolean',
    'Null',
    '{',
    '}',
    '[',
    ']',
    ',',
    ':',
    '⚠',
  ],
  states: [0],
  stateData: [0],
  gotoTable: [0],
  tokenData: [0],
  topRuleIndex: 1,
  nodeProps: {
    1: {NodeProp.top: true},
    12: {NodeProp.error: true},
  },
);

final _jsonLanguage = Language(
  name: 'json',
  parser: _jsonParser,
  data: const LanguageData(),
);

final _jsonSupport = LanguageSupport(language: _jsonLanguage);
