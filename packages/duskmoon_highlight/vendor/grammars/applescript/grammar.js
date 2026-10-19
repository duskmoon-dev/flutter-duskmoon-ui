// MIT License
// Copyright (c) 2025 Tom Waddington
// See LICENSE file for full license text

// AppleScript is line-oriented: a statement ends at a newline. Newlines are
// therefore kept out of `extras` — the ¬ and \ continuations that are in
// there are what lets a single statement span lines. Without this a run of
// words in property_name or an application command's argument list has no
// right-hand boundary, and an unparseable statement swallows the rest of the
// file because there is nowhere to resume.
const NEWLINE = /\r?\n/;

// A block body: the newline closing the block header, then any number of
// newline-terminated statements. Blank lines collapse into the neighbouring
// terminator, and the newline before `end` belongs to the last statement.
// The body may be empty; `on error` with nothing in it is common, and an
// empty `tell` or `repeat` is legal too.
function block($) {
  return blockOf($, $._statement);
}

// The same shape for a body of something other than plain statements.
function blockOf($, item) {
  return seq(repeat1(NEWLINE), repeat(seq(item, repeat1(NEWLINE))));
}

export default grammar({
  name: "applescript",

  // Keyword extraction: a keyword only matches at a whole-word boundary, so
  // `command` is never read as `comm` + `and`, and `with` stays a keyword
  // rather than a bare word.
  word: ($) => $.identifier,

  externals: ($) => [
    $.method_call_label, // Objective-C method call: stringWithString:
    $.path_to_command, // "path to" as atomic command
    $.handler_label, // Objective-C handler label: doJava (when followed by :)
  ],

  // \s minus \r and \n, which are significant now. The two continuation
  // forms stay: they are how one statement deliberately spans lines.
  extras: ($) => [
    $.comment,
    /[ \t\v\f\u00A0\u1680\u2000-\u200A\u202F\u205F\u3000\uFEFF\u2060\u200B]|\\\r?\n|¬\r?\n/,
  ],

  conflicts: ($) => [
    // A list and a record both open with '{'.
    [$.list, $.record],

    // A parenthesised group is either one expression or a call's argument list.
    [$.argument_list, $.parenthesized_expression],

    // The modifiers after `using` are optional, so the parser cannot tell a
    // bare `using x` from `using` plus a following expression until later.
    [$.using_clause, $._expression],

    // `x's y` is a property or an element.
    [$.element_access, $.property_access],

    // A run of bare words is a multi-word property or a sequence of separate
    // expressions. Only the application dictionary knows, so GLR carries both
    // and property_name's dynamic precedence picks. The keyword variants cover
    // runs containing words like `script` or `text`.
    [$.property_name, $._expression],
    [$.property_name],
    [$.property_name, $._identifier_or_keyword_token, $._expression],
    [$.property_name, $._identifier_or_keyword_token],

    // `script` opens a script object, names a script reference, and can also
    // be one word of a property or command name.
    [$._identifier_or_keyword_token, $.script_statement],
    [$._identifier_or_keyword_token, $.script_reference],

    // A record key may itself be a multi-word property name.
    [$.property_name, $.record_entry],

    // Postfix `exists` and `path to` compete for the same operand.
    [$.unary_expression, $.path_to_expression],
  ],

  rules: {
    // Unlike a block body this has no `end` to lean on, so the last item is
    // allowed to run to EOF without a closing newline.
    source_file: ($) =>
      seq(
        repeat(NEWLINE),
        repeat(seq($._top_level_item, repeat1(NEWLINE))),
        optional($._top_level_item),
      ),

    _top_level_item: ($) =>
      choice($.property_statement, $.handler_definition, $._statement),

    _statement: ($) =>
      choice(
        $.tell_statement,
        $.if_statement,
        $.repeat_statement,
        $.try_statement,
        $.set_statement,
        $.return_statement,
        $.exit_statement,
        $.error_statement,
        $.considering_statement,
        $.ignoring_statement,
        $.timeout_statement,
        $.transaction_statement,
        $.use_statement,
        $.script_statement,
        $.application_command,
        $.expression_statement,
      ),

    // Comments
    comment: ($) =>
      choice(
        seq("--", /.*/),
        seq("#", /.*/),
        seq("(*", repeat(choice(/[^*]/, /\*[^)]/)), "*)"),
      ),

    // Tell Statement
    tell_statement: ($) =>
      prec.right(
        choice(
          seq(
            "tell",
            field("target", $._expression),
            "to",
            field("statement", $._statement),
          ),
          seq(
            "tell",
            field("target", $._expression),
            block($),
            "end",
            optional("tell"),
          ),
          seq("tell", field("target", $._expression)),
        ),
      ),

    // If Statement
    if_statement: ($) =>
      seq(
        "if",
        field("condition", $._expression),
        "then",
        choice(
          $._statement,
          seq(
            block($),
            repeat($.else_if_clause),
            optional($.else_clause),
            "end",
            optional("if"),
          ),
        ),
      ),

    else_if_clause: ($) =>
      seq("else", "if", field("condition", $._expression), "then", block($)),

    else_clause: ($) => seq("else", block($)),

    // Repeat Statement
    repeat_statement: ($) =>
      choice(
        $.repeat_forever,
        $.repeat_times,
        $.repeat_until,
        $.repeat_while,
        $.repeat_with,
        $.repeat_with_in,
      ),

    repeat_forever: ($) =>
      prec.right(seq("repeat", block($), "end", optional("repeat"))),

    repeat_times: ($) =>
      prec.right(
        seq(
          "repeat",
          field("count", $._expression),
          optional("times"),
          block($),
          "end",
          optional("repeat"),
        ),
      ),

    repeat_until: ($) =>
      prec.right(
        seq(
          "repeat",
          "until",
          field("condition", $._expression),
          block($),
          "end",
          optional("repeat"),
        ),
      ),

    repeat_while: ($) =>
      prec.right(
        seq(
          "repeat",
          "while",
          field("condition", $._expression),
          block($),
          "end",
          optional("repeat"),
        ),
      ),

    repeat_with: ($) =>
      prec.right(
        seq(
          "repeat",
          "with",
          field("variable", $.identifier),
          "from",
          field("start", $._expression),
          "to",
          field("end", $._expression),
          optional(seq("by", field("step", $._expression))),
          block($),
          "end",
          optional("repeat"),
        ),
      ),

    repeat_with_in: ($) =>
      prec.right(
        seq(
          "repeat",
          "with",
          field("variable", $.identifier),
          "in",
          field("list", $._expression),
          block($),
          "end",
          optional("repeat"),
        ),
      ),

    // Try Statement
    try_statement: ($) =>
      prec.right(
        seq("try", block($), repeat($.on_error_clause), "end", optional("try")),
      ),

    on_error_clause: ($) =>
      seq(
        "on",
        "error",
        optional(field("message_var", choice($.identifier, $.string))),
        optional(seq("number", field("number_var", $.identifier))),
        optional(seq("from", field("from_var", $.identifier))),
        optional(seq("partial", "result", field("partial_var", $.identifier))),
        optional(seq("to", field("to_var", $.identifier))),
        block($),
      ),

    // Set Statement
    set_statement: ($) =>
      seq(
        choice("set", "copy"),
        field("target", $._expression),
        "to",
        field("value", $._expression),
      ),

    // Return Statement
    // Outranks the bare `return` text constant, so a lone `return` on a line
    // is the statement and not an expression.
    return_statement: ($) =>
      prec.right(1, seq("return", optional(field("value", $._expression)))),

    // Exit Statement
    exit_statement: ($) => prec.right(seq("exit", optional("repeat"))),

    // Error Statement
    error_statement: ($) =>
      prec.right(
        seq(
          "error",
          optional(
            choice(
              seq(field("message", $._expression), repeat($.error_clause)),
              repeat1($.error_clause),
            ),
          ),
        ),
      ),

    error_clause: ($) =>
      choice(
        seq("number", field("number", $._expression)),
        seq("from", field("from", $._expression)),
        seq("partial", "result", field("partial", $._expression)),
        seq("to", field("to", $._expression)),
      ),

    // Considering/Ignoring Statements
    considering_statement: ($) =>
      prec.right(
        seq(
          "considering",
          $.considering_terms,
          block($),
          "end",
          optional("considering"),
        ),
      ),

    ignoring_statement: ($) =>
      prec.right(
        seq(
          "ignoring",
          $.considering_terms,
          block($),
          "end",
          optional("ignoring"),
        ),
      ),

    considering_terms: ($) =>
      seq(
        $.considering_term,
        repeat(seq(optional(","), optional("and"), $.considering_term)),
      ),

    considering_term: ($) =>
      choice(
        "case",
        "diacriticals",
        "expansion",
        "hyphens",
        "punctuation",
        "white space",
        "numeric strings",
      ),

    // Timeout Statement
    timeout_statement: ($) =>
      seq(
        "with",
        "timeout",
        optional("of"),
        field("duration", $._expression),
        optional("seconds"),
        block($),
        "end",
        optional("timeout"),
      ),

    // Transaction Statement
    transaction_statement: ($) =>
      seq(
        "with",
        "transaction",
        optional(seq(optional("of"), field("session", $._expression))),
        block($),
        "end",
        optional("transaction"),
      ),

    // Use Statement
    use_statement: ($) =>
      seq(
        "use",
        choice(
          seq("scripting", "additions"),
          seq("AppleScript", "version", $.string),
          seq("framework", $.string),
          seq(
            optional(seq(field("alias", $.identifier), ":")),
            "script",
            $.string,
          ),
          seq(
            optional("application"),
            field("name", $.string),
            optional(seq("version", field("version", $.string))),
          ),
        ),
      ),

    // Script Statement
    script_statement: ($) =>
      prec.right(
        seq(
          "script",
          field("name", $.identifier),
          blockOf($, $._top_level_item),
          "end",
          optional("script"),
        ),
      ),

    // Property Statement
    property_statement: ($) =>
      seq(
        "property",
        field("name", $.identifier),
        ":",
        field("value", $._expression),
      ),

    // Handler Definition
    handler_definition: ($) =>
      choice($.simple_handler, $.positional_handler, $.labeled_handler),

    simple_handler: ($) =>
      prec.right(
        10,
        seq(
          "on",
          field("name", $.identifier),
          "(",
          optional($.parameter_list),
          ")",
          block($),
          "end",
          optional(field("end_name", $.identifier)),
        ),
      ),

    positional_handler: ($) =>
      prec.right(
        10,
        choice(
          // Regular positional handler
          seq(
            "on",
            field("name", $.identifier),
            optional($.direct_parameter),
            repeat($.labeled_parameter),
            repeat($.boolean_parameter),
            optional($.given_parameter),
            block($),
            "end",
            optional(field("end_name", $.identifier)),
          ),
          // Objective-C style positional handler: on label:param label:param
          seq(
            "on",
            field("name", alias($.handler_label, $.identifier)),
            alias($.objc_first_parameter, $.labeled_parameter),
            repeat(alias($.objc_parameter, $.labeled_parameter)),
            block($),
            "end",
            optional(field("end_name", choice($.identifier, $.objc_selector))),
          ),
        ),
      ),

    labeled_handler: ($) =>
      prec.right(
        10,
        seq(
          "to",
          field("name", $.identifier),
          optional($.direct_parameter),
          repeat($.labeled_parameter),
          repeat($.boolean_parameter),
          optional($.given_parameter),
          block($),
          "end",
          optional(field("end_name", $.identifier)),
        ),
      ),

    direct_parameter: ($) =>
      prec(1, field("parameter", choice($.identifier, $.string, $.number))),

    labeled_parameter: ($) =>
      prec(
        2,
        choice(
          seq(
            field("label", $.identifier),
            field("parameter", choice($.identifier, $._expression)),
          ),
          seq(
            field("label", $.identifier),
            ":",
            field("parameter", choice($.identifier, $._expression)),
          ),
          // Objective-C style: handler_label appears as identifier in parse tree
          seq(
            field("label", alias($.handler_label, $.identifier)),
            ":",
            field("parameter", choice($.identifier, $._expression)),
          ),
        ),
      ),

    // Boolean flags in a handler definition: on foo with saving, closing
    boolean_parameter: ($) =>
      seq(
        choice("with", "without"),
        field("parameter", $.identifier),
        repeat(seq(",", field("parameter", $.identifier))),
      ),

    // Labelled parameters in a handler definition: to foo given width:w, height:h
    given_parameter: ($) =>
      seq("given", $.labeled_parameter, repeat(seq(",", $.labeled_parameter))),

    // Objective-C style first parameter (label is implicit from handler name)
    // The closing line of an Objective-C handler repeats the whole selector:
    // `end addMod:valid:arg:subtitle:`.
    objc_selector: ($) =>
      repeat1(seq(alias($.handler_label, $.identifier), ":")),

    objc_first_parameter: ($) => seq(":", field("parameter", $.identifier)),

    // Objective-C style subsequent parameters
    objc_parameter: ($) =>
      seq(
        field("label", alias($.handler_label, $.identifier)),
        ":",
        field("parameter", $.identifier),
      ),

    parameter_list: ($) => seq($.identifier, repeat(seq(",", $.identifier))),

    // Known multi-word commands (tokens for commands without keywords, sequences for those with keywords)
    system_attribute: ($) => token(prec(10, seq("system", /\s+/, "attribute"))),
    do_shell_script: ($) =>
      token(prec(10, seq("do", /\s+/, "shell", /\s+/, "script"))),
    do_javascript: ($) => token(prec(10, seq("do", /\s+/, /[Jj]ava[Ss]cript/))),
    // path_to: Disabled for now due to conflicts with "POSIX path of" expressions

    // Application-specific multi-word properties (front window, scroll area,
    // radio group, ...) used to be a whitelist of atomic tokens here. That is
    // a fragment of a scripting dictionary embedded in the lexer: it never
    // generalises to the next application's vocabulary, and the generic
    // multi-word branch of property_name already covers all of them.

    // Application Command
    //
    // Arguments are a flat run of expressions. Which words are parameter
    // labels and which are values is fixed by the target application's
    // scripting dictionary, not by syntax: in `create field "A" left inset 0`
    // nothing says whether `left inset` is one label taking 0 or `left` takes
    // `inset 0`. The tree records the terms and does not guess. Only `given`,
    // which marks its labels explicitly, keeps a labelled structure.
    //
    // The branch precedences decide what counts as a command at all: a known
    // command word, a multi-word name, or a single name with an argument.
    application_command: ($) =>
      seq(
        // `my close with saving` runs the command in the script's own context.
        // Kept here rather than on reference_prefix_expression so a command
        // never becomes an expression, which would let one appear inside a
        // list or a record.
        optional(field("prefix", choice("my", "its"))),
        choice(
          // Known multi-word commands (highest precedence). path_to_command is
          // deliberately absent: it is only used by path_to_expression.
          prec.right(
            5,
            seq(
              field(
                "command",
                choice($.system_attribute, $.do_shell_script, $.do_javascript),
              ),
              repeat($.command_argument),
              optional($._command_clause),
            ),
          ),
          // A bare identifier needs at least one argument, or it is just an
          // identifier expression.
          prec.right(
            2,
            seq(
              field(
                "command",
                choice(
                  $.identifier,
                  alias(
                    seq(
                      $._identifier_or_keyword_token,
                      repeat1($._identifier_or_keyword_token),
                    ),
                    $.property_name,
                  ),
                ),
              ),
              // A given clause counts as the required argument, so
              // "calculateArea given width:5" is a command and not a bare
              // identifier expression.
              choice(
                seq(repeat($.command_argument), $._command_clause),
                repeat1($.command_argument),
              ),
            ),
          ),
          // Multi-word command without arguments (lower precedence).
          prec.right(
            1,
            seq(
              field(
                "command",
                alias(
                  seq(
                    $._identifier_or_keyword_token,
                    repeat1($._identifier_or_keyword_token),
                  ),
                  $.property_name,
                ),
              ),
              optional($._command_clause),
            ),
          ),
        ),
      ),

    // One term in a command phrase. Deliberately unlabelled: whether a
    // term is a parameter label or a value is dictionary knowledge. The
    // precedence is what direct_parameter used to supply, and is what
    // stops `open theFile` collapsing into a two-word command name.
    command_argument: ($) =>
      prec.dynamic(
        3,
        prec(1, choice($._expression, $._identifier_or_keyword_token)),
      ),

    // Any of these makes a bare name a command on its own, so
    // `close with saving` does not need a separate argument first.
    _command_clause: ($) =>
      choice($.given_clause, $.with_clause, $.without_clause, $.using_clause),

    with_clause: ($) =>
      seq(
        "with",
        field("option", $.property_name),
        optional(field("value", $._expression)),
      ),

    without_clause: ($) => seq("without", field("option", $.property_name)),

    // Call-side counterpart of given_parameter: foo given width:5, height:3
    given_clause: ($) =>
      seq("given", $.labeled_parameter, repeat(seq(",", $.labeled_parameter))),

    using_clause: ($) =>
      seq(
        "using",
        field(
          "modifiers",
          choice(
            prec.dynamic(1, $.property_name), // Prefer multi-word like "command down"
            $._expression,
          ),
        ),
      ),

    // Property name (can be multi-word)
    property_name: ($) =>
      choice(
        // Generic multi-word properties (any sequence of 2+ identifiers/keywords)
        // Use dynamic precedence to prefer this over keyword matches in expression contexts
        prec.dynamic(
          2,
          seq(
            $._identifier_or_keyword_token,
            repeat1($._identifier_or_keyword_token),
          ),
        ),
        // Single identifier (lowest precedence)
        prec.dynamic(-1, $.identifier),
      ),

    // Identifier or keyword used as identifier (for property names that contain keywords)
    _identifier_or_keyword_token: ($) =>
      choice(
        $.identifier,
        alias("script", $.identifier),
        alias("text", $.identifier),
        alias("library", $.identifier),
        alias("used", $.identifier),
        alias("source", $.identifier),
        alias("files", $.identifier),
        alias("line", $.identifier),
        alias("endings", $.identifier),
      ),

    // Expression Statement
    expression_statement: ($) => $._expression,

    // Objective-C Method Call (AppleScriptObjC)
    method_call: ($) =>
      prec.right(
        16,
        seq(
          field("object", $._expression),
          "'s",
          field("method", $.method_call_label),
          ":",
          field("argument", $._expression),
          // Multiple labelled arguments (`a:1 b:2`) were measured at about 750
          // extra states for one more clean real-world file. Not worth it.
        ),
      ),

    // `my handler()` / `its property`: evaluate in the script's own context
    // rather than the enclosing tell target's.
    reference_prefix_expression: ($) =>
      prec.right(
        16,
        seq(
          field("prefix", choice("my", "its")),
          field("target", $._expression),
        ),
      ),

    // Path to expression (special case of command used as expression)
    path_to_expression: ($) =>
      prec(
        14,
        seq(
          $.path_to_command,
          choice(
            prec.dynamic(1, $.property_name), // Prefer multi-word properties
            $._expression, // Fallback to any expression
          ),
        ),
      ),

    // Expressions
    _expression: ($) =>
      choice(
        $.binary_expression,
        $.unary_expression,
        $.type_cast, // Type cast with 'as' keyword
        $.parenthesized_expression,
        $.application_expression,
        $.path_to_expression, // "path to" command in expression context
        $.reference_prefix_expression,
        $.method_call, // Must be before property_access (higher precedence)
        $.handler_call, // Must be before property_access (uses same 's syntax)
        $.property_access,
        $.element_access,
        $.list,
        $.record,
        $.property_name, // Multi-word properties - no negative precedence
        $.identifier,
        $.string,
        $.number,
        $.boolean,
        $.missing_value,
        $.text_constant,
        $.current_application,
        $.script_reference,
        $.reference_expression,
      ),

    binary_expression: ($) => {
      const table = [
        [prec.left, 12, "^"],
        [prec.left, 11, choice("*", "/", "div", "mod", "÷")],
        [prec.left, 10, choice("+", "-", "&")],
        [prec.left, 7, choice("and", "or")],
        [
          prec.left,
          6,
          choice(
            "=",
            "≠",
            ">",
            "<",
            "≥",
            "≤",
            ">=",
            "<=",
            "equals",
            "is equal to",
            "is equal",
            "equal to",
            "is not",
            "is not equal to",
            "is not equal",
            "isn't",
            "isn't equal to",
            "is greater than",
            "greater than",
            "comes after",
            "is less than",
            "less than",
            "comes before",
            "is greater than or equal to",
            "is greater than or equal",
            "is less than or equal to",
            "is less than or equal",
            "is",
          ),
        ],
        // `whose` / `where` narrows an element specifier by a test. Modelled
        // as the loosest binary operator so the whole test binds as its right
        // operand: `every window whose name contains "Log"`. A dedicated
        // postfix clause on element_access was measured at 628 extra states
        // for the same result.
        [prec.left, 3, choice("whose", "where")],
        // Range specifier: text 2 thru -2 of result.
        [prec.left, 9, choice("thru", "through")],
        [
          prec.left,
          5,
          choice(
            "contains",
            "contain",
            "does not contain",
            "doesn't contain",
            "is in",
            "is contained by",
            "is not in",
            "is not contained by",
            "starts with",
            "start with",
            "begins with",
            "begin with",
            "ends with",
            "end with",
          ),
        ],
      ];

      return choice(
        ...table.map(([fn, precedence, operator]) =>
          fn(
            precedence,
            seq(
              field("left", $._expression),
              field("operator", operator),
              field("right", $._expression),
            ),
          ),
        ),
      );
    },

    // Type cast expression (e.g., "x as text", "(path to home) as alias")
    type_cast: ($) =>
      prec.left(
        4,
        seq(field("value", $._expression), "as", field("type", $.identifier)),
      ),

    unary_expression: ($) =>
      choice(
        prec(13, seq("-", field("operand", $._expression))),
        prec(13, seq("+", field("operand", $._expression))),
        prec(8, seq("not", field("operand", $._expression))),
        // `exists menu item "X"` and `menu item "X" exists` are both written.
        prec(8, seq("exists", field("operand", $._expression))),
        prec.left(14, seq(field("operand", $._expression), "exists")),
      ),

    parenthesized_expression: ($) =>
      seq(
        "(",
        choice(
          $._expression,
          $.application_command, // Allow commands in parentheses (e.g., for command results)
        ),
        ")",
      ),

    application_expression: ($) =>
      prec(
        14,
        seq("application", field("name", choice($.string, $.identifier))),
      ),

    property_access: ($) =>
      prec.left(
        15,
        seq(
          field("object", $._expression),
          "'s",
          field("property", $.property_name),
        ),
      ),

    element_access: ($) =>
      prec.left(
        15,
        choice(
          // Possessive form: object's element [index]
          seq(
            field("object", $._expression),
            "'s",
            field("element", $.property_name),
            optional(field("index", $.number)),
          ),
          // Of form: element [index] of object
          seq(
            field("element", $.property_name),
            choice(
              seq(
                field("index", $.number),
                "of",
                field("object", $._expression),
              ),
              seq("of", field("object", $._expression)),
              field("index", $.number), // Allow implicit object (e.g., "window 1")
              // Named form: process "Finder", menu item "Apply Rules".
              prec.dynamic(-1, field("name", $.string)),
            ),
          ),
        ),
      ),

    handler_call: ($) =>
      prec.dynamic(
        5,
        choice(
          // With object: obj's handler(args)
          prec.left(
            16,
            seq(
              field("object", $._expression),
              "'s",
              field("name", $.identifier),
              "(",
              optional($.argument_list),
              ")",
            ),
          ),
          // Without object: handler(args)
          prec(
            3,
            seq(
              field("name", $.identifier),
              "(",
              optional($.argument_list),
              ")",
            ),
          ),
        ),
      ),

    argument_list: ($) => seq($._expression, repeat(seq(",", $._expression))),

    reference_expression: ($) =>
      seq(
        choice("a ref to", "a reference to", "ref to", "reference to"),
        field("target", $._expression),
      ),

    // Literals
    // Wrapped in token() so identifier is a single terminal, which is what
    // lets `word` be declared. Without that, keywords like `with` also match
    // the bare-word pattern and get absorbed as ordinary arguments instead of
    // opening their clause.
    identifier: ($) =>
      token(choice(/[A-Za-z_][A-Za-z0-9_]*/, seq("|", /[^|]+/, "|"))),

    string: ($) => seq('"', repeat(choice(/[^"\\]+/, /\\./)), '"'),

    number: ($) => choice($.integer, $.real),

    integer: ($) => /[0-9]+/,

    real: ($) => choice(/[0-9]+\.[0-9]+/, /[0-9]+(\.[0-9]+)?[eE][+-]?[0-9]+/),

    boolean: ($) => choice("true", "false", "yes", "no"),

    // Only `return` needs a rule here. AppleScript's other character constants
    // (space, tab, linefeed, quote) are not keywords in this grammar, so they
    // still reach expressions as plain identifiers; naming them here only adds
    // ambiguity. `return` cannot, because it is the return statement's keyword
    // and `word` now holds it to that.
    text_constant: ($) => "return",

    missing_value: ($) => seq("missing", "value"),

    current_application: ($) => token(seq("current", /\s+/, "application")),

    script_reference: ($) => seq("script", $.string),

    list: ($) =>
      seq(
        "{",
        optional(
          seq($._expression, repeat(seq(",", $._expression)), optional(",")),
        ),
        "}",
      ),

    record: ($) =>
      seq(
        "{",
        optional(
          seq($.record_entry, repeat(seq(",", $.record_entry)), optional(",")),
        ),
        "}",
      ),

    record_entry: ($) =>
      prec.dynamic(
        3,
        seq(
          field(
            "key",
            choice(
              prec.dynamic(1, $.identifier), // Prefer plain identifier for single-word keys
              $.property_name, // Use property_name for multi-word keys
              $.string,
            ),
          ),
          ":",
          field("value", $._expression),
        ),
      ),
  },
});
