import 'package:flutter/material.dart';

/// A [ScrollController] with heading-anchor navigation support.
///
/// Use this controller with [DmMarkdown] to enable programmatic scrolling
/// to heading anchors:
///
/// ```dart
/// final controller = DmMarkdownScrollController();
/// // ...
/// controller.scrollToAnchor('getting-started');
/// ```
class DmMarkdownScrollController extends ScrollController {
  final Map<String, GlobalKey> _anchorKeys = {};

  /// Registers a heading anchor [id] with its [key].
  ///
  /// Called internally by the markdown renderer as headings are built.
  void registerAnchor(String id, GlobalKey key) {
    _anchorKeys[id] = key;
  }

  /// Clears all registered anchors. Called before re-rendering.
  void clearAnchors() {
    _anchorKeys.clear();
  }

  /// Returns all available anchor IDs (heading slugs) in registration order.
  List<String> get anchors => List.unmodifiable(_anchorKeys.keys);

  /// Scrolls to the heading identified by [anchorId].
  ///
  /// Returns `true` if the anchor was found and scrolled to, `false` if the
  /// anchor ID was not found.
  Future<bool> scrollToAnchor(
    String anchorId, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    final key = _anchorKeys[anchorId];
    if (key == null) return false;

    final context = key.currentContext;
    if (context == null) return false;

    final renderObject = context.findRenderObject();
    if (renderObject == null) return false;

    // Find the RenderAbstractViewport ancestor to compute the reveal offset.
    await Scrollable.ensureVisible(
      context,
      duration: duration,
      curve: curve,
      alignment: 0.0,
    );
    return true;
  }
}
