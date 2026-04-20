# DmChat Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the `DmChat*` module under `packages/duskmoon_widgets/lib/src/chat/` — models, theme, bubble with four block types + extensible custom block, input with Send/Stop/Attach + configurable submit shortcut, and a composed `DmChatView` with reverse list + pinned auto-scroll.

**Architecture:** Consumer-owned message list + per-block streams. Widgets render only; never mutate state. Reuses `DmMarkdown(stream:)` for zero-rebuild token streaming. `ThemeExtension`-based `DmChatTheme` derived from ambient `ColorScheme` + `DmColorExtension`. `AdaptiveWidget` mixin for Material/Cupertino variants (no Fluent in v1).

**Tech Stack:** Flutter >=3.24.0, Dart >=3.5.0, Melos 7.x, `flutter_test`, existing deps (`markdown`, `highlighting`, `flutter_math_fork`, `url_launcher`, `fluent_ui`), new dep `file_picker: ^8.1.2` for attachment picking.

**Spec:** [docs/superpowers/specs/2026-04-20-dm-chat-design.md](../specs/2026-04-20-dm-chat-design.md)

---

## File Structure

```
packages/duskmoon_widgets/
├── pubspec.yaml                                           (MOD: add file_picker)
├── lib/
│   ├── duskmoon_widgets.dart                              (MOD: add Chat exports)
│   └── src/chat/
│       ├── chat.dart                                      (NEW: barrel)
│       ├── models/
│       │   ├── dm_chat_message.dart                       (NEW)
│       │   ├── dm_chat_block.dart                         (NEW)
│       │   └── dm_chat_attachment.dart                    (NEW)
│       ├── theme/
│       │   └── dm_chat_theme.dart                         (NEW)
│       ├── bubble/
│       │   ├── dm_chat_bubble.dart                        (NEW)
│       │   ├── _bubble_frame.dart                         (NEW)
│       │   ├── _bubble_stream_coordinator.dart            (NEW)
│       │   └── blocks/
│       │       ├── _text_block_view.dart                  (NEW)
│       │       ├── _thinking_block_view.dart              (NEW)
│       │       ├── _tool_call_block_view.dart             (NEW)
│       │       ├── _attachment_block_view.dart            (NEW)
│       │       └── _custom_block_view.dart                (NEW)
│       ├── input/
│       │   ├── dm_chat_input.dart                         (NEW)
│       │   ├── dm_chat_submit_shortcut.dart               (NEW)
│       │   ├── _send_button.dart                          (NEW)
│       │   └── _attach_button.dart                        (NEW)
│       └── view/
│           ├── dm_chat_view.dart                          (NEW)
│           └── _scroll_tracker.dart                       (NEW)
└── test/chat/                                             (NEW dir)
    ├── dm_chat_message_test.dart
    ├── dm_chat_block_test.dart
    ├── dm_chat_attachment_test.dart
    ├── dm_chat_theme_test.dart
    ├── dm_chat_bubble_test.dart
    ├── dm_chat_thinking_block_test.dart
    ├── dm_chat_tool_call_block_test.dart
    ├── dm_chat_attachment_block_test.dart
    ├── dm_chat_input_test.dart
    └── dm_chat_view_test.dart
```

Example app: `example/lib/screens/chat/chat_screen.dart` (NEW), `example/lib/router.dart` and `example/lib/destination.dart` (MOD to register).

---

## Task 1: Scaffold — add dependency, folder structure, barrel

**Files:**
- Modify: `packages/duskmoon_widgets/pubspec.yaml`
- Create: `packages/duskmoon_widgets/lib/src/chat/chat.dart`
- Modify: `packages/duskmoon_widgets/lib/duskmoon_widgets.dart`

- [ ] **Step 1.1: Add file_picker dependency**

Edit `packages/duskmoon_widgets/pubspec.yaml`, append under `dependencies:` (alphabetical insert after `fluent_ui:`):

```yaml
  file_picker: ^8.1.2
```

- [ ] **Step 1.2: Run pub get and verify resolution**

Run: `cd packages/duskmoon_widgets && flutter pub get`
Expected: `Got dependencies!` with `file_picker` resolved.

- [ ] **Step 1.3: Create empty barrel file**

Create `packages/duskmoon_widgets/lib/src/chat/chat.dart`:

```dart
/// DuskMoon chat module — bubbles, blocks, input, and composed view.
///
/// See `docs/superpowers/specs/2026-04-20-dm-chat-design.md` for design.
library;

// Exports are added as each task ships.
```

- [ ] **Step 1.4: Wire barrel into duskmoon_widgets.dart**

Add to `packages/duskmoon_widgets/lib/duskmoon_widgets.dart` at the end (after Code Editor section):

```dart

// Chat
export 'src/chat/chat.dart';
```

- [ ] **Step 1.5: Verify analyzer**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 1.6: Commit**

```bash
git add packages/duskmoon_widgets/pubspec.yaml \
        packages/duskmoon_widgets/lib/src/chat/chat.dart \
        packages/duskmoon_widgets/lib/duskmoon_widgets.dart \
        packages/duskmoon_widgets/pubspec.lock
git commit -m "feat(chat): scaffold chat module with file_picker dep"
```

---

## Task 2: Message model — `DmChatRole`, `DmChatMessageStatus`, `DmChatMessage`

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/models/dm_chat_message.dart`
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_message_test.dart`

- [ ] **Step 2.1: Write failing test**

Create `packages/duskmoon_widgets/test/chat/dm_chat_message_test.dart`:

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmChatMessage', () {
    test('constructs with required fields', () {
      final msg = DmChatMessage(
        id: 'm1',
        role: DmChatRole.user,
        blocks: const [],
      );
      expect(msg.id, 'm1');
      expect(msg.role, DmChatRole.user);
      expect(msg.status, DmChatMessageStatus.complete);
      expect(msg.error, isNull);
      expect(msg.createdAt, isNull);
    });

    test('copyWith overrides selected fields and keeps the rest', () {
      final msg = DmChatMessage(
        id: 'm1',
        role: DmChatRole.assistant,
        blocks: const [],
        status: DmChatMessageStatus.streaming,
      );
      final copy = msg.copyWith(status: DmChatMessageStatus.complete);
      expect(copy.id, 'm1');
      expect(copy.role, DmChatRole.assistant);
      expect(copy.status, DmChatMessageStatus.complete);
    });

    test('equality compares by value', () {
      final a = DmChatMessage(id: 'm1', role: DmChatRole.user, blocks: const []);
      final b = DmChatMessage(id: 'm1', role: DmChatRole.user, blocks: const []);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
  });
}
```

- [ ] **Step 2.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_message_test.dart`
Expected: Fails with `Undefined name 'DmChatMessage'` (or similar).

- [ ] **Step 2.3: Implement the model**

Create `packages/duskmoon_widgets/lib/src/chat/models/dm_chat_message.dart`:

```dart
import 'package:flutter/foundation.dart';

import 'dm_chat_block.dart';

/// Role of a chat message participant.
enum DmChatRole { user, assistant, system }

/// Lifecycle status of a chat message.
enum DmChatMessageStatus { pending, streaming, complete, error }

/// A single chat message composed of ordered content blocks.
@immutable
class DmChatMessage {
  const DmChatMessage({
    required this.id,
    required this.role,
    required this.blocks,
    this.status = DmChatMessageStatus.complete,
    this.error,
    this.createdAt,
  });

  /// Stable identifier used for list diffing and stream re-subscription keys.
  final String id;
  final DmChatRole role;
  final List<DmChatBlock> blocks;
  final DmChatMessageStatus status;

  /// Populated when [status] == [DmChatMessageStatus.error].
  final Object? error;

  /// Optional creation timestamp — not rendered by default.
  final DateTime? createdAt;

  DmChatMessage copyWith({
    String? id,
    DmChatRole? role,
    List<DmChatBlock>? blocks,
    DmChatMessageStatus? status,
    Object? error,
    DateTime? createdAt,
  }) =>
      DmChatMessage(
        id: id ?? this.id,
        role: role ?? this.role,
        blocks: blocks ?? this.blocks,
        status: status ?? this.status,
        error: error ?? this.error,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatMessage &&
          id == other.id &&
          role == other.role &&
          listEquals(blocks, other.blocks) &&
          status == other.status &&
          error == other.error &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      Object.hash(id, role, Object.hashAll(blocks), status, error, createdAt);
}
```

- [ ] **Step 2.4: Add to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`, add:

```dart
// Models
export 'models/dm_chat_message.dart';
```

- [ ] **Step 2.5: Stub `dm_chat_block.dart` to satisfy import**

Create `packages/duskmoon_widgets/lib/src/chat/models/dm_chat_block.dart`:

```dart
import 'package:flutter/foundation.dart';

/// Base class for message content blocks. Replaced with a sealed hierarchy in Task 3.
@immutable
abstract class DmChatBlock {
  const DmChatBlock();
}
```

- [ ] **Step 2.6: Run test — verify it passes**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_message_test.dart`
Expected: All 3 tests pass.

- [ ] **Step 2.7: Verify analyzer**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 2.8: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_message_test.dart
git commit -m "feat(chat): add DmChatMessage, DmChatRole, DmChatMessageStatus"
```

---

## Task 3: Block model — sealed `DmChatBlock` hierarchy

**Files:**
- Modify: `packages/duskmoon_widgets/lib/src/chat/models/dm_chat_block.dart` (replace stub)
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_block_test.dart`

- [ ] **Step 3.1: Write failing tests**

Create `packages/duskmoon_widgets/test/chat/dm_chat_block_test.dart`:

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmChatTextBlock', () {
    test('accepts static text', () {
      const b = DmChatTextBlock(text: 'hello');
      expect(b.text, 'hello');
      expect(b.stream, isNull);
    });

    test('accepts stream', () {
      final s = Stream<String>.value('hi');
      final b = DmChatTextBlock(stream: s);
      expect(b.text, isNull);
      expect(b.stream, same(s));
    });

    test('asserts exactly one of text/stream is non-null', () {
      expect(() => DmChatTextBlock(), throwsAssertionError);
      expect(
        () => DmChatTextBlock(text: 'x', stream: Stream.value('y')),
        throwsAssertionError,
      );
    });
  });

  group('DmChatThinkingBlock', () {
    test('stores elapsed when complete', () {
      const b = DmChatThinkingBlock(
        text: 'reasoning',
        elapsed: Duration(seconds: 3),
      );
      expect(b.elapsed, const Duration(seconds: 3));
    });

    test('asserts exactly one of text/stream', () {
      expect(() => DmChatThinkingBlock(), throwsAssertionError);
    });
  });

  group('DmChatToolCallBlock', () {
    test('has default status pending', () {
      const b = DmChatToolCallBlock(id: 't1', name: 'search');
      expect(b.status, DmChatToolCallStatus.pending);
      expect(b.input, isNull);
      expect(b.output, isNull);
    });
  });

  group('DmChatAttachmentBlock', () {
    test('wraps a list of attachments', () {
      const att = DmChatAttachment(id: 'a1', name: 'x.png');
      const b = DmChatAttachmentBlock(attachments: [att]);
      expect(b.attachments, hasLength(1));
    });
  });

  group('DmChatCustomBlock', () {
    test('stores kind and data', () {
      const b = DmChatCustomBlock(kind: 'citation', data: {'n': 1});
      expect(b.kind, 'citation');
      expect(b.data, {'n': 1});
    });
  });

  test('sealed switch is exhaustive', () {
    String describe(DmChatBlock b) => switch (b) {
          DmChatTextBlock() => 'text',
          DmChatThinkingBlock() => 'thinking',
          DmChatToolCallBlock() => 'tool',
          DmChatAttachmentBlock() => 'attachment',
          DmChatCustomBlock() => 'custom',
        };
    expect(describe(const DmChatTextBlock(text: 'a')), 'text');
  });
}
```

- [ ] **Step 3.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_block_test.dart`
Expected: Fails (subclasses and `DmChatAttachment` not defined).

