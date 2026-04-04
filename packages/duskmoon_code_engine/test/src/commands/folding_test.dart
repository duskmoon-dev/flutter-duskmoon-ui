import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FoldDetector.detectRegions', () {
    test('detects a single fold from an indent increase', () {
      final doc = Document.fromString('def foo():\n  x = 1\n  y = 2');
      final regions = FoldDetector.detectRegions(doc);
      expect(regions, hasLength(1));
      expect(regions.first.startLine, 1);
      expect(regions.first.endLine, 3);
    });

    test('detects multiple fold regions', () {
      final code = [
        'def foo():', //  1 → indent 0, next 2
        '  x = 1', //  2 → indent 2
        'def bar():', //  3 → indent 0, next 4
        '  y = 2', //  4 → indent 2
      ].join('\n');
      final doc = Document.fromString(code);
      final regions = FoldDetector.detectRegions(doc);
      expect(regions, hasLength(2));
      expect(regions[0], const FoldRegion(1, 2));
      expect(regions[1], const FoldRegion(3, 4));
    });

    test('detects nested fold regions', () {
      final code = [
        'class A:', //  1 → indent 0
        '  def foo():', //  2 → indent 2
        '    x = 1', //  3 → indent 4
        '    y = 2', //  4 → indent 4
      ].join('\n');
      final doc = Document.fromString(code);
      final regions = FoldDetector.detectRegions(doc);
      // Line 1 folds over lines 2–4; line 2 folds over lines 3–4.
      expect(regions, contains(const FoldRegion(1, 4)));
      expect(regions, contains(const FoldRegion(2, 4)));
    });

    test('returns no fold regions for a flat document', () {
      final doc = Document.fromString('a\nb\nc');
      expect(FoldDetector.detectRegions(doc), isEmpty);
    });

    test('returns empty for empty document', () {
      expect(FoldDetector.detectRegions(Document.empty), isEmpty);
    });

    test('returns empty for single-line document', () {
      final doc = Document.fromString('hello');
      expect(FoldDetector.detectRegions(doc), isEmpty);
    });
  });

  group('FoldDetector.regionAtLine', () {
    test('returns region for a foldable line', () {
      final doc = Document.fromString('def foo():\n  x = 1');
      final region = FoldDetector.regionAtLine(doc, 1);
      expect(region, isNotNull);
      expect(region!.startLine, 1);
      expect(region.endLine, 2);
    });

    test('returns null for a non-foldable line', () {
      final doc = Document.fromString('def foo():\n  x = 1');
      expect(FoldDetector.regionAtLine(doc, 2), isNull);
    });

    test('returns null for flat document', () {
      final doc = Document.fromString('a\nb\nc');
      expect(FoldDetector.regionAtLine(doc, 1), isNull);
    });
  });
}
