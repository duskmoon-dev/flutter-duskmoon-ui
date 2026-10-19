; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(quoted_attribute_value) @string
(attribute_name) @property
(comment) @comment
"<" @operator
"=" @operator
">" @operator

; Source: vendor/grammars/html/queries/highlights.scm

(tag_name) @tag

(erroneous_end_tag_name) @tag.error

(doctype) @constant

(attribute_name) @attribute

(attribute_value) @string

(comment) @comment

[
  "<"
  ">"
  "</"
  "/>"
] @punctuation.bracket
