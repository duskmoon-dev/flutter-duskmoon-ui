import 'package:flutter/material.dart';

/// Pushes a fullscreen dialog with an [AppBar] containing a close button.
void showDmFullscreenDialog({
  required BuildContext context,
  required Widget title,
  required WidgetBuilder builder,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
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
  );
}
