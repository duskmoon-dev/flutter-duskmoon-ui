import 'package:flutter/foundation.dart';

class DmMermaidController extends ChangeNotifier {
  DmMermaidController({String source = ''}) : _source = source;

  String get source => _source;
  String _source;

  set source(String value) {
    if (value == _source) return;
    _source = value;
    notifyListeners();
  }
}