- [ ] **Step 3.3: Replace `dm_chat_block.dart` with full sealed hierarchy**

Overwrite `packages/duskmoon_widgets/lib/src/chat/models/dm_chat_block.dart`:

```dart
import 'package:flutter/foundation.dart';

import 'dm_chat_attachment.dart';

/// Status of a tool-call block.
enum DmChatToolCallStatus { pending, running, done, error }

/// Base class for message content blocks. Use pattern matching on subclasses.
@immutable
sealed class DmChatBlock {
  const DmChatBlock();
}

/// Markdown text block. Provide exactly one of [text] or [stream].
@immutable
class DmChatTextBlock extends DmChatBlock {
  const DmChatTextBlock({this.text, this.stream})
      : assert(
          (text == null) != (stream == null),
          'Exactly one of text or stream must be non-null',
        );

  final String? text;
  final Stream<String>? stream;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatTextBlock && text == other.text && stream == other.stream;

  @override
  int get hashCode => Object.hash(text, stream);
}

/// Reasoning / thinking block. Provide exactly one of [text] or [stream].
@immutable
class DmChatThinkingBlock extends DmChatBlock {
  const DmChatThinkingBlock({this.text, this.stream, this.elapsed})
      : assert(
          (text == null) != (stream == null),
          'Exactly one of text or stream must be non-null',
        );

  final String? text;
  final Stream<String>? stream;

  /// Elapsed reasoning duration; drives the "Thought for Ns" summary.
  final Duration? elapsed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatThinkingBlock &&
          text == other.text &&
          stream == other.stream &&
          elapsed == other.elapsed;

  @override
  int get hashCode => Object.hash(text, stream, elapsed);
}

/// Tool-call block — chip-style renderer with expand-on-tap input/output.
@immutable
class DmChatToolCallBlock extends DmChatBlock {
  const DmChatToolCallBlock({
    required this.id,
    required this.name,
    this.input,
    this.output,
    this.status = DmChatToolCallStatus.pending,
    this.errorMessage,
  });

  /// Tool-call id supplied by the LLM (used as stable widget key).
  final String id;
  final String name;

  /// JSON-encodable input payload.
  final Object? input;

  /// JSON-encodable output or markdown string.
  final Object? output;

  final DmChatToolCallStatus status;
  final String? errorMessage;

  DmChatToolCallBlock copyWith({
    String? id,
    String? name,
    Object? input,
    Object? output,
    DmChatToolCallStatus? status,
    String? errorMessage,
  }) =>
      DmChatToolCallBlock(
        id: id ?? this.id,
        name: name ?? this.name,
        input: input ?? this.input,
        output: output ?? this.output,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatToolCallBlock &&
          id == other.id &&
          name == other.name &&
          input == other.input &&
          output == other.output &&
          status == other.status &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      Object.hash(id, name, input, output, status, errorMessage);
}

/// Attachment block — one or more files/images.
@immutable
class DmChatAttachmentBlock extends DmChatBlock {
  const DmChatAttachmentBlock({required this.attachments});

  final List<DmChatAttachment> attachments;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatAttachmentBlock &&
          listEquals(attachments, other.attachments);

  @override
  int get hashCode => Object.hashAll(attachments);
}

/// Extensible custom block. Renderer is resolved via
/// `DmChatTheme.customBuilders[kind]`.
@immutable
class DmChatCustomBlock extends DmChatBlock {
  const DmChatCustomBlock({required this.kind, this.data});

  final String kind;
  final Object? data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatCustomBlock && kind == other.kind && data == other.data;

  @override
  int get hashCode => Object.hash(kind, data);
}
```

- [ ] **Step 3.4: Add exports to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`:

```dart
// Models
export 'models/dm_chat_block.dart';
export 'models/dm_chat_message.dart';
```

- [ ] **Step 3.5: Stub `dm_chat_attachment.dart` to satisfy import**

Create `packages/duskmoon_widgets/lib/src/chat/models/dm_chat_attachment.dart`:

```dart
import 'package:flutter/foundation.dart';

/// Stub — replaced with the full model in Task 4.
@immutable
class DmChatAttachment {
  const DmChatAttachment({required this.id, required this.name});
  final String id;
  final String name;
}
```

- [ ] **Step 3.6: Run test — verify it passes**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_block_test.dart`
Expected: All tests pass.

- [ ] **Step 3.7: Verify analyzer**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 3.8: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_block_test.dart
git commit -m "feat(chat): add sealed DmChatBlock hierarchy"
```

---

## Task 4: Attachment model + upload adapter

**Files:**
- Modify: `packages/duskmoon_widgets/lib/src/chat/models/dm_chat_attachment.dart` (replace stub)
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_attachment_test.dart`

- [ ] **Step 4.1: Write failing tests**

Create `packages/duskmoon_widgets/test/chat/dm_chat_attachment_test.dart`:

```dart
import 'dart:async';
import 'dart:typed_data';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmChatAttachment', () {
    test('defaults status to idle', () {
      const a = DmChatAttachment(id: 'a1', name: 'f.png');
      expect(a.status, DmChatAttachmentStatus.idle);
      expect(a.uploadProgress, isNull);
    });

    test('copyWith overrides selected fields', () {
      const a = DmChatAttachment(id: 'a1', name: 'f.png');
      final b = a.copyWith(
        status: DmChatAttachmentStatus.uploading,
        uploadProgress: 0.5,
      );
      expect(b.status, DmChatAttachmentStatus.uploading);
      expect(b.uploadProgress, 0.5);
      expect(b.name, 'f.png');
    });

    test('equality compares by value including bytes', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final a = DmChatAttachment(id: 'a1', name: 'f.png', bytes: bytes);
      final b = DmChatAttachment(id: 'a1', name: 'f.png', bytes: bytes);
      expect(a, equals(b));
    });
  });

  group('DmChatUploadAdapter', () {
    test('adapter interface is implementable', () async {
      final adapter = _FakeAdapter();
      const local = DmChatAttachment(id: 'a1', name: 'f.png');
      final progress = <double>[];
      await for (final update in adapter.upload(local)) {
        if (update.uploadProgress != null) progress.add(update.uploadProgress!);
        if (update.status == DmChatAttachmentStatus.done) break;
      }
      expect(progress, [0.5, 1.0]);
    });
  });
}

class _FakeAdapter implements DmChatUploadAdapter {
  @override
  Stream<DmChatAttachment> upload(DmChatAttachment local) async* {
    yield local.copyWith(
      status: DmChatAttachmentStatus.uploading,
      uploadProgress: 0.5,
    );
    yield local.copyWith(
      status: DmChatAttachmentStatus.done,
      uploadProgress: 1.0,
      url: Uri.parse('https://example.com/${local.name}'),
    );
  }

  @override
  Future<void> cancel(String attachmentId) async {}
}
```

- [ ] **Step 4.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_attachment_test.dart`
Expected: Fails (extra fields and adapter missing).

- [ ] **Step 4.3: Overwrite `dm_chat_attachment.dart` with the full model**

```dart
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

/// Lifecycle status of an attachment.
enum DmChatAttachmentStatus { idle, uploading, done, error }

/// A file/image attachment tied to a chat message or pending input composition.
@immutable
class DmChatAttachment {
  const DmChatAttachment({
    required this.id,
    required this.name,
    this.sizeBytes,
    this.mimeType,
    this.url,
    this.bytes,
    this.status = DmChatAttachmentStatus.idle,
    this.uploadProgress,
    this.errorMessage,
  });

  /// Stable attachment id (used as widget key and cancel handle).
  final String id;
  final String name;
  final int? sizeBytes;
  final String? mimeType;

  /// Remote URL after upload.
  final Uri? url;

  /// Local bytes prior to (or alongside) upload.
  final Uint8List? bytes;

  final DmChatAttachmentStatus status;

  /// Upload progress in [0.0, 1.0] inclusive.
  final double? uploadProgress;

  final String? errorMessage;

  DmChatAttachment copyWith({
    String? id,
    String? name,
    int? sizeBytes,
    String? mimeType,
    Uri? url,
    Uint8List? bytes,
    DmChatAttachmentStatus? status,
    double? uploadProgress,
    String? errorMessage,
  }) =>
      DmChatAttachment(
        id: id ?? this.id,
        name: name ?? this.name,
        sizeBytes: sizeBytes ?? this.sizeBytes,
        mimeType: mimeType ?? this.mimeType,
        url: url ?? this.url,
        bytes: bytes ?? this.bytes,
        status: status ?? this.status,
        uploadProgress: uploadProgress ?? this.uploadProgress,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatAttachment &&
          id == other.id &&
          name == other.name &&
          sizeBytes == other.sizeBytes &&
          mimeType == other.mimeType &&
          url == other.url &&
          _bytesEqual(bytes, other.bytes) &&
          status == other.status &&
          uploadProgress == other.uploadProgress &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        sizeBytes,
        mimeType,
        url,
        bytes == null ? null : Object.hashAll(bytes!),
        status,
        uploadProgress,
        errorMessage,
      );

