import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';

void main() {
  test('umbrella package exports DmThemeData', () {
    // Verify umbrella re-exports work by accessing a type from duskmoon_theme
    expect(DmThemeData.themes, isNotEmpty);
  });
}
