import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive text input that renders Material or Cupertino styles.
class DmTextField extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive text field.
  const DmTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.keyboardType,
    this.maxLines = 1,
    this.decoration,
    this.prefix,
    this.suffix,
    this.platformOverride,
  });

  /// Controller for reading and manipulating the text value.
  final TextEditingController? controller;

  /// Placeholder hint text shown when the field is empty.
  final String? placeholder;

  /// Whether to obscure the entered text (for passwords).
  final bool obscureText;

  /// Called when the text value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field (e.g. presses done).
  final ValueChanged<String>? onSubmitted;

  /// Whether the text field is interactive.
  final bool enabled;

  /// The type of keyboard to show.
  final TextInputType? keyboardType;

  /// Maximum number of lines; `null` for unlimited.
  final int? maxLines;

  /// Material-specific input decoration override.
  final InputDecoration? decoration;

  /// Widget displayed before the text content.
  final Widget? prefix;

  /// Widget displayed after the text content.
  final Widget? suffix;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => TextField(
          controller: controller,
          decoration: decoration ??
              InputDecoration(
                hintText: placeholder,
                prefixIcon: prefix,
                suffixIcon: suffix,
              ),
          obscureText: obscureText,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      DmPlatformStyle.cupertino => CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          obscureText: obscureText,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          prefix: prefix,
          suffix: suffix,
        ),
    };
  }
}
