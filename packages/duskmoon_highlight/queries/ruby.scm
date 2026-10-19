; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(_simple_numeric) @number
(bare_string) @string
(chained_string) @string
(heredoc_body) @string
(identifier) @variable
(nil) @constant.null
(regex) @string.regexp
(string) @string
(string_array) @string
(comment) @comment
(escape_sequence) @string.escape
(false) @boolean
(float) @number
(heredoc_beginning) @string
(heredoc_content) @string
(heredoc_end) @string
(integer) @number
(string_content) @string
(true) @boolean
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
"===" @operator
"=>" @operator
">" @operator
">=" @operator
"BEGIN" @keyword
"END" @keyword
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"alias" @keyword
"and" @keyword
"begin" @keyword
"break" @keyword
"case" @keyword
"class" @keyword
"def" @keyword
"do" @keyword
"else" @keyword
"elsif" @keyword
"end" @keyword
"for" @keyword
"if" @keyword
"in" @keyword
"module" @keyword
"not" @keyword
"or" @keyword
"return" @keyword
"then" @keyword
"when" @keyword
"while" @keyword
"yield" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(call method: (_) @function)
(class name: (_) @type)
(method name: (_) @function)
(singleton_method name: (_) @function)

; Source: vendor/grammars/ruby/queries/highlights.scm

(identifier) @variable

[
  "alias"
  "and"
  "begin"
  "break"
  "case"
  "class"
  "def"
  "do"
  "else"
  "elsif"
  "end"
  "ensure"
  "for"
  "if"
  "in"
  "module"
  "next"
  "or"
  "rescue"
  "retry"
  "return"
  "then"
  "unless"
  "until"
  "when"
  "while"
  "yield"
] @keyword

((identifier) @keyword
 (#match? @keyword "^(private|protected|public)$"))

(constant) @constructor

; Function calls

"defined?" @function.method.builtin

(call
  method: [(identifier) (constant)] @function.method)

((identifier) @function.method.builtin
 (#eq? @function.method.builtin "require"))

; Function definitions

(alias (identifier) @function.method)

(setter (identifier) @function.method)

(method name: [(identifier) (constant)] @function.method)

(singleton_method name: [(identifier) (constant)] @function.method)

; Identifiers

[
  (class_variable)
  (instance_variable)
] @property

((identifier) @constant.builtin
 (#match? @constant.builtin "^__(FILE|LINE|ENCODING)__$"))

(file) @constant.builtin

(line) @constant.builtin

(encoding) @constant.builtin

(hash_splat_nil
  "**" @operator) @constant.builtin

((constant) @constant
 (#match? @constant "^[A-Z\\d_]+$"))

[
  (self)
  (super)
] @variable.builtin

(block_parameter (identifier) @variable.parameter)

(block_parameters (identifier) @variable.parameter)

(destructured_parameter (identifier) @variable.parameter)

(hash_splat_parameter (identifier) @variable.parameter)

(lambda_parameters (identifier) @variable.parameter)

(method_parameters (identifier) @variable.parameter)

(splat_parameter (identifier) @variable.parameter)

(keyword_parameter name: (identifier) @variable.parameter)

(optional_parameter name: (identifier) @variable.parameter)

; Literals

[
  (string)
  (bare_string)
  (subshell)
  (heredoc_body)
  (heredoc_beginning)
] @string

[
  (simple_symbol)
  (delimited_symbol)
  (hash_key_symbol)
  (bare_symbol)
] @string.special.symbol

(regex) @string.special.regex

(escape_sequence) @escape

[
  (integer)
  (float)
] @number

[
  (nil)
  (true)
  (false)
] @constant.builtin

(interpolation
  "#{" @punctuation.special
  "}" @punctuation.special) @embedded

(comment) @comment

; Operators

[
"="
"=>"
"->"
] @operator

[
  ","
  ";"
  "."
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "%w("
  "%i("
] @punctuation.bracket
