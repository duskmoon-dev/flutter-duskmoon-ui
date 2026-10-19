; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(escape_sequence) @string.escape
(hex_string) @string
(interpolated_quoted_string) @string
(interpolated_raw_string) @string
(interpolated_token_string) @string
(keyword) @keyword
(quoted_string) @string
(raw_string) @string
(special_keyword) @keyword
(string_literal) @string
(token_string) @string
(cfloat) @number
(char) @character
(comment) @comment
(cstring) @string
(dstring) @string
(false) @boolean
(float) @number
(float_literal) @number
(identifier) @variable
(ifloat) @number
(int) @number
(null) @constant.null
(string) @string
(true) @boolean
(wstring) @string
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
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator

; Source: vendor/grammars/d/queries/highlights.scm

(string_literal) @string

(int_literal) @number

(float_literal) @number

(char_literal) @number

(identifier) @variable

(at_attribute) @property

(htmlentity) @string.special

(escape_sequence) @string.escape

[
	(lazy)
	(align)
	(extern)
	(static)
	(abstract)
	(final)
	(override)
	(synchronized)
	(auto)
	(scope)
	(gshared)
	(ref)
	(deprecated)
	(nothrow)
	(pure)
	(type_ctor)
] @keyword.storage

(parameter_attribute (return) @keyword.storage)

(parameter_attribute (in) @keyword.storage)

(parameter_attribute (out) @keyword.storage)

(function_declaration (identifier) @function)

(call_expression (identifier) @function)

(call_expression (type (template_instance (identifier) @function)))

(template_arguments (identifier) @variable.parameter)

(named_argument (identifier) @variable.parameter)

[
    (abstract)
    (alias)
    (align)
    (asm)
    (assert)
    (auto)
    (cast)
    (class)
    (const)
    (debug)
    (delegate)
    (delete)
    (deprecated)
    (enum)
    (export)
    (extern)
    (final)
    (function)
    (immutable)
    (import)
    (in)
    (inout)
    (interface)
    (invariant)
    (is)
    (lazy)
    ; "macro" - obsolete
    (mixin)
    (module)
    (new)
    (nothrow)
    (out)
    (override)
    (package)
    (pragma)
    (private)
    (protected)
    (public)
    (pure)
    (ref)
    (scope)
    (shared)
    (static)
    (struct)
    (super)
    (synchronized)
    (template)
    (this)
    (throw)
    (typeid)
    (typeof)
    (union)
    (unittest)
    (version)
    (with)
    (gshared)
    (traits)
    (vector)
    (parameters_)
] @keyword

[
    (break)
    (case)
    (catch)
    (continue)
    (do)
    (default)
    (finally)
    (else)
    (for)
    (foreach)
    (foreach_reverse)
    (goto)
    (if)
    (switch)
    (try)
    (return)
    (while)
] @keyword.control

[
    (not_in)
    (not_is)
    "/="
    "/"
    ".."
    "..."
    "&"
    "&="
    "&&"
    "|"
    "|="
    "||"
    "-"
    "-="
    "--"
    "+"
    "+="
    "++"
    "<"
    "<="
    "<<"
    "<<="
    ">"
    ">="
    ">>="
    ">>>="
    ">>"
    ">>>"
    "!"
    "!="
    "?"
    "$"
    "="
    "=="
    "*"
    "*="
    "%"
    "%="
    "^"
    "^="
    "^^"
    "^^="
    "~"
    "~="
    "@"
    "=>"
] @operator

[
    ";"
    "."
    ":"
    ","
] @punctuation.delimiter

[
    "("
    ")"
    "["
    "]"
    "{"
    "}"
] @punctuation.bracket

; The delimiters of an interpolation expression inside an interpolated string.
; Listed after the bracket rule above so the closing ")" is captured here rather
; than as a plain bracket; this keeps the opening "$(" and closing ")" the same
; color instead of the opener inheriting the surrounding string color.

(interpolation_expression
    "$(" @punctuation.special
    ")" @punctuation.special)

[
    (null)
    (true)
    (false)
] @constant.language

(special_keyword) @constant.language

(directive) @keyword.directive

(shebang) @keyword.directive

(comment) @comment

[
    (void)
    (bool)
    (byte)
    (ubyte)
    (char)
    (short)
    (ushort)
    (wchar)
    (dchar)
    (int)
    (uint)
    (long)
    (ulong)
    (real)
    (double)
    (float)
    (size_t)
    (ptrdiff_t)
    (string)
    (cstring)
    (wstring)
    (noreturn)
] @type.builtin

[
    (cent)
    (ucent)
    (ireal)
    (idouble)
    (ifloat)
    (creal)
    (double)
    (cfloat)
] @type.deprecated

(label (identifier) @label)

(goto_statement (goto) @keyword.control (identifier) @label)

; this covers other cases where the identifier can only
; be a type (such as in an is-expression on a constraint)

(type (identifier) @type)

; these are listed last, because they override keyword queries

(identity_expression (in) @operator)

(identity_expression (is) @operator)

; everything after __EOF_ is plain text

(end_file) @text
