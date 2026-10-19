; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(block_comment) @comment
(boolean_literal) @boolean
(inner_doc_comment_marker) @comment
(line_comment) @comment
(outer_doc_comment_marker) @comment
(raw_string_literal) @string
(string_literal) @string
(doc_comment) @comment
(escape_sequence) @string.escape
(field_identifier) @property
(float_literal) @number
(identifier) @variable
(integer_literal) @number
(primitive_type) @type
(string_content) @string
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
"=>" @operator
">" @operator
">=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"as" @keyword
"async" @keyword
"await" @keyword
"break" @keyword
"const" @keyword
"continue" @keyword
"default" @keyword
"else" @keyword
"enum" @keyword
"extern" @keyword
"false" @keyword
"fn" @keyword
"for" @keyword
"if" @keyword
"impl" @keyword
"in" @keyword
"let" @keyword
"match" @keyword
"pub" @keyword
"return" @keyword
"static" @keyword
"struct" @keyword
"trait" @keyword
"true" @keyword
"try" @keyword
"type" @keyword
"union" @keyword
"use" @keyword
"where" @keyword
"while" @keyword
"yield" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
(call_expression function: (_) @function)
(enum_item name: (_) @type)
(enum_variant name: (_) @type)
(function_item name: (_) @function)
(function_signature_item name: (_) @function)
(generic_function function: (_) @function)
(struct_expression name: (_) @type)
(struct_item name: (_) @type)

; Source: vendor/grammars/rust/queries/highlights.scm

(type_identifier) @type

(primitive_type) @type.builtin

(field_identifier) @property

; Identifier conventions

; Assume all-caps names are constants

((identifier) @constant
 (#match? @constant "^[A-Z][A-Z\\d_]+$'"))

; Assume uppercase names are enum constructors

((identifier) @constructor
 (#match? @constructor "^[A-Z]"))

; Assume that uppercase names in paths are types

((scoped_identifier
  path: (identifier) @type)
 (#match? @type "^[A-Z]"))

((scoped_identifier
  path: (scoped_identifier
    name: (identifier) @type))
 (#match? @type "^[A-Z]"))

((scoped_type_identifier
  path: (identifier) @type)
 (#match? @type "^[A-Z]"))

((scoped_type_identifier
  path: (scoped_identifier
    name: (identifier) @type))
 (#match? @type "^[A-Z]"))

; Assume all qualified names in struct patterns are enum constructors. (They're
; either that, or struct names; highlighting both as constructors seems to be
; the less glaring choice of error, visually.)

(struct_pattern
  type: (scoped_type_identifier
    name: (type_identifier) @constructor))

; Function calls

(call_expression
  function: (identifier) @function)

(call_expression
  function: (field_expression
    field: (field_identifier) @function.method))

(call_expression
  function: (scoped_identifier
    "::"
    name: (identifier) @function))

(generic_function
  function: (identifier) @function)

(generic_function
  function: (scoped_identifier
    name: (identifier) @function))

(generic_function
  function: (field_expression
    field: (field_identifier) @function.method))

(macro_invocation
  macro: (identifier) @function.macro
  "!" @function.macro)

; Function definitions

(function_item (identifier) @function)

(function_signature_item (identifier) @function)

(line_comment) @comment

(block_comment) @comment

(line_comment (doc_comment)) @comment.documentation

(block_comment (doc_comment)) @comment.documentation

"(" @punctuation.bracket

")" @punctuation.bracket

"[" @punctuation.bracket

"]" @punctuation.bracket

"{" @punctuation.bracket

"}" @punctuation.bracket

(type_arguments
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

(type_parameters
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

"::" @punctuation.delimiter

":" @punctuation.delimiter

"." @punctuation.delimiter

"," @punctuation.delimiter

";" @punctuation.delimiter

(parameter (identifier) @variable.parameter)

(lifetime (identifier) @label)

"as" @keyword

"async" @keyword

"await" @keyword

"break" @keyword

"const" @keyword

"continue" @keyword

"default" @keyword

"dyn" @keyword

"else" @keyword

"enum" @keyword

"extern" @keyword

"fn" @keyword

"for" @keyword

"gen" @keyword

"if" @keyword

"impl" @keyword

"in" @keyword

"let" @keyword

"loop" @keyword

"macro_rules!" @keyword

"match" @keyword

"mod" @keyword

"move" @keyword

"pub" @keyword

"raw" @keyword

"ref" @keyword

"return" @keyword

"static" @keyword

"struct" @keyword

"trait" @keyword

"type" @keyword

"union" @keyword

"unsafe" @keyword

"use" @keyword

"where" @keyword

"while" @keyword

"yield" @keyword

(crate) @keyword

(mutable_specifier) @keyword

(use_list (self) @keyword)

(scoped_use_list (self) @keyword)

(scoped_identifier (self) @keyword)

(super) @keyword

(self) @variable.builtin

(char_literal) @string

(string_literal) @string

(raw_string_literal) @string

(boolean_literal) @constant.builtin

(integer_literal) @constant.builtin

(float_literal) @constant.builtin

(escape_sequence) @escape

(attribute_item) @attribute

(inner_attribute_item) @attribute

"*" @operator

"&" @operator

"'" @operator
