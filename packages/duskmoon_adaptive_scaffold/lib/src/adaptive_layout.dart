// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'breakpoints.dart';
import 'duo_screen.dart';
import 'slot_layout.dart';

// Preserve the policy import path used before duo_screen.dart was introduced.
export 'duo_screen.dart' show DuoScreenPolicy, DuoScreenRole;

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
    this.duoScreenRole = DuoScreenRole.single,
    @Deprecated(
      'Use duoScreenRole instead. A displayId greater than 0 maps to '
      'DuoScreenRole.secondary. This parameter will be removed in 2.0.0.',
    )
    this.displayId = 0,
  });

  /// Legacy integer role selector.
  ///
  /// A value greater than 0 is treated as [DuoScreenRole.secondary] and takes
  /// precedence over [duoScreenRole].
  @Deprecated(
    'Use duoScreenRole instead. A displayId greater than 0 maps to '
    'DuoScreenRole.secondary. This parameter will be removed in 2.0.0.',
  )
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

  /// How slots are distributed when a second screen exists.
  final DuoScreenPolicy duoScreenPolicy;

  /// The role of this view in a multi-display setup.
  ///
  /// Only honoured with [DuoScreenPolicy.navigationOnSecondary].
  final DuoScreenRole duoScreenRole;

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
    _origin.dispose();
    for (final ValueNotifier<Key?> notifier in notifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  /// Layout offset of this widget inside the view, used to convert the
  /// window-relative hinge bounds into local coordinates.
  final ValueNotifier<Offset> _origin = ValueNotifier<Offset>(Offset.zero);
  static bool _isSlotVisible(_SlotIds slot, DuoLayoutMode mode) {
    return switch (mode) {
      DuoLayoutMode.none => true,
      DuoLayoutMode.hinge => slot != _SlotIds.secondaryNavigation,
      DuoLayoutMode.primary =>
        slot == _SlotIds.topNavigation || slot == _SlotIds.body,
      DuoLayoutMode.secondary => slot == _SlotIds.primaryNavigation ||
          slot == _SlotIds.bottomNavigation ||
          slot == _SlotIds.secondaryBody,
    };
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

    final Rect? hinge = DuoScreen.hingeOf(context);
    final DuoLayoutMode mode = resolveDuoLayoutMode(
      policy: widget.duoScreenPolicy,
      // ignore: deprecated_member_use_from_same_package
      role: resolveDuoScreenRole(widget.duoScreenRole, widget.displayId),
      hasHinge: hinge != null,
    );

    // Slots hidden by the duo arrangement are not mounted at all, so they are
    // neither built, focusable nor exposed to accessibility services.
    final List<Widget> entries = <Widget>[
      for (final _SlotIds slot in _SlotIds.values)
        if (slots[slot.name] != null && _isSlotVisible(slot, mode))
          LayoutId(
            key: ValueKey<_SlotIds>(slot),
            id: slot.name,
            child: ClipRect(child: slots[slot.name]!),
          ),
    ];

    notifiers.forEach((String key, ValueNotifier<Key?> notifier) {
      notifier.value = chosenWidgets[key]?.key;
    });

    return _HingeBoundary(
      hinge: hinge,
      origin: _origin,
      child: CustomMultiChildLayout(
        delegate: _AdaptiveLayoutDelegate(
          chosenWidgets: chosenWidgets,
          slotSizes: slotSizes,
          controller: _controller,
          bodyRatio: widget.bodyRatio,
          isAnimating: isAnimating,
          internalAnimations: widget.internalAnimations,
          bodyOrientation: widget.bodyOrientation,
          textDirection: Directionality.of(context) == TextDirection.ltr,
          globalHinge: hinge,
          origin: _origin,
          sizeAnimation: _sizeAnimation,
          duoLayoutMode: mode,
          duoScreenPolicy: widget.duoScreenPolicy,
        ),
        children: entries,
      ),
    );
  }
}

class _AdaptiveLayoutDelegate extends MultiChildLayoutDelegate {
  _AdaptiveLayoutDelegate({
    required this.chosenWidgets,
    required this.slotSizes,
    required this.controller,
    required this.bodyRatio,
    required this.isAnimating,
    required this.internalAnimations,
    required this.bodyOrientation,
    required this.textDirection,
    required this.sizeAnimation,
    required this.duoLayoutMode,
    required this.duoScreenPolicy,
    required this.origin,
    this.globalHinge,
  }) : super(relayout: Listenable.merge(<Listenable>[controller, origin]));

  final Map<String, SlotLayoutConfig?> chosenWidgets;
  final Map<String, Size?> slotSizes;
  final Set<String> isAnimating;
  final AnimationController controller;
  final double? bodyRatio;
  final bool internalAnimations;
  final Axis bodyOrientation;
  final bool textDirection;

