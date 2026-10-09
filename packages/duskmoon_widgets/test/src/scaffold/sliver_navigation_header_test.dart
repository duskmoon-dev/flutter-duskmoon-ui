import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter_test/flutter_test.dart';

const _destinations = [
  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
];

void main() {
  for (final mode in ['pinned', 'floating', 'expanded']) {
    for (final leadingMode in ['explicit', 'back', 'drawer']) {
      testWidgets('$mode sliver preserves $leadingMode and scrolling state',
          (tester) async {
        tester.view.physicalSize = const Size(1200, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = ScrollController();
        addTearDown(controller.dispose);
        bool visible = true;
        bool explicitPressed = false;
        Widget page() => StatefulBuilder(
            builder: (context, setState) => DmScaffold(
                  destinations: _destinations,
                  navigationVisible: visible,
                  showNavigationToggle: true,
                  navigationRestoreInHeader: true,
                  onNavigationVisibleChange: (value) =>
                      setState(() => visible = value),
                  body: (_) => Scaffold(
                    drawer: leadingMode == 'drawer'
                        ? const Drawer(child: Text('Nested drawer'))
                        : null,
                    body: CustomScrollView(controller: controller, slivers: [
                      DmNavigationHeader(
                        leading: leadingMode == 'explicit'
                            ? IconButton(
                                key: const Key('explicit'),
                                tooltip: 'Existing control',
                                icon: const Icon(Icons.star),
                                onPressed: () => explicitPressed = true)
                            : null,
                        builder: (context, header) => SliverAppBar(
                          pinned: mode != 'floating',
                          floating: mode == 'floating',
                          expandedHeight: mode == 'expanded' ? 180 : null,
                          leading: header.leading,
                          leadingWidth: header.leadingWidth,
                          automaticallyImplyLeading:
                              header.automaticallyImplyLeading,
                          title: const Text('Chat'),
                          actions: [
                            IconButton(
                                tooltip: 'Search',
                                onPressed: () {},
                                icon: const Icon(Icons.search))
                          ],
                        ),
                      ),
                      SliverList.builder(
                          itemCount: 100,
                          itemBuilder: (_, index) =>
                              SizedBox(height: 50, child: Text('Row $index'))),
                    ]),
                  ),
                ));
        await tester.pumpWidget(MaterialApp(
          initialRoute: '/page',
          routes: {
            '/': (_) => const Scaffold(body: Text('Previous page')),
            '/page': (_) => page()
          },
        ));
        await tester.pumpAndSettle();
        if (mode == 'expanded') {
          controller.jumpTo(260);
          await tester.pumpAndSettle();
        }
        final scrollState = tester.state(find.byType(Scrollable).last);
        final offset = controller.offset;
        final titleRect = tester.getRect(find.descendant(
            of: find.byType(SliverAppBar), matching: find.text('Chat')));
        final rowTop = tester
            .getRect(find.text(mode == 'expanded' ? 'Row 6' : 'Row 0'))
            .top;
        await tester.tap(find.byTooltip('Hide navigation'));
        await tester.pumpAndSettle();
        final restore = find.byTooltip('Show navigation');
        expect(
            find.descendant(of: find.byType(SliverAppBar), matching: restore),
            findsOneWidget);
        expect(
            tester
                .getRect(find.descendant(
                    of: find.byType(SliverAppBar), matching: find.text('Chat')))
                .top,
            titleRect.top);
        expect(
            tester
                .getRect(find.text(mode == 'expanded' ? 'Row 6' : 'Row 0'))
                .top,
            rowTop);
        expect(controller.offset, offset);
        expect(tester.state(find.byType(Scrollable).last), same(scrollState));
        final oldLeading = leadingMode == 'explicit'
            ? find.byTooltip('Existing control')
            : leadingMode == 'drawer'
                ? find.byTooltip('Open navigation menu')
                : find.byType(BackButton);
        expect(oldLeading, findsOneWidget);
        expect(tester.getRect(restore).right,
            lessThanOrEqualTo(tester.getRect(oldLeading).left));
        expect(
            tester.getRect(oldLeading).right,
            lessThanOrEqualTo(tester
                .getRect(find.descendant(
                    of: find.byType(SliverAppBar), matching: find.text('Chat')))
                .left));
        await tester.tap(oldLeading);
        await tester.pumpAndSettle();
        if (leadingMode == 'back') {
          expect(find.text('Previous page'), findsOneWidget);
        } else {
          if (leadingMode == 'drawer') {
            expect(find.text('Nested drawer'), findsOneWidget);
            Navigator.of(tester.element(find.text('Nested drawer'))).pop();
            await tester.pumpAndSettle();
          } else {
            expect(explicitPressed, isTrue);
          }
          await tester.tap(restore);
          await tester.pumpAndSettle();
          expect(visible, isTrue);
          expect(controller.offset, offset);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final style in DmPlatformStyle.values) {
    for (final drawer in [false, true]) {
      testWidgets(
          '$style app bar keeps automatic ${drawer ? 'drawer' : 'back'} with restore',
          (tester) async {
        await tester.pumpWidget(DuskmoonApp(
            platformStyle: style,
            child: MaterialApp(
              initialRoute: '/page',
              routes: {
                '/': (_) => const Scaffold(body: Text('Previous page')),
                '/page': (_) => DmNavigationVisibilityScope(
                      navigationVisible: false,
                      onNavigationVisibleChange: (_) {},
                      child: Scaffold(
                        drawer: drawer
                            ? const Drawer(child: Text('Nested drawer'))
                            : null,
                        appBar: const DmAppBar(
                            restoreNavigation: true, title: Text('Chat')),
                        body: const Text('Page'),
                      ),
                    ),
              },
            )));
        await tester.pumpAndSettle();
        expect(find.byTooltip('Show navigation'), findsOneWidget);
        if (drawer) {
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle();
          expect(find.text('Nested drawer'), findsOneWidget);
        } else {
          final existing = find.descendant(
              of: find.byType(DmAppBar), matching: find.byType(IconButton));
          // Restore uses one IconButton; the second is the resolved back control.
          if (style == DmPlatformStyle.cupertino) {
            await tester.tap(find.byType(CupertinoButton));
          } else {
            await tester.tap(existing.last);
          }
          await tester.pumpAndSettle();
          expect(find.text('Previous page'), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
}
