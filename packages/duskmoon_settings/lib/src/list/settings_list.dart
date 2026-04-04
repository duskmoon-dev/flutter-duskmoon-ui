import 'package:flutter/material.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart'
    show DmPlatformStyle, resolvePlatformStyle;
import 'package:duskmoon_settings/src/list/abstract_settings_list.dart';
import 'package:duskmoon_settings/src/list/platforms/cupertino_settings_list.dart';
import 'package:duskmoon_settings/src/list/platforms/fluent_settings_list.dart';
import 'package:duskmoon_settings/src/list/platforms/material_settings_list.dart';
import 'package:duskmoon_settings/src/utils/platform_utils.dart';

/// Compositor widget that creates platform-specific settings lists.
///
/// Delegates to design system implementations:
/// - [MaterialSettingsList] for Android, Linux, Web, Fuchsia
/// - [CupertinoSettingsList] for iOS, macOS
/// - [FluentSettingsList] for Windows
class SettingsList extends AbstractSettingsList {
  const SettingsList({
    required super.sections,
    super.shrinkWrap,
    super.physics,
    super.platform,
    super.contentPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Keep DevicePlatform.fromContext for sub-lists (they may use it internally).
    final resolvedPlatform = platform ?? DevicePlatform.fromContext(context);

    // Convert the explicit DevicePlatform override (if any) to DmPlatformStyle
    // so DuskmoonApp (L3) is honoured when platform is null.
    final DmPlatformStyle? platformOverride = switch (platform) {
      null => null,
      DevicePlatform.iOS || DevicePlatform.macOS => DmPlatformStyle.cupertino,
      DevicePlatform.windows => DmPlatformStyle.fluent,
      _ => DmPlatformStyle.material,
    };

    final style =
        resolvePlatformStyle(context, widgetOverride: platformOverride);

    return switch (style) {
      DmPlatformStyle.cupertino => CupertinoSettingsList(
          sections: sections,
          shrinkWrap: shrinkWrap,
          physics: physics,
          platform: resolvedPlatform,
          contentPadding: contentPadding,
        ),
      DmPlatformStyle.fluent => FluentSettingsList(
          sections: sections,
          shrinkWrap: shrinkWrap,
          physics: physics,
          platform: resolvedPlatform,
          contentPadding: contentPadding,
        ),
      DmPlatformStyle.material => MaterialSettingsList(
          sections: sections,
          shrinkWrap: shrinkWrap,
          physics: physics,
          platform: resolvedPlatform,
          contentPadding: contentPadding,
        ),
    };
  }
}
