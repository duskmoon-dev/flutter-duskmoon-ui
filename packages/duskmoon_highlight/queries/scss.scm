; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(attribute_name) @property
(class_name) @type
(float_value) @number
(integer_value) @number
(property_name) @property
(string_value) @string
(at_keyword) @keyword
(comment) @comment
(function_name) @function
(identifier) @variable
(js_comment) @comment
(variable) @variable
"!=" @operator
"%" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"*=" @operator
"+" @operator
"," @punctuation.delimiter
"-" @operator
"." @punctuation.delimiter
"/" @operator
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
"and" @keyword
"from" @keyword
"if" @keyword
"in" @keyword
"not" @keyword
"or" @keyword
"{" @punctuation.bracket
"|" @operator
"}" @punctuation.bracket
"~" @operator
(function_statement name: (_) @function)

; Source: vendor/grammars/css/queries/highlights.scm

(comment) @comment

(tag_name) @tag

(nesting_selector) @tag

(universal_selector) @tag

"~" @operator

">" @operator

"+" @operator

"-" @operator

"*" @operator

"/" @operator

"=" @operator

"^=" @operator

"|=" @operator

"~=" @operator

"$=" @operator

"*=" @operator

"and" @operator

"or" @operator

"not" @operator

"only" @operator

(attribute_selector (plain_value) @string)

((property_name) @variable
 (#match? @variable "^--"))

((plain_value) @variable
 (#match? @variable "^--"))

(class_name) @property

(id_name) @property

(namespace_name) @property

(property_name) @property

(feature_name) @property

(pseudo_element_selector (tag_name) @attribute)

(pseudo_class_selector (class_name) @attribute)

(attribute_name) @attribute

(function_name) @function

"@media" @keyword

"@import" @keyword

"@charset" @keyword

"@namespace" @keyword

"@supports" @keyword

"@keyframes" @keyword

(at_keyword) @keyword

(to) @keyword

(from) @keyword

(important) @keyword

(string_value) @string

(color_value) @string.special

(integer_value) @number

(float_value) @number

(unit) @type

[
  "#"
  ","
  "."
  ":"
  "::"
  ";"
] @punctuation.delimiter

[
  "{"
  ")"
  "("
  "}"
] @punctuation.bracket

; Source: vendor/grammars/scss/queries/highlights.scm

[
  "@at-root"
  "@debug"
  "@error"
  "@extend"
  "@forward"
  "@mixin"
  "@use"
  "@warn"
] @keyword

"@function" @keyword.function

"@return" @keyword.return

"@include" @keyword.import

[
  "@while"
  "@each"
  "@for"
  "from"
  "through"
  "in"
] @keyword.repeat

(js_comment) @comment @spell

(function_name) @function

[
  ">="
  "<="
] @operator

(mixin_statement
  name: (identifier) @function)

(mixin_statement
  (parameters
    (parameter) @variable.parameter))

(function_statement
  name: (identifier) @function)

(function_statement
  (parameters
    (parameter) @variable.parameter))

(plain_value) @string

(keyword_query) @function

(identifier) @variable

(variable) @variable

(argument) @variable.parameter

(arguments
  (variable) @variable.parameter)

[
  "["
  "]"
] @punctuation.bracket

(include_statement
  (identifier) @function)
