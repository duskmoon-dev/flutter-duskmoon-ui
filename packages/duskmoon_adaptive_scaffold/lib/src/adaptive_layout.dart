// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'breakpoints.dart';
import 'slot_layout.dart';

/// Policy for how the layout adapts when a dual-screen hinge/fold is detected.
enum DuoScreenPolicy {
  /// Default behavior. Body and [secondaryBody] split around the hinge.
  splitBody,

  /// Duo-screen mode: navigation moves to the secondary screen.
  navigationOnSecondary,
}

enum _SlotIds {
  primaryNavigation,
  secondaryNavigation,
  topNavigation,
  bottomNavigation,
  body,
  secondaryBody,
}

/// Layout an app that adapts to different screens using predefined slots.
class AdaptiveLayout extends StatefulWidget {
  /// Creates a const [AdaptiveLayout] widget.
  const AdaptiveLayout({
    super.key,
    this.topNavigation,
    this.primaryNavigation,
    this.secondaryNavigation,
    this.bottomNavigation,
    this.body,
    this.secondaryBody,
    this.bodyRatio,
    this.transitionDuration = const Duration(seconds: 1),
    this.internalAnimations = true,
    this.bodyOrientation = Axis.horizontal,
    this.duoScreenPolicy = DuoScreenPolicy.splitBody,
    this.displayId = 0,
  });

  final int displayId;
  final SlotLayout? primaryNavigation;
  final SlotLayout? secondaryNavigation;
  final SlotLayout? topNavigation;
  final SlotLayout? bottomNavigation;
  final SlotLayout? body;
  final SlotLayout? secondaryBody;
  final double? bodyRatio;
  final Duration transitionDuration;
  final bool internalAnimations;
  final Axis bodyOrientation;
  final DuoScreenPolicy duoScreenPolicy;

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late final CurvedAnimation _sizeAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutCubic,
  );

  late Map<String, SlotLayoutConfig?> chosenWidgets =
      <String, SlotLayoutConfig?>{};
  Map<String, Size?> slotSizes = <String, Size?>{};

  Map<String, ValueNotifier<Key?>> notifiers = <String, ValueNotifier<Key?>>{};

  Set<String> isAnimating = <String>{};

  @override
  void initState() {
    if (widget.internalAnimations) {
      _controller = AnimationController(
        duration: widget.transitionDuration,
        vsync: this,
      )..forward();
    } else {
      _controller = AnimationController(duration: Duration.zero, vsync: this);
    }

    for (final _SlotIds item in _SlotIds.values) {
      notifiers[item.name] = ValueNotifier<Key?>(null)
        ..addListener(() {
          isAnimating.add(item.name);
          _controller.reset();
          _controller.forward();
        });
    }

    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        isAnimating.clear();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _sizeAnimation.dispose();
    for (final ValueNotifier<Key?> notifier in notifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, SlotLayout?> slots = <String, SlotLayout?>{
      _SlotIds.primaryNavigation.name: widget.primaryNavigation,
      _SlotIds.secondaryNavigation.name: widget.secondaryNavigation,
      _SlotIds.topNavigation.name: widget.topNavigation,
      _SlotIds.bottomNavigation.name: widget.bottomNavigation,
      _SlotIds.body.name: widget.body,
      _SlotIds.secondaryBody.name: widget.secondaryBody,
    };
    chosenWidgets = <String, SlotLayoutConfig?>{};

    slots.forEach((String key, SlotLayout? value) {
      slots.update(key, (SlotLayout? val) => val, ifAbsent: () => value);
      chosenWidgets.update(
        key,
        (SlotLayoutConfig? val) => val,
        ifAbsent: () => SlotLayout.pickWidget(
          context,
          value?.config ?? <Breakpoint, SlotLayoutConfig?>{},
        ),
      );
    });

    final List<Widget> entries = slots.entries
        .map((MapEntry<String, SlotLayout?> entry) {
          if (entry.value != null) {
            return LayoutId(
              id: entry.key,
              child: entry.value!,
            );
          }
        })
        .whereType<Widget>()
        .toList();

    notifiers.forEach((String key, ValueNotifier<Key?> notifier) {
      notifier.value = chosenWidgets[key]?.key;
    });

    Rect? hinge;
    for (final DisplayFeature e in MediaQuery.displayFeaturesOf(context)) {
      if (e.type == DisplayFeatureType.hinge ||
          e.type == DisplayFeatureType.fold) {
        hinge = e.bounds;
      }
    }

    return CustomMultiChildLayout(
      delegate: _AdaptiveLayoutDelegate(
        slots: slots,
        chosenWidgets: chosenWidgets,
        slotSizes: slotSizes,
        controller: _controller,
        bodyRatio: widget.bodyRatio,
        isAnimating: isAnimating,
        internalAnimations: widget.internalAnimations,
        bodyOrientation: widget.bodyOrientation,
        textDirection: Directionality.of(context) == TextDirection.ltr,
        hinge: hinge,
        sizeAnimation: _sizeAnimation,
        duoScreenPolicy: widget.duoScreenPolicy,
        displayId: widget.displayId,
      ),
      children: entries,
    );
  }
}