  static bool _bytesEqual(Uint8List? a, Uint8List? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Adapter implemented by consumers to upload local attachments.
///
/// [upload] emits updated [DmChatAttachment] snapshots as progress advances.
/// Implementations should:
/// - Always emit at least one terminal value with `status: done` or `error`.
/// - Emit progress updates with `status: uploading` and `uploadProgress` in [0,1].
/// - Preserve the original [DmChatAttachment.id] in every emission.
///
/// [cancel] aborts an in-flight upload by id; no-op if the upload is not active.
abstract class DmChatUploadAdapter {
  Stream<DmChatAttachment> upload(DmChatAttachment local);
  Future<void> cancel(String attachmentId);
}
```

- [ ] **Step 4.4: Add export to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`:

```dart
// Models
export 'models/dm_chat_attachment.dart';
export 'models/dm_chat_block.dart';
export 'models/dm_chat_message.dart';
```

- [ ] **Step 4.5: Run test — verify it passes**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_attachment_test.dart`
Expected: All tests pass.

- [ ] **Step 4.6: Run analyzer**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 4.7: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_attachment_test.dart
git commit -m "feat(chat): add DmChatAttachment + DmChatUploadAdapter"
```

---

## Task 5: `DmChatTheme` — `ThemeExtension` with context-derived defaults

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/theme/dm_chat_theme.dart`
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_theme_test.dart`

- [ ] **Step 5.1: Write failing tests**

Create `packages/duskmoon_widgets/test/chat/dm_chat_theme_test.dart`:

```dart
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmChatTheme.withContext', () {
    testWidgets('derives colors from ColorScheme', (tester) async {
      late DmChatTheme theme;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          ),
          home: Builder(
            builder: (ctx) {
              theme = DmChatTheme.withContext(ctx);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(
        theme.userBubbleColor,
        Theme.of(tester.element(find.byType(SizedBox)))
            .colorScheme
            .primaryContainer,
      );
      expect(theme.userBubbleRadius, BorderRadius.circular(16));
      expect(theme.userBubbleMaxWidthFraction, 0.8);
    });

    testWidgets('uses DmColorExtension for thinking/tool-call colors when present',
        (tester) async {
      late DmChatTheme theme;
      await tester.pumpWidget(
        MaterialApp(
          theme: DmThemeData.sunshine(),
          home: Builder(
            builder: (ctx) {
              theme = DmChatTheme.withContext(ctx);
              return const SizedBox();
            },
          ),
        ),
      );
      final ext = Theme.of(tester.element(find.byType(SizedBox)))
          .extension<DmColorExtension>()!;
      expect(theme.toolCallChipDoneColor, ext.success);
      expect(theme.toolCallChipErrorColor, ext.error);
    });
  });

  group('DmChatTheme.lerp', () {
    test('interpolates colors', () {
      const a = DmChatTheme(
        userBubbleColor: Color(0xFF000000),
        userBubbleOnColor: Color(0xFFFFFFFF),
        assistantSurface: Colors.transparent,
        systemSurface: Color(0xFF808080),
        userBubbleRadius: BorderRadius.zero,
        bubblePadding: EdgeInsets.zero,
        userBubbleMaxWidthFraction: 0.8,
        rowSpacing: 12,
        thinkingForeground: Color(0xFF000000),
        thinkingSurface: Color(0xFFCCCCCC),
        thinkingTextStyle: TextStyle(),
        thinkingCollapseAnimation: Duration(milliseconds: 200),
        toolCallChipColor: Color(0xFF2196F3),
        toolCallChipRunningColor: Color(0xFFFF9800),
        toolCallChipDoneColor: Color(0xFF4CAF50),
        toolCallChipErrorColor: Color(0xFFF44336),
        toolCallLabelStyle: TextStyle(),
        attachmentChipColor: Color(0xFFCCCCCC),
        attachmentImageThumbSize: 96,
        inputPadding: EdgeInsets.zero,
        inputSurface: Color(0xFFFFFFFF),
        inputElevation: 1,
        inputRadius: BorderRadius.zero,
        customBuilders: {},
      );
      final b = a.copyWith(userBubbleColor: const Color(0xFFFFFFFF));
      final mid = a.lerp(b, 0.5);
      expect(mid.userBubbleColor, const Color(0xFF808080));
    });
  });
}
```

- [ ] **Step 5.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_theme_test.dart`
Expected: Fails (`DmChatTheme` not defined).

- [ ] **Step 5.3: Implement `DmChatTheme`**

Create `packages/duskmoon_widgets/lib/src/chat/theme/dm_chat_theme.dart`:

```dart
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';

import '../models/dm_chat_block.dart';
import '../models/dm_chat_message.dart';

/// Custom-block renderer signature.
typedef DmChatCustomBlockBuilder = Widget Function(
  BuildContext context,
  DmChatCustomBlock block,
);

/// Avatar fallback signature — used when `DmChatView.avatarBuilder` is null.
typedef DmChatAvatarBuilder = Widget? Function(
  BuildContext context,
  DmChatRole role,
);

/// Theme extension controlling chat visual conventions.
@immutable
class DmChatTheme extends ThemeExtension<DmChatTheme> {
  const DmChatTheme({
    required this.userBubbleColor,
    required this.userBubbleOnColor,
    required this.assistantSurface,
    required this.systemSurface,
    required this.userBubbleRadius,
    required this.bubblePadding,
    required this.userBubbleMaxWidthFraction,
    required this.rowSpacing,
    required this.thinkingForeground,
    required this.thinkingSurface,
    required this.thinkingTextStyle,
    required this.thinkingCollapseAnimation,
    required this.toolCallChipColor,
    required this.toolCallChipRunningColor,
    required this.toolCallChipDoneColor,
    required this.toolCallChipErrorColor,
    required this.toolCallLabelStyle,
    required this.attachmentChipColor,
    required this.attachmentImageThumbSize,
    required this.inputPadding,
    required this.inputSurface,
    required this.inputElevation,
    required this.inputRadius,
    this.customBuilders = const {},
    this.defaultAvatarBuilder,
  });

  // Bubble surfaces
  final Color userBubbleColor;
  final Color userBubbleOnColor;
  final Color assistantSurface;
  final Color systemSurface;
  final BorderRadius userBubbleRadius;
  final EdgeInsets bubblePadding;
  final double userBubbleMaxWidthFraction;
  final double rowSpacing;

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
  final double attachmentImageThumbSize;

  // Input
  final EdgeInsets inputPadding;
  final Color inputSurface;
  final double inputElevation;
  final BorderRadius inputRadius;

  // Extension points
  final Map<String, DmChatCustomBlockBuilder> customBuilders;
  final DmChatAvatarBuilder? defaultAvatarBuilder;

  /// Derives a [DmChatTheme] from ambient [Theme] + optional [DmColorExtension].
  factory DmChatTheme.withContext(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final ext = theme.extension<DmColorExtension>();

    Color thinkingSurface;
    Color toolDone;
    Color toolError;
    Color toolRunning;
    Color toolDefault;
    Color attachment;
    Color systemSurface;

    if (ext != null) {
      thinkingSurface = ext.surfaceVariant;
      toolDefault = ext.info;
      toolRunning = ext.warning;
      toolDone = ext.success;
      toolError = ext.error;
      attachment = ext.surfaceVariant;
      systemSurface = ext.neutral;
    } else {
      thinkingSurface = cs.surfaceContainerHighest;
      toolDefault = cs.secondary;
      toolRunning = cs.tertiary;
      toolDone = cs.primary;
      toolError = cs.error;
      attachment = cs.surfaceContainerHighest;
      systemSurface = cs.surfaceContainerHigh;
    }

    return DmChatTheme(
      userBubbleColor: cs.primaryContainer,
      userBubbleOnColor: cs.onPrimaryContainer,
      assistantSurface: Colors.transparent,
      systemSurface: systemSurface,
      userBubbleRadius: BorderRadius.circular(16),
      bubblePadding: const EdgeInsets.all(12),
      userBubbleMaxWidthFraction: 0.8,
      rowSpacing: 12,
      thinkingForeground: cs.onSurface.withValues(alpha: 0.7),
      thinkingSurface: thinkingSurface,
      thinkingTextStyle: (tt.bodyMedium ?? const TextStyle()).copyWith(
        fontStyle: FontStyle.italic,
        fontSize: (tt.bodyMedium?.fontSize ?? 14) * 0.95,
      ),
      thinkingCollapseAnimation: const Duration(milliseconds: 200),
      toolCallChipColor: toolDefault,
      toolCallChipRunningColor: toolRunning,
      toolCallChipDoneColor: toolDone,
      toolCallChipErrorColor: toolError,
      toolCallLabelStyle: (tt.labelMedium ?? const TextStyle()).copyWith(
        fontFamily: 'monospace',
        fontFamilyFallback: const ['Menlo', 'Consolas', 'monospace'],
      ),
      attachmentChipColor: attachment,
      attachmentImageThumbSize: 96,
      inputPadding: const EdgeInsets.all(8),
      inputSurface: cs.surface,
      inputElevation: 1,
      inputRadius: BorderRadius.circular(12),
    );
  }

  @override
  DmChatTheme copyWith({
    Color? userBubbleColor,
    Color? userBubbleOnColor,
    Color? assistantSurface,
    Color? systemSurface,
    BorderRadius? userBubbleRadius,
    EdgeInsets? bubblePadding,
    double? userBubbleMaxWidthFraction,
    double? rowSpacing,
    Color? thinkingForeground,
    Color? thinkingSurface,
    TextStyle? thinkingTextStyle,
    Duration? thinkingCollapseAnimation,
    Color? toolCallChipColor,
    Color? toolCallChipRunningColor,
    Color? toolCallChipDoneColor,
    Color? toolCallChipErrorColor,
    TextStyle? toolCallLabelStyle,
    Color? attachmentChipColor,
    double? attachmentImageThumbSize,
    EdgeInsets? inputPadding,
    Color? inputSurface,
    double? inputElevation,
    BorderRadius? inputRadius,
    Map<String, DmChatCustomBlockBuilder>? customBuilders,
    DmChatAvatarBuilder? defaultAvatarBuilder,
  }) =>
      DmChatTheme(
        userBubbleColor: userBubbleColor ?? this.userBubbleColor,
        userBubbleOnColor: userBubbleOnColor ?? this.userBubbleOnColor,
        assistantSurface: assistantSurface ?? this.assistantSurface,
        systemSurface: systemSurface ?? this.systemSurface,
        userBubbleRadius: userBubbleRadius ?? this.userBubbleRadius,
        bubblePadding: bubblePadding ?? this.bubblePadding,
        userBubbleMaxWidthFraction:
            userBubbleMaxWidthFraction ?? this.userBubbleMaxWidthFraction,
        rowSpacing: rowSpacing ?? this.rowSpacing,
        thinkingForeground: thinkingForeground ?? this.thinkingForeground,
        thinkingSurface: thinkingSurface ?? this.thinkingSurface,
        thinkingTextStyle: thinkingTextStyle ?? this.thinkingTextStyle,
        thinkingCollapseAnimation:
            thinkingCollapseAnimation ?? this.thinkingCollapseAnimation,
        toolCallChipColor: toolCallChipColor ?? this.toolCallChipColor,
        toolCallChipRunningColor:
            toolCallChipRunningColor ?? this.toolCallChipRunningColor,
        toolCallChipDoneColor:
            toolCallChipDoneColor ?? this.toolCallChipDoneColor,
        toolCallChipErrorColor:
            toolCallChipErrorColor ?? this.toolCallChipErrorColor,
        toolCallLabelStyle: toolCallLabelStyle ?? this.toolCallLabelStyle,
        attachmentChipColor: attachmentChipColor ?? this.attachmentChipColor,
        attachmentImageThumbSize:
            attachmentImageThumbSize ?? this.attachmentImageThumbSize,
        inputPadding: inputPadding ?? this.inputPadding,
        inputSurface: inputSurface ?? this.inputSurface,
        inputElevation: inputElevation ?? this.inputElevation,
        inputRadius: inputRadius ?? this.inputRadius,
        customBuilders: customBuilders ?? this.customBuilders,
        defaultAvatarBuilder: defaultAvatarBuilder ?? this.defaultAvatarBuilder,
      );

  @override
  DmChatTheme lerp(covariant DmChatTheme? other, double t) {
    if (other == null) return this;
    return DmChatTheme(
      userBubbleColor:
          Color.lerp(userBubbleColor, other.userBubbleColor, t) ?? userBubbleColor,
      userBubbleOnColor:
          Color.lerp(userBubbleOnColor, other.userBubbleOnColor, t) ??
              userBubbleOnColor,
      assistantSurface:
          Color.lerp(assistantSurface, other.assistantSurface, t) ??
              assistantSurface,
      systemSurface:
          Color.lerp(systemSurface, other.systemSurface, t) ?? systemSurface,
      userBubbleRadius:
          BorderRadius.lerp(userBubbleRadius, other.userBubbleRadius, t) ??
              userBubbleRadius,
      bubblePadding:
          EdgeInsets.lerp(bubblePadding, other.bubblePadding, t) ?? bubblePadding,
      userBubbleMaxWidthFraction: _lerpDouble(
          userBubbleMaxWidthFraction, other.userBubbleMaxWidthFraction, t),
      rowSpacing: _lerpDouble(rowSpacing, other.rowSpacing, t),
      thinkingForeground:
          Color.lerp(thinkingForeground, other.thinkingForeground, t) ??
              thinkingForeground,
      thinkingSurface:
          Color.lerp(thinkingSurface, other.thinkingSurface, t) ??
              thinkingSurface,
      thinkingTextStyle:
          TextStyle.lerp(thinkingTextStyle, other.thinkingTextStyle, t) ??
              thinkingTextStyle,
      thinkingCollapseAnimation:
          t < 0.5 ? thinkingCollapseAnimation : other.thinkingCollapseAnimation,
      toolCallChipColor:
          Color.lerp(toolCallChipColor, other.toolCallChipColor, t) ??
              toolCallChipColor,
      toolCallChipRunningColor:
          Color.lerp(toolCallChipRunningColor, other.toolCallChipRunningColor, t) ??
              toolCallChipRunningColor,
      toolCallChipDoneColor:
          Color.lerp(toolCallChipDoneColor, other.toolCallChipDoneColor, t) ??
              toolCallChipDoneColor,
      toolCallChipErrorColor:
          Color.lerp(toolCallChipErrorColor, other.toolCallChipErrorColor, t) ??
              toolCallChipErrorColor,
      toolCallLabelStyle:
          TextStyle.lerp(toolCallLabelStyle, other.toolCallLabelStyle, t) ??
              toolCallLabelStyle,
      attachmentChipColor:
          Color.lerp(attachmentChipColor, other.attachmentChipColor, t) ??
              attachmentChipColor,
      attachmentImageThumbSize:
          _lerpDouble(attachmentImageThumbSize, other.attachmentImageThumbSize, t),
      inputPadding:
          EdgeInsets.lerp(inputPadding, other.inputPadding, t) ?? inputPadding,
      inputSurface:
          Color.lerp(inputSurface, other.inputSurface, t) ?? inputSurface,
      inputElevation: _lerpDouble(inputElevation, other.inputElevation, t),
      inputRadius:
          BorderRadius.lerp(inputRadius, other.inputRadius, t) ?? inputRadius,
      customBuilders: t < 0.5 ? customBuilders : other.customBuilders,
      defaultAvatarBuilder:
          t < 0.5 ? defaultAvatarBuilder : other.defaultAvatarBuilder,
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
```

- [ ] **Step 5.4: Add export to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`, add:

```dart
// Theme
export 'theme/dm_chat_theme.dart';
```

- [ ] **Step 5.5: Run tests — verify they pass**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_theme_test.dart`
Expected: All tests pass.

- [ ] **Step 5.6: Run analyzer**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 5.7: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_theme_test.dart
git commit -m "feat(chat): add DmChatTheme ThemeExtension"
```

---

## Task 6: `_TextBlockView` — static/streaming markdown renderer

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_text_block_view.dart`
- Test: (covered by `dm_chat_bubble_test.dart` in Task 11; this task is internal-only)

- [ ] **Step 6.1: Implement `_TextBlockView`**

Create `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_text_block_view.dart`:

```dart
import 'package:flutter/material.dart';

import '../../../markdown/dm_markdown.dart';
import '../../../markdown/dm_markdown_config.dart';
import '../../models/dm_chat_block.dart';

/// Renders a [DmChatTextBlock] via [DmMarkdown], picking stream vs data mode.
class TextBlockView extends StatelessWidget {
  const TextBlockView({
    super.key,
    required this.block,
    required this.config,
  });

  final DmChatTextBlock block;
  final DmMarkdownConfig config;

  @override
  Widget build(BuildContext context) {
    if (block.stream != null) {
      return DmMarkdown(
        stream: block.stream,
        config: config,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
      );
    }
    return DmMarkdown(
      data: block.text ?? '',
      config: config,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
    );
  }
}
```

- [ ] **Step 6.2: Run analyzer**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 6.3: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_text_block_view.dart
git commit -m "feat(chat): add internal _TextBlockView"
```

---

## Task 7: `_BubbleStreamCoordinator` + `_ThinkingBlockView` (collapsible + auto-collapse)

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/bubble/_bubble_stream_coordinator.dart`
- Create: `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_thinking_block_view.dart`
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_thinking_block_test.dart`

- [ ] **Step 7.1: Write failing tests**

Create `packages/duskmoon_widgets/test/chat/dm_chat_thinking_block_test.dart`:

```dart
import 'dart:async';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatThinkingBlockView', () {
    testWidgets('renders static text collapsed with duration summary',
        (tester) async {
      await pumpThemed(
        tester,
        DmChatThinkingBlockView(
          block: const DmChatThinkingBlock(
            text: 'Step 1\nStep 2',
            elapsed: Duration(seconds: 3),
          ),
        ),
      );
      expect(find.textContaining('Thought for'), findsOneWidget);
      expect(find.textContaining('3'), findsOneWidget);
      expect(find.text('Step 1\nStep 2'), findsNothing);
    });

    testWidgets('tap expands revealing content', (tester) async {
      await pumpThemed(
        tester,
        DmChatThinkingBlockView(
          block: const DmChatThinkingBlock(
            text: 'reasoning body',
            elapsed: Duration(seconds: 2),
          ),
        ),
      );
      await tester.tap(find.byType(DmChatThinkingBlockView));
      await tester.pumpAndSettle();
      expect(find.textContaining('reasoning body'), findsOneWidget);
    });

    testWidgets('auto-expands while streaming', (tester) async {
      final controller = StreamController<String>();
      addTearDown(controller.close);
      await pumpThemed(
        tester,
        DmChatThinkingBlockView(
          block: DmChatThinkingBlock(stream: controller.stream),
        ),
      );
      controller.add('partial reasoning');
      await tester.pump();
      expect(find.textContaining('partial reasoning'), findsOneWidget);
    });
  });
}
```

Create `packages/duskmoon_widgets/test/chat/helpers/chat_test_harness.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpThemed(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: Scaffold(body: child),
    ),
  );
}
```

- [ ] **Step 7.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_thinking_block_test.dart`
Expected: Fails (`DmChatThinkingBlockView` undefined).

- [ ] **Step 7.3: Implement `_BubbleStreamCoordinator`**

Create `packages/duskmoon_widgets/lib/src/chat/bubble/_bubble_stream_coordinator.dart`:

```dart
import 'package:flutter/widgets.dart';

/// Signals cross-block events within a single bubble — specifically, the
/// first text token arriving from any `DmChatTextBlock` sibling, which
/// auto-collapses any `DmChatThinkingBlockView` that hasn't been manually
/// toggled yet.
class BubbleStreamCoordinator extends ChangeNotifier {
  bool _textStarted = false;
  bool get textStarted => _textStarted;

  void markTextStarted() {
    if (_textStarted) return;
    _textStarted = true;
    notifyListeners();
  }
}

/// Inherited notifier exposing a [BubbleStreamCoordinator] to block widgets.
class BubbleStreamScope extends InheritedNotifier<BubbleStreamCoordinator> {
  const BubbleStreamScope({
    super.key,
    required BubbleStreamCoordinator coordinator,
    required super.child,
  }) : super(notifier: coordinator);

  static BubbleStreamCoordinator? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<BubbleStreamScope>()
      ?.notifier;
}
```

- [ ] **Step 7.4: Implement `DmChatThinkingBlockView`**

Create `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_thinking_block_view.dart`:

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../markdown/dm_markdown.dart';
import '../../../markdown/dm_markdown_config.dart';
import '../../models/dm_chat_block.dart';
import '../../theme/dm_chat_theme.dart';
import '../_bubble_stream_coordinator.dart';

/// Collapsible thinking block. Auto-expands while streaming; auto-collapses
/// when the sibling text block starts emitting; user taps override auto.
class DmChatThinkingBlockView extends StatefulWidget {
  const DmChatThinkingBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
  });

  final DmChatThinkingBlock block;
  final DmMarkdownConfig config;

  @override
  State<DmChatThinkingBlockView> createState() =>
      _DmChatThinkingBlockViewState();
}

class _DmChatThinkingBlockViewState extends State<DmChatThinkingBlockView> {
  bool _expanded = true;
  bool _userToggled = false;
  StreamSubscription<String>? _sub;
  final StringBuffer _buffer = StringBuffer();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  bool get _isStreaming => widget.block.stream != null;

  @override
  void initState() {
    super.initState();
    if (_isStreaming) {
      _stopwatch.start();
      _sub = widget.block.stream!.listen((chunk) {
        if (!mounted) return;
        setState(() => _buffer.write(chunk));
      });
      _ticker = Timer.periodic(const Duration(milliseconds: 500), (_) {
        if (mounted) setState(() {});
      });
      _expanded = true;
    } else {
      _expanded = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final coord = BubbleStreamScope.maybeOf(context);
    if (coord != null && coord.textStarted && !_userToggled && _expanded) {
      _stopwatch.stop();
      _ticker?.cancel();
      setState(() => _expanded = false);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _ticker?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      _userToggled = true;
      _expanded = !_expanded;
    });
  }

  Duration get _elapsedDuration {
    if (widget.block.elapsed != null) return widget.block.elapsed!;
    return _stopwatch.elapsed;
  }

  String get _body =>
      widget.block.stream != null ? _buffer.toString() : (widget.block.text ?? '');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    final seconds = _elapsedDuration.inSeconds;
    final summary = seconds <= 0
        ? 'Thinking…'
        : (widget.block.elapsed != null
            ? 'Thought for ${seconds}s'
            : 'Thinking… ${seconds}s');

    return AnimatedContainer(
      duration: theme.thinkingCollapseAnimation,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: theme.thinkingSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 18,
                    color: theme.thinkingForeground,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    summary,
                    style: theme.thinkingTextStyle
                        .copyWith(color: theme.thinkingForeground),
                  ),
                ],
              ),
              if (_expanded && _body.isNotEmpty) ...[
                const SizedBox(height: 8),
                DefaultTextStyle.merge(
                  style: theme.thinkingTextStyle
                      .copyWith(color: theme.thinkingForeground),
                  child: DmMarkdown(
                    data: _body,
                    config: widget.config,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 7.5: Add export to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`, add:

```dart
// Block views
export 'bubble/blocks/_thinking_block_view.dart';
```

- [ ] **Step 7.6: Run tests — verify they pass**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_thinking_block_test.dart`
Expected: All 3 tests pass.

- [ ] **Step 7.7: Run analyzer**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 7.8: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_thinking_block_test.dart \
        packages/duskmoon_widgets/test/chat/helpers/
git commit -m "feat(chat): add DmChatThinkingBlockView with auto-collapse coordinator"
```

---

## Task 8: `DmChatToolCallBlockView` — compact chip with expand-on-tap

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_tool_call_block_view.dart`
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_tool_call_block_test.dart`

- [ ] **Step 8.1: Write failing tests**

Create `packages/duskmoon_widgets/test/chat/dm_chat_tool_call_block_test.dart`:

```dart
import 'dart:convert';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatToolCallBlockView', () {
    testWidgets('renders collapsed chip with tool name and status icon',
        (tester) async {
      await pumpThemed(
        tester,
        const DmChatToolCallBlockView(
          block: DmChatToolCallBlock(
            id: 't1',
            name: 'search_web',
            status: DmChatToolCallStatus.done,
          ),
        ),
      );
      expect(find.text('search_web'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('tap expands to show input JSON and output', (tester) async {
      await pumpThemed(
        tester,
        DmChatToolCallBlockView(
          block: DmChatToolCallBlock(
            id: 't1',
            name: 'search_web',
            status: DmChatToolCallStatus.done,
            input: const {'query': 'flutter'},
            output: 'result text',
          ),
        ),
      );
      await tester.tap(find.text('search_web'));
      await tester.pumpAndSettle();
      expect(find.textContaining(jsonEncode({'query': 'flutter'})), findsOneWidget);
      expect(find.textContaining('result text'), findsOneWidget);
    });

    testWidgets('error status shows errorMessage', (tester) async {
      await pumpThemed(
        tester,
        const DmChatToolCallBlockView(
          block: DmChatToolCallBlock(
            id: 't1',
            name: 'search_web',
            status: DmChatToolCallStatus.error,
            errorMessage: 'network timeout',
          ),
        ),
      );
      await tester.tap(find.text('search_web'));
      await tester.pumpAndSettle();
      expect(find.textContaining('network timeout'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 8.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_tool_call_block_test.dart`
Expected: Fails (`DmChatToolCallBlockView` undefined).

- [ ] **Step 8.3: Implement the view**

Create `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_tool_call_block_view.dart`:

```dart
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../markdown/dm_markdown.dart';
import '../../../markdown/dm_markdown_config.dart';
import '../../models/dm_chat_block.dart';
import '../../theme/dm_chat_theme.dart';

/// Compact status chip for a tool call. Tap expands to show input/output.
class DmChatToolCallBlockView extends StatefulWidget {
  const DmChatToolCallBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
  });

  final DmChatToolCallBlock block;
  final DmMarkdownConfig config;

  @override
  State<DmChatToolCallBlockView> createState() =>
      _DmChatToolCallBlockViewState();
}

class _DmChatToolCallBlockViewState extends State<DmChatToolCallBlockView> {
  bool _expanded = false;

  Color _chipColor(DmChatTheme t) => switch (widget.block.status) {
        DmChatToolCallStatus.pending => t.toolCallChipColor,
        DmChatToolCallStatus.running => t.toolCallChipRunningColor,
        DmChatToolCallStatus.done => t.toolCallChipDoneColor,
        DmChatToolCallStatus.error => t.toolCallChipErrorColor,
      };

  IconData _icon() => switch (widget.block.status) {
        DmChatToolCallStatus.pending => Icons.schedule,
        DmChatToolCallStatus.running => Icons.autorenew,
        DmChatToolCallStatus.done => Icons.check_circle,
        DmChatToolCallStatus.error => Icons.error,
      };

  String _encode(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } on Object {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    final chipColor = _chipColor(theme);
    final outputText = _encode(widget.block.output);
    final inputText = _encode(widget.block.input);
    final error = widget.block.errorMessage;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: chipColor.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
        color: chipColor.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_icon(), size: 16, color: chipColor),
                  const SizedBox(width: 6),
                  Text(widget.block.name, style: theme.toolCallLabelStyle),
                  const SizedBox(width: 6),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: chipColor,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (inputText.isNotEmpty) ...[
                    Text('Input', style: theme.toolCallLabelStyle),
                    const SizedBox(height: 4),
                    DmMarkdown(
                      data: '```json\n$inputText\n```',
                      config: widget.config,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                  if (outputText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Output', style: theme.toolCallLabelStyle),
                    const SizedBox(height: 4),
                    DmMarkdown(
                      data: outputText,
                      config: widget.config,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      error,
                      style: theme.toolCallLabelStyle
                          .copyWith(color: theme.toolCallChipErrorColor),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 8.4: Add export to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`, add:

```dart
export 'bubble/blocks/_tool_call_block_view.dart';
```

- [ ] **Step 8.5: Run test — verify it passes**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_tool_call_block_test.dart`
Expected: All 3 tests pass.

- [ ] **Step 8.6: Analyzer + commit**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos` → `No issues found!`

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_tool_call_block_test.dart
git commit -m "feat(chat): add DmChatToolCallBlockView (compact chip + expand)"
```

---

## Task 9: `DmChatAttachmentBlockView` — chip/image/progress/retry

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_attachment_block_view.dart`
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_attachment_block_test.dart`

- [ ] **Step 9.1: Write failing tests**

Create `packages/duskmoon_widgets/test/chat/dm_chat_attachment_block_test.dart`:

```dart
import 'dart:typed_data';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatAttachmentBlockView', () {
    testWidgets('renders file chip with name and size', (tester) async {
      await pumpThemed(
        tester,
        const DmChatAttachmentBlockView(
          block: DmChatAttachmentBlock(
            attachments: [
              DmChatAttachment(id: 'a1', name: 'report.pdf', sizeBytes: 2048),
            ],
          ),
        ),
      );
      expect(find.text('report.pdf'), findsOneWidget);
      expect(find.textContaining('2.0 KB'), findsOneWidget);
    });

    testWidgets('renders image thumbnail when bytes provided and mime is image',
        (tester) async {
      final bytes = Uint8List.fromList([
        // Minimal valid PNG (1x1 transparent)
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
        0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
        0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41,
        0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00,
        0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
        0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
        0x42, 0x60, 0x82,
      ]);
      await pumpThemed(
        tester,
        DmChatAttachmentBlockView(
          block: DmChatAttachmentBlock(
            attachments: [
              DmChatAttachment(
                id: 'a1',
                name: 'photo.png',
                mimeType: 'image/png',
                bytes: bytes,
              ),
            ],
          ),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows linear progress while uploading', (tester) async {
      await pumpThemed(
        tester,
        const DmChatAttachmentBlockView(
          block: DmChatAttachmentBlock(
            attachments: [
              DmChatAttachment(
                id: 'a1',
                name: 'big.zip',
                status: DmChatAttachmentStatus.uploading,
                uploadProgress: 0.4,
              ),
            ],
          ),
        ),
      );
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, 0.4);
    });

    testWidgets('error state shows retry button calling onRetry', (tester) async {
      var retries = 0;
      await pumpThemed(
        tester,
        DmChatAttachmentBlockView(
          block: const DmChatAttachmentBlock(
            attachments: [
              DmChatAttachment(
                id: 'a1',
                name: 'fail.bin',
                status: DmChatAttachmentStatus.error,
                errorMessage: 'upload failed',
              ),
            ],
          ),
          onRetry: (a) => retries++,
        ),
      );
      expect(find.text('upload failed'), findsOneWidget);
      await tester.tap(find.byTooltip('Retry'));
      expect(retries, 1);
    });
  });
}
```

- [ ] **Step 9.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_attachment_block_test.dart`
Expected: Fails (`DmChatAttachmentBlockView` undefined).

- [ ] **Step 9.3: Implement the view**

Create `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_attachment_block_view.dart`:

```dart
import 'package:flutter/material.dart';

import '../../models/dm_chat_attachment.dart';
import '../../models/dm_chat_block.dart';
import '../../theme/dm_chat_theme.dart';

/// Renders a [DmChatAttachmentBlock] — image thumbnails for image MIME types,
/// file chips otherwise, with upload progress and retry affordances.
class DmChatAttachmentBlockView extends StatelessWidget {
  const DmChatAttachmentBlockView({
    super.key,
    required this.block,
    this.onTap,
    this.onRetry,
    this.onCancel,
  });

  final DmChatAttachmentBlock block;
  final ValueChanged<DmChatAttachment>? onTap;
  final ValueChanged<DmChatAttachment>? onRetry;
  final ValueChanged<DmChatAttachment>? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final a in block.attachments)
          _AttachmentTile(
            attachment: a,
            theme: theme,
            onTap: onTap,
            onRetry: onRetry,
            onCancel: onCancel,
          ),
      ],
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.attachment,
    required this.theme,
    this.onTap,
    this.onRetry,
    this.onCancel,
  });

  final DmChatAttachment attachment;
  final DmChatTheme theme;
  final ValueChanged<DmChatAttachment>? onTap;
  final ValueChanged<DmChatAttachment>? onRetry;
  final ValueChanged<DmChatAttachment>? onCancel;

  bool get _isImage =>
      attachment.mimeType != null && attachment.mimeType!.startsWith('image/');

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final content = _isImage && attachment.bytes != null
        ? _imageThumb()
        : _fileChip(context);

    return InkWell(
      onTap: onTap == null ? null : () => onTap!(attachment),
      borderRadius: BorderRadius.circular(8),
      child: content,
    );
  }

  Widget _imageThumb() {
    final size = theme.attachmentImageThumbSize;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            attachment.bytes!,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
        if (attachment.status == DmChatAttachmentStatus.uploading)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              value: attachment.uploadProgress ?? 0,
              minHeight: 3,
            ),
          ),
        if (attachment.status == DmChatAttachmentStatus.error)
          Positioned.fill(
            child: _errorOverlay(),
          ),
      ],
    );
  }

  Widget _fileChip(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.attachmentChipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.insert_drive_file, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (attachment.status == DmChatAttachmentStatus.error)
                IconButton(
                  tooltip: 'Retry',
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh),
                  onPressed:
                      onRetry == null ? null : () => onRetry!(attachment),
                ),
              if (attachment.status == DmChatAttachmentStatus.uploading)
                IconButton(
                  tooltip: 'Cancel',
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close),
                  onPressed:
                      onCancel == null ? null : () => onCancel!(attachment),
                ),
            ],
          ),
          if (attachment.sizeBytes != null)
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(
                _formatSize(attachment.sizeBytes!),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          if (attachment.status == DmChatAttachmentStatus.uploading)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: LinearProgressIndicator(
                value: attachment.uploadProgress ?? 0,
                minHeight: 3,
              ),
            ),
          if (attachment.status == DmChatAttachmentStatus.error &&
              attachment.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 4),
              child: Text(
                attachment.errorMessage!,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  Widget _errorOverlay() => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: IconButton(
            tooltip: 'Retry',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: onRetry == null ? null : () => onRetry!(attachment),
          ),
        ),
      );
}
```

- [ ] **Step 9.4: Add export to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`:

```dart
export 'bubble/blocks/_attachment_block_view.dart';
```

- [ ] **Step 9.5: Run test — verify it passes**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_attachment_block_test.dart`
Expected: All 4 tests pass.

- [ ] **Step 9.6: Analyzer + commit**

```bash
cd packages/duskmoon_widgets && dart analyze --fatal-infos
```

Expected: `No issues found!`

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_attachment_block_test.dart
git commit -m "feat(chat): add DmChatAttachmentBlockView with progress/retry"
```

---

## Task 10: `_CustomBlockView` — theme-dispatched renderer

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_custom_block_view.dart`

- [ ] **Step 10.1: Implement the view**

Create `packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_custom_block_view.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/dm_chat_block.dart';
import '../../theme/dm_chat_theme.dart';

/// Dispatches custom blocks through [DmChatTheme.customBuilders].
class CustomBlockView extends StatelessWidget {
  const CustomBlockView({super.key, required this.block});

  final DmChatCustomBlock block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    final builder = theme.customBuilders[block.kind];
    assert(
      builder != null || kReleaseMode,
      'No DmChatTheme.customBuilders registered for kind="${block.kind}"',
    );
    if (builder == null) return const SizedBox.shrink();
    return builder(context, block);
  }
}
```

- [ ] **Step 10.2: Analyzer + commit**

```bash
cd packages/duskmoon_widgets && dart analyze --fatal-infos
```

Expected: `No issues found!`

```bash
git add packages/duskmoon_widgets/lib/src/chat/bubble/blocks/_custom_block_view.dart
git commit -m "feat(chat): add internal _CustomBlockView dispatch"
```

---

## Task 11: `_BubbleFrame` + `DmChatBubble` — assembled message renderer

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/bubble/_bubble_frame.dart`
- Create: `packages/duskmoon_widgets/lib/src/chat/bubble/dm_chat_bubble.dart`
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_bubble_test.dart`

- [ ] **Step 11.1: Write failing tests**

Create `packages/duskmoon_widgets/test/chat/dm_chat_bubble_test.dart`:

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatBubble', () {
    testWidgets('user message aligns right and is wrapped in a filled bubble',
        (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 'u1',
            role: DmChatRole.user,
            blocks: [DmChatTextBlock(text: 'hi there')],
          ),
        ),
      );
      expect(find.text('hi there'), findsOneWidget);
      // Right alignment signal: the Align widget with Alignment.centerRight.
      final aligns = tester.widgetList<Align>(find.byType(Align)).toList();
      expect(aligns.any((a) => a.alignment == Alignment.centerRight), isTrue);
    });

    testWidgets('assistant message renders full-width with no bubble fill',
        (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 'a1',
            role: DmChatRole.assistant,
            blocks: [DmChatTextBlock(text: 'long response')],
          ),
        ),
      );
      expect(find.text('long response'), findsOneWidget);
      // Full-width: no centerRight Align around content.
      final aligns = tester.widgetList<Align>(find.byType(Align)).toList();
      expect(aligns.any((a) => a.alignment == Alignment.centerRight), isFalse);
    });

    testWidgets('system message centers and uses italic style', (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 's1',
            role: DmChatRole.system,
            blocks: [DmChatTextBlock(text: 'context injected')],
          ),
        ),
      );
      expect(find.text('context injected'), findsOneWidget);
      final aligns = tester.widgetList<Align>(find.byType(Align)).toList();
      expect(aligns.any((a) => a.alignment == Alignment.center), isTrue);
    });

    testWidgets('renders avatar and header slots when provided', (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 'a1',
            role: DmChatRole.assistant,
            blocks: [DmChatTextBlock(text: 'body')],
          ),
          avatar: Icon(Icons.smart_toy, key: ValueKey('avatar')),
          header: Text('Assistant', key: ValueKey('header')),
        ),
      );
      expect(find.byKey(const ValueKey('avatar')), findsOneWidget);
      expect(find.byKey(const ValueKey('header')), findsOneWidget);
    });
  });
}
```

- [ ] **Step 11.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_bubble_test.dart`
Expected: Fails (`DmChatBubble` undefined).

