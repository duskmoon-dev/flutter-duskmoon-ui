import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Adaptive dialog action that renders as [TextButton] on Material platforms
/// and [CupertinoDialogAction] on Apple platforms.
///
/// Uses the DuskMoon platform resolution chain ([DuskmoonApp],
/// [DmPlatformOverride]) instead of the raw OS platform, so it responds
/// to the global platform style switcher.
class DmDialogAction extends StatelessWidget {
  /// Creates an adaptive dialog action button.
  const DmDialogAction({super.key, this.onPressed, required this.child});

  /// Callback invoked when the action is pressed.
  final Function(BuildContext context)? onPressed;

  /// The label widget displayed inside the action button.
  final Widget child;

  VoidCallback? _onPressed(BuildContext context) {
    if (onPressed != null) {
      return () => onPressed!(context);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = resolvePlatformStyle(context);
    return switch (style) {
      DmPlatformStyle.cupertino => CupertinoDialogAction(
          onPressed: _onPressed(context),
          child: child,
        ),
      _ => TextButton(onPressed: _onPressed(context), child: child),
    };
  }
}

/// Shows an adaptive dialog that respects the DuskMoon platform resolution
/// chain ([DuskmoonApp], [DmPlatformOverride]).
///
/// Renders [CupertinoAlertDialog] when the resolved style is
/// [DmPlatformStyle.cupertino], and [AlertDialog] otherwise.
Future<T?> showDmDialog<T>({
  required BuildContext context,
  required Widget title,
  required Widget content,
  List<Widget>? actions,
}) {
  final style = resolvePlatformStyle(context);
  return showDialog<T>(
    context: context,
    builder: (context) {
      if (style == DmPlatformStyle.cupertino) {
        return CupertinoAlertDialog(
          title: title,
          content: content,
          actions: actions ?? const [],
        );
      }
      return AlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    },
  );
}
