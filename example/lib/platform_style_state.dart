import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

/// Global notifier for the selected platform style.
///
/// `null` means "auto" — the platform default is used.
final platformStyleNotifier = ValueNotifier<DmPlatformStyle?>(null);

/// A popup menu button for switching the global platform style.
///
/// Place this in a [DmAppBar]'s `actions` list.
class PlatformSwitchAction extends StatelessWidget {
  const PlatformSwitchAction({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DmPlatformStyle?>(
      valueListenable: platformStyleNotifier,
      builder: (context, current, _) {
        return PopupMenuButton<DmPlatformStyle?>(
          icon: Icon(_iconFor(current)),
          tooltip: 'Platform style',
          onSelected: (value) => platformStyleNotifier.value = value,
          itemBuilder: (_) => [
            _item(null, 'Auto', Icons.devices),
            _item(DmPlatformStyle.material, 'Material', Icons.android),
            _item(DmPlatformStyle.cupertino, 'Cupertino', Icons.apple),
            _item(DmPlatformStyle.fluent, 'Fluent', Icons.window),
          ],
        );
      },
    );
  }

  PopupMenuItem<DmPlatformStyle?> _item(
    DmPlatformStyle? value,
    String label,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  IconData _iconFor(DmPlatformStyle? style) {
    return switch (style) {
      DmPlatformStyle.material => Icons.android,
      DmPlatformStyle.cupertino => Icons.apple,
      DmPlatformStyle.fluent => Icons.window,
      null => Icons.devices,
    };
  }
}
