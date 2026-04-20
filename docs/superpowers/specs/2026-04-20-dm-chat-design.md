# DuskMoon Chat Widget — Design Spec

**Date:** 2026-04-20
**Status:** Approved (brainstorm phase)
**Scope:** New chat module inside `duskmoon_widgets`

## Summary

A chat UI module for LLM assistant apps built on top of existing DuskMoon primitives — `DmMarkdown` (streaming), `DmMarkdownInput`, `DmAvatar`, `DmCard`, `AdaptiveWidget`. Ships primitive widgets (`DmChatBubble`, `DmChatInput`, block views) plus a composed `DmChatView` that wires up the reverse list, pinned-to-bottom auto-scroll, streaming glue, and action dispatch.

Primary use case: LLM assistant (roles `user` / `assistant` / `system`, streaming tokens, thinking blocks, tool calls, attachments). Human-to-human messaging is out of scope for v1.

## Non-Goals (v1)

- Human-peer messaging primitives (read receipts, delivery state, per-sender avatars beyond role-based).
- Fluent-platform variants (Material + Cupertino only).
- Golden tests (deferred until visuals settle).
- Controller-driven message state (consumer owns `List<DmChatMessage>` and streams).
- LLM SDK adapters (the widget is SDK-agnostic; consumers wire their own).

## Decisions

| # | Decision | Rationale |
|---|---|---|
| Q1 | Live under `packages/duskmoon_widgets/lib/src/chat/` | No new package boundary; ride existing deps. |
| Q2 | LLM-oriented message model | Matches "thinking in bubble" requirement; avoids half-generic model. |
| Q3 | Thinking = collapsible, auto-expand while streaming, auto-collapse on first response token, "Thought for Ns" summary | Matches Claude/ChatGPT conventions; keeps scrollback tidy. |
| Q4 | Content types = text + thinking + tool-call + attachment + custom (extensible) | User requested all four with a custom slot. |
| Q5 | Primitives + composed `DmChatView` | Power users get control; common case is one-liner. |
| Q6 | Stream-per-message via `DmChatTextBlock.stream` / `DmChatThinkingBlock.stream` | Reuses `DmMarkdown(stream:)` zero-rebuild path. |
| Q7 | Input actions: Send + Stop (built-in, toggled by `isStreaming`) + Attach (built-in when `onAttach` set) + `leading`/`trailing` slots | Everything beyond this varies per app. |
| Q8 | Tool-call = compact chip (expand reveals input/output code blocks) | Keeps scrollback readable; expand-on-demand for debugging. |
| Q9 | Hybrid layout: user bubbles right-aligned (max 80% width, filled); assistant full-width rows; system centered muted | Matches Claude/ChatGPT web — long assistant content needs width. |
| Q10 | Attachments: full pipeline (pick via `file_picker` + upload adapter + progress/error/retry + thumbnails) | User explicitly requested C. |
| Input shortcut | Default `DmChatSubmitShortcut.cmdEnter`, configurable to `enter` | User-specified. `Cmd` = Meta on macOS/iOS, `Ctrl` elsewhere. |

## File Layout

```
packages/duskmoon_widgets/lib/src/chat/
├── models/
│   ├── dm_chat_message.dart       # DmChatMessage, DmChatRole, DmChatMessageStatus
│   ├── dm_chat_block.dart         # sealed DmChatBlock + variants
│   └── dm_chat_attachment.dart    # DmChatAttachment, DmChatAttachmentStatus, DmChatUploadAdapter
├── theme/
│   └── dm_chat_theme.dart         # DmChatTheme (ThemeExtension)
├── bubble/
│   ├── dm_chat_bubble.dart
│   ├── _bubble_frame.dart         # role-based layout frame
│   └── blocks/
│       ├── _text_block.dart       # DmMarkdown(stream|data)
│       ├── _thinking_block.dart   # collapsible + timer + auto-collapse
│       ├── _tool_call_block.dart  # chip + expand panel
│       ├── _attachment_block.dart # chip/image/progress/retry
│       └── _custom_block.dart     # dispatches via DmChatTheme.customBuilders
├── input/
│   ├── dm_chat_input.dart         # wraps DmMarkdownInput
│   ├── _send_button.dart          # Send↔Stop toggle
│   └── _attach_button.dart        # file_picker hook
├── view/
│   ├── dm_chat_view.dart          # reverse list + pinned auto-scroll + input
│   └── _scroll_controller.dart    # pinned-to-bottom tracking + jump-to-bottom FAB
└── chat.dart                       # barrel export
```

