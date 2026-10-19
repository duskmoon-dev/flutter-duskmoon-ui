; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(concatenated_string) @string
(null) @constant.null
(string_literal) @string
(comment) @comment
(escape_sequence) @string.escape
(false) @boolean
(field_identifier) @property
(identifier) @variable
(number_literal) @number
(primitive_type) @type
(string_content) @string
(system_lib_string) @string
(true) @boolean
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
">" @operator
">=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"break" @keyword
"case" @keyword
"const" @keyword
"continue" @keyword
"default" @keyword
"do" @keyword
"else" @keyword
"enum" @keyword
"extern" @keyword
"for" @keyword
"if" @keyword
"return" @keyword
"static" @keyword
"struct" @keyword
"switch" @keyword
"typedef" @keyword
"union" @keyword
"while" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(abstract_function_declarator declarator: (_) @function)
(call_expression function: (_) @function)
(enum_specifier name: (_) @type)
(enumerator name: (_) @type)
(function_declarator declarator: (_) @function)
(function_definition declarator: (_) @function)
(preproc_function_def name: (_) @function)
(struct_specifier name: (_) @type)

; Source: vendor/grammars/c/queries/highlights.scm

(identifier) @variable

((identifier) @constant
 (#match? @constant "^[A-Z][A-Z\\d_]*$"))

"break" @keyword

"case" @keyword

"const" @keyword

"continue" @keyword

"default" @keyword

"do" @keyword

"else" @keyword

"enum" @keyword

"extern" @keyword

"for" @keyword

"if" @keyword

"inline" @keyword

"return" @keyword

"sizeof" @keyword

"static" @keyword

"struct" @keyword

"switch" @keyword

"typedef" @keyword

"union" @keyword

"volatile" @keyword

"while" @keyword

"#define" @keyword

"#elif" @keyword

"#else" @keyword

"#endif" @keyword

"#if" @keyword

"#ifdef" @keyword

"#ifndef" @keyword

"#include" @keyword

(preproc_directive) @keyword

"--" @operator

"-" @operator

"-=" @operator

"->" @operator

"=" @operator

"!=" @operator

"*" @operator

"&" @operator

"&&" @operator

"+" @operator

"++" @operator

"+=" @operator

"<" @operator

"==" @operator

">" @operator

"||" @operator

"." @delimiter

";" @delimiter

(string_literal) @string

(system_lib_string) @string

(null) @constant

(number_literal) @number

(char_literal) @number

(field_identifier) @property

(statement_identifier) @label

(type_identifier) @type

(primitive_type) @type

(sized_type_specifier) @type

(call_expression
  function: (identifier) @function)

(call_expression
  function: (field_expression
    field: (field_identifier) @function))

(function_declarator
  declarator: (identifier) @function)

(preproc_function_def
  name: (identifier) @function.special)

(comment) @comment
