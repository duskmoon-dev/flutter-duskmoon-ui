import 'package:flutter/material.dart';

import '../config/render_options.dart';
import '../error/mermaid_error.dart';
import '../render/mermaid_render_object.dart';

class DmMermaidView extends LeafRenderObjectWidget {
  const DmMermaidView({
    super.key,
    required this.source,
    this.options = const MermaidRenderOptions(),
    this.onError,
  });

  final String source;
  final MermaidRenderOptions options;
  final ValueChanged<MermaidError>? onError;

  @override
  RenderDmMermaid createRenderObject(BuildContext context) {
    return RenderDmMermaid(
      source: source,
      options: options,
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      textScaler: MediaQuery.maybeTextScalerOf(context) ?? TextScaler.noScaling,
      onError: onError,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderDmMermaid renderObject,
  ) {
    renderObject
      ..source = source
      ..options = options
      ..textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr
      ..textScaler =
          MediaQuery.maybeTextScalerOf(context) ?? TextScaler.noScaling
      ..onError = onError;
  }
}
