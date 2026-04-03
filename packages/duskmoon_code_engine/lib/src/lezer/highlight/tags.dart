class Tag {
  Tag._(this.name, [this._parent]);

  Tag modified(Tag modifier) => Tag._('$name.${modifier.name}', this);

  final String name;
  final Tag? _parent;
  Tag? get parent => _parent;

  // Predefined base tags:
  static final comment = Tag._('comment');
  static final lineComment = comment.modified(Tag._('lineComment'));
  static final blockComment = comment.modified(Tag._('blockComment'));

  static final name_ = Tag._('name');
  static final variableName = name_.modified(Tag._('variableName'));
  static final typeName = name_.modified(Tag._('typeName'));
  static final propertyName = name_.modified(Tag._('propertyName'));
  static final className = name_.modified(Tag._('className'));
  static final namespace = name_.modified(Tag._('namespace'));

  static final literal = Tag._('literal');
  static final string = literal.modified(Tag._('string'));
  static final number = literal.modified(Tag._('number'));
  static final integer = number.modified(Tag._('integer'));
  static final float = number.modified(Tag._('float'));
  static final bool_ = literal.modified(Tag._('bool'));
  static final regexp = literal.modified(Tag._('regexp'));
  static final escape = literal.modified(Tag._('escape'));
  static final null_ = literal.modified(Tag._('null'));
  static final atom = literal.modified(Tag._('atom'));
  static final url = literal.modified(Tag._('url'));
  static final character = literal.modified(Tag._('character'));

  static final keyword = Tag._('keyword');
  static final self_ = keyword.modified(Tag._('self'));
  static final operator_ = Tag._('operator');
  static final operatorKeyword = keyword.modified(Tag._('operatorKeyword'));
  static final controlKeyword = keyword.modified(Tag._('controlKeyword'));
  static final definitionKeyword = keyword.modified(Tag._('definitionKeyword'));
  static final moduleKeyword = keyword.modified(Tag._('moduleKeyword'));

  static final function_ = Tag._('function');
  static final punctuation = Tag._('punctuation');
  static final paren = punctuation.modified(Tag._('paren'));
  static final squareBracket = punctuation.modified(Tag._('squareBracket'));
  static final brace = punctuation.modified(Tag._('brace'));
  static final angleBracket = punctuation.modified(Tag._('angleBracket'));
  static final separator = punctuation.modified(Tag._('separator'));

  static final content = Tag._('content');
  static final heading = content.modified(Tag._('heading'));
  static final emphasis = content.modified(Tag._('emphasis'));
  static final strong = content.modified(Tag._('strong'));
  static final link = content.modified(Tag._('link'));
  static final strikethrough = content.modified(Tag._('strikethrough'));

  static final meta = Tag._('meta');
  static final annotation_ = meta.modified(Tag._('annotation'));

  static final invalid = Tag._('invalid');
  static final definition = Tag._('definition');
  static final constant = Tag._('constant');
  static final local = Tag._('local');
  static final special = Tag._('special');

  @override
  String toString() => 'Tag($name)';
}
