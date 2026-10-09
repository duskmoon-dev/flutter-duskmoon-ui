import 'dart:ui';

import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

const _destinations = [
  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
];
const _body = Key('duo-body');
const _secondary = Key('duo-secondary');

DisplayFeature _feature(
  Rect bounds, {
  DisplayFeatureType type = DisplayFeatureType.hinge,
  DisplayFeatureState state = DisplayFeatureState.unknown,
}) =>
    DisplayFeature(bounds: bounds, type: type, state: state);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(800, 1000),
  List<DisplayFeature> features = const [],
  TextDirection direction = TextDirection.ltr,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: size, displayFeatures: features),
      child: Directionality(textDirection: direction, child: child),
    ),
  ));
  await tester.pumpAndSettle();
}

SlotLayout _slot(Key key, {WidgetBuilder? builder}) => SlotLayout(config: {
      Breakpoints.standard: SlotLayout.from(
        key: ValueKey('config-$key'),
        builder: builder ?? (_) => SizedBox.expand(key: key),
      ),
    });

void main() {
  testWidgets('single screen navigationOnSecondary retains mobile navigation',
      (tester) async {
    await _pump(
        tester,
        DmAdaptiveScaffold(
          destinations: _destinations,
          useDrawer: false,
          duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
          body: (_) => const SizedBox.expand(key: _body),
        ),
        size: const Size(400, 800));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    await tester.tap(find.text('Settings'));
    expect(tester.takeException(), isNull);
  });

  for (final policy in DuoScreenPolicy.values) {
    for (final horizontal in [false, true]) {
      for (final direction in TextDirection.values) {
        testWidgets(
            '$policy ${horizontal ? 'horizontal' : 'vertical'} hinge respects AppBar, padding and $direction',
            (tester) async {
          final hinge = horizontal
              ? const Rect.fromLTRB(0, 490, 800, 510)
              : const Rect.fromLTRB(390, 0, 410, 1000);
          await _pump(
              tester,
              Scaffold(
                appBar: AppBar(),
                body: Padding(
                  padding: const EdgeInsets.all(10),
                  child: AdaptiveLayout(
                    internalAnimations: false,
                    duoScreenPolicy: policy,
                    body: _slot(_body),
                    secondaryBody: _slot(_secondary),
                  ),
                ),
              ),
              features: [_feature(hinge)],
              direction: direction);
          final body = tester.getRect(find.byKey(_body));
          final secondary = tester.getRect(find.byKey(_secondary));
          if (horizontal) {
            expect(body, const Rect.fromLTRB(10, 66, 790, 490));
            expect(secondary, const Rect.fromLTRB(10, 510, 790, 990));
          } else if (direction == TextDirection.ltr) {
            expect(body, const Rect.fromLTRB(10, 66, 390, 990));
            expect(secondary, const Rect.fromLTRB(410, 66, 790, 990));
          } else {
            expect(body, const Rect.fromLTRB(410, 66, 790, 990));
            expect(secondary, const Rect.fromLTRB(10, 66, 390, 990));
          }
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('hidden body is not built on legacy secondary display',
      (tester) async {
    var bodyBuilds = 0;
    await _pump(
        tester,
        AdaptiveLayout(
          // ignore: deprecated_member_use
          displayId: 42,
          duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
          body: _slot(_body, builder: (_) {
            bodyBuilds++;
            return const TextField();
          }),
          secondaryBody: _slot(_secondary),
        ));
    expect(bodyBuilds, 0);
    expect(find.byType(TextField), findsNothing);
    expect(tester.getRect(find.byKey(_secondary)),
        const Rect.fromLTWH(0, 0, 800, 1000));
  });

  testWidgets(
      'explicit narrow secondary uses bottom navigation and only secondary content',
      (tester) async {
    var bodyBuilds = 0;
    await _pump(
        tester,
        DmAdaptiveScaffold(
          destinations: _destinations,
          duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
          duoScreenRole: DuoScreenRole.secondary,
          body: (_) {
            bodyBuilds++;
            return const Text('hidden viewer');
          },
          secondaryBody: (_) => const SizedBox.expand(key: _secondary),
        ),
        size: const Size(400, 800));
    expect(bodyBuilds, 0);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(tester.getRect(find.byKey(_secondary)).bottom, lessThan(800));
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow hinge secondary uses bottom navigation within its pane',
      (tester) async {
    await _pump(
        tester,
        DmAdaptiveScaffold(
          destinations: _destinations,
          duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
          body: (_) => const SizedBox.expand(key: _body),
          secondaryBody: (_) => const SizedBox.expand(key: _secondary),
        ),
        features: [_feature(const Rect.fromLTRB(390, 0, 410, 1000))]);
    expect(find.byType(NavigationRail), findsNothing);
    expect(tester.getRect(find.byType(NavigationBar)),
        const Rect.fromLTRB(410, 920, 800, 1000));
    expect(tester.getRect(find.byKey(_body)),
        const Rect.fromLTRB(0, 0, 390, 1000));
    expect(tester.getRect(find.byKey(_secondary)),
        const Rect.fromLTRB(410, 0, 800, 920));
    expect(tester.takeException(), isNull);
  });

  testWidgets('primary hidden slots neither build nor join focus or semantics',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final visibleFocus = FocusNode();
    final hiddenFocus = FocusNode();
    addTearDown(visibleFocus.dispose);
    addTearDown(hiddenFocus.dispose);
    try {
      var hiddenBuilds = 0;
      await _pump(
          tester,
          AdaptiveLayout(
            duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
            duoScreenRole: DuoScreenRole.primary,
            body: _slot(_body,
                builder: (_) =>
                    Material(child: TextField(focusNode: visibleFocus))),
            secondaryBody: _slot(_secondary, builder: (_) {
              hiddenBuilds++;
              return TextField(
                  focusNode: hiddenFocus,
                  decoration: const InputDecoration(labelText: 'Hidden input'));
            }),
            primaryNavigation: _slot(const Key('hidden-nav'), builder: (_) {
              hiddenBuilds++;
              return const Text('Hidden navigation');
            }),
          ));
      expect(hiddenBuilds, 0);
      expect(find.text('Hidden input'), findsNothing);
      expect(find.text('Hidden navigation'), findsNothing);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(visibleFocus.hasFocus, isTrue);
      expect(hiddenFocus.hasFocus, isFalse);
      expect(hiddenFocus.context, isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('single to primary and back preserves body state',
      (tester) async {
    Widget scaffold(DuoScreenRole role) => DmAdaptiveScaffold(
          destinations: _destinations,
          useDrawer: false,
          duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
          duoScreenRole: role,
          body: (_) => const TextField(),
          secondaryBody: (_) => const Text('secondary'),
        );
    await _pump(tester, scaffold(DuoScreenRole.single));
    await tester.enterText(find.byType(TextField), 'Retained viewer state');
    final state = tester.state(find.byType(EditableText));
    await _pump(tester, scaffold(DuoScreenRole.primary));
    expect(tester.state(find.byType(EditableText)), same(state));
    expect(find.text('secondary'), findsNothing);
    await _pump(tester, scaffold(DuoScreenRole.single));
    expect(tester.state(find.byType(EditableText)), same(state));
    expect(find.text('Retained viewer state'), findsOneWidget);
  });

  testWidgets('ancestor-only position changes refresh local hinge coordinates',
      (tester) async {
    late StateSetter updatePosition;
    var top = 0.0;
    final layout = AdaptiveLayout(
        internalAnimations: false,
        body: _slot(_body),
        secondaryBody: _slot(_secondary));
    await _pump(tester, StatefulBuilder(builder: (context, setState) {
      updatePosition = setState;
      return Stack(children: [
        Positioned(top: top, left: 0, width: 800, height: 800, child: layout)
      ]);
    }), features: [_feature(const Rect.fromLTRB(0, 490, 800, 510))]);
    expect(tester.getRect(find.byKey(_body)).bottom, 490);
    updatePosition(() => top = 100);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(_body)),
        const Rect.fromLTRB(0, 100, 800, 490));
    expect(tester.getRect(find.byKey(_secondary)),
        const Rect.fromLTRB(0, 510, 800, 900));
  });

  testWidgets('equivalent slot maps do not request redundant relayout',
      (tester) async {
    Widget layout() =>
        AdaptiveLayout(body: _slot(_body), secondaryBody: _slot(_secondary));
    await _pump(tester, layout());
    final old = tester
        .widget<CustomMultiChildLayout>(
            find.byType(CustomMultiChildLayout).last)
        .delegate;
    await _pump(tester, layout());
    final current = tester
        .widget<CustomMultiChildLayout>(
            find.byType(CustomMultiChildLayout).last)
        .delegate;
    expect(current.shouldRelayout(old), isFalse);
  });

  testWidgets('first frame never paints through the physical hinge',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 1000);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    const boundaryKey = Key('hinge-paint-boundary');
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
      data: MediaQueryData(size: const Size(800, 1000), displayFeatures: [
        _feature(const Rect.fromLTRB(0, 490, 800, 510)),
      ]),
      child: RepaintBoundary(
          key: boundaryKey,
          child: Scaffold(
            backgroundColor: const Color(0xFF000000),
            appBar: AppBar(),
            body: AdaptiveLayout(
              body: _slot(_body,
                  builder: (_) => const SizedBox.expand(
                      child: ColoredBox(key: _body, color: Color(0xFF00FF00)))),
              secondaryBody: _slot(_secondary,
                  builder: (_) => const SizedBox.expand(
                      child: ColoredBox(
                          key: _secondary, color: Color(0xFF0000FF)))),
            ),
          )),
    )));
    // Capture before the origin correction's next frame: physical clipping
    // must protect the hinge even while the local coordinates are settling.
    final boundary =
        tester.renderObject<RenderRepaintBoundary>(find.byKey(boundaryKey));
    final image = await tester.runAsync(() => boundary.toImage(pixelRatio: 1));
    final bytes = await tester
        .runAsync(() => image!.toByteData(format: ImageByteFormat.rawRgba));
    const offset = (500 * 800 + 400) * 4;
    expect(bytes!.buffer.asUint8List().sublist(offset, offset + 4),
        [0, 0, 0, 255]);
    final pixels = bytes.buffer.asUint8List();
    const bodyOffset = (250 * 800 + 400) * 4;
    const secondaryOffset = (750 * 800 + 400) * 4;
    expect(pixels.sublist(bodyOffset, bodyOffset + 4), [0, 255, 0, 255]);
    expect(
        pixels.sublist(secondaryOffset, secondaryOffset + 4), [0, 0, 255, 255]);
    image!.dispose();
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(_body)).bottom, 490);
    expect(tester.getRect(find.byKey(_secondary)).top, 510);
  });

  testWidgets('feature selection is deterministic and posture aware',
      (tester) async {
    Rect? resolved;
    final probe = Builder(builder: (context) {
      resolved = DuoScreen.hingeOf(context);
      return const SizedBox();
    });
    final fold = _feature(const Rect.fromLTRB(0, 300, 800, 300),
        type: DisplayFeatureType.fold,
        state: DisplayFeatureState.postureHalfOpened);
    final hinge = _feature(const Rect.fromLTRB(390, 0, 410, 1000));
    final cutout = _feature(const Rect.fromLTRB(0, 0, 40, 20),
        type: DisplayFeatureType.cutout);
    for (final features in [
      [fold, hinge, cutout],
      [cutout, hinge, fold]
    ]) {
      await _pump(tester, probe, features: features);
      expect(resolved, hinge.bounds);
    }
    await _pump(tester, probe, features: [fold]);
    expect(resolved, fold.bounds);
  });

  testWidgets('flat fold is ignored but occluding fold still separates',
      (tester) async {
    Rect? resolved;
    final probe = Builder(builder: (context) {
      resolved = DuoScreen.hingeOf(context);
      return const SizedBox();
    });
    await _pump(tester, probe, features: [
      _feature(
        const Rect.fromLTRB(400, 0, 400, 1000),
        type: DisplayFeatureType.fold,
        state: DisplayFeatureState.postureFlat,
      )
    ]);
    expect(resolved, isNull);
    await _pump(tester, probe, features: [
      _feature(
        const Rect.fromLTRB(390, 0, 410, 1000),
        type: DisplayFeatureType.fold,
        state: DisplayFeatureState.postureFlat,
      )
    ]);
    expect(resolved, const Rect.fromLTRB(390, 0, 410, 1000));
  });
}
