/* DuskMoon adapter for the official Tree-sitter runtime. */
#include <tree_sitter/api.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#if defined(_WIN32)
#define DM_EXPORT __declspec(dllexport)
#else
#define DM_EXPORT __attribute__((visibility("default")))
#endif

const TSLanguage *dmh_language(const char *name);

typedef struct {
  TSParser *parser;
  TSQuery *query;
  TSTree *tree;
} DmSession;

typedef struct { char *data; size_t size, capacity; } Buffer;
static void append(Buffer *b, const char *text, size_t length) {
  if (b->size + length + 1 > b->capacity) {
    b->capacity = (b->size + length + 1) * 2;
    char *next = realloc(b->data, b->capacity);
    if (!next) abort();
    b->data = next;
  }
  memcpy(b->data + b->size, text, length);
  b->size += length;
  b->data[b->size] = 0;
}
static void text(Buffer *b, const char *s) { append(b, s, strlen(s)); }
static void number(Buffer *b, uint32_t n) {
  char value[32]; snprintf(value, sizeof(value), "%u", n); text(b, value);
}
static void quote(Buffer *b, const char *s, uint32_t length) {
  text(b, "\"");
  for (uint32_t i = 0; i < length; i++) {
    unsigned char c = s[i];
    if (c == '"' || c == '\\') { text(b, "\\"); append(b, s + i, 1); }
    else if (c < 32) {
      char escaped[7]; snprintf(escaped, sizeof(escaped), "\\u%04x", c);
      text(b, escaped);
    } else append(b, s + i, 1);
  }
  text(b, "\"");
}
static void node_json(Buffer *b, TSNode node) {
  text(b, "{\"type\":"); const char *type = ts_node_type(node);
  quote(b, type, (uint32_t)strlen(type));
  text(b, ",\"from\":"); number(b, ts_node_start_byte(node) / 2);
  text(b, ",\"to\":"); number(b, ts_node_end_byte(node) / 2);
  text(b, ",\"isNamed\":"); text(b, ts_node_is_named(node) ? "true" : "false");
  text(b, ",\"hasError\":"); text(b, ts_node_has_error(node) ? "true" : "false");
  text(b, ",\"children\":[");
  uint32_t count = ts_node_child_count(node);
  for (uint32_t i = 0; i < count; i++) {
    if (i) text(b, ","); node_json(b, ts_node_child(node, i));
  }
  text(b, "]}");
}
DM_EXPORT void *dmh_allocate(intptr_t size) { return malloc((size_t)size); }
DM_EXPORT void dmh_free(void *pointer) { free(pointer); }
DM_EXPORT void *dmh_create(const char *language_name, const char *query_source, uint32_t *query_error) {
  query_error[0] = 0; query_error[1] = 0;
  const TSLanguage *language = dmh_language(language_name);
  if (!language) return NULL;
  DmSession *s = calloc(1, sizeof(DmSession));
  if (!s) return NULL;
  s->parser = ts_parser_new();
  if (!ts_parser_set_language(s->parser, language)) {
    ts_parser_delete(s->parser); free(s); return NULL;
  }
  uint32_t offset; TSQueryError error;
  s->query = ts_query_new(language, query_source, (uint32_t)strlen(query_source), &offset, &error);
  if (!s->query) {
    query_error[0] = offset; query_error[1] = (uint32_t)error;
    ts_parser_delete(s->parser); free(s); return NULL;
  }
  return s;
}
DM_EXPORT void dmh_dispose(DmSession *s) {
  if (!s) return;
  ts_tree_delete(s->tree); ts_query_delete(s->query); ts_parser_delete(s->parser); free(s);
}
DM_EXPORT char *dmh_predicates(DmSession *s) {
  Buffer b = {0}; text(&b, "[");
  uint32_t count = ts_query_pattern_count(s->query);
  for (uint32_t p = 0; p < count; p++) {
    if (p) text(&b, ","); text(&b, "[");
    uint32_t length; const TSQueryPredicateStep *steps = ts_query_predicates_for_pattern(s->query, p, &length);
    bool first_predicate = true, first_step = true;
    for (uint32_t i = 0; i < length; i++) {
      if (steps[i].type == TSQueryPredicateStepTypeDone) {
        if (!first_step) text(&b, "]");
        first_step = true;
        continue;
      }
      if (first_step) {
        if (!first_predicate) text(&b, ",");
        text(&b, "["); first_predicate = false; first_step = false;
      } else text(&b, ",");
      uint32_t size;
      const char *value = steps[i].type == TSQueryPredicateStepTypeCapture
        ? ts_query_capture_name_for_id(s->query, steps[i].value_id, &size)
        : ts_query_string_value_for_id(s->query, steps[i].value_id, &size);
      text(&b, "{\"capture\":");
      text(&b, steps[i].type == TSQueryPredicateStepTypeCapture ? "true" : "false");
      text(&b, ",\"value\":"); quote(&b, value, size); text(&b, "}");
    }
    text(&b, "]");
  }
  text(&b, "]"); return b.data;
}
DM_EXPORT char *dmh_parse(DmSession *s, const char *source, uint32_t length,
  uint32_t start, uint32_t old_end, uint32_t new_end,
  uint32_t start_row, uint32_t start_column,
  uint32_t old_row, uint32_t old_column,
  uint32_t new_row, uint32_t new_column) {
  if (s->tree) {
    TSInputEdit edit = {start * 2, old_end * 2, new_end * 2,
      {start_row, start_column * 2}, {old_row, old_column * 2}, {new_row, new_column * 2}};
    ts_tree_edit(s->tree, &edit);
  }
  TSTree *next = ts_parser_parse_string_encoding(s->parser, s->tree, source, length * 2, TSInputEncodingUTF16LE);
  if (!next) return NULL;
  ts_tree_delete(s->tree); s->tree = next;
  Buffer b = {0}; TSNode root = ts_tree_root_node(next);
  text(&b, "{\"root\":"); node_json(&b, root);
  text(&b, ",\"matches\":[");
  TSQueryCursor *cursor = ts_query_cursor_new(); ts_query_cursor_exec(cursor, s->query, root);
  TSQueryMatch match; bool first = true;
  while (ts_query_cursor_next_match(cursor, &match)) {
    if (!first) text(&b, ","); first = false;
    text(&b, "{\"pattern\":"); number(&b, match.pattern_index);
    text(&b, ",\"captures\":[");
    for (uint16_t i = 0; i < match.capture_count; i++) {
      if (i) text(&b, ","); uint32_t size;
      const char *name = ts_query_capture_name_for_id(s->query, match.captures[i].index, &size);
      TSNode node = match.captures[i].node;
      text(&b, "{\"name\":"); quote(&b, name, size);
      text(&b, ",\"from\":"); number(&b, ts_node_start_byte(node) / 2);
      text(&b, ",\"to\":"); number(&b, ts_node_end_byte(node) / 2); text(&b, "}");
    }
    text(&b, "]}");
  }
  bool exceeded = ts_query_cursor_did_exceed_match_limit(cursor);
  ts_query_cursor_delete(cursor);
  text(&b, "]"); text(&b, exceeded ? ",\"exceeded\":true}" : ",\"exceeded\":false}");
  return b.data;
}
