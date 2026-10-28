import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('controller materials and analog feedback in light and dark',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 1140);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const boundary = ValueKey('controllers');
    await tester.pumpWidget(MaterialApp(
        home: RepaintBoundary(
      key: boundary,
      child: Column(children: [
        for (final style in DmControllerStyle.values)
          Expanded(
              child: Row(children: [
            for (final brightness in Brightness.values)
              Expanded(
                  child: Theme(
                data: ThemeData(brightness: brightness),
                child: Material(
                  color: brightness == Brightness.dark
                      ? const Color(0xff15191f)
                      : const Color(0xffedf0f4),
                  child: Center(
                      child: DmControllerView(
                    style: style,
                    width: 540,
                    leftStick: const Offset(-.7, -.7),
                    rightStick: const Offset(.8, .3),
                    leftTrigger: .25,
                    rightTrigger: .75,
                    pressedButtons: const {DmControllerButton.south},
                  )),
                ),
              )),
          ])),
      ]),
    )));
    await tester.pumpAndSettle();
    await expectLater(find.byKey(boundary),
        matchesGoldenFile('goldens/controller_views.png'));
  });
}
