; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(identifier) @variable
(predefined_type) @type
(regex) @string.regexp
(string) @string
(template_string) @string
(comment) @comment
(escape_sequence) @string.escape
(false) @boolean
(html_comment) @comment
(null) @constant.null
(number) @number
(property_identifier) @property
(regex_pattern) @string.regexp
(string_fragment) @string
(true) @boolean
(type_identifier) @type
"!" @operator
"!=" @operator
"!==" @operator
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
"." @punctuation.delimiter
"/" @operator
"/=" @operator
":" @punctuation.delimiter
";" @punctuation.delimiter
"<" @operator
"<=" @operator
"=" @operator
"==" @operator
"===" @operator
"=>" @operator
">" @operator
">=" @operator
"?." @operator
"??" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"abstract" @keyword
"as" @keyword
"async" @keyword
"await" @keyword
"break" @keyword
"case" @keyword
"catch" @keyword
"class" @keyword
"const" @keyword
"continue" @keyword
"default" @keyword
"do" @keyword
"else" @keyword
"enum" @keyword
"export" @keyword
"extends" @keyword
"finally" @keyword
"for" @keyword
"from" @keyword
"function" @keyword
"if" @keyword
"import" @keyword
"in" @keyword
"interface" @keyword
"is" @keyword
"let" @keyword
"module" @keyword
"namespace" @keyword
"new" @keyword
"of" @keyword
"private" @keyword
"protected" @keyword
"public" @keyword
"return" @keyword
"static" @keyword
"switch" @keyword
"throw" @keyword
"try" @keyword
"type" @keyword
"using" @keyword
"var" @keyword
"void" @keyword
"while" @keyword
"with" @keyword
"yield" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(abstract_class_declaration name: (_) @type)
(abstract_method_signature name: (_) @function)
(call_expression function: (_) @function)
(class name: (_) @type)
(class_declaration name: (_) @type)
(enum_assignment name: (_) @type)
(enum_body name: (_) @type)
(enum_declaration name: (_) @type)
(function_declaration name: (_) @function)
(function_expression name: (_) @function)
(function_signature name: (_) @function)
(generator_function name: (_) @function)
(generator_function_declaration name: (_) @function)
(interface_declaration name: (_) @type)
(method_definition name: (_) @function)
(method_signature name: (_) @function)
(type_alias_declaration name: (_) @type)

; Source: vendor/grammars/javascript/queries/highlights.scm

(identifier) @variable

; Properties
;-----------

(property_identifier) @property

; Function and method definitions
;--------------------------------

(function_expression
  name: (identifier) @function)

(function_declaration
  name: (identifier) @function)

(method_definition
  name: (property_identifier) @function.method)

(pair
  key: (property_identifier) @function.method
  value: [(function_expression) (arrow_function)])

(assignment_expression
  left: (member_expression
    property: (property_identifier) @function.method)
  right: [(function_expression) (arrow_function)])

(variable_declarator
  name: (identifier) @function
  value: [(function_expression) (arrow_function)])

(assignment_expression
  left: (identifier) @function
  right: [(function_expression) (arrow_function)])

; Function and method calls
;--------------------------

(call_expression
  function: (identifier) @function)

(call_expression
  function: (member_expression
    property: (property_identifier) @function.method))

; Special identifiers
;--------------------

((identifier) @constructor
 (#match? @constructor "^[A-Z]"))

([
    (identifier)
    (shorthand_property_identifier)
    (shorthand_property_identifier_pattern)
 ] @constant
 (#match? @constant "^[A-Z_][A-Z\\d_]+$"))

(this) @variable.builtin

(super) @variable.builtin

[
  (true)
  (false)
  (null)
  (undefined)
] @constant.builtin

(comment) @comment

[
  (string)
  (template_string)
] @string

(regex) @string.special

(number) @number

; Tokens
;-------

[
  ";"
  (optional_chain)
  "."
  ","
] @punctuation.delimiter

[
  "-"
  "--"
  "-="
  "+"
  "++"
  "+="
  "*"
  "*="
  "**"
  "**="
  "/"
  "/="
  "%"
  "%="
  "<"
  "<="
  "<<"
  "<<="
  "="
  "=="
  "==="
  "!"
  "!="
  "!=="
  "=>"
  ">"
  ">="
  ">>"
  ">>="
  ">>>"
  ">>>="
  "~"
  "^"
  "&"
  "|"
  "^="
  "&="
  "|="
  "&&"
  "||"
  "??"
  "&&="
  "||="
  "??="
] @operator

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
]  @punctuation.bracket

(template_substitution
  "${" @punctuation.special
  "}" @punctuation.special) @embedded

[
  "as"
  "async"
  "await"
  "break"
  "case"
  "catch"
  "class"
  "const"
  "continue"
  "debugger"
  "default"
  "delete"
  "do"
  "else"
  "export"
  "extends"
  "finally"
  "for"
  "from"
  "function"
  "get"
  "if"
  "import"
  "in"
  "instanceof"
  "let"
  "new"
  "of"
  "return"
  "set"
  "static"
  "switch"
  "target"
  "throw"
  "try"
  "typeof"
  "var"
  "void"
  "while"
  "with"
  "yield"
] @keyword

; Source: vendor/grammars/javascript/queries/highlights-jsx.scm

(jsx_opening_element (identifier) @tag (#match? @tag "^[a-z][^.]*$"))

(jsx_closing_element (identifier) @tag (#match? @tag "^[a-z][^.]*$"))

(jsx_self_closing_element (identifier) @tag (#match? @tag "^[a-z][^.]*$"))

(jsx_attribute (property_identifier) @attribute)

(jsx_opening_element (["<" ">"]) @punctuation.bracket)

(jsx_closing_element (["</" ">"]) @punctuation.bracket)

(jsx_self_closing_element (["<" "/>"]) @punctuation.bracket)

; Source: vendor/grammars/typescript/queries/highlights.scm

(type_identifier) @type

(predefined_type) @type.builtin

((identifier) @type
 (#match? @type "^[A-Z]"))

(type_arguments
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

; Variables

(required_parameter (identifier) @variable.parameter)

(optional_parameter (identifier) @variable.parameter)

; Keywords

[ "abstract"
  "declare"
  "enum"
  "export"
  "implements"
  "interface"
  "keyof"
  "namespace"
  "private"
  "protected"
  "public"
  "type"
  "readonly"
  "override"
  "satisfies"
] @keyword

; Source: vendor/grammars/tsx/queries/highlights.scm

(type_identifier) @type

(predefined_type) @type.builtin

((identifier) @type
 (#match? @type "^[A-Z]"))

(type_arguments
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

; Variables

(required_parameter (identifier) @variable.parameter)

(optional_parameter (identifier) @variable.parameter)

; Keywords

[ "abstract"
  "declare"
  "enum"
  "export"
  "implements"
  "interface"
  "keyof"
  "namespace"
  "private"
  "protected"
  "public"
  "type"
  "readonly"
  "override"
  "satisfies"
] @keyword