- [ ] **Step 11.3: Implement `_BubbleFrame`**

Create `packages/duskmoon_widgets/lib/src/chat/bubble/_bubble_frame.dart`:

```dart
import 'package:flutter/material.dart';

import '../models/dm_chat_message.dart';
import '../theme/dm_chat_theme.dart';

/// Role-based frame that arranges avatar/header/body for a chat message.
class BubbleFrame extends StatelessWidget {
  const BubbleFrame({
    super.key,
    required this.role,
    required this.child,
    this.avatar,
    this.header,
  });

  final DmChatRole role;
  final Widget child;
  final Widget? avatar;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    switch (role) {
      case DmChatRole.user:
        return LayoutBuilder(
          builder: (ctx, constraints) {
            final maxWidth =
                constraints.maxWidth * theme.userBubbleMaxWidthFraction;
            return Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Container(
                  padding: theme.bubblePadding,
                  decoration: BoxDecoration(
                    color: theme.userBubbleColor,
                    borderRadius: theme.userBubbleRadius,
                  ),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(color: theme.userBubbleOnColor),
                    child: child,
                  ),
                ),
              ),
            );
          },
        );
      case DmChatRole.assistant:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (avatar != null) ...[
              avatar!,
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (header != null) ...[
                    header!,
                    const SizedBox(height: 4),
                  ],
                  child,
                ],
              ),
            ),
          ],
        );
      case DmChatRole.system:
        return Align(
          alignment: Alignment.center,
          child: Container(
            padding: theme.bubblePadding,
            decoration: BoxDecoration(
              color: theme.systemSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DefaultTextStyle.merge(
              style: theme.thinkingTextStyle,
              textAlign: TextAlign.center,
              child: child,
            ),
          ),
        );
    }
  }
}
```