Public exports added to `packages/duskmoon_widgets/lib/duskmoon_widgets.dart` under a `// Chat` section.

### Dependency additions

`packages/duskmoon_widgets/pubspec.yaml`:

```yaml
dependencies:
  file_picker: ^8.x    # attachment picking (Q10-C)
```

No other new dependencies — streaming reuses `DmMarkdown(stream:)`; code blocks reuse `DmMarkdownConfig`.

## Data Model

```dart
enum DmChatRole { user, assistant, system }

enum DmChatMessageStatus { pending, streaming, complete, error }

class DmChatMessage {
  final String id;
  final DmChatRole role;
  final List<DmChatBlock> blocks;
  final DmChatMessageStatus status;
  final Object? error;
  final DateTime? createdAt;
  DmChatMessage copyWith({...});
}

sealed class DmChatBlock { const DmChatBlock(); }

class DmChatTextBlock extends DmChatBlock {
  final String? text;
  final Stream<String>? stream;  // invariant: exactly one of text/stream non-null
}

class DmChatThinkingBlock extends DmChatBlock {
  final String? text;
  final Stream<String>? stream;
  final Duration? elapsed;       // drives "Thought for Ns" summary when complete
}

enum DmChatToolCallStatus { pending, running, done, error }

class DmChatToolCallBlock extends DmChatBlock {
  final String id;               // tool-call id from LLM
  final String name;
  final Object? input;           // JSON-encodable
  final Object? output;          // JSON-encodable or markdown String
  final DmChatToolCallStatus status;
  final String? errorMessage;
}

class DmChatAttachmentBlock extends DmChatBlock {
  final List<DmChatAttachment> attachments;
}

class DmChatCustomBlock extends DmChatBlock {
  final String kind;             // dispatch key for DmChatTheme.customBuilders
  final Object? data;
}

enum DmChatAttachmentStatus { idle, uploading, done, error }

class DmChatAttachment {
  final String id;
  final String name;
  final int? sizeBytes;
  final String? mimeType;
  final Uri? url;                // remote url after upload
  final Uint8List? bytes;        // local bytes before upload
  final DmChatAttachmentStatus status;
  final double? uploadProgress;  // 0.0–1.0
  final String? errorMessage;
}

abstract class DmChatUploadAdapter {
  Stream<DmChatAttachment> upload(DmChatAttachment local);  // emits progress updates
  Future<void> cancel(String attachmentId);
}
```

### Invariants

- `DmChatTextBlock` / `DmChatThinkingBlock`: exactly one of `text` / `stream` is non-null.
- Streams are **single-subscription**. `DmChatBubble` subscribes once per block lifetime. If the consumer hands in a new stream instance for the same block position, the widget tears down and resubscribes on `didUpdateWidget`.
- `DmChatMessage.status == streaming` drives `DmChatInput`'s Send↔Stop toggle via `DmChatView`.
- `DmChatCustomBlock.kind` dispatches through `DmChatTheme.customBuilders[kind]`. Unknown kinds render an empty `SizedBox` with a debug-only `assert`.

## Widget API

### `DmChatView` — composed entry point

