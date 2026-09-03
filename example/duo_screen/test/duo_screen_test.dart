import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duo_screen/main.dart';

void main() {
  testWidgets('DuoScreenApp builds without crashing', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DuoScreenApp(displayId: 0));
    expect(find.byType(DuoScreenApp), findsOneWidget);
    expect(find.text('Widgets'), findsWidgets);
  });
}
