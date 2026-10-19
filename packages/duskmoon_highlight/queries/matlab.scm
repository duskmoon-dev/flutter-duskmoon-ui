; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(end_keyword) @keyword
(identifier) @variable
(number) @number
(property_name) @property
(string) @string
(command_name) @function
(comment) @comment
(escape_sequence) @string.escape
(string_content) @string
"&" @operator
"&&" @operator
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
"catch" @keyword
"continue" @keyword
"else" @keyword
"end" @keyword
"for" @keyword
"function" @keyword
"if" @keyword
"return" @keyword
"switch" @keyword
"try" @keyword
"while" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(class_definition name: (_) @type)
(function_call name: (_) @function)
(function_definition name: (_) @function)
(function_signature name: (_) @function)
(methods name: (_) @function)

; Source: vendor/grammars/matlab/queries/helix/highlights.scm

(events (identifier) @constant)

(attribute (identifier) @constant)

"~" @constant.builtin

; Fields/Properties

(superclass "." (identifier) @variable.other.member)

(property_name "." (identifier) @variable.other.member)

(property name: (identifier) @variable.other.member)

; Types

(class_definition name: (identifier) @keyword.storage.type)

(attributes (identifier) @constant)

(enum . (identifier) @type.enum.variant)

; Functions

(function_definition
  "function" @keyword.function
  name: (identifier) @function
  [ "end" "endfunction" ]? @keyword.function)

(function_signature name: (identifier) @function)

(function_call name: (identifier) @function)

(handle_operator (identifier) @function)

(validation_functions (identifier) @function)

(command (command_name) @function.macro)

(command_argument) @string

(return_statement) @keyword.control.return

; Assignments

(assignment left: (_) @variable)

(multioutput_variable (_) @variable)

; Parameters

(function_arguments (identifier) @variable.parameter)

; Conditionals

(if_statement [ "if" "end" ] @keyword.control.conditional)

(elseif_clause "elseif" @keyword.control.conditional)

(else_clause "else" @keyword.control.conditional)

(switch_statement [ "switch" "end" ] @keyword.control.conditional)

(case_clause "case" @keyword.control.conditional)

(otherwise_clause "otherwise" @keyword.control.conditional)

(break_statement) @keyword.control.conditional

; Repeats

(for_statement [ "for" "parfor" "end" ] @keyword.control.repeat)

(while_statement [ "while" "end" ] @keyword.control.repeat)

(continue_statement) @keyword.control.repeat

; Exceptions

(try_statement [ "try" "end" ] @keyword.control.exception)

(catch_clause "catch" @keyword.control.exception)

; Punctuation

[ ";" "," "." ] @punctuation.delimiter

[ "(" ")" "[" "]" "{" "}" ] @punctuation.bracket

; Literals

(escape_sequence) @constant.character.escape

(formatting_sequence) @constant.character.escape

(string) @string

(number) @constant.numeric.float

(unary_operator ["+" "-"] @constant.numeric.float)

; Comments

[ (comment) (line_continuation) ] @comment.line

; Operators

[
  "+"
  ".+"
  "-"
  ".*"
  "*"
  ".*"
  "/"
  "./"
  "\\"
  ".\\"
  "^"
  ".^"
  "'"
  ".'"
  "|"
  "&"
  "?"
  "@"
  "<"
  "<="
  ">"
  ">="
  "=="
  "~="
  "="
  "&&"
  "||"
  ":"
] @operator

; Keywords

"classdef" @keyword.storage.type

[
  "arguments"
  "end"
  "enumeration"
  "events"
  "global"
  "methods"
  "persistent"
  "properties"
] @keyword