class _AdaptiveLayoutDelegate extends MultiChildLayoutDelegate {
  _AdaptiveLayoutDelegate({
    required this.slots,
    required this.chosenWidgets,
    required this.slotSizes,
    required this.controller,
    required this.bodyRatio,
    required this.isAnimating,
    required this.internalAnimations,
    required this.bodyOrientation,
    required this.textDirection,
    required this.sizeAnimation,
    required this.duoScreenPolicy,
    required this.displayId,
    this.hinge,
  }) : super(relayout: controller);

  final Map<String, SlotLayout?> slots;
  final Map<String, SlotLayoutConfig?> chosenWidgets;
  final Map<String, Size?> slotSizes;
  final Set<String> isAnimating;
  final AnimationController controller;
  final double? bodyRatio;
  final bool internalAnimations;
  final Axis bodyOrientation;
  final bool textDirection;
  final Rect? hinge;
  final Animation<double> sizeAnimation;
  final DuoScreenPolicy duoScreenPolicy;
  final int displayId;

  bool get _isVerticalHinge => hinge != null && hinge!.left == 0;

  @override
  void performLayout(Size size) {
    if (duoScreenPolicy == DuoScreenPolicy.navigationOnSecondary) {
      _performDuoScreenLayout(size);
      return;
    }

    double leftMargin = 0;
    double topMargin = 0;
    double rightMargin = 0;
    double bottomMargin = 0;

    double animatedSize(double begin, double end) {
      if (isAnimating.contains(_SlotIds.secondaryBody.name)) {
        return internalAnimations
            ? Tween<double>(begin: begin, end: end).animate(sizeAnimation).value
            : end;
      }
      return end;
    }

    if (hasChild(_SlotIds.topNavigation.name)) {
      final Size childSize =
          layoutChild(_SlotIds.topNavigation.name, BoxConstraints.loose(size));
      updateSize(_SlotIds.topNavigation.name, childSize);
      final Size currentSize = Tween<Size>(
        begin: slotSizes[_SlotIds.topNavigation.name] ?? Size.zero,
        end: childSize,
      ).animate(controller).value;
      positionChild(_SlotIds.topNavigation.name, Offset.zero);
      topMargin += currentSize.height;
    }
    if (hasChild(_SlotIds.bottomNavigation.name)) {
      final Size childSize =
          layoutChild(_SlotIds.bottomNavigation.name, BoxConstraints.loose(size));
      updateSize(_SlotIds.bottomNavigation.name, childSize);
      final Size currentSize = Tween<Size>(
        begin: slotSizes[_SlotIds.bottomNavigation.name] ?? Size.zero,
        end: childSize,
      ).animate(controller).value;
      positionChild(
        _SlotIds.bottomNavigation.name,
        Offset(0, size.height - currentSize.height),
      );
      bottomMargin += currentSize.height;
    }
    if (hasChild(_SlotIds.primaryNavigation.name)) {
      final Size childSize =
          layoutChild(_SlotIds.primaryNavigation.name, BoxConstraints.loose(size));
      updateSize(_SlotIds.primaryNavigation.name, childSize);
      final Size currentSize = Tween<Size>(
        begin: slotSizes[_SlotIds.primaryNavigation.name] ?? Size.zero,
        end: childSize,
      ).animate(controller).value;
      if (textDirection) {
        positionChild(
            _SlotIds.primaryNavigation.name, Offset(leftMargin, topMargin));
        leftMargin += currentSize.width;
      } else {
        positionChild(_SlotIds.primaryNavigation.name,
            Offset(size.width - currentSize.width, topMargin));
        rightMargin += currentSize.width;
      }
    }
    if (hasChild(_SlotIds.secondaryNavigation.name)) {
      final Size childSize = layoutChild(
          _SlotIds.secondaryNavigation.name, BoxConstraints.loose(size));
      updateSize(_SlotIds.secondaryNavigation.name, childSize);
      final Size currentSize = Tween<Size>(
        begin: slotSizes[_SlotIds.secondaryNavigation.name] ?? Size.zero,
        end: childSize,
      ).animate(controller).value;
      if (textDirection) {
        positionChild(_SlotIds.secondaryNavigation.name,
            Offset(size.width - currentSize.width, topMargin));
        rightMargin += currentSize.width;
      } else {
        positionChild(_SlotIds.secondaryNavigation.name, Offset(0, topMargin));
        leftMargin += currentSize.width;
      }
    }

    final double remainingWidth = size.width - rightMargin - leftMargin;
    final double remainingHeight = size.height - bottomMargin - topMargin;
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;
    final double hingeWidth = hinge != null ? hinge!.right - hinge!.left : 0;

    if (hasChild(_SlotIds.body.name) && hasChild(_SlotIds.secondaryBody.name)) {
      Size currentBodySize = Size.zero;
      Size currentSBodySize = Size.zero;
      if (chosenWidgets[_SlotIds.secondaryBody.name] == null ||
          chosenWidgets[_SlotIds.secondaryBody.name]!.builder == null) {
        if (!textDirection) {
          currentBodySize = layoutChild(_SlotIds.body.name,
              BoxConstraints.tight(Size(remainingWidth, remainingHeight)));
        } else if (bodyOrientation == Axis.horizontal) {
          double beginWidth =
              bodyRatio == null ? halfWidth - leftMargin : remainingWidth * bodyRatio!;
          currentBodySize = layoutChild(
              _SlotIds.body.name,
              BoxConstraints.tight(Size(
                  animatedSize(beginWidth, remainingWidth), remainingHeight)));
        } else {
          double beginHeight =
              bodyRatio == null ? halfHeight - topMargin : remainingHeight * bodyRatio!;
          currentBodySize = layoutChild(
              _SlotIds.body.name,
              BoxConstraints.tight(Size(
                  remainingWidth, animatedSize(beginHeight, remainingHeight))));
        }
        layoutChild(_SlotIds.secondaryBody.name, BoxConstraints.loose(size));
      } else {
        if (bodyOrientation == Axis.horizontal) {
          if (textDirection) {
            double finalBodySize = hinge != null
                ? hinge!.left - leftMargin
                : (bodyRatio != null ? remainingWidth * bodyRatio! : halfWidth - leftMargin);
            double finalSBodySize = hinge != null
                ? size.width - (hinge!.left + hingeWidth) - rightMargin
                : (bodyRatio != null
                    ? remainingWidth * (1 - bodyRatio!)
                    : halfWidth - rightMargin);

            currentBodySize = layoutChild(
                _SlotIds.body.name,
                BoxConstraints.tight(Size(
                    animatedSize(remainingWidth, finalBodySize),
                    remainingHeight)));
            layoutChild(_SlotIds.secondaryBody.name,
                BoxConstraints.tight(Size(finalSBodySize, remainingHeight)));
          } else {
            double finalBodySize = hinge != null
                ? size.width - (hinge!.left + hingeWidth) - rightMargin
                : (bodyRatio != null ? remainingWidth * bodyRatio! : halfWidth - rightMargin);
            double finalSBodySize = hinge != null
                ? hinge!.left - leftMargin
                : (bodyRatio != null
                    ? remainingWidth * (1 - bodyRatio!)
                    : halfWidth - leftMargin);
            currentSBodySize = layoutChild(
                _SlotIds.secondaryBody.name,
                BoxConstraints.tight(
                    Size(animatedSize(0, finalSBodySize), remainingHeight)));
            layoutChild(_SlotIds.body.name,
                BoxConstraints.tight(Size(finalBodySize, remainingHeight)));
          }
        } else {
          currentBodySize = layoutChild(
              _SlotIds.body.name,
              BoxConstraints.tight(Size(
                  remainingWidth,
                  animatedSize(
                      remainingHeight,
                      bodyRatio == null
                          ? halfHeight - topMargin
                          : remainingHeight * bodyRatio!))));
          layoutChild(
              _SlotIds.secondaryBody.name,
              BoxConstraints.tight(Size(
                  remainingWidth,
                  bodyRatio == null
                      ? halfHeight - bottomMargin
                      : remainingHeight * (1 - bodyRatio!))));
        }
      }
      if (bodyOrientation == Axis.horizontal &&
          !textDirection &&
          chosenWidgets[_SlotIds.secondaryBody.name] != null) {
        double offset = hinge != null ? hingeWidth : 0;
        positionChild(_SlotIds.body.name,
            Offset(currentSBodySize.width + leftMargin + offset, topMargin));
        positionChild(_SlotIds.secondaryBody.name, Offset(leftMargin, topMargin));
      } else {
        positionChild(_SlotIds.body.name, Offset(leftMargin, topMargin));
        if (bodyOrientation == Axis.horizontal) {
          double offset = hinge != null ? hingeWidth : 0;
          positionChild(_SlotIds.secondaryBody.name,
              Offset(currentBodySize.width + leftMargin + offset, topMargin));
        } else {
          positionChild(_SlotIds.secondaryBody.name,
              Offset(leftMargin, topMargin + currentBodySize.height));
        }
      }
    } else if (hasChild(_SlotIds.body.name)) {
      layoutChild(_SlotIds.body.name,
          BoxConstraints.tight(Size(remainingWidth, remainingHeight)));
      positionChild(_SlotIds.body.name, Offset(leftMargin, topMargin));
    } else if (hasChild(_SlotIds.secondaryBody.name)) {
      layoutChild(_SlotIds.secondaryBody.name,
          BoxConstraints.tight(Size(remainingWidth, remainingHeight)));
    }
  }

