import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('CodeEngine Baseline Benchmark', () {
    test('measures baseline document operations across scales', () {
      final scales = [100, 1000, 10000];

      for (final lineCount in scales) {
        final text = List.generate(
          lineCount,
          (i) => 'const int line$i = $i; // standard code comment block here',
        ).join('\n');

        // 1. Measure Document creation
        final swDoc = Stopwatch()..start();
        final doc = Document.fromString(text);
        swDoc.stop();

        // 2. Measure single character insertion via doc.replace (which calls ChangeSet.apply)
        final midOffset = doc.length ~/ 2;
        final change = ChangeSet.of(doc.length, [
          ChangeSpec.insert(midOffset, 'x'),
        ]);

        final swApply = Stopwatch()..start();
        final newDoc = doc.replace(change);
        swApply.stop();

        // 3. Measure line lookup at midpoint
        final swLine = Stopwatch()..start();
        final line = doc.lineAtOffset(midOffset);
        swLine.stop();

        // ignore: avoid_print
        print(
          'BASELINE [${lineCount.toString().padLeft(5)} lines] '
          'len=${doc.length} '
          'docCreate=${swDoc.elapsedMicroseconds}us '
          'changeApply=${swApply.elapsedMicroseconds}us '
          'lineLookup=${swLine.elapsedMicroseconds}us (line ${line.number})',
        );

        expect(newDoc.length, doc.length + 1);
      }
    });
  });
}
