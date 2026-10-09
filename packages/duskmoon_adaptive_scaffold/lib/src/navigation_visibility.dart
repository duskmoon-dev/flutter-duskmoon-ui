import 'package:flutter/material.dart';

/// Shares caller-controlled navigation visibility with nested page headers.
///
/// [DmAdaptiveScaffold] installs this scope. It may also be used independently.
class DmNavigationVisibilityScope extends InheritedWidget {
  const DmNavigationVisibilityScope({
    super.key,
    required this.navigationVisible,
    required this.onNavigationVisibleChange,
    required super.child,
  });

  final bool navigationVisible;
  final ValueChanged<bool>? onNavigationVisibleChange;

  static DmNavigationVisibilityScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DmNavigationVisibilityScope>();

  @override
  bool updateShouldNotify(DmNavigationVisibilityScope oldWidget) =>
      navigationVisible != oldWidget.navigationVisible ||
      onNavigationVisibleChange != oldWidget.onNavigationVisibleChange;
}

/// Requests hide/restore from the nearest [DmNavigationVisibilityScope].
///
/// The caller must update its controlled visibility value in the callback.
class DmNavigationVisibilityButton extends StatelessWidget {
  const DmNavigationVisibilityButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = DmNavigationVisibilityScope.maybeOf(context);
    if (scope?.onNavigationVisibleChange == null) {
      return const SizedBox.shrink();
    }
    final label =
        scope!.navigationVisible ? 'Hide navigation' : 'Show navigation';
    return SizedBox(
      width: 48,
      height: 48,
      child: Semantics(
        label: label,
        button: true,
        child: Tooltip(
          message: label,
          excludeFromSemantics: true,
          child: IconButton(
            icon: const Icon(Icons.view_sidebar_outlined),
            onPressed: () =>
                scope.onNavigationVisibleChange!(!scope.navigationVisible),
          ),
        ),
      ),
    );
  }
}

/// Leading configuration for an existing AppBar or SliverAppBar toolbar.
class DmNavigationHeaderData {
  const DmNavigationHeaderData({
    required this.leading,
    required this.leadingWidth,
    required this.automaticallyImplyLeading,
  });

  final Widget? leading;
  final double? leadingWidth;
  final bool automaticallyImplyLeading;
}

/// Composes restore and existing leading controls in a single toolbar row.
///
/// Forward all three [DmNavigationHeaderData] properties to an [AppBar] or
/// [SliverAppBar]. Pinned, floating and expanded sliver behavior is unchanged.
/// Put this inside the scaffold that owns the header so automatic drawer/back
/// resolution uses that scaffold and route. No system insets are added here.
class DmNavigationHeader extends StatelessWidget {
  const DmNavigationHeader({
    super.key,
    required this.builder,
    this.leading,
    this.leadingWidth,
    this.automaticallyImplyLeading = true,
  });

  final Widget Function(BuildContext context, DmNavigationHeaderData data)
      builder;
  final Widget? leading;
  final double? leadingWidth;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final scope = DmNavigationVisibilityScope.maybeOf(context);
    final restore = scope != null &&
        !scope.navigationVisible &&
        scope.onNavigationVisibleChange != null;
    if (!restore) {
      return builder(
          context,
          DmNavigationHeaderData(
            leading: leading,
            leadingWidth: leadingWidth,
            automaticallyImplyLeading: automaticallyImplyLeading,
          ));
    }

    Widget? existing = leading;
    if (existing == null && automaticallyImplyLeading) {
      final scaffold = Scaffold.maybeOf(context);
      final route = ModalRoute.of(context);
      if (scaffold?.hasDrawer ?? false) {
        existing = IconButton(
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          icon: const Icon(Icons.menu),
          onPressed: scaffold!.openDrawer,
        );
      } else if (route?.impliesAppBarDismissal ?? false) {
        existing = route is PageRoute && route.fullscreenDialog
            ? const CloseButton()
            : const BackButton();
      }
    }
    final existingWidth = leadingWidth ?? kToolbarHeight;
    return builder(
        context,
        DmNavigationHeaderData(
          leading: Row(
            children: [
              const DmNavigationVisibilityButton(),
              if (existing != null)
                SizedBox(width: existingWidth, child: existing),
            ],
          ),
          leadingWidth: 48 + (existing != null ? existingWidth : 0),
          automaticallyImplyLeading: false,
        ));
  }
}
