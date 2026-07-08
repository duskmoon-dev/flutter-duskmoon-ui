import 'dart:ui';

import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_mermaid_renderer/src/render/shape_painter.dart';
import 'package:duskmoon_mermaid_renderer/src/scene/scene_label.dart';
import 'package:duskmoon_mermaid_renderer/src/scene/scene_node.dart';

void main() {
  test('ShapePainter paints common shapes without throwing', () {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const painter = ShapePainter();

    for (final shape in NodeShape.values) {
      painter.paint(
        canvas,
        SceneNode(
          id: shape.name,
          shape: shape,
          bounds: const Rect.fromLTWH(0, 0, 80, 48),
          fillColor: Colors.white,
          strokeColor: Colors.black,
          label: const SceneLabel(
            text: 'Label',
            bounds: Rect.fromLTWH(0, 0, 80, 48),
            textColor: Colors.black,
          ),
        ),
      );
    }

    recorder.endRecording().dispose();
  });
}