- [ ] **Step 11.4: Implement `DmChatBubble`**

Create `packages/duskmoon_widgets/lib/src/chat/bubble/dm_chat_bubble.dart`:

```dart
import 'package:flutter/material.dart';

import '../../markdown/dm_markdown_config.dart';
import '../models/dm_chat_block.dart';
import '../models/dm_chat_message.dart';
import '../theme/dm_chat_theme.dart';
import '_bubble_frame.dart';
import '_bubble_stream_coordinator.dart';
import 'blocks/_attachment_block_view.dart';
import 'blocks/_custom_block_view.dart';
import 'blocks/_text_block_view.dart';
import 'blocks/_thinking_block_view.dart';
import 'blocks/_tool_call_block_view.dart';

/// Renders a single chat message. Stateful so each block can own per-stream
/// subscriptions without losing state across rebuilds.
class DmChatBubble extends StatefulWidget {
  const DmChatBubble({
    super.key,
    required this.message,
    this.avatar,
    this.header,
    this.markdownConfig = const DmMarkdownConfig(),
    this.theme,
  });

  final DmChatMessage message;
  final Widget? avatar;
  final Widget? header;
  final DmMarkdownConfig markdownConfig;
  final DmChatTheme? theme;

  @override
  State<DmChatBubble> createState() => _DmChatBubbleState();
}

class _DmChatBubbleState extends State<DmChatBubble> {
  late final BubbleStreamCoordinator _coordinator =
      BubbleStreamCoordinator();

  @override
  void dispose() {
    _coordinator.dispose();
    super.dispose();
  }

  List<Widget> _buildBlocks() {
    final blocks = widget.message.blocks;
    final children = <Widget>[];
    for (var i = 0; i < blocks.length; i++) {
      final b = blocks[i];
      children.add(_buildBlock(b));
      if (i < blocks.length - 1) {
        children.add(const SizedBox(height: 8));
      }
    }
    return children;
  }

  Widget _buildBlock(DmChatBlock b) {
    return switch (b) {
      DmChatTextBlock() => _TextBlockWithStreamSignal(
          block: b,
          config: widget.markdownConfig,
          coordinator: _coordinator,
        ),
      DmChatThinkingBlock() => DmChatThinkingBlockView(
          block: b,
          config: widget.markdownConfig,
        ),
      DmChatToolCallBlock() => DmChatToolCallBlockView(
          block: b,
          config: widget.markdownConfig,
        ),
      DmChatAttachmentBlock() => DmChatAttachmentBlockView(block: b),
      DmChatCustomBlock() => CustomBlockView(block: b),
    };
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildBlocks(),
    );
    final frame = BubbleFrame(
      role: widget.message.role,
      avatar: widget.avatar,
      header: widget.header,
      child: body,
    );
    final wrapped = BubbleStreamScope(
      coordinator: _coordinator,
      child: frame,
    );
    if (widget.theme != null) {
      return Theme(
        data: Theme.of(context).copyWith(extensions: [
          ...Theme.of(context).extensions.values,
          widget.theme!,
        ]),
        child: wrapped,
      );
    }
    return wrapped;
  }
}

/// Wrapper that signals the bubble coordinator on first stream emission.
class _TextBlockWithStreamSignal extends StatefulWidget {
  const _TextBlockWithStreamSignal({
    required this.block,
    required this.config,
    required this.coordinator,
  });

  final DmChatTextBlock block;
  final DmMarkdownConfig config;
  final BubbleStreamCoordinator coordinator;

  @override
  State<_TextBlockWithStreamSignal> createState() =>
      _TextBlockWithStreamSignalState();
}

class _TextBlockWithStreamSignalState
    extends State<_TextBlockWithStreamSignal> {
  Stream<String>? _wrappedStream;

  @override
  void initState() {
    super.initState();
    _wrapStream();
  }

  @override
  void didUpdateWidget(_TextBlockWithStreamSignal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.block.stream != oldWidget.block.stream) {
      _wrapStream();
    }
    if (widget.block.text != null && widget.block.text!.isNotEmpty) {
      widget.coordinator.markTextStarted();
    }
  }

  void _wrapStream() {
    final src = widget.block.stream;
    if (src == null) {
      _wrappedStream = null;
      return;
    }
    _wrappedStream = src.map((chunk) {
      if (chunk.isNotEmpty) widget.coordinator.markTextStarted();
      return chunk;
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBlock = _wrappedStream != null
        ? DmChatTextBlock(stream: _wrappedStream)
        : widget.block;
    return TextBlockView(block: effectiveBlock, config: widget.config);
  }
}
```

