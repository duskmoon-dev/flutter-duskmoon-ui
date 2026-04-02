import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';

void main() {
  test('umbrella package exports all workspace packages', () {
    expect(DmThemeData.themes, isNotEmpty);
    expect(DmThemeBloc, isNotNull);
    expect(DmVisualization.packageName, 'duskmoon_visualization');
    expect(DmTextFieldBlocBuilder, isNotNull);
  });
}
