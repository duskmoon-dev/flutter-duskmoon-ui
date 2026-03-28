import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for all theme-related events.
sealed class DmThemeEvent extends Equatable {
  /// Creates a [DmThemeEvent].
  const DmThemeEvent();

  @override
  List<Object> get props => [];
}

/// Event to change the active theme by name.
class DmSetTheme extends DmThemeEvent {
  /// Creates a [DmSetTheme] event with the target theme [name].
  const DmSetTheme(this.name);

  /// The name of the theme to activate.
  final String name;

  @override
  List<Object> get props => [name];
}

/// Event to change the theme mode (light, dark, or system).
class DmSetThemeMode extends DmThemeEvent {
  /// Creates a [DmSetThemeMode] event with the target [mode].
  const DmSetThemeMode(this.mode);

  /// The theme mode to apply.
  final ThemeMode mode;

  @override
  List<Object> get props => [mode];
}
