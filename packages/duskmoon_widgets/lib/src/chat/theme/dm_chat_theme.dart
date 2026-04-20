import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';

import '../models/dm_chat_block.dart';
import '../models/dm_chat_message.dart';

/// Custom-block renderer signature.
typedef DmChatCustomBlockBuilder = Widget Function(
  BuildContext context,
  DmChatCustomBlock block,
);

/// Avatar fallback signature — used when `DmChatView.avatarBuilder` is null.
typedef DmChatAvatarBuilder = Widget? Function(
  BuildContext context,
  DmChatRole role,
);

/// Theme extension controlling chat visual conventions.
@immutable
class DmChatTheme extends ThemeExtension<DmChatTheme> {
  /// Creates a [DmChatTheme] with every visual axis explicit.
  const DmChatTheme({
    required this.userBubbleColor,
    required this.userBubbleOnColor,
    required this.assistantSurface,
    required this.systemSurface,
    required this.userBubbleRadius,
    required this.bubblePadding,
    required this.userBubbleMaxWidthFraction,
    required this.rowSpacing,
    required this.thinkingForeground,
    required this.thinkingSurface,
    required this.thinkingTextStyle,
    required this.thinkingCollapseAnimation,
    required this.toolCallChipColor,
    required this.toolCallChipRunningColor,
    required this.toolCallChipDoneColor,
    required this.toolCallChipErrorColor,
    required this.toolCallLabelStyle,
    required this.attachmentChipColor,
    required this.attachmentImageThumbSize,
    required this.inputPadding,
    required this.inputSurface,
    required this.inputElevation,
    required this.inputRadius,
    this.customBuilders = const {},
    this.defaultAvatarBuilder,
  });

  // Bubble surfaces
  /// Background color for user-role message bubbles.
  final Color userBubbleColor;

  /// Foreground color for content inside user-role bubbles.
  final Color userBubbleOnColor;

  /// Surface color for assistant-role rows. Usually transparent so markdown
  /// content sits flat on the chat surface.
  final Color assistantSurface;

  /// Surface color for system-role rows (callouts/banners).
  final Color systemSurface;

  /// Corner radius for user bubbles.
  final BorderRadius userBubbleRadius;

  /// Padding applied inside bubbles.
  final EdgeInsets bubblePadding;

  /// Fraction of available width a user bubble is allowed to span.
  final double userBubbleMaxWidthFraction;

  /// Vertical spacing between message rows.
  final double rowSpacing;

  // Thinking block
  /// Foreground color for thinking / reasoning text.
  final Color thinkingForeground;

  /// Surface color for the collapsed thinking block.
  final Color thinkingSurface;

  /// Text style for thinking / reasoning content.
  final TextStyle thinkingTextStyle;

  /// Duration of the thinking block expand/collapse animation.
  final Duration thinkingCollapseAnimation;

  // Tool-call chip
  /// Default tool-call chip color (pending state).
  final Color toolCallChipColor;

  /// Chip color while the tool call is running.
  final Color toolCallChipRunningColor;

  /// Chip color when the tool call completed successfully.
  final Color toolCallChipDoneColor;

  /// Chip color when the tool call errored.
  final Color toolCallChipErrorColor;

  /// Label style used for tool-call chip names (typically monospace).
  final TextStyle toolCallLabelStyle;

  // Attachments
  /// Background color for non-image attachment chips.
  final Color attachmentChipColor;

  /// Edge length (in logical pixels) of image attachment thumbnails.
  final double attachmentImageThumbSize;

  // Input
  /// Padding inside the composer input area.
  final EdgeInsets inputPadding;

  /// Background color for the composer surface.
  final Color inputSurface;

  /// Material elevation for the composer surface.
  final double inputElevation;

  /// Corner radius for the composer surface.
  final BorderRadius inputRadius;

  // Extension points
  /// Map from [DmChatCustomBlock.kind] to a renderer.
  final Map<String, DmChatCustomBlockBuilder> customBuilders;

  /// Optional fallback avatar builder, used when `DmChatView.avatarBuilder`
  /// is null.
  final DmChatAvatarBuilder? defaultAvatarBuilder;