- [ ] **Step 11.5: Add export to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`:

```dart
// Bubble
export 'bubble/dm_chat_bubble.dart';
```

- [ ] **Step 11.6: Run tests — verify they pass**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_bubble_test.dart`
Expected: All 4 tests pass.

- [ ] **Step 11.7: Analyzer + commit**

```bash
cd packages/duskmoon_widgets && dart analyze --fatal-infos
```

Expected: `No issues found!`

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_bubble_test.dart
git commit -m "feat(chat): add DmChatBubble assembling all block views"
```

---

## Task 12: `DmChatInput` — composer with Send/Stop/Attach + submit shortcut

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/input/dm_chat_submit_shortcut.dart`
- Create: `packages/duskmoon_widgets/lib/src/chat/input/_send_button.dart`
- Create: `packages/duskmoon_widgets/lib/src/chat/input/_attach_button.dart`
- Create: `packages/duskmoon_widgets/lib/src/chat/input/dm_chat_input.dart`
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_input_test.dart`

- [ ] **Step 12.1: Write failing tests**

Create `packages/duskmoon_widgets/test/chat/dm_chat_input_test.dart`:

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatInput', () {
    testWidgets('renders send button; tap submits current text', (tester) async {
      String? sent;
      await pumpThemed(
        tester,
        DmChatInput(
          onSend: (text, atts) => sent = text,
        ),
      );
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      expect(sent, 'hello');
    });

    testWidgets('submitShortcut=enter submits on Enter, Shift+Enter inserts newline',
        (tester) async {
      final submissions = <String>[];
      await pumpThemed(
        tester,
        DmChatInput(
          submitShortcut: DmChatSubmitShortcut.enter,
          onSend: (text, atts) => submissions.add(text),
        ),
      );
      await tester.enterText(find.byType(TextField), 'a');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(submissions, ['a']);
    });

    testWidgets('submitShortcut=cmdEnter does NOT submit on Enter alone',
        (tester) async {
      final submissions = <String>[];
      await pumpThemed(
        tester,
        DmChatInput(
          onSend: (text, atts) => submissions.add(text),
        ),
      );
      await tester.enterText(find.byType(TextField), 'b');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(submissions, isEmpty);
    });

    testWidgets('send button becomes stop when isStreaming', (tester) async {
      var stopped = false;
      await pumpThemed(
        tester,
        DmChatInput(
          onSend: (_, __) {},
          onStop: () => stopped = true,
          isStreaming: true,
        ),
      );
      expect(find.byTooltip('Stop'), findsOneWidget);
      expect(find.byTooltip('Send'), findsNothing);
      await tester.tap(find.byTooltip('Stop'));
      expect(stopped, isTrue);
    });

    testWidgets('attach button hidden when onAttach is null', (tester) async {
      await pumpThemed(
        tester,
        DmChatInput(onSend: (_, __) {}),
      );
      expect(find.byTooltip('Attach'), findsNothing);
    });

    testWidgets('send disabled while any pending attachment is uploading',
        (tester) async {
      var sent = false;
      await pumpThemed(
        tester,
        DmChatInput(
          onSend: (_, __) => sent = true,
          pendingAttachments: const [
            DmChatAttachment(
              id: 'a1',
              name: 'x',
              status: DmChatAttachmentStatus.uploading,
            ),
          ],
        ),
      );
      await tester.enterText(find.byType(TextField), 'text');
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      expect(sent, isFalse);
    });
  });
}
```

- [ ] **Step 12.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_input_test.dart`
Expected: Fails (`DmChatInput` etc. undefined).

- [ ] **Step 12.3: Implement submit shortcut enum**

Create `packages/duskmoon_widgets/lib/src/chat/input/dm_chat_submit_shortcut.dart`:

```dart
/// Submission keyboard shortcut for [DmChatInput].
enum DmChatSubmitShortcut {
  /// Default — Enter inserts newline; Cmd/Ctrl+Enter submits.
  cmdEnter,

  /// Enter submits; Shift+Enter inserts newline.
  enter,
}
```

- [ ] **Step 12.4: Implement `_SendButton`**

Create `packages/duskmoon_widgets/lib/src/chat/input/_send_button.dart`:

```dart
import 'package:flutter/material.dart';

/// Toggles between Send and Stop based on [isStreaming].
class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.isStreaming,
    required this.onSend,
    required this.onStop,
    required this.enabled,
  });

  final bool isStreaming;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (isStreaming) {
      return IconButton(
        tooltip: 'Stop',
        onPressed: onStop,
        icon: const Icon(Icons.stop),
      );
    }
    return IconButton(
      tooltip: 'Send',
      onPressed: enabled ? onSend : null,
      icon: const Icon(Icons.send),
    );
  }
}
```

- [ ] **Step 12.5: Implement `_AttachButton`**

Create `packages/duskmoon_widgets/lib/src/chat/input/_attach_button.dart`:

```dart
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/dm_chat_attachment.dart';

/// Opens the platform file picker and forwards selected files as attachments.
class AttachButton extends StatelessWidget {
  const AttachButton({super.key, required this.onPicked});

  final ValueChanged<List<DmChatAttachment>> onPicked;

  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );
    if (result == null) return;
    final attachments = <DmChatAttachment>[];
    for (final f in result.files) {
      attachments.add(
        DmChatAttachment(
          id: f.identifier ?? '${f.name}:${DateTime.now().microsecondsSinceEpoch}',
          name: f.name,
          sizeBytes: f.size,
          mimeType: _mimeFromExtension(f.extension),
          bytes: f.bytes == null ? null : Uint8List.fromList(f.bytes!),
          status: DmChatAttachmentStatus.idle,
        ),
      );
    }
    onPicked(attachments);
  }

  String? _mimeFromExtension(String? ext) {
    if (ext == null) return null;
    return switch (ext.toLowerCase()) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'pdf' => 'application/pdf',
      'txt' => 'text/plain',
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: 'Attach',
        onPressed: _pick,
        icon: const Icon(Icons.attach_file),
      );
}
```

- [ ] **Step 12.6: Implement `DmChatInput`**

Create `packages/duskmoon_widgets/lib/src/chat/input/dm_chat_input.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../markdown_input/dm_markdown_input.dart';
import '../../markdown_input/dm_markdown_input_controller.dart';
import '../bubble/blocks/_attachment_block_view.dart';
import '../models/dm_chat_attachment.dart';
import '../models/dm_chat_block.dart';
import '../theme/dm_chat_theme.dart';
import '_attach_button.dart';
import '_send_button.dart';
import 'dm_chat_submit_shortcut.dart';

