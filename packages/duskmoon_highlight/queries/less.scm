; DuskMoon Tree-sitter highlights. See grammar manifest for upstream provenance.

(at_keyword) @keyword

(attribute_name) @property

(class_name) @type

(float_value) @number

(function_name) @function

(identifier) @variable

(integer_value) @number

(keyword) @keyword

(property_name) @property

(string_value) @string

(variable) @variable

(comment) @comment

(variable_name) @variable

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

">" @operator

">=" @operator

"[" @punctuation.bracket

"]" @punctuation.bracket

"and" @keyword

"false" @keyword

"from" @keyword

"not" @keyword

"or" @keyword

"true" @keyword

"when" @keyword

"{" @punctuation.bracket

"}" @punctuation.bracket

"~" @operator

(call_expression name: (_) @function)

(class_selector name: (_) @type)

(pseudo_class_selector name: (_) @type)

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

(at_keyword) @keyword

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

; Source: vendor/grammars/less/queries/highlights.scm

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

(pseudo_element_selector (tag_name) @attribute)

(pseudo_class_selector (class_name) @attribute)

(class_name) @property

(id_name) @property

(namespace_name) @property

(property_name) @property

(feature_name) @property

(attribute_name) @attribute

(function_name) @function

((property_name) @variable
 (#match? @variable "^--"))

((plain_value) @variable
 (#match? @variable "^--"))

"@media" @keyword

"@import" @keyword

"@charset" @keyword

"@namespace" @keyword

"@supports" @keyword

(keyword) @keyword

(keyframes_statement (keyword) @keyword)

(at_keyword) @keyword

"to" @keyword

"from" @keyword

"!important" @keyword

(string_value) @string

(color_value) @string.special

(integer_value) @number

(float_value) @number

(unit) @type

[
 (color_value)]
@character

(string_value 
  (interpolated_variable) @string.escape)
@string

((property_name) @variable
 (#match? @variable "^--"))

((plain_value) @variable
 (#match? @variable "^--"))

(integer_value) @number

(float_value) @float

["true"
 "false"] @boolean

(variable_name) @variable

(params (variable) @parameter)

(params (keyword_param (variable) @parameter))

"#" @punctuation.delimiter

"," @punctuation.delimiter

":" @punctuation.delimiter
