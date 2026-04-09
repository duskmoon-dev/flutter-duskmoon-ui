import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart'
    show DmPlatformStyle, resolvePlatformStyle;

/// An action item for [showDmBottomSheetActionList].
class DmBottomSheetAction {
  /// Creates a bottom sheet action with a [title] and [onTap] callback.
  const DmBottomSheetAction({
    required this.title,
    required this.onTap,
    this.style,
  });

  /// The label widget displayed on the action button.
  final Widget title;

  /// Callback invoked when this action is tapped.
  final VoidCallback onTap;

  /// Optional custom button style override.
  final ButtonStyle? style;
}

/// Shows a bottom sheet with a list of action buttons.
///
/// When [showBackdrop] is true, a semi-transparent overlay is shown and
/// tapping outside the buttons dismisses the sheet.
void showDmBottomSheetActionList({
  required BuildContext context,
  required List<DmBottomSheetAction> actions,
  bool showBackdrop = true,
}) {
  final spacingSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 16.0;

  showBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    constraints: const BoxConstraints(
      maxWidth: double.infinity,
      maxHeight: double.infinity,
    ),
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      final style = resolvePlatformStyle(context);

      return GestureDetector(
        onTap: showBackdrop ? () => Navigator.of(context).pop() : null,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: showBackdrop
              ? BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                )
              : null,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom * 2,
          ),
          child: SafeArea(
            child: Wrap(
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.end,
              runSpacing: spacingSize,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final action in actions)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacingSize),
                    child: _buildButton(
                      context: context,
                      action: action,
                      colorScheme: colorScheme,
                      style: style,
                    ),
                  ),
                SizedBox(width: double.infinity, height: spacingSize),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildButton({
  required BuildContext context,
  required DmBottomSheetAction action,
  required ColorScheme colorScheme,
  required DmPlatformStyle style,
}) {
  return switch (style) {
    DmPlatformStyle.cupertino => CupertinoButton.filled(
        onPressed: () {
          Navigator.of(context).pop();
          action.onTap();
        },
        child: action.title,
      ),
    _ => ElevatedButton(
        style: action.style ??
            ElevatedButton.styleFrom(
              foregroundColor: colorScheme.onPrimary,
              backgroundColor: colorScheme.primary,
              minimumSize: const Size.fromHeight(50),
            ),
        onPressed: () {
          Navigator.of(context).pop();
          action.onTap();
        },
        child: Center(child: action.title),
      ),
  };
}
