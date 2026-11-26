import 'package:flutter/foundation.dart';

class DmMermaidController extends ChangeNotifier {
  DmMermaidController({this._source = ''});

  String get source => _source;
  String _source;

  set source(String value) {
    if (value == _source) return;
    _source = value;
    notifyListeners();
  }
}
