import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _destinations = [
  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
];
const _bodyKey = Key('draft-body');
const _leadingKey = Key('existing-leading');
const _actionKey = Key('existing-action');

void main() {
  for (final style in DmPlatformStyle.values) {
    for (final width in [390.0, 800.0, 1200.0]) {
      testWidgets(
          '$style toolbar restore preserves controls and geometry at $width',
          (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        bool visible = true;
        late StateSetter change;
        await tester.pumpWidget(DuskmoonApp(
          platformStyle: style,
          child:
              MaterialApp(home: StatefulBuilder(builder: (context, setState) {
            change = setState;
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(padding: const EdgeInsets.only(top: 24)),
              child: DmScaffold(
                destinations: _destinations,
                selectedIndex: 1,
                navigationVisible: visible,
                showNavigationToggle: true,
                onNavigationVisibleChange: (value) =>
                    setState(() => visible = value),
                navigationRestoreInHeader: true,
                showCollapseToggle: true,
                body: (_) => Scaffold(
                  appBar: DmAppBar(
                    restoreNavigation: true,
                    title: const Text('Chat'),
                    leading: IconButton(
                        key: _leadingKey,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {}),
                    actions: [
                      IconButton(
                          key: _actionKey,
                          icon: const Icon(Icons.search),
                          onPressed: () {})
                    ],
                  ),
                  body: const Center(
                      key: _bodyKey,
                      child: SizedBox(width: 200, child: TextField())),
                ),
              ),
            );
          })),
        ));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Unsaved draft');
        final draftState = tester.state(find.byType(EditableText));
        final bodyTop = tester.getRect(find.byKey(_bodyKey)).top;
        final barHeight = tester.getSize(find.byType(DmAppBar)).height;
        final leadingTop = tester.getRect(find.byKey(_leadingKey)).top;
        if (width >= 600) {
          if (find.byTooltip('Collapse navigation').evaluate().isNotEmpty) {
            await tester.tap(find.byTooltip('Collapse navigation'));
          }
          await tester.pumpAndSettle();
          await tester.tap(find.byTooltip('Hide navigation'));
        } else {
          change(() => visible = false);
        }
        await tester.pumpAndSettle();
        final restore = find.byTooltip('Show navigation');
        expect(find.descendant(of: find.byType(DmAppBar), matching: restore),
            findsOneWidget);
        expect(tester.getSize(find.byType(DmAppBar)).height, barHeight);
        expect(tester.getRect(find.byKey(_bodyKey)).top, bodyTop);
        expect(tester.getRect(find.byKey(_leadingKey)).top, leadingTop);
        final restoreRect = tester.getRect(restore);
        final leadingRect = tester.getRect(find.byKey(_leadingKey));
        final titleRect = tester.getRect(find.text('Chat'));
        final actionRect = tester.getRect(find.byKey(_actionKey));
        expect(restoreRect.right, lessThanOrEqualTo(leadingRect.left));
        expect(leadingRect.right, lessThanOrEqualTo(titleRect.left));
        expect(titleRect.right, lessThanOrEqualTo(actionRect.left));
        expect(tester.state(find.byType(EditableText)), same(draftState));
        expect(
            tester
                .widget<EditableText>(find.byType(EditableText))
                .controller
                .text,
            'Unsaved draft');
        expect(find.byType(NavigationRail), findsNothing);
        await tester.tap(restore);
        await tester.pumpAndSettle();
        expect(visible, isTrue);
        expect(tester.state(find.byType(EditableText)), same(draftState));
        if (width >= 600) {
          final rail =
              tester.widget<NavigationRail>(find.byType(NavigationRail));
          expect(rail.extended, isFalse);
          expect(rail.selectedIndex, 1);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('no-header fallback respects safe area without moving body',
      (tester) async {
    bool visible = true;
    await tester.pumpWidget(
        MaterialApp(home: StatefulBuilder(builder: (context, setState) {
      return MediaQuery(
        data: const MediaQueryData(
            size: Size(800, 600), padding: EdgeInsets.only(top: 24, left: 12)),
        child: DmScaffold(
          destinations: _destinations,
          navigationVisible: visible,
          showNavigationToggle: true,
          onNavigationVisibleChange: (value) => setState(() => visible = value),
          body: (_) => const SizedBox.expand(key: _bodyKey),
        ),
      );
    })));
    await tester.pumpAndSettle();
    final top = tester.getRect(find.byKey(_bodyKey)).top;
    final body = tester.element(find.byKey(_bodyKey));
    await tester.tap(find.byTooltip('Hide navigation'));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byTooltip('Show navigation')),
        const Offset(12, 24));
    expect(tester.getRect(find.byKey(_bodyKey)).top, top);
    expect(tester.element(find.byKey(_bodyKey)), same(body));
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Show navigation'), findsOneWidget);
    semantics.dispose();
    await tester.tap(find.byTooltip('Show navigation'));
    await tester.pumpAndSettle();
    expect(visible, isTrue);
    expect(tester.takeException(), isNull);
  });
  testWidgets('RTL fallback respects right inset and remains caller controlled',
      (tester) async {
    final changes = <bool>[];
    final outerChanges = <bool>[];
    await tester.pumpWidget(MaterialApp(
        home: Directionality(
      textDirection: TextDirection.rtl,
      child: MediaQuery(
        data: const MediaQueryData(
            size: Size(800, 600),
            padding: EdgeInsets.only(top: 24, left: 12, right: 20)),
        child: DmNavigationVisibilityScope(
          navigationVisible: true,
          onNavigationVisibleChange: outerChanges.add,
          child: DmScaffold(
            destinations: _destinations,
            navigationVisible: false,
            showNavigationToggle: true,
            onNavigationVisibleChange: changes.add,
            body: (_) => const SizedBox.expand(key: _bodyKey),
          ),
        ),
      ),
    )));
    await tester.pumpAndSettle();
    final restore = find.byTooltip('Show navigation');
    expect(tester.getRect(restore).right, 780);
    expect(tester.getRect(restore).top, 24);
    await tester.tap(restore);
    await tester.pumpAndSettle();
    expect(changes, [true]);
    expect(outerChanges, isEmpty);
    expect(restore, findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
