; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(FLOAT) @number
(IDENTIFIER) @variable
(INTEGER) @number
(LINESTRING) @string
(STRINGLITERALSINGLE) @string
(container_doc_comment) @comment
(doc_comment) @comment
(line_comment) @comment
"!" @operator
"!=" @operator
"%" @operator
"&" @operator
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
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"and" @keyword
"async" @keyword
"await" @keyword
"break" @keyword
"catch" @keyword
"const" @keyword
"continue" @keyword
"defer" @keyword
"else" @keyword
"enum" @keyword
"export" @keyword
"extern" @keyword
"false" @keyword
"fn" @keyword
"for" @keyword
"if" @keyword
"or" @keyword
"pub" @keyword
"return" @keyword
"struct" @keyword
"switch" @keyword
"true" @keyword
"try" @keyword
"union" @keyword
"var" @keyword
"while" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator

; Source: vendor/grammars/zig/queries/highlights.scm

[
  (container_doc_comment)
  (doc_comment)
  (line_comment)
] @comment @spell

[
  variable: (IDENTIFIER)
  variable_type_function: (IDENTIFIER)
] @variable

parameter:

(IDENTIFIER) @parameter

[
  field_member: (IDENTIFIER)
  field_access: (IDENTIFIER)
] @field

;; assume TitleCase is a type

(
  [
    variable_type_function: (IDENTIFIER)
    field_access: (IDENTIFIER)
    parameter: (IDENTIFIER)
  ] @type
  (#match? @type "^[A-Z]([a-z]+[A-Za-z0-9]*)*$")
)
;; assume camelCase is a function

(
  [
    variable_type_function: (IDENTIFIER)
    field_access: (IDENTIFIER)
    parameter: (IDENTIFIER)
  ] @function
  (#match? @function "^[a-z]+([A-Z][a-z0-9]*)+$")
)

;; assume all CAPS_1 is a constant

(
  [
    variable_type_function: (IDENTIFIER)
    field_access: (IDENTIFIER)
  ] @constant
  (#match? @constant "^[A-Z][A-Z_0-9]+$")
)

[
  function_call: (IDENTIFIER)
  function: (IDENTIFIER)
] @function

exception:

"!" @exception

(
  (IDENTIFIER) @variable.builtin
  (#eq? @variable.builtin "_")
)

(PtrTypeStart "c" @variable.builtin)

(
  (ContainerDeclType
    [
      (ErrorUnionExpr)
      "enum"
    ]
  )
  (ContainerField (IDENTIFIER) @constant)
)

field_constant:

(IDENTIFIER) @constant

(BUILTINIDENTIFIER) @function.builtin

((BUILTINIDENTIFIER) @include
  (#any-of? @include "@import" "@cImport"))

(INTEGER) @number

(FLOAT) @float

[
  "true"
  "false"
] @boolean

[
  (LINESTRING)
  (STRINGLITERALSINGLE)
] @string @spell

(CHAR_LITERAL) @character

(EscapeSequence) @string.escape

(FormatSequence) @string.special

(BreakLabel (IDENTIFIER) @label)

(BlockLabel (IDENTIFIER) @label)

[
  "asm"
  "defer"
  "errdefer"
  "test"
  "struct"
  "union"
  "enum"
  "opaque"
  "error"
] @keyword

[
  "async"
  "await"
  "suspend"
  "nosuspend"
  "resume"
] @keyword.coroutine

[
  "fn"
] @keyword.function

[
  "and"
  "or"
  "orelse"
] @keyword.operator

[
  "return"
] @keyword.return

[
  "if"
  "else"
  "switch"
] @conditional

[
  "for"
  "while"
  "break"
  "continue"
] @repeat

[
  "usingnamespace"
] @include

[
  "try"
  "catch"
] @exception

[
  "anytype"
  (BuildinTypeExpr)
] @type.builtin

[
  "const"
  "var"
  "volatile"
  "allowzero"
  "noalias"
] @type.qualifier

[
  "addrspace"
  "align"
  "callconv"
  "linksection"
] @storageclass

[
  "comptime"
  "export"
  "extern"
  "inline"
  "noinline"
  "packed"
  "pub"
  "threadlocal"
] @attribute

[
  "null"
  "unreachable"
  "undefined"
] @constant.builtin

[
  (CompareOp)
  (BitwiseOp)
  (BitShiftOp)
  (AdditionOp)
  (AssignOp)
  (MultiplyOp)
  (PrefixOp)
  "*"
  "**"
  "->"
  ".?"
  ".*"
  "?"
] @operator

[
  ";"
  "."
  ","
  ":"
] @punctuation.delimiter

[
  ".."
  "..."
] @punctuation.special

[
  "["
  "]"
  "("
  ")"
  "{"
  "}"
  (Payload "|")
  (PtrPayload "|")
  (PtrIndexPayload "|")
] @punctuation.bracket

; Error

(ERROR) @error