  /// Hinge bounds in window coordinates, as reported by [MediaQuery].
  final Rect? globalHinge;

  /// Layout offset of the [AdaptiveLayout] inside the window.
  final ValueListenable<Offset> origin;
  final Animation<double> sizeAnimation;
  final DuoLayoutMode duoLayoutMode;
  final DuoScreenPolicy duoScreenPolicy;

  /// Hinge bounds in local coordinates, resolved at the start of each layout.
  Rect? hinge;

  /// Whether the hinge runs horizontally, splitting the view top/bottom.
  bool get _isHorizontalHinge => hinge != null && hinge!.width > hinge!.height;

  Rect? _localHinge(Size size) {
    final Rect? h = globalHinge?.shift(-origin.value);
    if (h == null) return null;
    double clampX(double v) => v.clamp(0.0, size.width);
    double clampY(double v) => v.clamp(0.0, size.height);
    return Rect.fromLTRB(
      clampX(h.left),
      clampY(h.top),
      clampX(h.right),
      clampY(h.bottom),
    );
  }

  @override
  void performLayout(Size size) {
    hinge = _localHinge(size);
    if (duoLayoutMode != DuoLayoutMode.none) {
      _performDuoScreenLayout(size);
      return;
    }
    if (hinge != null) {
      _performHingeLayout(size);
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
      final Size childSize = layoutChild(
          _SlotIds.bottomNavigation.name, BoxConstraints.loose(size));
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
      final Size childSize = layoutChild(
          _SlotIds.primaryNavigation.name, BoxConstraints.loose(size));
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
          double beginWidth = bodyRatio == null
              ? halfWidth - leftMargin
              : remainingWidth * bodyRatio!;
          currentBodySize = layoutChild(
              _SlotIds.body.name,
              BoxConstraints.tight(Size(
                  animatedSize(beginWidth, remainingWidth), remainingHeight)));
        } else {
          double beginHeight = bodyRatio == null
              ? halfHeight - topMargin
              : remainingHeight * bodyRatio!;
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
                : (bodyRatio != null
                    ? remainingWidth * bodyRatio!
                    : halfWidth - leftMargin);
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
                : (bodyRatio != null
                    ? remainingWidth * bodyRatio!
                    : halfWidth - rightMargin);
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
        positionChild(
            _SlotIds.secondaryBody.name, Offset(leftMargin, topMargin));
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

  /// A physical separator fixes pane boundaries. Geometry never interpolates
  /// across it; slot fades and navigation widths can still animate in a pane.
  void _performHingeLayout(Size size) {
    final Rect h = hinge!;
    final Rect start;
    final Rect end;
    if (_isHorizontalHinge) {
      start = Rect.fromLTRB(0, 0, size.width, h.top);
      end = Rect.fromLTRB(0, h.bottom, size.width, size.height);
    } else {
      start = Rect.fromLTRB(0, 0, h.left, size.height);
      end = Rect.fromLTRB(h.right, 0, size.width, size.height);
    }
    final main = _isHorizontalHinge || textDirection ? start : end;
    final secondary = _isHorizontalHinge || textDirection ? end : start;
    final navigationOnSecondary =
        duoScreenPolicy == DuoScreenPolicy.navigationOnSecondary;
    _layoutPane(
      main,
      body: _SlotIds.body,
      top: _SlotIds.topNavigation,
      leading: navigationOnSecondary ? null : _SlotIds.primaryNavigation,
      bottom: navigationOnSecondary ? null : _SlotIds.bottomNavigation,
    );
    _layoutPane(
      secondary,
      body: _SlotIds.secondaryBody,
      leading: navigationOnSecondary ? _SlotIds.primaryNavigation : null,
      trailing: navigationOnSecondary ? null : _SlotIds.secondaryNavigation,
      bottom: navigationOnSecondary ? _SlotIds.bottomNavigation : null,
    );
  }

  void _performDuoScreenLayout(Size size) {
    switch (duoLayoutMode) {
      case DuoLayoutMode.none:
        assert(false, 'Regular layouts are handled by performLayout');
      case DuoLayoutMode.hinge:
        _performHingeLayout(size);
      case DuoLayoutMode.primary:
        _layoutPane(Offset.zero & size,
            body: _SlotIds.body, top: _SlotIds.topNavigation);
      case DuoLayoutMode.secondary:
        _layoutPane(Offset.zero & size,
            body: _SlotIds.secondaryBody,
            leading: _SlotIds.primaryNavigation,
            bottom: _SlotIds.bottomNavigation);
    }
  }

  void _layoutPane(
    Rect area, {
    required _SlotIds body,
    _SlotIds? top,
    _SlotIds? bottom,
    _SlotIds? leading,
    _SlotIds? trailing,
  }) {
    double animatedExtent(_SlotIds slot, double extent, {required bool width}) {
      if (!internalAnimations || !isAnimating.contains(slot.name)) {
        return extent;
      }
      final previous = slotSizes[slot.name] ?? Size.zero;
      return Tween<double>(
              begin: width ? previous.width : previous.height, end: extent)
          .animate(sizeAnimation)
          .value;
    }

    for (final slot in [top, bottom]) {
      if (slot == null || !hasChild(slot.name)) continue;
      final childSize = layoutChild(slot.name, BoxConstraints.loose(area.size));
      final extent = animatedExtent(slot, childSize.height, width: false)
          .clamp(0.0, area.height);
      updateSize(slot.name, childSize);
      final atTop = slot == top;
      positionChild(slot.name,
          Offset(area.left, atTop ? area.top : area.bottom - childSize.height));
      area = Rect.fromLTRB(area.left, atTop ? area.top + extent : area.top,
          area.right, atTop ? area.bottom : area.bottom - extent);
    }
    for (final slot in [leading, trailing]) {
      if (slot == null || !hasChild(slot.name)) continue;
      final childSize = layoutChild(slot.name, BoxConstraints.loose(area.size));
      final extent = animatedExtent(slot, childSize.width, width: true)
          .clamp(0.0, area.width);
      updateSize(slot.name, childSize);
      final atLeft = (slot == leading) == textDirection;
      positionChild(slot.name,
          Offset(atLeft ? area.left : area.right - childSize.width, area.top));
      area = Rect.fromLTRB(atLeft ? area.left + extent : area.left, area.top,
          atLeft ? area.right : area.right - extent, area.bottom);
    }
    if (hasChild(body.name)) {
      layoutChild(body.name, BoxConstraints.tight(area.size));
      positionChild(body.name, area.topLeft);
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
    // Animation progress is covered by relayout. Compare selected slot keys,
    // rather than newly allocated maps, and inputs that affect geometry.
    final slotsChanged =
        chosenWidgets.length != oldDelegate.chosenWidgets.length ||
            chosenWidgets.entries.any((entry) =>
                entry.value?.key != oldDelegate.chosenWidgets[entry.key]?.key ||
                (entry.value?.builder == null) !=
                    (oldDelegate.chosenWidgets[entry.key]?.builder == null));
    return slotsChanged ||
        oldDelegate.duoLayoutMode != duoLayoutMode ||
        oldDelegate.duoScreenPolicy != duoScreenPolicy ||
        oldDelegate.globalHinge != globalHinge ||
        oldDelegate.bodyRatio != bodyRatio ||
        oldDelegate.bodyOrientation != bodyOrientation ||
        oldDelegate.internalAnimations != internalAnimations ||
        oldDelegate.textDirection != textDirection;
  }
}

/// Tracks the actual view offset after parent positioning, and clips the
/// physical hinge even during the initial frame and ancestor transitions.
class _HingeBoundary extends SingleChildRenderObjectWidget {
  const _HingeBoundary(
      {required this.hinge, required this.origin, required super.child});

  final Rect? hinge;
  final ValueNotifier<Offset> origin;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderHingeBoundary(hinge, origin);

  @override
  void updateRenderObject(
      BuildContext context, _RenderHingeBoundary renderObject) {
    renderObject.hinge = hinge;
  }
}

class _RenderHingeBoundary extends RenderProxyBox {
  _RenderHingeBoundary(this._hinge, this.origin);

  Rect? _hinge;
  final ValueNotifier<Offset> origin;
  bool _syncScheduled = false;

  set hinge(Rect? value) {
    if (_hinge == value) return;
    _hinge = value;
    markNeedsLayout();
    markNeedsPaint();
  }

  @override
  void performLayout() {
    super.performLayout();
    _scheduleOriginSync();
  }

  void _scheduleOriginSync() {
    if (_hinge == null || _syncScheduled) return;
    _syncScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (attached && hasSize) origin.value = localToGlobal(Offset.zero);
    });
  }

  Rect? get _localHinge => _hinge == null
      ? null
      : Rect.fromPoints(
          globalToLocal(_hinge!.topLeft), globalToLocal(_hinge!.bottomRight));

  @override
  void paint(PaintingContext context, Offset offset) {
    _scheduleOriginSync();
    final localHinge = _localHinge;
    if (localHinge == null) {
      super.paint(context, offset);
      return;
    }
    final path = Path.combine(PathOperation.difference,
        Path()..addRect(Offset.zero & size), Path()..addRect(localHinge));
    context.pushClipPath(
        needsCompositing, offset, Offset.zero & size, path, super.paint,
        clipBehavior: Clip.hardEdge);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (_localHinge?.contains(position) ?? false) return false;
    return super.hitTest(result, position: position);
  }
}
