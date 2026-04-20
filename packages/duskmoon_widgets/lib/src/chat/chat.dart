/// DuskMoon chat module — bubbles, blocks, input, and composed view.
///
/// See `docs/superpowers/specs/2026-04-20-dm-chat-design.md` for design.
library;

// Exports are added as each task ships.

// Models
export 'models/dm_chat_attachment.dart';
export 'models/dm_chat_block.dart';
export 'models/dm_chat_message.dart';

// Theme
export 'theme/dm_chat_theme.dart';

// Block views
export 'bubble/blocks/_attachment_block_view.dart';
export 'bubble/blocks/_thinking_block_view.dart';
export 'bubble/blocks/_tool_call_block_view.dart';

// Bubble
export 'bubble/dm_chat_bubble.dart';

// Input
export 'input/dm_chat_input.dart';
export 'input/dm_chat_submit_shortcut.dart';
