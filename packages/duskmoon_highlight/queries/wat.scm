; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(comment_block) @comment
(comment_block_annot) @comment
(comment_line) @comment
(comment_line_annot) @comment
(float) @number
(int) @number
(name) @variable
(nat) @number
(op_const) @keyword
(op_func_bind) @keyword
(op_let) @keyword
(op_select) @keyword
(op_simd_const) @keyword
(op_simd_lane) @keyword
(op_table_copy) @keyword
(op_table_init) @keyword
(string) @string
(value_type) @type
(comment_block_inner) @comment
(dec_float) @number
(escape_sequence) @string.escape
(hex_float) @number
(identifier) @variable
(op_index) @keyword
(op_index_opt) @keyword
(op_index_opt_offset_opt_align_opt) @keyword
(op_nullary) @keyword
(op_simd_offset_opt_align_opt) @keyword
"(" @punctuation.bracket
")" @punctuation.bracket
"." @punctuation.delimiter
"=" @operator
"else" @keyword
"end" @keyword
"export" @keyword
"if" @keyword
"import" @keyword
"let" @keyword
"local" @keyword
"module" @keyword
"select" @keyword
"then" @keyword
"type" @keyword