  /// Derives a [DmChatTheme] from ambient [Theme] + optional [DmColorExtension].
  factory DmChatTheme.withContext(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final ext = theme.extension<DmColorExtension>();

    Color thinkingSurface;
    Color toolDone;
    Color toolError;
    Color toolRunning;
    Color toolDefault;
    Color attachment;
    Color systemSurface;

    if (ext != null) {
      thinkingSurface = ext.surfaceVariant;
      toolDefault = ext.info;
      toolRunning = ext.warning;
      toolDone = ext.success;
      // DmColorExtension has no `error` field; fall back to ColorScheme.error.
      toolError = cs.error;
      attachment = ext.surfaceVariant;
      systemSurface = ext.neutral;
    } else {
      thinkingSurface = cs.surfaceContainerHighest;
      toolDefault = cs.secondary;
      toolRunning = cs.tertiary;
      toolDone = cs.primary;
      toolError = cs.error;
      attachment = cs.surfaceContainerHighest;
      systemSurface = cs.surfaceContainerHigh;
    }

    return DmChatTheme(
      userBubbleColor: cs.primaryContainer,
      userBubbleOnColor: cs.onPrimaryContainer,
      assistantSurface: Colors.transparent,
      systemSurface: systemSurface,
      userBubbleRadius: BorderRadius.circular(16),
      bubblePadding: const EdgeInsets.all(12),
      userBubbleMaxWidthFraction: 0.8,
      rowSpacing: 12,
      thinkingForeground: cs.onSurface.withValues(alpha: 0.7),
      thinkingSurface: thinkingSurface,
      thinkingTextStyle: (tt.bodyMedium ?? const TextStyle()).copyWith(
        fontStyle: FontStyle.italic,
        fontSize: (tt.bodyMedium?.fontSize ?? 14) * 0.95,
      ),
      thinkingCollapseAnimation: const Duration(milliseconds: 200),
      toolCallChipColor: toolDefault,
      toolCallChipRunningColor: toolRunning,
      toolCallChipDoneColor: toolDone,
      toolCallChipErrorColor: toolError,
      toolCallLabelStyle: (tt.labelMedium ?? const TextStyle()).copyWith(
        fontFamily: 'monospace',
        fontFamilyFallback: const ['Menlo', 'Consolas', 'monospace'],
      ),
      attachmentChipColor: attachment,
      attachmentImageThumbSize: 96,
      inputPadding: const EdgeInsets.all(8),
      inputSurface: cs.surface,
      inputElevation: 1,
      inputRadius: BorderRadius.circular(12),
    );
  }

  @override
  DmChatTheme copyWith({
    Color? userBubbleColor,
    Color? userBubbleOnColor,
    Color? assistantSurface,
    Color? systemSurface,
    BorderRadius? userBubbleRadius,
    EdgeInsets? bubblePadding,
    double? userBubbleMaxWidthFraction,
    double? rowSpacing,
    Color? thinkingForeground,
    Color? thinkingSurface,
    TextStyle? thinkingTextStyle,
    Duration? thinkingCollapseAnimation,
    Color? toolCallChipColor,
    Color? toolCallChipRunningColor,
    Color? toolCallChipDoneColor,
    Color? toolCallChipErrorColor,
    TextStyle? toolCallLabelStyle,
    Color? attachmentChipColor,
    double? attachmentImageThumbSize,
    EdgeInsets? inputPadding,
    Color? inputSurface,
    double? inputElevation,
    BorderRadius? inputRadius,
    Map<String, DmChatCustomBlockBuilder>? customBuilders,
    DmChatAvatarBuilder? defaultAvatarBuilder,
  }) =>
      DmChatTheme(
        userBubbleColor: userBubbleColor ?? this.userBubbleColor,
        userBubbleOnColor: userBubbleOnColor ?? this.userBubbleOnColor,
        assistantSurface: assistantSurface ?? this.assistantSurface,
        systemSurface: systemSurface ?? this.systemSurface,
        userBubbleRadius: userBubbleRadius ?? this.userBubbleRadius,
        bubblePadding: bubblePadding ?? this.bubblePadding,
        userBubbleMaxWidthFraction:
            userBubbleMaxWidthFraction ?? this.userBubbleMaxWidthFraction,
        rowSpacing: rowSpacing ?? this.rowSpacing,
        thinkingForeground: thinkingForeground ?? this.thinkingForeground,
        thinkingSurface: thinkingSurface ?? this.thinkingSurface,
        thinkingTextStyle: thinkingTextStyle ?? this.thinkingTextStyle,
        thinkingCollapseAnimation:
            thinkingCollapseAnimation ?? this.thinkingCollapseAnimation,
        toolCallChipColor: toolCallChipColor ?? this.toolCallChipColor,
        toolCallChipRunningColor:
            toolCallChipRunningColor ?? this.toolCallChipRunningColor,
        toolCallChipDoneColor:
            toolCallChipDoneColor ?? this.toolCallChipDoneColor,
        toolCallChipErrorColor:
            toolCallChipErrorColor ?? this.toolCallChipErrorColor,
        toolCallLabelStyle: toolCallLabelStyle ?? this.toolCallLabelStyle,
        attachmentChipColor: attachmentChipColor ?? this.attachmentChipColor,
        attachmentImageThumbSize:
            attachmentImageThumbSize ?? this.attachmentImageThumbSize,
        inputPadding: inputPadding ?? this.inputPadding,
        inputSurface: inputSurface ?? this.inputSurface,
        inputElevation: inputElevation ?? this.inputElevation,
        inputRadius: inputRadius ?? this.inputRadius,
        customBuilders: customBuilders ?? this.customBuilders,
        defaultAvatarBuilder: defaultAvatarBuilder ?? this.defaultAvatarBuilder,
      );

