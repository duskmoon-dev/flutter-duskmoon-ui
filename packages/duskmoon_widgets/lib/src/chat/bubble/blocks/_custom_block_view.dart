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
