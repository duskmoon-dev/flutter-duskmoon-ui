import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmTextField extends StatelessWidget with AdaptiveWidget {
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

  final TextEditingController? controller;
  final String? placeholder;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final TextInputType? keyboardType;
  final int? maxLines;
  final InputDecoration? decoration;
  final Widget? prefix;
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