  void _performDuoScreenLayout(Size size) {
    late final double mainWidth;
    late final double mainHeight;
    late final double secondaryWidth;
    late final double secondaryHeight;
    late final Offset secondaryOrigin;

    final bool isSecondaryScreen = displayId > 0;

    if (displayId > 0) {
      mainWidth = 0;
      mainHeight = 0;
      secondaryWidth = size.width;
      secondaryHeight = size.height;
      secondaryOrigin = Offset.zero;
    } else if (hinge != null) {
      final Rect h = hinge!;
      if (_isVerticalHinge) {
        mainWidth = size.width;
        mainHeight = h.top;
        secondaryWidth = size.width;
        secondaryHeight = size.height - h.bottom;
        secondaryOrigin = Offset(0, h.bottom);
      } else {
        mainWidth = h.left;
        mainHeight = size.height;
        secondaryWidth = size.width - h.right;
        secondaryHeight = size.height;
        secondaryOrigin = Offset(h.right, 0);
      }
    } else {
      mainWidth = size.width;
      mainHeight = size.height;
      secondaryWidth = 0;
      secondaryHeight = 0;
      secondaryOrigin = Offset.zero;
    }

    if (displayId == 0) {
      double mainTopMargin = 0;
      if (hasChild(_SlotIds.topNavigation.name)) {
        final Size childSize = layoutChild(
            _SlotIds.topNavigation.name, BoxConstraints.loose(Size(mainWidth, mainHeight)));
        updateSize(_SlotIds.topNavigation.name, childSize);
        positionChild(_SlotIds.topNavigation.name, Offset.zero);
        mainTopMargin += childSize.height;
      }
      if (hasChild(_SlotIds.body.name)) {
        layoutChild(
            _SlotIds.body.name, BoxConstraints.tight(Size(mainWidth, mainHeight - mainTopMargin)));
        positionChild(_SlotIds.body.name, Offset(0, mainTopMargin));
      }
    } else {
      if (hasChild(_SlotIds.topNavigation.name)) {
        layoutChild(_SlotIds.topNavigation.name, BoxConstraints.tight(Size.zero));
        positionChild(_SlotIds.topNavigation.name, Offset.zero);
      }
      if (hasChild(_SlotIds.body.name)) {
        layoutChild(_SlotIds.body.name, BoxConstraints.tight(Size.zero));
        positionChild(_SlotIds.body.name, Offset.zero);
      }
    }

    if (hasChild(_SlotIds.bottomNavigation.name)) {
      layoutChild(_SlotIds.bottomNavigation.name, BoxConstraints.tight(Size.zero));
      positionChild(_SlotIds.bottomNavigation.name, Offset.zero);
    }
    if (hasChild(_SlotIds.secondaryNavigation.name)) {
      layoutChild(_SlotIds.secondaryNavigation.name, BoxConstraints.tight(Size.zero));
      positionChild(_SlotIds.secondaryNavigation.name, Offset.zero);
    }

    if (isSecondaryScreen || (displayId == 0 && hinge != null)) {
      double navWidth = 0;
      if (hasChild(_SlotIds.primaryNavigation.name)) {
        final Size childSize = layoutChild(_SlotIds.primaryNavigation.name,
            BoxConstraints.loose(Size(secondaryWidth, secondaryHeight)));
        updateSize(_SlotIds.primaryNavigation.name, childSize);
        if (textDirection) {
          positionChild(_SlotIds.primaryNavigation.name, secondaryOrigin);
        } else {
          positionChild(_SlotIds.primaryNavigation.name,
              secondaryOrigin + Offset(secondaryWidth - childSize.width, 0));
        }
        navWidth = childSize.width;
      }
      if (hasChild(_SlotIds.secondaryBody.name)) {
        final double sBodyWidth = secondaryWidth - navWidth;
        layoutChild(_SlotIds.secondaryBody.name,
            BoxConstraints.tight(Size(sBodyWidth, secondaryHeight)));
        if (textDirection) {
          positionChild(
              _SlotIds.secondaryBody.name, secondaryOrigin + Offset(navWidth, 0));
        } else {
          positionChild(_SlotIds.secondaryBody.name, secondaryOrigin);
        }
      }
    } else {
      if (hasChild(_SlotIds.primaryNavigation.name)) {
        layoutChild(_SlotIds.primaryNavigation.name, BoxConstraints.tight(Size.zero));
        positionChild(_SlotIds.primaryNavigation.name, Offset.zero);
      }
      if (hasChild(_SlotIds.secondaryBody.name)) {
        layoutChild(_SlotIds.secondaryBody.name, BoxConstraints.tight(Size.zero));
        positionChild(_SlotIds.secondaryBody.name, Offset.zero);
      }
    }
  }

  void updateSize(String id, Size childSize) {
    if (slotSizes[id] == null || slotSizes[id] != childSize) {
      void listener(AnimationStatus status) {
        if ((status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed) &&
            (slotSizes[id] == null || slotSizes[id] != childSize)) {
          slotSizes[id] = childSize;
        }
        controller.removeStatusListener(listener);
      }
      controller.addStatusListener(listener);
    }
  }

  @override
  bool shouldRelayout(_AdaptiveLayoutDelegate oldDelegate) {
    return oldDelegate.slots != slots || oldDelegate.displayId != displayId;
  }
}
