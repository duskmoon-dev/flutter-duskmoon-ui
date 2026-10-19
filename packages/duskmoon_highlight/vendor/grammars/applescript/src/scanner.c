// MIT License
// Copyright (c) 2025 Tom Waddington
// See LICENSE file for full license text

// Quoted, not angled: cgo compiles this without src/ on the include path.
#include "tree_sitter/parser.h"
#include <wctype.h>

// External token types - must match order in grammar.js externals array
enum TokenType {
    METHOD_CALL_LABEL,  // Objective-C style method call: stringWithString:
    PATH_TO_COMMAND,    // "path to" as atomic command
    HANDLER_LABEL,      // Objective-C style handler label: doJava (when followed by :)
};

// The scanner holds no state. Every token it emits is decided from lookahead
// alone, so serialize writes nothing and create hands back a null payload.

static void skip_whitespace(TSLexer *lexer) {
    while (iswspace(lexer->lookahead)) {
        lexer->advance(lexer, true);
    }
}

// Gap between the two words of a multi-word token. Deliberately does not cross
// a newline: AppleScript is line-oriented, so "path" ending one line and "to"
// starting the next are two separate tokens.
static void skip_inline_space(TSLexer *lexer) {
    while (lexer->lookahead == ' ' || lexer->lookahead == '\t') {
        lexer->advance(lexer, true);
    }
}

static bool is_identifier_start(int32_t c) {
    return iswalpha(c) || c == '_';
}

static bool is_identifier_char(int32_t c) {
    return iswalnum(c) || c == '_';
}

// Consume an identifier and check it matches `expected` exactly, rather than
// being a prefix of something longer.
static bool consume_identifier(TSLexer *lexer, const char *expected) {
    if (!is_identifier_start(lexer->lookahead)) {
        return false;
    }

    const char *p = expected;
    while (*p && lexer->lookahead == *p) {
        lexer->advance(lexer, false);
        p++;
    }

    if (*p != '\0') {
        return false;
    }

    return !is_identifier_char(lexer->lookahead);
}

// "path to" as a single token, so the "to" is not mistaken for the "to" that
// opens a handler definition.
static bool scan_path_to_command(TSLexer *lexer) {
    if (!consume_identifier(lexer, "path")) {
        return false;
    }

    skip_inline_space(lexer);

    if (!consume_identifier(lexer, "to")) {
        return false;
    }

    lexer->mark_end(lexer);
    lexer->result_symbol = PATH_TO_COMMAND;
    return true;
}

// An identifier followed by ':'. Serves both the Objective-C method call label
// (stringWithString:) and the handler label (on doJava:action); which one is
// wanted is decided by the grammar via valid_symbols.
static bool scan_label(TSLexer *lexer, enum TokenType symbol) {
    if (!is_identifier_start(lexer->lookahead)) {
        return false;
    }

    while (is_identifier_char(lexer->lookahead)) {
        lexer->advance(lexer, false);
    }

    // The colon is lookahead only, not part of the token.
    lexer->mark_end(lexer);

    skip_whitespace(lexer);

    if (lexer->lookahead != ':') {
        return false;
    }

    lexer->result_symbol = symbol;
    return true;
}

bool tree_sitter_applescript_external_scanner_scan(
    void *payload,
    TSLexer *lexer,
    const bool *valid_symbols
) {
    (void)payload;

    skip_whitespace(lexer);

    if (valid_symbols[METHOD_CALL_LABEL] && scan_label(lexer, METHOD_CALL_LABEL)) {
        return true;
    }

    if (valid_symbols[PATH_TO_COMMAND] && scan_path_to_command(lexer)) {
        return true;
    }

    if (valid_symbols[HANDLER_LABEL] && scan_label(lexer, HANDLER_LABEL)) {
        return true;
    }

    return false;
}

void *tree_sitter_applescript_external_scanner_create() {
    return NULL;
}

void tree_sitter_applescript_external_scanner_destroy(void *payload) {
    (void)payload;
}

unsigned tree_sitter_applescript_external_scanner_serialize(
    void *payload,
    char *buffer
) {
    (void)payload;
    (void)buffer;
    return 0;
}

void tree_sitter_applescript_external_scanner_deserialize(
    void *payload,
    const char *buffer,
    unsigned length
) {
    (void)payload;
    (void)buffer;
    (void)length;
}
