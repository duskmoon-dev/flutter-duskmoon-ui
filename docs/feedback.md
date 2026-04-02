# Feedback Helpers

The `duskmoon_feedback` package provides adaptive dialogs, snackbars, toasts, bottom sheets, and fullscreen dialogs.

## Table of Contents

- [Installation](#installation)
- [Dialogs](#dialogs)
- [Snackbars](#snackbars)
- [Toasts](#toasts)
- [Bottom Sheets](#bottom-sheets)
- [Fullscreen Dialog](#fullscreen-dialog)
- [Helpers](#helpers)

## Installation

```yaml
dependencies:
  duskmoon_feedback: ^1.0.1
```

```dart
import 'package:duskmoon_feedback/duskmoon_feedback.dart';
```

Or use the umbrella `duskmoon_ui` package.

## Dialogs

### showDmDialog

Shows an adaptive dialog using `AlertDialog.adaptive`. Returns a `Future<T?>` for the dialog result.

| Parameter | Type | Description |
|-----------|------|-------------|
| `context` | `BuildContext` | Current build context |
| `title` | `Widget` | Dialog title |
| `content` | `Widget` | Dialog body |
| `actions` | `List<Widget>?` | Action buttons |

```dart
final confirmed = await showDmDialog<bool>(
  context: context,
  title: const Text('Delete Item'),
  content: const Text('This action cannot be undone.'),
  actions: [
    DmDialogAction(
      onPressed: (ctx) => Navigator.of(ctx).pop(false),
      child: const Text('Cancel'),
    ),
    DmDialogAction(
      onPressed: (ctx) => Navigator.of(ctx).pop(true),
      child: const Text('Delete'),
    ),
  ],
);
```

### DmDialogAction

Adaptive action button that renders as `TextButton` on Material platforms and `CupertinoDialogAction` on Apple platforms.

| Parameter | Type | Description |
|-----------|------|-------------|
| `onPressed` | `Function(BuildContext)?` | Callback with context for navigation |
| `child` | `Widget` | Button label |

The `onPressed` callback receives the dialog's `BuildContext`, making it easy to call `Navigator.of(ctx).pop()`.

## Snackbars

### showDmSnackbar

Basic snackbar with optional action button.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `context` | `BuildContext` | required | Current context |
| `message` | `Widget` | required | Snackbar content |
| `duration` | `Duration` | 5 seconds | Display duration |
| `showCloseIcon` | `bool` | `false` | Show close button |
| `actionLabel` | `String?` | `null` | Action button text |
| `onActionPressed` | `VoidCallback?` | `null` | Action callback |

```dart
showDmSnackbar(
  context: context,
  message: const Text('Item saved successfully'),
  actionLabel: 'VIEW',
  onActionPressed: () => navigateToItem(),
);
```

### showDmUndoSnackbar

Snackbar with a built-in undo action.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `context` | `BuildContext` | required | Current context |
| `message` | `Widget` | required | Snackbar content |
| `onUndoPressed` | `VoidCallback` | required | Undo callback |
| `undoLabel` | `String` | `'Undo'` | Undo button text (localizable) |
| `duration` | `Duration` | 5 seconds | Display duration |
| `showCloseIcon` | `bool` | `true` | Show close button |

```dart
showDmUndoSnackbar(
  context: context,
  message: const Text('Item deleted'),
  onUndoPressed: () => restoreItem(),
);
```

> **Type difference:** Snackbar `message` accepts a `Widget` (e.g. `const Text('...')`). Toast `message` accepts a plain `String`.

## Toasts

### showDmSuccessToast

Themed toast with checkmark icon, title, and message. Uses the theme's primary color.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `context` | `BuildContext` | required | Current context |
| `message` | `String` | required | Toast message |
| `title` | `String` | `'Success'` | Toast title (localizable) |
| `duration` | `Duration` | 5 seconds | Display duration |
| `showCloseIcon` | `bool` | `false` | Show close button |
| `actionLabel` | `String?` | `null` | Action button text |
| `onActionPressed` | `VoidCallback?` | `null` | Action callback |

```dart
showDmSuccessToast(
  context: context,
  message: 'Profile updated successfully',
);
```

### showDmErrorToast

Persistent error toast with error icon and selectable message text. Uses the theme's error color.

**Important:** This toast always persists until manually dismissed. The close icon is always shown and the duration is hardcoded to infinite. These are not configurable.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `context` | `BuildContext` | required | Current context |
| `message` | `String` | required | Error message (selectable text) |
| `title` | `String` | `'Error'` | Toast title (localizable) |
| `actionLabel` | `String?` | `null` | Action button text |
| `onActionPressed` | `VoidCallback?` | `null` | Action callback |

```dart
showDmErrorToast(
  context: context,
  message: 'Connection timeout. Please try again.',
  actionLabel: 'RETRY',
  onActionPressed: () => retry(),
);
```

## Bottom Sheets

### showDmBottomSheetActionList

Shows a bottom sheet with a vertical list of action buttons.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `context` | `BuildContext` | required | Current context |
| `actions` | `List<DmBottomSheetAction>` | required | Action items |
| `showBackdrop` | `bool` | `true` | Show overlay; tap outside to dismiss |

### DmBottomSheetAction

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `Widget` | Button label |
| `onTap` | `VoidCallback` | Tap callback |
| `style` | `ButtonStyle?` | Optional button style override |

```dart
showDmBottomSheetActionList(
  context: context,
  actions: [
    DmBottomSheetAction(
      title: const Text('Take Photo'),
      onTap: () => takePhoto(),
    ),
    DmBottomSheetAction(
      title: const Text('Choose from Gallery'),
      onTap: () => pickFromGallery(),
    ),
  ],
);
```

## Fullscreen Dialog

### showDmFullscreenDialog

Pushes a fullscreen dialog page with an AppBar containing a close button.

| Parameter | Type | Description |
|-----------|------|-------------|
| `context` | `BuildContext` | Current context |
| `title` | `Widget` | AppBar title |
| `builder` | `WidgetBuilder` | Body content builder |

```dart
showDmFullscreenDialog(
  context: context,
  title: const Text('Edit Profile'),
  builder: (context) => const ProfileEditForm(),
);
```

## Helpers

### dmScaffoldMessengerKey

A global `GlobalKey<ScaffoldMessengerState>` for showing snackbars without a `BuildContext`:

```dart
// Register in MaterialApp:
MaterialApp(
  scaffoldMessengerKey: dmScaffoldMessengerKey,
  // ...
);

// Show snackbar from anywhere:
dmScaffoldMessengerKey.currentState?.showSnackBar(
  SnackBar(content: Text('Hello')),
);
```

### getDmWidgetSize

Returns the rendered size of a widget identified by a `GlobalKey`, or `null` if not rendered:

```dart
final key = GlobalKey();
// ... assign key to a widget ...
final size = getDmWidgetSize(key); // Size?
```
