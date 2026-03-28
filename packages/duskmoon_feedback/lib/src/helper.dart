import 'package:flutter/material.dart';

/// Global key for accessing [ScaffoldMessengerState] directly.
final GlobalKey<ScaffoldMessengerState> dmScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Returns the rendered size of the widget identified by [key],
/// or null if the widget is not currently rendered.
Size? getDmWidgetSize(GlobalKey key) {
  final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
  return renderBox?.size;
}
