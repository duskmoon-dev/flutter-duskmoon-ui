; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(bin_val) @number
(case_insensitive_string) @string
(case_sensitive_string) @string
(core_rulename) @type.builtin
(dec_val) @number
(hex_val) @number
(num_val) @number
(quoted_string) @string
(comment) @comment
(rulename) @type
"%" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"-" @operator
"." @punctuation.delimiter
"/" @operator
"<" @operator
"=" @operator
">" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
