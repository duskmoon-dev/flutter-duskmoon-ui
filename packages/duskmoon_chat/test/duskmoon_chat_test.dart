// Verifies the package barrel compiles while the scaffold has no public API.
// ignore: unused_import
import 'package:duskmoon_chat/duskmoon_chat.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('duskmoon_chat scaffold', () {
    test('has a compilable package library', () {
      expect(true, isTrue);
    });
  });
}
