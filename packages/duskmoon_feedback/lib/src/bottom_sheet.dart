// Placeholder — implementation in Phase 4
import 'package:flutter/material.dart';

Future<T?> showDmBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(context: context, builder: builder);
}
