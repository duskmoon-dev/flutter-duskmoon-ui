// Placeholder — implementation in Phase 4
import 'package:flutter/material.dart';

class DmDialogAction extends StatelessWidget {
  const DmDialogAction({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

Future<T?> showDmDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showDialog<T>(context: context, builder: builder);
}