  @override
  DmChatTheme lerp(covariant DmChatTheme? other, double t) {
    if (other == null) return this;
    return DmChatTheme(
      userBubbleColor: Color.lerp(userBubbleColor, other.userBubbleColor, t) ??
          userBubbleColor,
      userBubbleOnColor:
          Color.lerp(userBubbleOnColor, other.userBubbleOnColor, t) ??
              userBubbleOnColor,
      assistantSurface:
          Color.lerp(assistantSurface, other.assistantSurface, t) ??
              assistantSurface,
      systemSurface:
          Color.lerp(systemSurface, other.systemSurface, t) ?? systemSurface,
      userBubbleRadius:
          BorderRadius.lerp(userBubbleRadius, other.userBubbleRadius, t) ??
              userBubbleRadius,
      bubblePadding: EdgeInsets.lerp(bubblePadding, other.bubblePadding, t) ??
          bubblePadding,
      userBubbleMaxWidthFraction: _lerpDouble(
        userBubbleMaxWidthFraction,
        other.userBubbleMaxWidthFraction,
        t,
      ),
      rowSpacing: _lerpDouble(rowSpacing, other.rowSpacing, t),
      thinkingForeground:
          Color.lerp(thinkingForeground, other.thinkingForeground, t) ??
              thinkingForeground,
      thinkingSurface: Color.lerp(thinkingSurface, other.thinkingSurface, t) ??
          thinkingSurface,
      thinkingTextStyle:
          TextStyle.lerp(thinkingTextStyle, other.thinkingTextStyle, t) ??
              thinkingTextStyle,
      thinkingCollapseAnimation:
          t < 0.5 ? thinkingCollapseAnimation : other.thinkingCollapseAnimation,
      toolCallChipColor:
          Color.lerp(toolCallChipColor, other.toolCallChipColor, t) ??
              toolCallChipColor,
      toolCallChipRunningColor: Color.lerp(
            toolCallChipRunningColor,
            other.toolCallChipRunningColor,
            t,
          ) ??
          toolCallChipRunningColor,
      toolCallChipDoneColor:
          Color.lerp(toolCallChipDoneColor, other.toolCallChipDoneColor, t) ??
              toolCallChipDoneColor,
      toolCallChipErrorColor:
          Color.lerp(toolCallChipErrorColor, other.toolCallChipErrorColor, t) ??
              toolCallChipErrorColor,
      toolCallLabelStyle:
          TextStyle.lerp(toolCallLabelStyle, other.toolCallLabelStyle, t) ??
              toolCallLabelStyle,
      attachmentChipColor:
          Color.lerp(attachmentChipColor, other.attachmentChipColor, t) ??
              attachmentChipColor,
      attachmentImageThumbSize: _lerpDouble(
        attachmentImageThumbSize,
        other.attachmentImageThumbSize,
        t,
      ),
      inputPadding:
          EdgeInsets.lerp(inputPadding, other.inputPadding, t) ?? inputPadding,
      inputSurface:
          Color.lerp(inputSurface, other.inputSurface, t) ?? inputSurface,
      inputElevation: _lerpDouble(inputElevation, other.inputElevation, t),
      inputRadius:
          BorderRadius.lerp(inputRadius, other.inputRadius, t) ?? inputRadius,
      customBuilders: t < 0.5 ? customBuilders : other.customBuilders,
      defaultAvatarBuilder:
          t < 0.5 ? defaultAvatarBuilder : other.defaultAvatarBuilder,
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
