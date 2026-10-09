import 'package:duo_screen/duo_display_controller.dart';
import 'package:duo_screen/main.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'duo_display_controller_test.dart' show FakeBridge, FakePlatform;

Future<void> _disposeController(
  WidgetTester tester,
  DuoDisplayController controller,
) async {
  await tester.pumpWidget(const SizedBox());
  // Stream cancellation must run outside the widget FakeAsync zone so its
  // asynchronous completion can be awaited without waiting for another pump.
  await tester.runAsync(() async {
    controller.dispose();
    await controller.shutdown();
  });
  await tester.pump();
}

void main() {
  for (final size in [const Size(400, 800), const Size(1200, 800)]) {
    testWidgets('unsupported platform retains AppBar and navigation at $size',
        (tester) async {
      final originalPlatform = debugDefaultTargetPlatformOverride;
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      try {
        expect(defaultDisplayPlatform(), isA<SingleDisplayPlatform>());
        expect(defaultBridge(secondary: false), isA<SingleDisplayBridge>());
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(const DuoScreenApp());
        await tester.pump();
        expect(find.text('DuskMoon Duo'), findsOneWidget);
        expect(find.byType(DmAppBar), findsOneWidget);
        expect(find.text('Widgets'), findsWidgets);
        expect(find.text('Forms'), findsWidgets);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      } finally {
        debugDefaultTargetPlatformOverride = originalPlatform;
      }
    });
  }

  testWidgets('form draft, preview toggle and save render authoritative state',
      (tester) async {
    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = DuoDisplayController(
      secondary: false,
      platform: const SingleDisplayPlatform(),
      bridge: const SingleDisplayBridge(),
    );
    await tester.pumpWidget(DuoScreenApp(controller: controller));
    controller.intent('select', 1);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Orbit');
    await tester.pump();
    expect(find.text('Preview: Orbit'), findsOneWidget);
    await tester.tap(find.text('Save Configuration'));
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Comet');
    await tester.pump();
    expect(find.text('Preview: Orbit'), findsOneWidget);
    expect(find.text('Saved project: Orbit'), findsOneWidget);
    expect(controller.state.projectName, 'Comet');
    await tester.tap(find.text('Save Configuration'));
    await tester.pump();
    expect(find.text('Preview: Comet'), findsOneWidget);
    await _disposeController(tester, controller);
  });

  testWidgets('language selector replaces sample and installs highlighting',
      (tester) async {
    tester.view.physicalSize = const Size(600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = DuoDisplayController(
      secondary: false,
      platform: const SingleDisplayPlatform(),
      bridge: const SingleDisplayBridge(),
    );
    await tester.pumpWidget(DuoScreenApp(controller: controller));
    controller.intent('select', 3);
    await tester.pumpAndSettle();
    var editor = tester.widget<DmCodeEditor>(find.byType(DmCodeEditor));
    expect(editor.language, 'dart');
    expect(editor.initialDoc, contains('void main'));
    final oldState = tester.state(find.byType(DmCodeEditor));
    expect(find.text('Python'), findsOneWidget);
    await tester.tap(find.text('Python'));
    await tester.pumpAndSettle();
    editor = tester.widget<DmCodeEditor>(find.byType(DmCodeEditor));
    expect(editor.language, 'python');
    expect(editor.initialDoc, contains('def main'));
    expect(tester.state(find.byType(DmCodeEditor)), isNot(same(oldState)));
    final engine =
        tester.widget<CodeEditorWidget>(find.byType(CodeEditorWidget));
    expect(engine.controller!.state.doc.toString(), contains('def main'));
    expect(syntaxTree(engine.controller!.state), isNotNull);
    await _disposeController(tester, controller);
  });

  testWidgets('secondary route explicitly builds a titled controller',
      (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = DuoDisplayController(
      secondary: true,
      platform: FakePlatform(),
      bridge: FakeBridge(),
    );
    tester.binding.platformDispatcher.defaultRouteNameTestValue =
        secondaryRoute;
    addTearDown(
        tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);
    await tester.pumpWidget(
      DuoScreenApp(secondary: true, controller: controller),
    );
    await tester.pump();
    expect(find.text('Controller Panel'), findsOneWidget);
    expect(find.text('Waiting for viewer connection…'), findsOneWidget);
    expect(find.byType(DmCodeEditor), findsNothing);
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).routes,
        contains(secondaryRoute));
    await _disposeController(tester, controller);
  });
}
