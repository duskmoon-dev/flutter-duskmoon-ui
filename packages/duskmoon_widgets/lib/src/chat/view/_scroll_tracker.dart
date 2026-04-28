import 'package:flutter/widgets.dart';

/// Tracks whether a `reverse: true` scrollable is pinned near offset 0
/// (= visual bottom). Exposes a notifier so a Jump-to-Bottom button can
/// show/hide with unread counts.
class ChatScrollTracker extends ChangeNotifier {
  ChatScrollTracker({this.pinnedThreshold = 48});

  final double pinnedThreshold;
  final ScrollController controller = ScrollController();
  bool _pinned = true;
  int _unread = 0;

  bool get pinned => _pinned;
  int get unread => _unread;

  void attach() {
    controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    controller.removeListener(_onScroll);
    controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!controller.hasClients) return;
    final nowPinned = controller.offset <= pinnedThreshold;
    if (nowPinned != _pinned) {
      _pinned = nowPinned;
      if (_pinned) _unread = 0;
      notifyListeners();
    }
  }

  /// Call when a new message is appended.
  void onNewMessage({bool fromAssistant = true}) {
    if (!_pinned && fromAssistant) {
      _unread++;
      notifyListeners();
    }
  }

  Future<void> scrollToBottom() async {
    if (!controller.hasClients) return;
    await controller.animateTo(
      0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
    _unread = 0;
    _pinned = true;
    notifyListeners();
  }
}
