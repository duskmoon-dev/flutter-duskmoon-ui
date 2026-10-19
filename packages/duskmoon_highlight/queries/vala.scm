; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(decimal_literal) @number
(regex_literal) @string.regexp
(string_literal) @string
(string_template) @string
(string_template_expression) @string
(string_template_variable) @string
(translation_string) @string
(comment) @comment
(escape_sequence) @string.escape
(false) @boolean
(identifier) @variable
(null) @constant.null
(number) @number
(primitive_type) @type
(regex_pattern) @string.regexp
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
";" @punctuation.delimiter
"<" @operator
"<=" @operator
"=" @operator
"==" @operator
"=>" @operator
">" @operator
">=" @operator
"??" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"abstract" @keyword
"as" @keyword
"async" @keyword
"break" @keyword
"case" @keyword
"catch" @keyword
"class" @keyword
"const" @keyword
"default" @keyword
"do" @keyword
"else" @keyword
"enum" @keyword
"extern" @keyword
"for" @keyword
"foreach" @keyword
"if" @keyword
"in" @keyword
"interface" @keyword
"is" @keyword
"namespace" @keyword
"new" @keyword
"private" @keyword
"protected" @keyword
"public" @keyword
"return" @keyword
"static" @keyword
"struct" @keyword
"switch" @keyword
"throw" @keyword
"try" @keyword
"using" @keyword
"var" @keyword
"virtual" @keyword
"while" @keyword
"yield" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(class_constructor_definition name: (_) @type)
(enum_declaration name: (_) @type)
(function_definition name: (_) @function)

; Source: vendor/grammars/vala/queries/highlights.scm

((identifier) @constant (#match? @constant "^[A-Z][A-Z\\d_]+$"))

(namespaced_identifier
  left: [
    ; Lowercased names in lhs typically are variables, while camel cased are namespaces
    ((identifier) @namespace (#match? @namespace "^[A-Z]+[a-z]+$"))
    ((identifier) @variable (#match? @variable "^[a-z]"))
    (_)
  ]
  right: [
    ; Lowercased are variables, camel cased are types
    ((identifier) @parameter (#match? @parameter "^[a-z]"))
    ((identifier) @type (#match? @type "^[A-Z]+[a-z]+$"))
    (_)
  ]
)

((identifier) @constructor (#match? @constructor "^[A-Z]*[a-z]+"))

; Pointers

(address_of_identifier "&" @symbol)

(pointer_type "*" @symbol)

(indirection_identifier "*" @symbol)

; Misc

(number) @number

[
  "{"
  "}"
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

[
  ";"
  ":"
  "."
  ","
  "->"
] @punctuation.delimiter

; Reserved keywords

[
  "return" 
  "yield"
  "break"
] @keyword.return

(null) @constant.builtin

[
  "typeof"
  "is"
] @keyword.operator

[
  (modifier)
  "var"
  "class"
  "interface"
  (property_parameter)
  (this)
  "enum"
  "new"
  "in"
  "as"
  "try"
  "catch"
  "requires"
  "ensures"
  "owned"
  "throws"
  "delete"
  "#if"
  "#elif"
  (preproc_else)
  (preproc_endif)
] @keyword

"throw" @exception

[
  "if"
  "else"
  "switch"
  "case"
  "default"
] @conditional

[
  "for"
  "foreach"
  "while"
  "do"
] @repeat

[
  (true)
  (false)
] @boolean

; Operators

(binary_expression
  [
    "*"
    "/"
    "+"
    "-"
    "%"
    "<"
    "<="
    ">"
    ">="
    "=="
    "!="
    "+="
    "-="
    "*="
    "/="
    "%="
    "&&"
    "||"
    "&"
    "|"
    "^"
    "~"
    "|="
    "&="
    "^="
    "??"
    "="
  ] @operator    
)

(unary_expression
  [
    "-"
    "!"
    "--"
    "++"
  ] @operator
)

; Declaration

(declaration
  type_name: (_) @type
)

; Methods

(function_definition
  type: (_) @type
  name: [
  	(identifier) @method
    (generic_identifier (_) @type) 
  ]
)

(function_call
  identifier: [
  	(identifier) @method
    (generic_identifier (_) @type) 
  ]
)

(member_function
  identifier: [
  	(identifier) @method
    (generic_identifier (_) @type)
  ]
)

; Types

(primitive_type) @type

(nullable_type
    (_) @type
    "?" @symbol
)

; Comments

(comment) @comment

; Namespace

(namespace
  "namespace" @include
  (_) @namespace
)

"global::" @namespace

(using 
  "using" @include
  (_) @namespace
)

; Classes

(class_declaration) @type

(class_constructor_definition
  name: [
    (_)
    (namespaced_identifier (_) @constructor .)
  ] @constructor
)

(class_destructor
  "~" @symbol
  (_) @constructor
)

; Interfaces

(interface_declaration) @type

; Strings and escape sequences

(string_literal) @string

(verbatim) @string

(escape_sequence) @string.escape

(string_template
  "@" @symbol
) @string

(string_template_variable) @variable

(string_template_expression) @variable

; New instance from Object

(new_instance
  "new" @keyword
)

; GObject construct

(gobject_construct 
  "construct" @keyword
)

; Try statement

(try_statement
  exception: (parameter_list (declaration_parameter
    (_) @exception
    (_) @variable
  ))
)

; Enum

(enum_declaration
    name: (identifier) @type
)

; Loop

(foreach_statement
  loop_item: (identifier) @variable
)

; Casting

(static_cast
  type: (_) @type
)

(dynamic_cast
  type: (_) @type
)

; Regex

(regex_literal) @string.regex

; Code attribute

(code_attribute
  name: (identifier) @attribute
  param: (_) @attribute
) @attribute
