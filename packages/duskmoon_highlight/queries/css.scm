; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(attribute_name) @property
(class_name) @type
(float_value) @number
(integer_value) @number
(string_value) @string
(at_keyword) @keyword
(comment) @comment
(escape_sequence) @string.escape
(function_name) @function
(identifier) @variable
(js_comment) @comment
(property_name) @property
(string_content) @string
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
"=" @operator
">" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"and" @keyword
"not" @keyword
"of" @keyword
"or" @keyword
"{" @punctuation.bracket
"|" @operator
"}" @punctuation.bracket
"~" @operator

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
