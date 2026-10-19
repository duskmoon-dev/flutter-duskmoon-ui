; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(class_name) @type
(comment) @comment
(comment_condition) @comment
(quoted_attribute_value) @string
(attribute_name) @property
(verbatim_string) @string
"!=" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"," @punctuation.delimiter
"-" @operator
"." @punctuation.delimiter
"/" @operator
":" @punctuation.delimiter
"=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket
"~" @operator

; Source: vendor/grammars/haml/queries/highlights.scm

[
  "="
  "-"
] @keyword

(attribute_name) @attribute

(tag_name) @tag

(class) @type

(comment) @comment

[
  (quoted_attribute_value)
] @string

(verbatim_string) @string