/// Signature of the send callback — current markdown text and the set of
/// completed pending attachments.
typedef DmChatSendCallback = void Function(
  String markdown,
  List<DmChatAttachment> attachments,
);

/// Chat composer — wraps [DmMarkdownInput] with Send/Stop/Attach controls.
class DmChatInput extends StatefulWidget {
  const DmChatInput({
    super.key,
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

  final DmChatSendCallback onSend;
  final VoidCallback? onStop;
  final ValueChanged<List<DmChatAttachment>>? onAttach;
  final DmChatUploadAdapter? uploadAdapter;
  final DmMarkdownInputController? controller;
  final bool isStreaming;
  final List<DmChatAttachment> pendingAttachments;
  final ValueChanged<DmChatAttachment>? onRemoveAttachment;
  final String? placeholder;
  final Widget? leading;
  final Widget? trailing;
  final int minLines;
  final int maxLines;
  final DmChatSubmitShortcut submitShortcut;

  @override
  State<DmChatInput> createState() => _DmChatInputState();
}

class _DmChatInputState extends State<DmChatInput> {
  late DmMarkdownInputController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = DmMarkdownInputController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  bool get _anyUploading => widget.pendingAttachments
      .any((a) => a.status == DmChatAttachmentStatus.uploading);

  bool get _canSend =>
      !widget.isStreaming && !_anyUploading && _controller.text.isNotEmpty;

  void _submit() {
    if (!_canSend) return;
    final text = _controller.text;
    final ready = widget.pendingAttachments
        .where((a) => a.status == DmChatAttachmentStatus.done)
        .toList();
    widget.onSend(text, ready);
    _controller.clear();
  }

  bool _isSubmitShortcut(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    switch (widget.submitShortcut) {
      case DmChatSubmitShortcut.enter:
        if (key != LogicalKeyboardKey.enter) return false;
        if (HardwareKeyboard.instance.isShiftPressed) return false;
        return true;
      case DmChatSubmitShortcut.cmdEnter:
        if (key != LogicalKeyboardKey.enter) return false;
        final isMac = defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.iOS;
        final modifier = isMac
            ? HardwareKeyboard.instance.isMetaPressed
            : HardwareKeyboard.instance.isControlPressed;
        return modifier;
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (_isSubmitShortcut(event)) {
      _submit();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          padding: theme.inputPadding,
          decoration: BoxDecoration(
            color: theme.inputSurface,
            borderRadius: theme.inputRadius,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.pendingAttachments.isNotEmpty) ...[
                DmChatAttachmentBlockView(
                  block: DmChatAttachmentBlock(
                    attachments: widget.pendingAttachments,
                  ),
                  onCancel: widget.onRemoveAttachment,
                  onRetry: widget.onRemoveAttachment,
                ),
                const SizedBox(height: 8),
              ],
              Focus(
                onKeyEvent: _onKey,
                child: DmMarkdownInput(
                  controller: _controller,
                  showPreview: false,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  if (widget.leading != null) widget.leading!,
                  if (widget.onAttach != null)
                    AttachButton(onPicked: widget.onAttach!),
                  const Spacer(),
                  if (widget.trailing != null) widget.trailing!,
                  SendButton(
                    isStreaming: widget.isStreaming,
                    onSend: _submit,
                    onStop: widget.onStop ?? () {},
                    enabled: _canSend,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 12.7: Add exports to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`:

```dart
// Input
export 'input/dm_chat_input.dart';
export 'input/dm_chat_submit_shortcut.dart';
```

- [ ] **Step 12.8: Run tests — verify they pass**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_input_test.dart`
Expected: All 6 tests pass.

- [ ] **Step 12.9: Analyzer + commit**

```bash
cd packages/duskmoon_widgets && dart analyze --fatal-infos
```

Expected: `No issues found!`

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_input_test.dart
git commit -m "feat(chat): add DmChatInput with Send/Stop/Attach and submit shortcut"
```

---

## Task 13: `DmChatView` — composed reverse-list with pinned auto-scroll

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/chat/view/_scroll_tracker.dart`
- Create: `packages/duskmoon_widgets/lib/src/chat/view/dm_chat_view.dart`
- Test: `packages/duskmoon_widgets/test/chat/dm_chat_view_test.dart`

- [ ] **Step 13.1: Write failing tests**

Create `packages/duskmoon_widgets/test/chat/dm_chat_view_test.dart`:

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatView', () {
    testWidgets('renders messages oldest→newest visually (reverse list)',
        (tester) async {
      await pumpThemed(
        tester,
        SizedBox(
          height: 400,
          child: DmChatView(
            messages: const [
              DmChatMessage(
                id: 'u1',
                role: DmChatRole.user,
                blocks: [DmChatTextBlock(text: 'first')],
              ),
              DmChatMessage(
                id: 'a1',
                role: DmChatRole.assistant,
                blocks: [DmChatTextBlock(text: 'second')],
              ),
            ],
            onSend: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsOneWidget);
      // Newest message sits at the bottom — its y-coordinate is greater.
      final first = tester.getTopLeft(find.text('first')).dy;
      final second = tester.getTopLeft(find.text('second')).dy;
      expect(second, greaterThan(first));
    });

    testWidgets('shows emptyBuilder when messages is empty', (tester) async {
      await pumpThemed(
        tester,
        SizedBox(
          height: 400,
          child: DmChatView(
            messages: const [],
            onSend: (_, __) {},
            emptyBuilder: (_) => const Text('no messages yet'),
          ),
        ),
      );
      expect(find.text('no messages yet'), findsOneWidget);
    });

    testWidgets('input placeholder propagates to DmChatInput', (tester) async {
      await pumpThemed(
        tester,
        SizedBox(
          height: 400,
          child: DmChatView(
            messages: const [],
            onSend: (_, __) {},
            inputPlaceholder: 'Say hi',
          ),
        ),
      );
      expect(find.text('Say hi'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 13.2: Run test — verify it fails**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_view_test.dart`
Expected: Fails (`DmChatView` undefined).

- [ ] **Step 13.3: Implement `_ScrollTracker`**

Create `packages/duskmoon_widgets/lib/src/chat/view/_scroll_tracker.dart`:

```dart
import 'package:flutter/widgets.dart';

/// Tracks whether a `reverse: true` scrollable is pinned near offset 0
/// (= visual bottom). Exposes a notifier so a Jump-to-Bottom button can
/// show/hide with unread counts.
class ChatScrollTracker extends ChangeNotifier {
  ChatScrollTracker({this.pinnedThreshold = 48});

  final double pinnedThreshold;
  final ScrollController controller = ScrollController();
  bool _pinned = true;
  int _unread = 0;

  bool get pinned => _pinned;
  int get unread => _unread;

  void attach() {
    controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    controller.removeListener(_onScroll);
    controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!controller.hasClients) return;
    final nowPinned = controller.offset <= pinnedThreshold;
    if (nowPinned != _pinned) {
      _pinned = nowPinned;
      if (_pinned) _unread = 0;
      notifyListeners();
    }
  }

  /// Call when a new message is appended.
  void onNewMessage({bool fromAssistant = true}) {
    if (!_pinned && fromAssistant) {
      _unread++;
      notifyListeners();
    }
  }

  Future<void> scrollToBottom() async {
    if (!controller.hasClients) return;
    await controller.animateTo(
      0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
    _unread = 0;
    _pinned = true;
    notifyListeners();
  }
}
```

- [ ] **Step 13.4: Implement `DmChatView`**

Create `packages/duskmoon_widgets/lib/src/chat/view/dm_chat_view.dart`:

```dart
import 'package:flutter/material.dart';

import '../../markdown/dm_markdown_config.dart';
import '../../markdown_input/dm_markdown_input_controller.dart';
import '../bubble/dm_chat_bubble.dart';
import '../input/dm_chat_input.dart';
import '../input/dm_chat_submit_shortcut.dart';
import '../models/dm_chat_attachment.dart';
import '../models/dm_chat_message.dart';
import '../theme/dm_chat_theme.dart';
import '_scroll_tracker.dart';

/// Optional retry callback exposed on [DmChatView] for error recovery.
typedef DmChatRetryCallback = void Function(DmChatMessage message);

/// Composed chat view — reverse list + pinned auto-scroll + input bar.
class DmChatView extends StatefulWidget {
  const DmChatView({
    super.key,
    required this.messages,
    this.onSend,
    this.onStop,
    this.onAttach,
    this.onRetry,
    this.uploadAdapter,
    this.isStreaming = false,
    this.inputController,
    this.inputPlaceholder = 'Message…',
    this.inputLeading,
    this.inputTrailing,
    this.submitShortcut = DmChatSubmitShortcut.cmdEnter,
    this.markdownConfig = const DmMarkdownConfig(),
    this.emptyBuilder,
    this.avatarBuilder,
    this.headerBuilder,
    this.showJumpToBottom = true,
    this.autoScroll = true,
    this.reverse = true,
    this.padding,
    this.theme,
    this.onRemoveAttachment,
    this.pendingAttachments = const [],
  });

  final List<DmChatMessage> messages;
  final DmChatSendCallback? onSend;
  final VoidCallback? onStop;
  final ValueChanged<List<DmChatAttachment>>? onAttach;
  final DmChatRetryCallback? onRetry;
  final DmChatUploadAdapter? uploadAdapter;
  final bool isStreaming;
  final DmMarkdownInputController? inputController;
  final String inputPlaceholder;
  final Widget? inputLeading;
  final Widget? inputTrailing;
  final DmChatSubmitShortcut submitShortcut;
  final DmMarkdownConfig markdownConfig;
  final WidgetBuilder? emptyBuilder;
  final Widget? Function(BuildContext, DmChatMessage)? avatarBuilder;
  final Widget? Function(BuildContext, DmChatMessage)? headerBuilder;
  final bool showJumpToBottom;
  final bool autoScroll;
  final bool reverse;
  final EdgeInsets? padding;
  final DmChatTheme? theme;
  final ValueChanged<DmChatAttachment>? onRemoveAttachment;
  final List<DmChatAttachment> pendingAttachments;

  @override
  State<DmChatView> createState() => _DmChatViewState();
}

class _DmChatViewState extends State<DmChatView> {
  late final ChatScrollTracker _tracker = ChatScrollTracker()..attach();

  @override
  void didUpdateWidget(DmChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length && widget.autoScroll) {
      final added = widget.messages.last;
      final fromAssistant = added.role == DmChatRole.assistant;
      if (_tracker.pinned) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _tracker.scrollToBottom();
        });
      } else {
        _tracker.onNewMessage(fromAssistant: fromAssistant);
      }
    }
  }

  @override
  void dispose() {
    _tracker.dispose();
    super.dispose();
  }

  Widget _buildList() {
    final reversed = widget.messages.reversed.toList(growable: false);
    return ListView.separated(
      controller: _tracker.controller,
      reverse: widget.reverse,
      padding: widget.padding ?? const EdgeInsets.all(16),
      itemCount: reversed.length,
      separatorBuilder: (_, __) => SizedBox(
        height: (Theme.of(context).extension<DmChatTheme>() ??
                DmChatTheme.withContext(context))
            .rowSpacing,
      ),
      itemBuilder: (ctx, i) {
        final msg = reversed[i];
        return DmChatBubble(
          key: ValueKey(msg.id),
          message: msg,
          avatar: widget.avatarBuilder?.call(ctx, msg),
          header: widget.headerBuilder?.call(ctx, msg),
          markdownConfig: widget.markdownConfig,
          theme: widget.theme,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ??
        Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    final body = widget.messages.isEmpty && widget.emptyBuilder != null
        ? Center(child: widget.emptyBuilder!(context))
        : Stack(
            children: [
              _buildList(),
              if (widget.showJumpToBottom)
                AnimatedBuilder(
                  animation: _tracker,
                  builder: (_, __) {
                    if (_tracker.pinned) return const SizedBox.shrink();
                    return Positioned(
                      right: 16,
                      bottom: 16,
                      child: FloatingActionButton.small(
                        heroTag: null,
                        onPressed: _tracker.scrollToBottom,
                        child: Badge(
                          label: _tracker.unread > 0
                              ? Text('${_tracker.unread}')
                              : null,
                          isLabelVisible: _tracker.unread > 0,
                          child: const Icon(Icons.arrow_downward),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );

    return Theme(
      data: Theme.of(context).copyWith(extensions: [
        ...Theme.of(context).extensions.values.where((e) => e is! DmChatTheme),
        theme,
      ]),
      child: Column(
        children: [
          Expanded(child: body),
          DmChatInput(
            controller: widget.inputController,
            onSend: widget.onSend ?? (_, __) {},
            onStop: widget.onStop,
            onAttach: widget.onAttach,
            uploadAdapter: widget.uploadAdapter,
            isStreaming: widget.isStreaming,
            pendingAttachments: widget.pendingAttachments,
            onRemoveAttachment: widget.onRemoveAttachment,
            placeholder: widget.inputPlaceholder,
            leading: widget.inputLeading,
            trailing: widget.inputTrailing,
            submitShortcut: widget.submitShortcut,
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 13.5: Add exports to barrel**

Edit `packages/duskmoon_widgets/lib/src/chat/chat.dart`:

```dart
// View
export 'view/dm_chat_view.dart';
```

- [ ] **Step 13.6: Run tests — verify they pass**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/dm_chat_view_test.dart`
Expected: All 3 tests pass.

- [ ] **Step 13.7: Run the full chat test suite**

Run: `cd packages/duskmoon_widgets && flutter test test/chat/`
Expected: All tests pass across 8 test files.

- [ ] **Step 13.8: Analyzer + commit**

```bash
cd packages/duskmoon_widgets && dart analyze --fatal-infos
```

Expected: `No issues found!`

```bash
git add packages/duskmoon_widgets/lib/src/chat/ \
        packages/duskmoon_widgets/test/chat/dm_chat_view_test.dart
git commit -m "feat(chat): add DmChatView with pinned auto-scroll and jump-to-bottom"
```

---

## Task 14: Final barrel + `duskmoon_ui` re-export audit + full project checks

**Files:**
- Modify: `packages/duskmoon_widgets/lib/src/chat/chat.dart`
- Modify: `packages/duskmoon_widgets/lib/duskmoon_widgets.dart`

- [ ] **Step 14.1: Finalize barrel exports**

Overwrite `packages/duskmoon_widgets/lib/src/chat/chat.dart`:

```dart
/// DuskMoon chat module — bubbles, blocks, input, and composed view.
///
/// See `docs/superpowers/specs/2026-04-20-dm-chat-design.md` for design.
library;

// Models
export 'models/dm_chat_attachment.dart';
export 'models/dm_chat_block.dart';
export 'models/dm_chat_message.dart';

// Theme
export 'theme/dm_chat_theme.dart';

// Block views (public)
export 'bubble/blocks/_attachment_block_view.dart';
export 'bubble/blocks/_thinking_block_view.dart';
export 'bubble/blocks/_tool_call_block_view.dart';

// Bubble
export 'bubble/dm_chat_bubble.dart';

// Input
export 'input/dm_chat_input.dart';
export 'input/dm_chat_submit_shortcut.dart';

// View
export 'view/dm_chat_view.dart';
```

- [ ] **Step 14.2: Verify `duskmoon_widgets.dart` still re-exports via `// Chat` section**

Confirm `packages/duskmoon_widgets/lib/duskmoon_widgets.dart` contains:

```dart
// Chat
export 'src/chat/chat.dart';
```

If it does not, append it.

- [ ] **Step 14.3: Run melos analyze and test for the whole repo**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui && dart pub get
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui && melos run analyze
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui && melos run test
```

Expected: Both `melos run analyze` and `melos run test` complete with no failures.

- [ ] **Step 14.4: Verify `duskmoon_ui` umbrella re-exports chat symbols**

Run: `cd packages/duskmoon_ui && dart -e "import 'package:duskmoon_ui/duskmoon_ui.dart'; void main() { DmChatMessage(id:'x', role: DmChatRole.user, blocks: const []); }"`

If the `duskmoon_ui` umbrella re-exports `duskmoon_widgets`, this compiles. If not, add `export 'package:duskmoon_widgets/duskmoon_widgets.dart';` (or an equivalent granular re-export) to `packages/duskmoon_ui/lib/duskmoon_ui.dart` matching existing patterns for other widgets, then re-run.

- [ ] **Step 14.5: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/chat/chat.dart \
        packages/duskmoon_widgets/lib/duskmoon_widgets.dart \
        packages/duskmoon_ui/lib/duskmoon_ui.dart 2>/dev/null || true
git commit -m "chore(chat): finalize barrel exports and umbrella re-exports"
```

---

## Task 15: Example app — chat screen

**Files:**
- Create: `example/lib/screens/chat/chat_screen.dart`
- Modify: `example/lib/router.dart`
- Modify: `example/lib/destination.dart`

- [ ] **Step 15.1: Read router.dart and destination.dart to understand patterns**

Read the existing `example/lib/router.dart` and `example/lib/destination.dart` files. Note how existing screens are registered (e.g., `code_editor_screen.dart`). Follow the same pattern exactly for the new chat destination.

- [ ] **Step 15.2: Implement `chat_screen.dart`**

Create `example/lib/screens/chat/chat_screen.dart`:

```dart
import 'dart:async';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<DmChatMessage> _messages = [];
  bool _isStreaming = false;
  DmChatSubmitShortcut _shortcut = DmChatSubmitShortcut.cmdEnter;
  StreamController<String>? _activeThinking;
  StreamController<String>? _activeText;
  Timer? _scriptTimer;

  void _onSend(String text, List<DmChatAttachment> atts) {
    if (_isStreaming) return;
    setState(() {
      _messages.add(
        DmChatMessage(
          id: 'u${_messages.length}',
          role: DmChatRole.user,
          blocks: [
            if (text.isNotEmpty) DmChatTextBlock(text: text),
            if (atts.isNotEmpty) DmChatAttachmentBlock(attachments: atts),
          ],
        ),
      );
      _startAssistantResponse(text);
    });
  }

  void _startAssistantResponse(String prompt) {
    _activeThinking = StreamController<String>();
    _activeText = StreamController<String>();
    final thinking = _activeThinking!;
    final textC = _activeText!;
    final id = 'a${_messages.length}';
    final toolCall = DmChatToolCallBlock(
      id: 't$id',
      name: 'run_code',
      input: const {'snippet': 'print("ok")'},
      status: DmChatToolCallStatus.pending,
    );
    _messages.add(
      DmChatMessage(
        id: id,
        role: DmChatRole.assistant,
        status: DmChatMessageStatus.streaming,
        blocks: [
          DmChatThinkingBlock(stream: thinking.stream),
          toolCall,
          DmChatTextBlock(stream: textC.stream),
        ],
      ),
    );
    _isStreaming = true;

    // Simulated deltas.
    final chunks = [
      (
        delay: const Duration(milliseconds: 200),
        send: () => thinking.add('Considering prompt: "$prompt"... '),
      ),
      (
        delay: const Duration(milliseconds: 600),
        send: () => thinking.add('Checking options. '),
      ),
      (
        delay: const Duration(milliseconds: 300),
        send: () {
          setState(() => _replaceBlock(id, toolCall.copyWith(status: DmChatToolCallStatus.running)));
        },
      ),
      (
        delay: const Duration(milliseconds: 500),
        send: () {
          setState(() => _replaceBlock(
                id,
                toolCall.copyWith(
                  status: DmChatToolCallStatus.done,
                  output: 'ok\n',
                ),
              ));
        },
      ),
      (
        delay: const Duration(milliseconds: 300),
        send: () => textC.add('Here is the response:\n\n'),
      ),
      (
        delay: const Duration(milliseconds: 200),
        send: () => textC.add('Hello! '),
      ),
      (
        delay: const Duration(milliseconds: 200),
        send: () => textC.add('The tool call completed successfully.'),
      ),
      (
        delay: const Duration(milliseconds: 200),
        send: () {
          thinking.close();
          textC.close();
          setState(() {
            _isStreaming = false;
            final idx = _messages.indexWhere((m) => m.id == id);
            if (idx >= 0) {
              _messages[idx] = _messages[idx]
                  .copyWith(status: DmChatMessageStatus.complete);
            }
          });
        },
      ),
    ];

    var elapsed = Duration.zero;
    for (final c in chunks) {
      elapsed += c.delay;
      Future.delayed(elapsed, () {
        if (!mounted) return;
        c.send();
      });
    }
  }

  void _replaceBlock(String messageId, DmChatToolCallBlock updated) {
    final idx = _messages.indexWhere((m) => m.id == messageId);
    if (idx < 0) return;
    final blocks = _messages[idx].blocks.map<DmChatBlock>((b) {
      if (b is DmChatToolCallBlock && b.id == updated.id) return updated;
      return b;
    }).toList();
    _messages[idx] = _messages[idx].copyWith(blocks: blocks);
  }

  @override
  void dispose() {
    _scriptTimer?.cancel();
    _activeThinking?.close();
    _activeText?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          PopupMenuButton<DmChatSubmitShortcut>(
            tooltip: 'Submit shortcut',
            initialValue: _shortcut,
            onSelected: (v) => setState(() => _shortcut = v),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: DmChatSubmitShortcut.cmdEnter,
                child: Text('Cmd/Ctrl+Enter submits'),
              ),
              PopupMenuItem(
                value: DmChatSubmitShortcut.enter,
                child: Text('Enter submits'),
              ),
            ],
            icon: const Icon(Icons.keyboard),
          ),
        ],
      ),
      body: DmChatView(
        messages: _messages,
        onSend: _onSend,
        isStreaming: _isStreaming,
        submitShortcut: _shortcut,
        emptyBuilder: (_) => const Text(
          'Send a message to begin.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
```

- [ ] **Step 15.3: Register the screen in destination/router**

Edit `example/lib/destination.dart` to add a chat destination following the same field pattern as existing entries (import the screen, add a new const with icon `Icons.chat`, title `'Chat'`, and the `ChatScreen()` widget). Edit `example/lib/router.dart` to register the new route exactly like other screens are registered.

Run: `cd example && flutter run -d chrome` (or your primary target) and verify the Chat entry appears and the simulated conversation runs end-to-end.

- [ ] **Step 15.4: Run example analyzer**

Run: `cd example && dart analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 15.5: Commit**

```bash
git add example/lib/screens/chat/ \
        example/lib/destination.dart \
        example/lib/router.dart
git commit -m "feat(example): add chat screen showcasing DmChatView"
```

---

## Task 16: Final verification

- [ ] **Step 16.1: Run format + analyze + test across the monorepo**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
melos run format
melos run analyze
melos run test
```

Expected: All three complete with no failures.

- [ ] **Step 16.2: Verify spec coverage manually**

Cross-check [docs/superpowers/specs/2026-04-20-dm-chat-design.md](../specs/2026-04-20-dm-chat-design.md) decision table against shipped files. Every Q1–Q10 decision + the submit-shortcut follow-up must have a corresponding implementation task.

- [ ] **Step 16.3: Commit format-only changes (if any)**

```bash
git add -u
git diff --cached --quiet || git commit -m "style(chat): apply dart format"
```
