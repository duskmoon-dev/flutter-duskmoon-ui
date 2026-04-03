import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive app bar that renders Material [AppBar] or Cupertino navigation bar.
class DmAppBar extends StatelessWidget
    with AdaptiveWidget
    implements PreferredSizeWidget {
  /// Creates an adaptive app bar.
  const DmAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.platformOverride,
  });

  /// The primary title widget displayed in the app bar.
  final Widget? title;

  /// Widget placed before the [title], typically a back button.
  final Widget? leading;

  /// Trailing action widgets shown after the [title].
  final List<Widget>? actions;

  /// Whether to automatically show a back/close button when applicable.
  final bool automaticallyImplyLeading;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => AppBar(
          title: title,
          leading: leading,
          actions: actions,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
      DmPlatformStyle.cupertino => CupertinoNavigationBar(
          middle: title,
          leading: leading,
          trailing: actions != null && actions!.isNotEmpty
              ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
              : null,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
      DmPlatformStyle.fluent => AppBar(
          title: title,
          leading: leading,
          actions: actions,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
    };
  }
}
