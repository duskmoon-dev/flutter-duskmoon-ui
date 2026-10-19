; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(info_string) @string
(numeric_character_reference) @number
"!" @operator
"%" @operator
"&" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"+" @operator
"," @punctuation.delimiter
"-" @operator
"." @punctuation.delimiter
"/" @operator
":" @punctuation.delimiter
";" @punctuation.delimiter
"<" @operator
"=" @operator
">" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"{" @punctuation.bracket
"|" @operator
"}" @punctuation.bracket
"~" @operator

; Source: vendor/grammars/markdown/tree-sitter-markdown/queries/highlights.scm

(atx_heading
  (inline) @text.title)

(setext_heading
  (paragraph) @text.title)

[
  (atx_h1_marker)
  (atx_h2_marker)
  (atx_h3_marker)
  (atx_h4_marker)
  (atx_h5_marker)
  (atx_h6_marker)
  (setext_h1_underline)
  (setext_h2_underline)
] @punctuation.special

[
  (link_title)
  (indented_code_block)
  (fenced_code_block)
] @text.literal

(fenced_code_block_delimiter) @punctuation.delimiter

(code_fence_content) @none

(link_destination) @text.uri

(link_label) @text.reference

[
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
  (thematic_break)
] @punctuation.special

[
  (block_continuation)
  (block_quote_marker)
] @punctuation.special

(backslash_escape) @string.escape
