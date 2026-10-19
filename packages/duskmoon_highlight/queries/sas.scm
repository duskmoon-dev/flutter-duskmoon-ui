; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(string_literal) @string
(block_comment) @comment
(identifier) @variable
(line_comment) @comment
(numeric_literal) @number
(percent_comment) @comment
"%" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"," @punctuation.delimiter
"." @punctuation.delimiter
"/" @operator
":" @punctuation.delimiter
";" @punctuation.delimiter
"=" @operator
(macro_call name: (_) @function)
(macro_call_statement name: (_) @function)

; Source: vendor/grammars/sas/queries/highlights.scm

(block_comment) @comment.block

(line_comment) @comment.line

(macro_definition) @function

(macro_name) @function.method

(macro_if_statement) @keyword.control

(macro_do_statement) @keyword.control

(macro_variable_assignment) @keyword

(macro_variable_ref) @variable

(numeric_literal) @constant.numeric

(string_literal) @string

(data_step_header) @keyword

(proc_step_header) @keyword

(run_statement) @keyword

(run_or_quit_statement) @keyword

(set_statement) @keyword

(merge_statement) @keyword

(update_statement) @keyword

(output_statement) @keyword

(macro_end) @keyword

(libname_statement) @keyword

(include_statement) @keyword

(options_statement) @keyword

(proc_sql_header) @keyword

(sql_create_statement) @keyword

(sql_select_statement) @keyword

(sql_insert_statement) @keyword

(sql_join_clause) @keyword