```dart
class DmChatView extends StatefulWidget {
  const DmChatView({
    required this.messages,                          // ordered oldest → newest
    this.onSend,                                     // (String markdown, List<DmChatAttachment> pending)
    this.onStop,
    this.onAttach,                                   // null → hides attach button
    this.onRetry,                                    // (DmChatMessage) → retry after error
    this.uploadAdapter,                              // drives progress; required for Q10-C pipeline
    this.isStreaming = false,
    this.inputController,                            // DmMarkdownInputController passthrough
    this.inputPlaceholder = 'Message…',
    this.inputLeading,
    this.inputTrailing,
    this.submitShortcut = DmChatSubmitShortcut.cmdEnter,
    this.markdownConfig,                             // DmMarkdownConfig shared by all bubbles
    this.emptyBuilder,
    this.avatarBuilder,                              // (ctx, message) → Widget?
    this.headerBuilder,                              // (ctx, message) → Widget? (name/timestamp)
    this.showJumpToBottom = true,
    this.autoScroll = true,
    this.reverse = true,
    this.padding,
    this.theme,                                      // DmChatTheme override
  });
}
```

### `DmChatBubble` — single message

```dart
class DmChatBubble extends StatefulWidget {
  const DmChatBubble({
    required this.message,
    this.avatar,
    this.header,
    this.markdownConfig,
    this.theme,
  });
}
```

### `DmChatInput` — composer

```dart
enum DmChatSubmitShortcut {
  cmdEnter,   // default — Enter = newline, Cmd/Ctrl+Enter = submit
  enter,      // Enter = submit, Shift+Enter = newline
}

class DmChatInput extends StatefulWidget {
  const DmChatInput({
    required this.onSend,
    this.onStop,
    this.onAttach,
    this.uploadAdapter,
    this.controller,
    this.isStreaming = false,
    this.pendingAttachments = const [],
    this.onRemoveAttachment,
    this.placeholder,
    this.leading,
    this.trailing,
    this.minLines = 1,
    this.maxLines = 8,
    this.submitShortcut = DmChatSubmitShortcut.cmdEnter,
  });
}
```

### Block-level widgets (exported)

- `DmChatThinkingBlockView`
- `DmChatToolCallBlockView`
- `DmChatAttachmentBlockView`

Exposed so power users composing custom bubbles can reuse the block visuals.

### Behavior details

