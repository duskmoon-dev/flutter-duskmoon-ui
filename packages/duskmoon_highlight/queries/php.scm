; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(boolean) @boolean
(encapsed_string) @string
(heredoc) @string
(heredoc_body) @string
(name) @variable
(null) @constant.null
(primitive_type) @type
(string) @string
(string_content) @string
(variable_name) @variable
(comment) @comment
(escape_sequence) @string.escape
(float) @number
(heredoc_end) @string
(heredoc_start) @string
(integer) @number
(nowdoc_string) @string
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
"??" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"abstract" @keyword
"and" @keyword
"as" @keyword
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
"extends" @keyword
"final" @keyword
"finally" @keyword
"fn" @keyword
"for" @keyword
"foreach" @keyword
"function" @keyword
"if" @keyword
"include" @keyword
"interface" @keyword
"match" @keyword
"namespace" @keyword
"new" @keyword
"or" @keyword
"private" @keyword
"protected" @keyword
"public" @keyword
"return" @keyword
"static" @keyword
"switch" @keyword
"throw" @keyword
"trait" @keyword
"try" @keyword
"use" @keyword
"while" @keyword
"yield" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(class_declaration name: (_) @type)
(enum_case name: (_) @type)
(enum_declaration name: (_) @type)
(function_call_expression function: (_) @function)
(function_definition name: (_) @function)
(interface_declaration name: (_) @type)
(member_call_expression name: (_) @function)
(method_declaration name: (_) @function)
(nullsafe_member_call_expression name: (_) @function)
(scoped_call_expression name: (_) @function)

; Source: vendor/grammars/php/queries/highlights.scm

[
  (php_tag)
  (php_end_tag)
] @tag

; Keywords

[
  "and"
  "as"
  "break"
  "case"
  "catch"
  "class"
  "clone"
  "const"
  "continue"
  "declare"
  "default"
  "do"
  "echo"
  "else"
  "elseif"
  "enddeclare"
  "endfor"
  "endforeach"
  "endif"
  "endswitch"
  "endwhile"
  "enum"
  "exit"
  "extends"
  "finally"
  "fn"
  "for"
  "foreach"
  "function"
  "global"
  "goto"
  "if"
  "implements"
  "include"
  "include_once"
  "instanceof"
  "insteadof"
  "interface"
  "match"
  "namespace"
  "new"
  "or"
  "print"
  "require"
  "require_once"
  "return"
  "switch"
  "throw"
  "trait"
  "try"
  "use"
  "while"
  "xor"
  "yield"
  "yield from"
  (abstract_modifier)
  (final_modifier)
  (readonly_modifier)
  (static_modifier)
  (visibility_modifier)
] @keyword

(function_static_declaration "static" @keyword)

; Namespace

(namespace_definition
  name: (namespace_name
    (name) @module))

(namespace_name
  (name) @module)

(namespace_use_clause
  [
    (name) @type
    (qualified_name
      (name) @type)
    alias: (name) @type
  ])

(namespace_use_clause
  type: "function"
  [
    (name) @function
    (qualified_name
      (name) @function)
    alias: (name) @function
  ])

(namespace_use_clause
  type: "const"
  [
    (name) @constant
    (qualified_name
      (name) @constant)
    alias: (name) @constant
  ])

(relative_name "namespace" @module.builtin)

; Variables

(relative_scope) @variable.builtin

(variable_name) @variable

(method_declaration name: (name) @constructor
  (#eq? @constructor "__construct"))

(object_creation_expression [
  (name) @constructor
  (qualified_name (name) @constructor)
  (relative_name (name) @constructor)
])

((name) @constant
 (#match? @constant "^_?[A-Z][A-Z\\d_]+$"))

((name) @constant.builtin
 (#match? @constant.builtin "^__[A-Z][A-Z\d_]+__$"))

(const_declaration (const_element (name) @constant))

; Types

(primitive_type) @type.builtin

(cast_type) @type.builtin

(named_type [
  (name) @type
  (qualified_name (name) @type)
  (relative_name (name) @type)
]) @type

(named_type (name) @type.builtin
  (#any-of? @type.builtin "static" "self"))

(scoped_call_expression
  scope: [
    (name) @type
    (qualified_name (name) @type)
    (relative_name (name) @type)
  ])

; Functions

(array_creation_expression "array" @function.builtin)

(list_literal "list" @function.builtin)

(exit_statement "exit" @function.builtin "(")

(method_declaration
  name: (name) @function.method)

(function_call_expression
  function: [
    (qualified_name (name))
    (relative_name (name))
    (name)
  ] @function)

(scoped_call_expression
  name: (name) @function)

(member_call_expression
  name: (name) @function.method)

(function_definition
  name: (name) @function)

; Member

(property_element
  (variable_name) @property)

(member_access_expression
  name: (variable_name (name)) @property)

(member_access_expression
  name: (name) @property)

; Basic tokens

[
  (string)
  (string_content)
  (encapsed_string)
  (heredoc)
  (heredoc_body)
  (nowdoc_body)
] @string

(boolean) @constant.builtin

(null) @constant.builtin

(integer) @number

(float) @number

(comment) @comment

((name) @variable.builtin
 (#eq? @variable.builtin "this"))

"$" @operator
