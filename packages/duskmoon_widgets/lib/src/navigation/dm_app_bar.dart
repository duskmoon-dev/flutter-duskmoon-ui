import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/fluent_theme_bridge.dart';
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
    this.backgroundColor,
    this.foregroundColor,
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

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The foreground color for text and icons in the app bar.
  final Color? foregroundColor;

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
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          iconTheme: foregroundColor != null
              ? IconThemeData(color: foregroundColor)
              : null,
        ),
      DmPlatformStyle.cupertino => CupertinoNavigationBar(
          middle: title != null && foregroundColor != null
              ? IconTheme(
                  data: IconThemeData(color: foregroundColor),
                  child: DefaultTextStyle(
                    style: TextStyle(color: foregroundColor, fontSize: 17),
                    child: title!,
                  ),
                )
              : title,
          leading: leading,
          trailing: actions != null && actions!.isNotEmpty
              ? IconTheme(
                  data: IconThemeData(
                      color: foregroundColor ??
                          CupertinoTheme.of(context).primaryColor),
                  child:
                      Row(mainAxisSize: MainAxisSize.min, children: actions!),
                )
              : null,
          automaticallyImplyLeading: automaticallyImplyLeading,
          backgroundColor: backgroundColor,
        ),
      DmPlatformStyle.fluent => _buildFluent(context),
    };
  }

  Widget _buildFluent(BuildContext context) {
    return wrapWithFluentTheme(
      context,
      Builder(builder: (context) {
        final fluentTheme = fluent.FluentTheme.of(context);
        final bgColor = backgroundColor ?? fluentTheme.micaBackgroundColor;
        final fgColor = foregroundColor ??
            fluentTheme.typography.body?.color ??
            Colors.black;
        return Container(
          height: kToolbarHeight,
          color: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (leading != null)
                IconTheme(
                    data: IconThemeData(color: fgColor), child: leading!)
              else if (automaticallyImplyLeading &&
                  Navigator.of(context).canPop())
                fluent.IconButton(
                  icon:
                      Icon(fluent.FluentIcons.back, color: fgColor, size: 16),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              if (title != null)
                Expanded(
                  child: DefaultTextStyle(
                    style:
                        (fluentTheme.typography.subtitle ?? const TextStyle())
                            .copyWith(color: fgColor),
                    child: title!,
                  ),
                )
              else
                const Spacer(),
              if (actions != null)
                IconTheme(
                  data: IconThemeData(color: fgColor),
                  child:
                      Row(mainAxisSize: MainAxisSize.min, children: actions!),
                ),
            ],
          ),
        );
      }),
    );
  }
}
