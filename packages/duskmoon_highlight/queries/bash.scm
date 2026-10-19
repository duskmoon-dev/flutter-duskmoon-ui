; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(command_name) @function
(heredoc_body) @string
(heredoc_redirect) @string
(herestring_redirect) @string
(number) @number
(string) @string
(translated_string) @string
(ansi_c_string) @string
(comment) @comment
(heredoc_content) @string
(heredoc_end) @string
(heredoc_start) @string
(raw_string) @string
(regex) @string.regexp
(string_content) @string
(variable_name) @variable
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
"/" @operator
"/=" @operator
":" @punctuation.delimiter
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
"case" @keyword
"do" @keyword
"done" @keyword
"elif" @keyword
"else" @keyword
"export" @keyword
"for" @keyword
"function" @keyword
"if" @keyword
"in" @keyword
"local" @keyword
"select" @keyword
"then" @keyword
"while" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(function_definition name: (_) @function)

; Source: vendor/grammars/bash/queries/highlights.scm

[
  (string)
  (raw_string)
  (heredoc_body)
  (heredoc_start)
] @string

(command_name) @function

(variable_name) @property

[
  "case"
  "do"
  "done"
  "elif"
  "else"
  "esac"
  "export"
  "fi"
  "for"
  "function"
  "if"
  "in"
  "select"
  "then"
  "unset"
  "until"
  "while"
] @keyword

(comment) @comment

(function_definition name: (word) @function)

(file_descriptor) @number

[
  (command_substitution)
  (process_substitution)
  (expansion)
]@embedded

[
  "$"
  "&&"
  ">"
  ">>"
  "<"
  "|"
] @operator

(
  (command (_) @constant)
  (#match? @constant "^-")
)
