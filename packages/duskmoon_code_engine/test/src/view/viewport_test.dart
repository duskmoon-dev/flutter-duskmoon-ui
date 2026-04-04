import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditorViewport', () {
    const lineHeight = 20.0;
    const viewportHeight = 200.0;
    const totalLines = 100;

    EditorViewport make({
      double scrollOffset = 0,
      int overscan = 5,
      int lines = totalLines,
    }) =>
        EditorViewport(
          scrollOffset: scrollOffset,
          viewportHeight: viewportHeight,
          lineHeight: lineHeight,
          totalLines: lines,
          overscan: overscan,
        );

    group('visible range at scroll=0', () {
      test('firstVisibleLine is 0', () {
        final vp = make();
        expect(vp.firstVisibleLine, 0);
      });

      test('lastVisibleLine accounts for viewport and overscan', () {
        final vp = make();
        // ceil((0+200)/20) + 5 = 10 + 5 = 15, clamped to 100
        expect(vp.lastVisibleLine, 15);
      });

      test('visibleLineCount equals lastVisibleLine - firstVisibleLine', () {
        final vp = make();
        expect(vp.visibleLineCount, vp.lastVisibleLine - vp.firstVisibleLine);
      });
    });

    group('visible range when scrolled down', () {
      test('firstVisibleLine excludes overscan below 0', () {
        // scroll=200: floor(200/20)=10 - 5 = 5
        final vp = make(scrollOffset: 200);
        expect(vp.firstVisibleLine, 5);
      });

      test('lastVisibleLine scrolled into middle', () {
        // scroll=200: ceil((200+200)/20) + 5 = 20 + 5 = 25
        final vp = make(scrollOffset: 200);
        expect(vp.lastVisibleLine, 25);
      });

      test('scrolled near end clamps lastVisibleLine to totalLines', () {
        // scroll=1800: ceil((1800+200)/20)+5=100+5=105 -> clamped to 100
        final vp = make(scrollOffset: 1800);
        expect(vp.lastVisibleLine, 100);
      });

      test('firstVisibleLine never goes below 0 when near top', () {
        // scroll=20: floor(20/20)-5 = 1-5 = -4 -> clamped to 0
        final vp = make(scrollOffset: 20);
        expect(vp.firstVisibleLine, 0);
      });
    });

    group('maxScrollExtent', () {
      test('equals totalLines * lineHeight', () {
        final vp = make();
        expect(vp.maxScrollExtent, totalLines * lineHeight);
      });

      test('scales with different line count', () {
        final vp = make(lines: 50);
        expect(vp.maxScrollExtent, 50 * lineHeight);
      });
    });

    group('visibleLineCount', () {
      test('is consistent with first/last', () {
        final vp = make(scrollOffset: 300);
        expect(
          vp.visibleLineCount,
          vp.lastVisibleLine - vp.firstVisibleLine,
        );
      });

      test('is at least 0', () {
        final vp = make();
        expect(vp.visibleLineCount, greaterThanOrEqualTo(0));
      });
    });

    group('lineAtY coordinate mapping', () {
      test('y=0 at scroll=0 returns line 0', () {
        final vp = make();
        expect(vp.lineAtY(0), 0);
      });

      test('y=20 at scroll=0 returns line 1', () {
        final vp = make();
        expect(vp.lineAtY(20), 1);
      });

      test('accounts for scrollOffset', () {
        // scrollOffset=100, y=0 -> (100+0)/20 = 5
        final vp = make(scrollOffset: 100);
        expect(vp.lineAtY(0), 5);
      });

      test('y=10 (mid-line) returns current line', () {
        final vp = make();
        expect(vp.lineAtY(10), 0);
      });
    });

    group('yForLine coordinate mapping', () {
      test('line 0 at scroll=0 returns 0', () {
        final vp = make();
        expect(vp.yForLine(0), 0.0);
      });

      test('line 1 at scroll=0 returns lineHeight', () {
        final vp = make();
        expect(vp.yForLine(1), lineHeight);
      });

      test('subtracts scrollOffset', () {
        // line=10, scrollOffset=100 -> 10*20 - 100 = 100
        final vp = make(scrollOffset: 100);
        expect(vp.yForLine(10), 100.0);
      });

      test('negative y for lines above viewport', () {
        // line=0, scrollOffset=200 -> 0 - 200 = -200
        final vp = make(scrollOffset: 200);
        expect(vp.yForLine(0), -200.0);
      });
    });

    group('small document clamping', () {
      test('lastVisibleLine clamped to totalLines', () {
        final vp = make(lines: 3);
        expect(vp.lastVisibleLine, 3);
      });

      test('visibleLineCount equals totalLines for small document', () {
        final vp = make(lines: 3);
        expect(vp.visibleLineCount, 3);
      });
    });

    group('custom overscan', () {
      test('overscan=0 firstVisibleLine exact', () {
        // scroll=200: floor(200/20) - 0 = 10
        final vp = make(scrollOffset: 200, overscan: 0);
        expect(vp.firstVisibleLine, 10);
      });

      test('overscan=10 adds extra buffer', () {
        // scroll=200: floor(200/20) - 10 = 0 (clamped)
        final vp = make(scrollOffset: 200, overscan: 10);
        expect(vp.firstVisibleLine, 0);
      });

      test('overscan=0 lastVisibleLine exact', () {
        // scroll=0: ceil((0+200)/20) + 0 = 10
        final vp = make(overscan: 0);
        expect(vp.lastVisibleLine, 10);
      });
    });
  });
}
