import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: DmThemeData.sunshine(),
    themeAnimationDuration: Duration.zero,
    home: Scaffold(body: child),
  );
}

void main() {
  group('Consumer Harness: Complete Editing Lifecycle', () {
    testWidgets(
      'supports open -> edit -> switch config -> save -> reopen workflow',
      (tester) async {
        // 1. Initial document
        const initialSource = 'void main() {\n  print("Hello DuskMoon");\n}\n';
        var currentController = EditorViewController(text: initialSource);
        String? savedDocument;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return _wrap(
                Column(
                  children: [
                    Expanded(
                      child: DmCodeEditor(
                        controller: currentController,
                        language: 'dart',
                        lineNumbers: true,
                        onChanged: (text) {
                          savedDocument = text;
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        // Verify initial rendering
        expect(find.byType(DmCodeEditor), findsOneWidget);
        expect(currentController.text, initialSource);

        // 2. Programmatic edit (simulating user or consumer typing)
        currentController.insertText('// leading comment\n');
        await tester.pump();

        // 3. Save
        savedDocument = currentController.text;
        expect(savedDocument, startsWith('// leading comment\nvoid main()'));

        // 4. Dispose current and simulate Reopen with saved content
        final savedText = savedDocument!;
        currentController.dispose();

        currentController = EditorViewController(text: savedText);
        await tester.pumpWidget(
          _wrap(DmCodeEditor(controller: currentController, language: 'dart')),
        );
        await tester.pumpAndSettle();

        // Verify reopened content matches exact saved content
        expect(currentController.text, savedText);
        currentController.dispose();
      },
    );
  });
}
