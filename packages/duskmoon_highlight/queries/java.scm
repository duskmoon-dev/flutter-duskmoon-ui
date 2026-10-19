; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(floating_point_type) @number
(multiline_string_fragment) @string
(string_interpolation) @string
(string_literal) @string
(binary_integer_literal) @number
(block_comment) @comment
(decimal_floating_point_literal) @number
(decimal_integer_literal) @number
(escape_sequence) @string.escape
(false) @boolean
(hex_floating_point_literal) @number
(hex_integer_literal) @number
(identifier) @variable
(line_comment) @comment
(null_literal) @constant.null
(octal_integer_literal) @number
(string_fragment) @string
(true) @boolean
(type_identifier) @type
"!" @operator
"!=" @operator
"%" @operator
"&" @operator
"&&" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"*=" @operator
"+" @operator
"+=" @operator
"," @punctuation.delimiter
"-" @operator
"-=" @operator
"->" @operator
"." @punctuation.delimiter
"/" @operator
"/=" @operator
":" @punctuation.delimiter
"::" @operator
";" @punctuation.delimiter
"<" @operator
"<=" @operator
"=" @operator
"==" @operator
">" @operator
">=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"abstract" @keyword
"break" @keyword
"case" @keyword
"catch" @keyword
"class" @keyword
"continue" @keyword
"default" @keyword
"do" @keyword
"else" @keyword
"enum" @keyword
"extends" @keyword
"final" @keyword
"finally" @keyword
"for" @keyword
"if" @keyword
"import" @keyword
"interface" @keyword
"module" @keyword
"new" @keyword
"package" @keyword
"private" @keyword
"protected" @keyword
"public" @keyword
"return" @keyword
"static" @keyword
"switch" @keyword
"throw" @keyword
"try" @keyword
"when" @keyword
"while" @keyword
"with" @keyword
"yield" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(class_declaration name: (_) @type)
(compact_constructor_declaration name: (_) @type)
(constructor_declaration name: (_) @type)
(enum_constant name: (_) @type)
(enum_declaration name: (_) @type)
(interface_declaration name: (_) @type)
(method_declaration name: (_) @function)
(method_invocation name: (_) @function)

; Source: vendor/grammars/java/queries/highlights.scm

(identifier) @variable

; Methods

(method_declaration
  name: (identifier) @function.method)

(method_invocation
  name: (identifier) @function.method)

(super) @function.builtin

; Annotations

(annotation
  name: (identifier) @attribute)

(marker_annotation
  name: (identifier) @attribute)

"@" @operator

; Types

(type_identifier) @type

(interface_declaration
  name: (identifier) @type)

(class_declaration
  name: (identifier) @type)

(enum_declaration
  name: (identifier) @type)

((field_access
  object: (identifier) @type)
 (#match? @type "^[A-Z]"))

((scoped_identifier
  scope: (identifier) @type)
 (#match? @type "^[A-Z]"))

((method_invocation
  object: (identifier) @type)
 (#match? @type "^[A-Z]"))

((method_reference
  . (identifier) @type)
 (#match? @type "^[A-Z]"))

(constructor_declaration
  name: (identifier) @type)

[
  (boolean_type)
  (integral_type)
  (floating_point_type)
  (floating_point_type)
  (void_type)
] @type.builtin

; Constants

((identifier) @constant
 (#match? @constant "^_*[A-Z][A-Z\\d_]+$"))

; Builtins

(this) @variable.builtin

; Literals

[
  (hex_integer_literal)
  (decimal_integer_literal)
  (octal_integer_literal)
  (decimal_floating_point_literal)
  (hex_floating_point_literal)
] @number

[
  (character_literal)
  (string_literal)
] @string

(escape_sequence) @string.escape

[
  (true)
  (false)
  (null_literal)
] @constant.builtin

[
  (line_comment)
  (block_comment)
] @comment

; Keywords

[
  "abstract"
  "assert"
  "break"
  "case"
  "catch"
  "class"
  "continue"
  "default"
  "do"
  "else"
  "enum"
  "exports"
  "extends"
  "final"
  "finally"
  "for"
  "if"
  "implements"
  "import"
  "instanceof"
  "interface"
  "module"
  "native"
  "new"
  "non-sealed"
  "open"
  "opens"
  "package"
  "permits"
  "private"
  "protected"
  "provides"
  "public"
  "requires"
  "record"
  "return"
  "sealed"
  "static"
  "strictfp"
  "switch"
  "synchronized"
  "throw"
  "throws"
  "to"
  "transient"
  "transitive"
  "try"
  "uses"
  "volatile"
  "when"
  "while"
  "with"
  "yield"
] @keyword
