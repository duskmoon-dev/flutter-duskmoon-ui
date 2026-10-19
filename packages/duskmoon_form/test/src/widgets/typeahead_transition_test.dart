import 'dart:async';

import 'package:duskmoon_form/src/widgets/flutter_typeahead.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _loadingKey = Key('loading');
const _duration = Duration(milliseconds: 400);

Future<void> _pumpField(
  WidgetTester tester, {
  required TextEditingController controller,
  required FocusNode focusNode,
  required SuggestionsCallback<String> suggestions,
  TextDirection textDirection = TextDirection.ltr,
  AnimationTransitionBuilder? transitionBuilder,
  SuggestionSelectionCallback<String>? onSelected,
  bool hideOnLoading = false,
}) async {
  await tester.pumpWidget(MaterialApp(
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 320,
            child: TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration<String>(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                dragStartBehavior: DragStartBehavior.start,
                enableInteractiveSelection: true,
                enableSuggestions: true,
                expands: false,
                readOnly: false,
              ),
              suggestionsCallback: suggestions,
              itemBuilder: (context, suggestion) => SizedBox(
                height: 48,
                child: Center(child: Text(suggestion)),
              ),
              onSuggestionSelected: onSelected ?? (_) {},
              onSuggestionRemoved: (_) {},
              removeSuggestionOnLongPress: false,
              suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                borderRadius: BorderRadius.zero,
              ),
              getImmediateSuggestions: true,
              keepSuggestionsOnLoading: false,
              hideOnLoading: hideOnLoading,
              debounceDuration: Duration.zero,
              animationDuration: _duration,
              animationStart: 1,
              loadingBuilder: (context) => const SizedBox(
                key: _loadingKey,
                width: 80,
                height: 100,
              ),
              transitionBuilder: transitionBuilder,
            ),
          ),
        ),
      ),
    ),
  ));
  await tester.pump();
}

Finder _suggestionsSurface() => find
    .ancestor(of: find.byKey(_loadingKey), matching: find.byType(Material))
    .first;

void main() {
  for (final direction in TextDirection.values) {
    testWidgets('default transition stays top-centered in ${direction.name}',
        (tester) async {
      final controller = TextEditingController(text: 'a');
      final focusNode = FocusNode();
      final suggestions = Completer<List<String>>();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await _pumpField(tester,
          controller: controller,
          focusNode: focusNode,
          suggestions: (_) => suggestions.future,
          textDirection: direction);
      await tester.pump(const Duration(milliseconds: 100));

      final field = tester.getRect(find.byType(TextField));
      final loading = tester.getRect(find.byKey(_loadingKey));
      final opening = tester.getRect(_suggestionsSurface());
      expect(loading.width, 80);
      expect(loading.center.dx, closeTo(field.center.dx, 0.01));
      expect(loading.top, closeTo(opening.top, 0.01));
      expect(opening.height, greaterThan(0));
      expect(opening.height, lessThan(loading.height));

      await tester.pump(_duration);
      final opened = tester.getRect(_suggestionsSurface());
      expect(opened.height, closeTo(loading.height, 0.01));
      expect(opened.top, closeTo(opening.top, 0.01));

      focusNode.unfocus();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final closing = tester.getRect(_suggestionsSurface());
      expect(closing.height, greaterThan(0));
      expect(closing.height, lessThan(opened.height));
      expect(closing.top, closeTo(opened.top, 0.01));
      await tester.pumpAndSettle();
      expect(find.byKey(_loadingKey), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('custom transition receives the live controller and content',
      (tester) async {
    final controller = TextEditingController(text: 'a');
    final focusNode = FocusNode();
    final suggestions = Completer<List<String>>();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    final animations = <AnimationController>{};
    const transitionKey = Key('custom-transition');

    await _pumpField(tester,
        controller: controller,
        focusNode: focusNode,
        suggestions: (_) => suggestions.future,
        transitionBuilder: (context, child, animation) {
          animations.add(animation!);
          return FadeTransition(
              key: transitionKey, opacity: animation, child: child);
        });
    await tester.pump(const Duration(milliseconds: 100));
    final transition = tester.widget<FadeTransition>(find.byKey(transitionKey));
    expect(animations, hasLength(1));
    expect(transition.opacity, same(animations.single));
    expect(transition.opacity.value, closeTo(0.25, 0.01));
    expect(find.byKey(_loadingKey), findsOneWidget);

    await tester.pump(_duration);
    expect(transition.opacity.value, 1);
    focusNode.unfocus();
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(transition.opacity.value, closeTo(0.75, 0.01));
    await tester.pumpAndSettle();
    expect(find.byKey(transitionKey), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('selecting a suggestion calls the callback and closes the box',
      (tester) async {
    final controller = TextEditingController(text: 'a');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    final selected = <String>[];
    final patterns = <String>[];

    await _pumpField(tester, controller: controller, focusNode: focusNode,
        suggestions: (pattern) {
      patterns.add(pattern);
      return ['Alpha', 'Beta'];
    }, onSelected: selected.add, hideOnLoading: true);
    await tester.pumpAndSettle();
    expect(patterns, ['a']);
    expect(find.text('Alpha'), findsOneWidget);
    await tester.tap(find.text('Beta'));
    expect(selected, ['Beta']);
    await tester.pumpAndSettle();
    expect(find.text('Beta'), findsNothing);
    expect(focusNode.hasFocus, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
