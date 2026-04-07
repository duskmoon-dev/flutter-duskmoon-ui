import 'package:flutter/material.dart';

import '_markdown_editing_controller.dart';

/// The public controller for [DmMarkdownInput].
///
/// Extends [MarkdownEditingController] with convenience methods for
/// markdown editing: wrapping, inserting, toggling line prefixes, etc.
class DmMarkdownInputController extends MarkdownEditingController {
  /// Creates a markdown input controller.
  DmMarkdownInputController({super.text, super.enableGfm, super.enableKatex});

  /// Wraps the current selection with [marker] (e.g. `**` for bold).
  ///
  /// If the selection is already wrapped, unwraps it (toggle behavior).
  void wrapSelection(String marker) {
    final sel = selection;
    if (!sel.isValid) return;

    final selected = sel.textInside(text);

    // Check if already wrapped — toggle: unwrap.
    if (selected.startsWith(marker) && selected.endsWith(marker)) {
      final unwrapped =
          selected.substring(marker.length, selected.length - marker.length);
      applyMutation(
        text: text.replaceRange(sel.start, sel.end, unwrapped),
        selection: TextSelection(
          baseOffset: sel.start,
          extentOffset: sel.start + unwrapped.length,
        ),
      );
      return;
    }

    // Check if markers are outside the selection.
    if (sel.start >= marker.length &&
        sel.end + marker.length <= text.length &&
        text.substring(sel.start - marker.length, sel.start) == marker &&
        text.substring(sel.end, sel.end + marker.length) == marker) {
      // Unwrap by removing surrounding markers.
      final newText = text.substring(0, sel.start - marker.length) +
          selected +
          text.substring(sel.end + marker.length);
      applyMutation(
        text: newText,
        selection: TextSelection(
          baseOffset: sel.start - marker.length,
          extentOffset: sel.end - marker.length,
        ),
      );
      return;
    }

    // Wrap.
    final wrapped = '$marker$selected$marker';
    applyMutation(
      text: text.replaceRange(sel.start, sel.end, wrapped),
      selection: TextSelection(
        baseOffset: sel.start + marker.length,
        extentOffset: sel.start + marker.length + selected.length,
      ),
    );
  }

  /// Inserts [content] at the current cursor position.
  void insertAtCursor(String content) {
    final sel = selection;
    if (!sel.isValid) return;

    applyMutation(
      text: text.replaceRange(sel.start, sel.end, content),
      selection: TextSelection.collapsed(
        offset: sel.start + content.length,
      ),
    );
  }

  /// Toggles a line prefix (e.g. `# `, `> `, `- `) on selected lines.
  void toggleLinePrefix(String prefix) {
    final sel = selection;
    if (!sel.isValid) return;

    final lines = text.split('\n');
    final startLine = _lineAt(sel.start);
    final endLine = _lineAt(sel.end);

    // Check if all lines already have the prefix.
    final allPrefixed = lines
        .sublist(startLine, endLine + 1)
        .every((line) => line.startsWith(prefix));

    final newLines = <String>[];
    for (var i = 0; i < lines.length; i++) {
      if (i >= startLine && i <= endLine) {
        if (allPrefixed) {
          newLines.add(lines[i].substring(prefix.length));
        } else {
          newLines.add('$prefix${lines[i]}');
        }
      } else {
        newLines.add(lines[i]);
      }
    }

    final newText = newLines.join('\n');
    final lineCount = endLine - startLine + 1;
    final totalDelta =
        (allPrefixed ? -prefix.length : prefix.length) * lineCount;
    final newStart =
        (sel.start + (allPrefixed ? -prefix.length : prefix.length))
            .clamp(0, newText.length);
    final newEnd = (sel.end + totalDelta).clamp(newStart, newText.length);
    applyMutation(
      text: newText,
      selection: TextSelection(
        baseOffset: newStart,
        extentOffset: newEnd,
      ),
    );
  }

  /// Inserts a fenced code block at the cursor.
  void insertCodeFence({String language = ''}) {
    final sel = selection;
    if (!sel.isValid) return;

    final selected = sel.textInside(text);
    final replacement = '```$language\n$selected\n```';
    applyMutation(
      text: text.replaceRange(sel.start, sel.end, replacement),
      selection: TextSelection.collapsed(
        offset: sel.start + 3 + language.length + 1, // after opening fence
      ),
    );
  }

  /// Inserts a markdown link at the cursor.
  void insertLink({String url = 'url'}) {
    final sel = selection;
    if (!sel.isValid) return;

    final selected = sel.textInside(text);
    final linkText = selected.isEmpty ? 'text' : selected;
    final replacement = '[$linkText]($url)';
    applyMutation(
      text: text.replaceRange(sel.start, sel.end, replacement),
      selection: TextSelection(
        baseOffset: sel.start + linkText.length + 3,
        extentOffset: sel.start + linkText.length + 3 + url.length,
      ),
    );
  }

  /// Appends markdown text at the end.
  void appendMarkdown(String markdown) {
    final newText = text.isEmpty ? markdown : '$text\n$markdown';
    applyMutation(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  int _lineAt(int offset) {
    var line = 0;
    for (var i = 0; i < offset && i < text.length; i++) {
      if (text[i] == '\n') line++;
    }
    return line;
  }
}
