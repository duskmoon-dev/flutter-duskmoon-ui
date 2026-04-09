import 'package:flutter/widgets.dart';

import 'dm_platform_style.dart';

/// App-level platform-style provider for DuskMoon adaptive widgets.
///
/// Place above [MaterialApp] or [CupertinoApp] to declare a default
/// [DmPlatformStyle] for all adaptive widgets in the tree.
///
/// Resolution order for adaptive widgets:
/// 1. Per-widget `platformOverride` parameter
/// 2. Nearest [DmPlatformOverride] ancestor
/// 3. Nearest [DuskmoonApp] ancestor  ← this widget
/// 4. Platform default from [Theme.of(context).platform]
///
/// Example:
/// ```dart
/// DuskmoonApp(
///   platformStyle: DmPlatformStyle.cupertino,
///   child: MaterialApp(home: MyHome()),
/// );
/// ```
class DuskmoonApp extends InheritedWidget {
  const DuskmoonApp({
    super.key,
    this.platformStyle,
    required super.child,
  });

  /// Explicit platform style for all adaptive widgets in the subtree.
  ///
  /// When null, adaptive widgets fall through to platform-default detection.
  final DmPlatformStyle? platformStyle;

  /// Returns the [DmPlatformStyle] from the nearest [DuskmoonApp], or null.
  static DmPlatformStyle? maybeStyleOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DuskmoonApp>()
        ?.platformStyle;
  }

  @override
  bool updateShouldNotify(DuskmoonApp oldWidget) =>
      platformStyle != oldWidget.platformStyle;
}
