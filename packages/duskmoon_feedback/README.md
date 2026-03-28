# duskmoon_feedback

Adaptive feedback widgets for the DuskMoon Design System — dialogs, snackbars, toasts, bottom sheets, and fullscreen dialogs.

## Installation

```bash
flutter pub add duskmoon_feedback
```

## Usage

```dart
import 'package:duskmoon_feedback/duskmoon_feedback.dart';

// Dialog
showDmDialog(
  context: context,
  title: const Text('Confirm'),
  content: const Text('Are you sure?'),
  actions: [
    DmDialogAction(onPressed: (_) => Navigator.pop(context), child: const Text('Cancel')),
    DmDialogAction(onPressed: (_) {}, child: const Text('OK')),
  ],
);

// Toast
showDmSuccessToast(context: context, title: 'Saved', message: 'Changes saved');
showDmErrorToast(context: context, title: 'Error', message: 'Something went wrong');

// Snackbar with undo
showDmUndoSnackbar(
  context: context,
  message: const Text('Item deleted'),
  onUndoPressed: () { /* restore item */ },
);

// Bottom sheet
showDmBottomSheetActionList(
  context: context,
  actions: [
    DmBottomSheetAction(title: const Text('Share'), onTap: () {}),
    DmBottomSheetAction(title: const Text('Delete'), onTap: () {}),
  ],
);

// Fullscreen dialog
showDmFullscreenDialog(
  context: context,
  title: const Text('Edit'),
  builder: (context) => const MyForm(),
);
```

## License

MIT
