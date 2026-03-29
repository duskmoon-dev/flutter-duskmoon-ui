import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDialogSection(context),
        const SizedBox(height: 16),
        _buildSnackbarSection(context),
        const SizedBox(height: 16),
        _buildToastSection(context),
        const SizedBox(height: 16),
        _buildBottomSheetSection(context),
        const SizedBox(height: 16),
        _buildFullscreenDialogSection(context),
      ],
    );
  }

  Widget _buildDialogSection(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dialogs', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DmButton(
                  onPressed: () => _showBasicDialog(context),
                  child: const Text('Basic Dialog'),
                ),
                DmButton(
                  variant: DmButtonVariant.outlined,
                  onPressed: () => _showConfirmDialog(context),
                  child: const Text('Confirm Dialog'),
                ),
                DmButton(
                  variant: DmButtonVariant.tonal,
                  onPressed: () => _showInfoDialog(context),
                  child: const Text('Info Dialog'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnackbarSection(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Snackbars', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DmButton(
                  onPressed: () => showDmSnackbar(
                    context: context,
                    message: const Text('This is a basic snackbar'),
                  ),
                  child: const Text('Basic Snackbar'),
                ),
                DmButton(
                  variant: DmButtonVariant.outlined,
                  onPressed: () => showDmSnackbar(
                    context: context,
                    message: const Text('Snackbar with action'),
                    actionLabel: 'Retry',
                    onActionPressed: () {},
                    showCloseIcon: true,
                  ),
                  child: const Text('With Action'),
                ),
                DmButton(
                  variant: DmButtonVariant.tonal,
                  onPressed: () => showDmUndoSnackbar(
                    context: context,
                    message: const Text('Item deleted'),
                    onUndoPressed: () {},
                    undoLabel: 'Undo',
                  ),
                  child: const Text('Undo Snackbar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToastSection(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Toasts', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DmButton(
                  onPressed: () => showDmSuccessToast(
                    context: context,
                    message: 'Operation completed successfully!',
                  ),
                  child: const Text('Success Toast'),
                ),
                DmButton(
                  variant: DmButtonVariant.outlined,
                  onPressed: () => showDmSuccessToast(
                    context: context,
                    title: 'Saved',
                    message: 'Your changes have been saved.',
                    actionLabel: 'View',
                    onActionPressed: () {},
                  ),
                  child: const Text('Success + Action'),
                ),
                DmButton(
                  variant: DmButtonVariant.tonal,
                  onPressed: () => showDmErrorToast(
                    context: context,
                    message:
                        'Something went wrong. Please try again later.\nError code: 500',
                    actionLabel: 'Report',
                    onActionPressed: () {},
                  ),
                  child: const Text('Error Toast'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetSection(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bottom Sheet',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DmButton(
              onPressed: () => showDmBottomSheetActionList(
                context: context,
                actions: [
                  DmBottomSheetAction(
                    title: const Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 12),
                        Text('Share'),
                      ],
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  DmBottomSheetAction(
                    title: const Row(
                      children: [
                        Icon(Icons.link),
                        SizedBox(width: 12),
                        Text('Copy Link'),
                      ],
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  DmBottomSheetAction(
                    title: const Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 12),
                        Text('Edit'),
                      ],
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  DmBottomSheetAction(
                    title: Row(
                      children: [
                        Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error),
                        const SizedBox(width: 12),
                        Text('Delete',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      ],
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              child: const Text('Action List'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullscreenDialogSection(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fullscreen Dialog',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DmButton(
              onPressed: () => showDmFullscreenDialog(
                context: context,
                title: const Text('Fullscreen Dialog'),
                builder: (ctx) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fullscreen,
                          size: 64,
                          color: Theme.of(ctx).colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'This is a fullscreen dialog',
                        style: Theme.of(ctx).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Close it using the X button in the app bar',
                        style: Theme.of(ctx).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              child: const Text('Open Fullscreen'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBasicDialog(BuildContext context) {
    showDmDialog(
      context: context,
      title: const Text('Basic Dialog'),
      content: const Text('This is a basic dialog with a single action.'),
      actions: [
        DmDialogAction(
          onPressed: (ctx) => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDmDialog(
      context: context,
      title: const Text('Confirm Action'),
      content: const Text('Are you sure you want to proceed?'),
      actions: [
        DmDialogAction(
          onPressed: (ctx) => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        DmDialogAction(
          onPressed: (ctx) {
            Navigator.of(ctx).pop();
            showDmSuccessToast(
              context: context,
              message: 'Action confirmed!',
            );
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDmDialog(
      context: context,
      title: const Text('Information'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DmDialogAction adapts to the platform:'),
          SizedBox(height: 8),
          Text('  - Material: TextButton'),
          Text('  - iOS/macOS: CupertinoDialogAction'),
          SizedBox(height: 8),
          Text('The dialog itself uses AlertDialog.adaptive.'),
        ],
      ),
      actions: [
        DmDialogAction(
          onPressed: (ctx) => Navigator.of(ctx).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}
