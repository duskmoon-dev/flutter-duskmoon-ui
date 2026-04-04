import 'package:flutter/services.dart';

/// A command function that operates on a view (or editor state).
/// Returns true if the command was handled, false otherwise.
typedef Command = bool Function(dynamic view);

/// Maps a key name string to a [LogicalKeyboardKey].
LogicalKeyboardKey? _keyNameToLogicalKey(String name) {
  return const {
    'a': LogicalKeyboardKey.keyA,
    'b': LogicalKeyboardKey.keyB,
    'c': LogicalKeyboardKey.keyC,
    'd': LogicalKeyboardKey.keyD,
    'e': LogicalKeyboardKey.keyE,
    'f': LogicalKeyboardKey.keyF,
    'g': LogicalKeyboardKey.keyG,
    'h': LogicalKeyboardKey.keyH,
    'i': LogicalKeyboardKey.keyI,
    'j': LogicalKeyboardKey.keyJ,
    'k': LogicalKeyboardKey.keyK,
    'l': LogicalKeyboardKey.keyL,
    'm': LogicalKeyboardKey.keyM,
    'n': LogicalKeyboardKey.keyN,
    'o': LogicalKeyboardKey.keyO,
    'p': LogicalKeyboardKey.keyP,
    'q': LogicalKeyboardKey.keyQ,
    'r': LogicalKeyboardKey.keyR,
    's': LogicalKeyboardKey.keyS,
    't': LogicalKeyboardKey.keyT,
    'u': LogicalKeyboardKey.keyU,
    'v': LogicalKeyboardKey.keyV,
    'w': LogicalKeyboardKey.keyW,
    'x': LogicalKeyboardKey.keyX,
    'y': LogicalKeyboardKey.keyY,
    'z': LogicalKeyboardKey.keyZ,
    'Enter': LogicalKeyboardKey.enter,
    'Tab': LogicalKeyboardKey.tab,
    'Escape': LogicalKeyboardKey.escape,
    'Backspace': LogicalKeyboardKey.backspace,
    'Delete': LogicalKeyboardKey.delete,
    'ArrowUp': LogicalKeyboardKey.arrowUp,
    'ArrowDown': LogicalKeyboardKey.arrowDown,
    'ArrowLeft': LogicalKeyboardKey.arrowLeft,
    'ArrowRight': LogicalKeyboardKey.arrowRight,
    'Home': LogicalKeyboardKey.home,
    'End': LogicalKeyboardKey.end,
    'PageUp': LogicalKeyboardKey.pageUp,
    'PageDown': LogicalKeyboardKey.pageDown,
    '/': LogicalKeyboardKey.slash,
    '[': LogicalKeyboardKey.bracketLeft,
    ']': LogicalKeyboardKey.bracketRight,
  }[name];
}

/// Parsed representation of a key binding descriptor string.
class _ParsedKey {
  const _ParsedKey({
    required this.logicalKey,
    required this.ctrl,
    required this.shift,
    required this.alt,
  });

  final LogicalKeyboardKey logicalKey;
  final bool ctrl;
  final bool shift;
  final bool alt;
}

/// Parses a key descriptor string like "Ctrl-z", "Shift-Enter", "Ctrl-Shift-z".
_ParsedKey? _parseKey(String key) {
  final parts = key.split('-');
  var ctrl = false;
  var shift = false;
  var alt = false;
  String? keyName;

  for (final part in parts) {
    switch (part) {
      case 'Ctrl':
      case 'Cmd':
      case 'Meta':
        ctrl = true;
      case 'Shift':
        shift = true;
      case 'Alt':
        alt = true;
      default:
        keyName = part;
    }
  }

  if (keyName == null) return null;
  final logicalKey = _keyNameToLogicalKey(keyName);
  if (logicalKey == null) return null;

  return _ParsedKey(logicalKey: logicalKey, ctrl: ctrl, shift: shift, alt: alt);
}

/// Associates a key descriptor string with one or two [Command] functions.
///
/// The [key] string uses dash-separated modifiers followed by the key name,
/// e.g. "Ctrl-z", "Shift-Enter", "Alt-f", "Ctrl-Shift-z".
///
/// [run] is called when the key is pressed normally; [shift] is an alternate
/// command invoked when Shift is additionally held (for bindings that define
/// both a non-shift and shift variant, e.g. "Ctrl-z" run=undo, shift=redo).
///
/// [preventDefault] controls whether the default browser/platform action
/// should be suppressed when this binding matches.
class KeyBinding {
  const KeyBinding({
    required this.key,
    this.run,
    this.shift,
    this.preventDefault = true,
  });

  /// Key descriptor, e.g. "Ctrl-z", "Shift-Enter", "Alt-f".
  final String key;

  /// Command to run when the key matches (without extra Shift held).
  final Command? run;

  /// Command to run when the key matches with Shift additionally held.
  final Command? shift;

  /// Whether to suppress the default platform action when matched.
  final bool preventDefault;

  /// Returns true if the provided key state matches this binding's descriptor.
  ///
  /// When the binding key includes "Shift", [shift] in the binding descriptor
  /// is matched against the provided [shiftHeld]. When the binding does NOT
  /// include Shift, the shift parameter is not used for matching (either shift
  /// state can match the base binding; the caller selects [run] vs [shift]).
  bool matches(
    LogicalKeyboardKey logicalKey,
    bool ctrl,
    bool shiftHeld,
    bool alt,
  ) {
    final parsed = _parseKey(key);
    if (parsed == null) return false;

    if (parsed.logicalKey != logicalKey) return false;
    if (parsed.ctrl != ctrl) return false;
    if (parsed.alt != alt) return false;
    // Shift: if the binding descriptor includes Shift, it must match exactly.
    // If not, allow matching regardless of shift (shift selects run vs this.shift).
    if (parsed.shift && !shiftHeld) return false;

    return true;
  }
}

/// A collection of [KeyBinding]s that can be queried to dispatch key events.
class Keymap {
  const Keymap(this.bindings);

  /// The key bindings in this keymap, in priority order (first wins).
  final List<KeyBinding> bindings;

  /// Returns the first [KeyBinding] whose descriptor matches the given key
  /// state, or null if no binding matches.
  KeyBinding? resolve(
    LogicalKeyboardKey logicalKey,
    bool ctrl,
    bool shift,
    bool alt,
  ) {
    for (final binding in bindings) {
      if (binding.matches(logicalKey, ctrl, shift, alt)) {
        return binding;
      }
    }
    return null;
  }

  /// Merges multiple [Keymap]s into one, preserving order (earlier keymaps
  /// have higher priority).
  static Keymap compose(List<Keymap> keymaps) {
    return Keymap([for (final km in keymaps) ...km.bindings]);
  }
}
