// Placeholder — implementation in Phase 4
import 'package:flutter/material.dart';

Future<T?> showDmFullscreenDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showDialog<T>(
    context: context,
    builder: builder,
    useSafeArea: false,
  );
}
