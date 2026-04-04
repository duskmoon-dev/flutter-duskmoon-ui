import 'dart:async';
import 'package:flutter/foundation.dart';

class CursorBlink extends ChangeNotifier {
  CursorBlink();

  bool _visible = true;
  Timer? _timer;
  bool _started = false;

  bool get visible => _visible;

  void start() {
    if (_started) return;
    _started = true;
    _visible = true;
    _timer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      _visible = !_visible;
      notifyListeners();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _started = false;
    _visible = false;
    notifyListeners();
  }

  void restart() {
    _timer?.cancel();
    _timer = null;
    _started = true;
    _visible = true;
    notifyListeners();
    _timer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      _visible = !_visible;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
