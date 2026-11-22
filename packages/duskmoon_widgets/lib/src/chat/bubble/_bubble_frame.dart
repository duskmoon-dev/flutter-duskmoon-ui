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
    this.footer,
  });

  final DmChatRole role;
  final Widget child;
  final Widget? avatar;
  final Widget? header;
  final Widget? footer;

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
            final bubble = Container(
              padding: theme.bubblePadding,
              decoration: BoxDecoration(
                color: theme.userBubbleColor,
                borderRadius: theme.userBubbleRadius,
              ),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: theme.userBubbleOnColor),
                child: child,
              ),
            );
            final column = Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (header != null) ...[
                  header!,
                  const SizedBox(height: 4),
                ],
                bubble,
                if (footer != null) ...[
                  const SizedBox(height: 4),
                  footer!,
                ],
              ],
            );
            return Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: avatar == null
                    ? (header == null && footer == null ? bubble : column)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: column),
                          const SizedBox(width: 10),
                          avatar!,
                        ],
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
                  if (footer != null) ...[
                    const SizedBox(height: 4),
                    footer!,
                  ],
                ],
              ),
            ),
          ],
        );
      case DmChatRole.system:
        final banner = Container(
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
        );
        return Align(
          alignment: Alignment.center,
          child: footer == null
              ? banner
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    banner,
                    const SizedBox(height: 4),
                    footer!,
                  ],
                ),
        );
    }
  }
}