- `DmChatView` owns its `ScrollController`. Pinned-to-bottom tracking = "within 48 px of end". New message while pinned → smooth-scroll to end. While unpinned → show jump-to-bottom FAB with unread count badge.
- `DmChatBubble` is stateful to own per-block subscriptions (thinking elapsed timer, tool-call animations). `didUpdateWidget` diffs blocks by index + `runtimeType`, preserving state where possible.
- `Cmd` maps to Meta on macOS/iOS and Ctrl on Linux/Windows/Android (uses Flutter's `LogicalKeyboardKey.meta` + platform check).
- `onSend` fires with current markdown text + any `status: done` attachments. Editor text and pending-attachments chip row clear on return.

## Streaming & Lifecycle

### Ownership boundary

The **consumer** owns the `List<DmChatMessage>` and all streams. Widgets are rendering-only — they never mutate message state.

### Streaming flow (assistant response)

1. User hits Send in `DmChatInput` → `onSend(markdown, attachments)` fires.
2. Consumer appends a user message (status `complete`).
3. Consumer appends an assistant message:
   - `status: streaming`
   - `blocks: [DmChatThinkingBlock(stream: thinkingStream), DmChatTextBlock(stream: textStream)]`
4. Consumer pipes LLM SDK deltas into `thinkingStream` / `textStream`.
5. Thinking block UI:
   - While any token arrives → expanded, timer ticks.
   - When `textStream` emits its first token → auto-collapse thinking, record elapsed, show "Thought for Ns".
   - User manual expand/collapse after auto-collapse wins.
6. When LLM finishes → consumer closes streams **and** updates the message with `status: complete` + resolved final strings (so rebuilds don't resubscribe to a closed stream).
7. `DmChatView` observes `isStreaming` flip → Stop button reverts to Send.

### Thinking auto-collapse mechanism

`_ThinkingBlockView` watches the sibling `DmChatTextBlock` via an `InheritedNotifier` scoped to the bubble (`_BubbleStreamCoordinator`). First non-empty text token → fires `collapse()`. User manual toggles after that override the auto behavior (tracked by a `_userInteracted` flag).

### Tool-call status animations

- `pending` → shimmer on chip label
- `running` → rotating icon
- `done` → checkmark fade-in
- `error` → red border + error icon

All driven by implicit animations (`AnimatedSwitcher`, `AnimatedContainer`) — no explicit controllers.

### Upload lifecycle

`DmChatInput` holds `pendingAttachments` as a `ValueListenable`. On pick, the adapter's `upload()` stream starts; each emitted `DmChatAttachment` replaces the previous entry by id. Chip re-renders with new progress/status.

On Send, only `status: done` attachments flow to `onSend`; any `uploading` attachments disable the Send button with a tooltip. User can tap a chip's cancel affordance to call `adapter.cancel(id)`.

### Cancellation

`onStop` is the consumer's hook for cancelling the LLM request. The widget doesn't own LLM cancellation — consumer cancels, closes streams, updates the message to `status: complete` (or `error`).

### Error handling

- Stream errors propagate through `DmMarkdown`'s existing stream-error path.
- Consumer additionally flips `DmChatMessage.status = error` with a populated `error` field.
- Per-block error rendering: a red `DmCard` beneath the failed block containing the error message and a `Retry` button that fires `onRetry(message)` if the prop is provided on `DmChatView`.

## Theming

`DmChatTheme` follows the existing `ThemeExtension` pattern used by `DmCodeEditorTheme` and `DmFormTheme`.

```dart
class DmChatTheme extends ThemeExtension<DmChatTheme> {
  // Bubble surfaces
  final Color userBubbleColor;              // default: colorScheme.primaryContainer
  final Color userBubbleOnColor;            // default: colorScheme.onPrimaryContainer
  final Color assistantSurface;             // default: Colors.transparent
  final Color systemSurface;                // default: dmColors.neutral

  final BorderRadius userBubbleRadius;      // default: BorderRadius.circular(16)
  final EdgeInsets bubblePadding;           // default: EdgeInsets.all(12)
  final double userBubbleMaxWidthFraction;  // default: 0.8
  final double rowSpacing;                  // default: 12

  // Thinking block
  final Color thinkingForeground;
  final Color thinkingSurface;
  final TextStyle thinkingTextStyle;
  final Duration thinkingCollapseAnimation;

  // Tool-call chip
  final Color toolCallChipColor;
  final Color toolCallChipRunningColor;
  final Color toolCallChipDoneColor;
  final Color toolCallChipErrorColor;
  final TextStyle toolCallLabelStyle;

  // Attachments
  final Color attachmentChipColor;
  final double attachmentImageThumbSize;    // default: 96

  // Input
  final EdgeInsets inputPadding;
  final Color inputSurface;
  final double inputElevation;
  final BorderRadius inputRadius;

  // Extensibility
  final Map<String, Widget Function(BuildContext, DmChatCustomBlock)> customBuilders;
  final Widget Function(BuildContext, DmChatRole)? defaultAvatarBuilder;

  factory DmChatTheme.withContext(BuildContext context);
  @override DmChatTheme copyWith({...});
  @override DmChatTheme lerp(covariant DmChatTheme? other, double t);
}
```

### Resolution precedence

1. Explicit `theme:` prop on `DmChatView` / `DmChatBubble` / `DmChatInput`.
2. `Theme.of(context).extension<DmChatTheme>()`.
3. `DmChatTheme.withContext(context)` (defaults derived from ambient `ColorScheme` + `DmColorExtension`).

### Adaptive rendering

All widgets use the `AdaptiveWidget` mixin. Material is the default. Cupertino path:

- `DmChatInput` uses `CupertinoButton` for send / stop / attach.
- `DmChatBubble` user bubbles derive surface from `CupertinoColors.activeBlue`.
- Thinking / tool-call / attachment content stays the same (markdown-driven); only chrome (buttons, borders) switches.

**Fluent is not supported in v1.** Chat is not a native desktop form idiom. Can be added later following the `duskmoon_settings` pattern if requested.

Dark mode is free: `.withContext(context)` reads `Theme.of(context).brightness` through `ColorScheme` / `DmColorExtension`.

## Testing Strategy

New files under `packages/duskmoon_widgets/test/chat/`:

| Test file | Covers |
|---|---|
| `dm_chat_message_test.dart` | Model invariants (text/stream exclusivity); `copyWith`; sealed-class exhaustiveness via switch helper. |
| `dm_chat_bubble_test.dart` | Role-based layout: user = right-aligned bubble with max-width; assistant = full-width row; system = centered muted. Avatar/header slot rendering. Markdown via `DmMarkdown`. |
| `dm_chat_thinking_block_test.dart` | Auto-expand while tokens arrive; auto-collapse on first sibling text token; user toggle overrides auto; "Thought for Ns" summary after `elapsed` set. |
| `dm_chat_tool_call_block_test.dart` | Chip states; tap-expand reveals input/output as syntax-highlighted code; error chip shows `errorMessage`. |
| `dm_chat_attachment_block_test.dart` | Image thumbnail vs. file chip; upload progress binding; cancel via adapter; retry on error. |
| `dm_chat_input_test.dart` | Submit shortcut default `cmdEnter` and `enter` mode; Send↔Stop toggle on `isStreaming`; Send disabled while any attachment is `uploading`; attach button hidden when `onAttach == null`; pending-attachments row clears on send. |
| `dm_chat_view_test.dart` | Reverse list order; pinned-to-bottom auto-scroll on new message; jump-to-bottom FAB appears when scrolled up + unread count; `emptyBuilder`; `markdownConfig` propagation. |
| `dm_chat_theme_test.dart` | `withContext` derives from `ColorScheme` + `DmColorExtension`; explicit `theme` prop wins over `Theme.extension`; `lerp` interpolates correctly. |

Streaming tests use `StreamController<String>` fakes — no real LLM calls. Tests assert against exact hex values for themed colors where they come from codegen (matches repo convention).

All new files must pass `dart analyze --fatal-infos` (project convention).

**Golden tests:** not in v1. Can be added once visual conventions settle.

## Example App Integration

New page `example/lib/pages/chat_page.dart` (follows existing 9-page showcase pattern):

1. Canned "LLM" that replays a scripted sequence with artificial delays, driving `DmChatTextBlock.stream` + `DmChatThinkingBlock.stream` via `StreamController`s.
2. Mock `DmChatUploadAdapter` emitting fake progress ticks.
3. One scripted tool-call round-trip (`run_code` → pending → running → done with output).
4. Live toggle between `submitShortcut: cmdEnter` and `enter`.
5. One custom-block kind (`"citation"`) registered via `DmChatTheme.customBuilders` to prove the extension point.

Nav entry added in `example/lib/main.dart`.

## Open Questions

None — all scoping decisions confirmed via Q1–Q10 + input-shortcut follow-up.

## Out of Scope (explicitly)

- Human messaging primitives (delivery receipts, typing indicators, per-peer avatars).
- Fluent-platform variants.
- Golden tests.
- LLM-SDK-specific adapters.
- Message virtualization beyond what `ListView` provides (reverse `ListView.builder` is sufficient for realistic chat scrollback lengths; can revisit with `SliverReorderableList` or custom viewport if needed).
- Persistence (message history storage is the consumer's concern).
