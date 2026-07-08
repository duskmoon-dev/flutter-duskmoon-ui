import 'dart:ui';

import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_mermaid_renderer/src/render/edge_painter.dart';
import 'package:duskmoon_mermaid_renderer/src/scene/scene_edge.dart';

void main() {
  test('EdgePainter paints edge styles without throwing', () {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const painter = EdgePainter();

    for (final style in EdgeStyle.values) {
      painter.paint(
        canvas,
        SceneEdge(
          points: const [Offset(0, 0), Offset(40, 0), Offset(40, 40)],
          style: style,
          color: Colors.black,
          arrowStart: true,
          arrowEnd: true,
        ),
      );
    }

    recorder.endRecording().dispose();
  });
}
