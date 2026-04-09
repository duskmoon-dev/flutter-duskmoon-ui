import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart'
    show DmPlatformStyle, resolvePlatformStyle;

/// Pushes a fullscreen dialog with an [AppBar] (Material) or [CupertinoNavigationBar]
/// (Cupertino) containing a close button.
void showDmFullscreenDialog({
  required BuildContext context,
  required Widget title,
  required WidgetBuilder builder,
}) {
  final style = resolvePlatformStyle(context);

  final route = switch (style) {
    DmPlatformStyle.cupertino => CupertinoPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: title,
              leading: CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            child: SafeArea(child: builder(context)),
          );
        },
      ),
    _ => MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: title,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SafeArea(child: builder(context)),
          );
        },
      ),
  };

  Navigator.of(context).push(route);
}
