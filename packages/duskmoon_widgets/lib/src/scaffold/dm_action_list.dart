import 'package:flutter/material.dart';

/// Controls how [DmActionList] renders its actions.
enum DmActionSize {
  /// Collapsed into a [PopupMenuButton].
  small,

  /// Icon-only buttons in a [Wrap].
  medium,

  /// Icon + label buttons in a [Wrap].
  large,
}

/// A single action entry used by [DmActionList].
class DmAction {
  /// Label shown in [DmActionSize.small] and [DmActionSize.large] modes.
  final String title;

  /// Icon shown in all modes.
  final IconData icon;

  /// Callback invoked when the action is triggered.
  final VoidCallback onPressed;

  /// When `true`, the action is greyed out or hidden depending on
  /// [DmActionList.hideDisabled].
  final bool disabled;

  /// Creates an action with a [title], [icon], and [onPressed] callback.
  const DmAction({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.disabled = false,
  });
}

/// Renders a list of [DmAction]s in one of three visual sizes.
///
/// * [DmActionSize.small] — a [PopupMenuButton] overflow menu.
/// * [DmActionSize.medium] — icon-only [IconButton]s.
/// * [DmActionSize.large] — [TextButton.icon] with label.
///
/// When [hideDisabled] is `true` (the default), disabled actions are
/// removed from the rendered list entirely.
class DmActionList extends StatelessWidget {
  /// Controls the visual presentation of the action list.
  final DmActionSize size;

  /// The actions to display — already filtered if [hideDisabled] is `true`.
  final List<DmAction> actions;

  /// Layout direction for [DmActionSize.medium] and [DmActionSize.large].
  final Axis direction;

  /// Whether disabled actions should be hidden rather than greyed out.
  final bool hideDisabled;

  /// Creates an action list that filters out disabled actions when [hideDisabled] is `true`.
  DmActionList({
    super.key,
    this.size = DmActionSize.medium,
    required List<DmAction> actions,
    this.hideDisabled = true,
    this.direction = Axis.horizontal,
  }) : actions = hideDisabled
            ? actions.where((action) => !action.disabled).toList()
            : actions;

  @override
  Widget build(BuildContext context) {
    switch (size) {
      case DmActionSize.small:
        return PopupMenuButton<int>(
          itemBuilder: (context) => actions
              .map<PopupMenuEntry<int>>(
                (action) => PopupMenuItem(
                  value: actions.indexOf(action),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            action.icon,
                            color: action.disabled
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).iconTheme.color,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(text: action.title),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          onSelected: (value) {
            if (actions[value].disabled) return;
            actions[value].onPressed();
          },
        );
      case DmActionSize.medium:
        return Wrap(
          direction: direction,
          children: actions
              .map<Widget>(
                (action) => IconButton(
                  icon: Icon(action.icon),
                  onPressed: action.disabled ? null : action.onPressed,
                ),
              )
              .toList(),
        );
      case DmActionSize.large:
        return Wrap(
          direction: direction,
          children: actions
              .map<Widget>(
                (action) => TextButton.icon(
                  icon: Icon(action.icon),
                  label: Text(action.title),
                  onPressed: action.disabled ? null : action.onPressed,
                ),
              )
              .toList(),
        );
    }
  }
}
