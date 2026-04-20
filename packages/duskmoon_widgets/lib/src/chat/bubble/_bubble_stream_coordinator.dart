import 'package:flutter/widgets.dart';

/// Signals cross-block events within a single bubble — specifically, the
/// first text token arriving from any `DmChatTextBlock` sibling, which
/// auto-collapses any `DmChatThinkingBlockView` that hasn't been manually
/// toggled yet.
class BubbleStreamCoordinator extends ChangeNotifier {
  bool _textStarted = false;
  bool get textStarted => _textStarted;

  void markTextStarted() {
    if (_textStarted) return;
    _textStarted = true;
    notifyListeners();
  }
}

/// Inherited notifier exposing a [BubbleStreamCoordinator] to block widgets.
class BubbleStreamScope extends InheritedNotifier<BubbleStreamCoordinator> {
  const BubbleStreamScope({
    super.key,
    required BubbleStreamCoordinator coordinator,
    required super.child,
  }) : super(notifier: coordinator);

  static BubbleStreamCoordinator? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<BubbleStreamScope>()
      ?.notifier;
}
