# DmChat Widget Module Design Spec

## Overview
A new package `duskmoon_chat` in the DuskMoon UI monorepo providing a production-grade LLM-focused chat widget. It features streaming markdown rendering, thinking/reasoning blocks, tool-call tracking, attachments with upload adapters, and an opinionated auto-scrolling list view.

## Scope
- **Path**: `packages/duskmoon_chat/`
- **Use Case**: LLM assistant interactions (streaming, tool calls, reasoning), not human-to-human messaging.
- **Dependencies**: Depends on `duskmoon_widgets` (for layout/primitives), `duskmoon_theme` (for colors/styling), and `file_picker` (for attachments).

## Architecture

The module is divided into three layers:
1. **Model Layer**: Immutable, heterogeneous representation of chat data.
2. **Primitive Views**: Individual renderers for specific block types (bubbles, thinking cards, tool chips).
3. **Composed View**: `DmChatView`, an opinionated list + input layout managing scroll behavior.

## Data Model

```dart
enum DmChatRole { user, assistant, system }
enum DmChatMessageStatus { pending, streaming, done, error, stopped }

/// An immutable message in the chat timeline.
class DmChatMessage {
  final String id;
  final DmChatRole role;
  final List<DmChatBlock> blocks;
  final DateTime? createdAt;
  final DmChatMessageStatus status;
  final Object? error;
}

sealed class DmChatBlock {}

/// Text or markdown content. Only one of text or stream is non-null.
class DmChatTextBlock extends DmChatBlock {
  final String? text;
  final Stream<String>? stream;
}

/// Assistant reasoning block. Auto-collapses on completion.
class DmChatThinkingBlock extends DmChatBlock {
  final String? text;
  final Stream<String>? stream;
  final Duration? duration;
  final bool initiallyExpanded;
}

enum DmChatToolCallStatus { running, done, error }

/// Status and payload of an LLM tool call.
class DmChatToolCallBlock extends DmChatBlock {
  final String toolName;
  final Map<String, Object?> input;
  final String? output;
  final DmChatToolCallStatus status; // running | done | error
  final Object? error;
}

class DmChatAttachmentBlock extends DmChatBlock {
  final List<DmChatAttachment> attachments;
}

class DmChatCustomBlock extends DmChatBlock {
  final String kind;
  final Object? data;
}
```

### Attachment & Upload Interfaces

```dart
enum DmChatUploadStatus { idle, uploading, done, error }

class DmChatAttachment {
  final String id;
  final String name;
  final int? sizeBytes;
  final String? mimeType;
  final Uri? url;
  final Uint8List? bytes;
  final DmChatUploadStatus uploadStatus;
  final double? uploadProgress;
  final Object? uploadError;
}

/// Implemented by the app to handle file uploads
abstract class DmChatUploadAdapter {
  Stream<DmChatAttachment> upload(DmChatAttachment attachment);
  Future<void> cancel(String attachmentId);
}
```

## UI Components & Interaction

### DmChatView
The top-level exported widget.
- **Layout**: `Column` containing a reverse `ListView.builder` for messages, and a `DmChatInput` at the bottom.
- **State/Props**: Takes `List<DmChatMessage> messages`. Caller handles appending blocks and updating status.
- **Scroll Behavior**: Auto-scrolls to bottom on new content if already at bottom. Pauses auto-scroll and shows "Jump to Bottom" FAB if user scrolls up.

### Bubble Layout (Hybrid Pattern)
- **User Messages**: Right-aligned, 80% max-width, `primaryContainer` bubble surface. No avatar.
- **Assistant Messages**: Full-width row, left-aligned avatar, content uses ambient background.

### Block Renderers
- **Text Block**: Reuses `DmMarkdown(data: ...)` or `DmMarkdown(stream: ...)` from `duskmoon_widgets`.
- **Thinking Block**: Renders as a `DmCard` with muted `surfaceVariant`. Expanded while streaming. Auto-collapses to "Thought for X sec" chip when done.
- **Tool Call Block**: Renders as a compact chip row (`[🔧 name] [spinner]`). Tap expands a panel showing syntax-highlighted JSON input and output via `DmMarkdown`.
- **Attachment Block**: Renders as file chips or image thumbnails. Overlays circular progress indicator when `uploadStatus == uploading`.

### Input Area
Wraps the existing `DmMarkdownInput` from `duskmoon_widgets`.
- **Actions**: Built-in "Send" button.
- **State Toggle**: Changes "Send" to "Stop" when the bottom-most assistant message is `isStreaming`.
- **Attach**: Built-in paperclip icon invokes `file_picker`. Yields local files to the caller via `onAttach` callback to be wrapped in a message and sent to the upload adapter.

## Theme & Styling
- Driven by `duskmoon_theme`.
- `DmChatThemeData` extension configures bubble colors, avatar styles, and spacing.
- Relies on `DmColorScheme` semantic tokens (`primaryContainer`, `surfaceVariant`, `onSurfaceVariant`).

## Incremental Delivery Plan (TBD)
1. Base package scaffold + data models.
2. Primitive block renderers (Text, Thinking).
3. Bubble layouts and compositing.
4. `DmChatView` scroll management and Input wiring.
5. Attachments and upload adapter (optional feature slice).
