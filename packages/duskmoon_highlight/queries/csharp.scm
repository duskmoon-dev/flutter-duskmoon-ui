; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(boolean_literal) @boolean
(identifier) @variable
(interpolated_string_expression) @string
(raw_string_literal) @string
(string_literal) @string
(comment) @comment
(escape_sequence) @string.escape
(integer_literal) @number
(null_literal) @constant.null
(predefined_type) @type
(raw_string_content) @string
(raw_string_end) @string
(raw_string_start) @string
(string_content) @string
(string_literal_content) @string
(string_literal_encoding) @string
(verbatim_string_literal) @string
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
"=>" @operator
">" @operator
">=" @operator
"??" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"abstract" @keyword
"alias" @keyword
"and" @keyword
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
"extern" @keyword
"false" @keyword
"finally" @keyword
"for" @keyword
"foreach" @keyword
"from" @keyword
"if" @keyword
"in" @keyword
"interface" @keyword
"is" @keyword
"let" @keyword
"module" @keyword
"namespace" @keyword
"new" @keyword
"not" @keyword
"or" @keyword
"private" @keyword
"protected" @keyword
"public" @keyword
"return" @keyword
"select" @keyword
"static" @keyword
"struct" @keyword
"switch" @keyword
"this" @keyword
"throw" @keyword
"true" @keyword
"try" @keyword
"type" @keyword
"using" @keyword
"var" @keyword
"virtual" @keyword
"when" @keyword
"where" @keyword
"while" @keyword
"with" @keyword
"yield" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(class_declaration name: (_) @type)
(constructor_declaration name: (_) @type)
(destructor_declaration name: (_) @type)
(enum_declaration name: (_) @type)
(enum_member_declaration name: (_) @type)
(interface_declaration name: (_) @type)
(local_function_statement name: (_) @function)
(method_declaration name: (_) @function)
(struct_declaration name: (_) @type)

; Source: vendor/grammars/csharp/queries/highlights.scm

(identifier) @variable

;; Methods

(method_declaration name: (identifier) @function)

(local_function_statement name: (identifier) @function)

;; Types

(interface_declaration name: (identifier) @type)

(class_declaration name: (identifier) @type)

(enum_declaration name: (identifier) @type)

(struct_declaration (identifier) @type)

(record_declaration (identifier) @type)

(namespace_declaration name: (identifier) @module)

(generic_name (identifier) @type)

(type_parameter (identifier) @property.definition)

(parameter type: (identifier) @type)

(type_argument_list (identifier) @type)

(as_expression right: (identifier) @type)

(is_expression right: (identifier) @type)

(constructor_declaration name: (identifier) @constructor)

(destructor_declaration name: (identifier) @constructor)

(_ type: (identifier) @type)

(base_list (identifier) @type)

(predefined_type) @type.builtin

;; Enum

(enum_member_declaration (identifier) @property.definition)

;; Literals

[
  (real_literal)
  (integer_literal)
] @number

[
  (character_literal)
  (string_literal)
  (raw_string_literal)
  (verbatim_string_literal)
  (interpolated_string_expression)
  (interpolation_start)
  (interpolation_quote)
 ] @string

(escape_sequence) @string.escape

[
  (boolean_literal)
  (null_literal)
] @constant.builtin

;; Comments

(comment) @comment

;; Tokens

[
  ";"
  "."
  ","
] @punctuation.delimiter

[
  "--"
  "-"
  "-="
  "&"
  "&="
  "&&"
  "+"
  "++"
  "+="
  "<"
  "<="
  "<<"
  "<<="
  "="
  "=="
  "!"
  "!="
  "=>"
  ">"
  ">="
  ">>"
  ">>="
  ">>>"
  ">>>="
  "|"
  "|="
  "||"
  "?"
  "??"
  "??="
  "^"
  "^="
  "~"
  "*"
  "*="
  "/"
  "/="
  "%"
  "%="
  ":"
  ".."
] @operator

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  (interpolation_brace)
]  @punctuation.bracket

;; Keywords

[
  (modifier)
  "this"
  (implicit_type)
] @keyword

[
  "add"
  "alias"
  "as"
  "base"
  "break"
  "case"
  "catch"
  "checked"
  "class"
  "continue"
  "default"
  "delegate"
  "do"
  "else"
  "enum"
  "event"
  "explicit"
  "extern"
  "finally"
  "for"
  "foreach"
  "global"
  "goto"
  "if"
  "implicit"
  "interface"
  "is"
  "lock"
  "namespace"
  "notnull"
  "operator"
  "params"
  "return"
  "remove"
  "sizeof"
  "stackalloc"
  "static"
  "struct"
  "switch"
  "throw"
  "try"
  "typeof"
  "unchecked"
  "using"
  "while"
  "new"
  "await"
  "in"
  "yield"
  "get"
  "set"
  "when"
  "out"
  "ref"
  "from"
  "where"
  "select"
  "record"
  "init"
  "with"
  "let"
  "unsafe"
] @keyword

;; Attribute

(attribute name: (identifier) @attribute)

;; Parameters

(parameter
  name: (identifier) @variable.parameter)

;; Type constraints

(type_parameter_constraints_clause (identifier) @property.definition)

;; Method calls

(invocation_expression (member_access_expression name: (identifier) @function))
