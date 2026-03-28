import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class DmThemeEvent extends Equatable {
  const DmThemeEvent();

  @override
  List<Object> get props => [];
}

class DmSetTheme extends DmThemeEvent {
  const DmSetTheme(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class DmSetThemeMode extends DmThemeEvent {
  const DmSetThemeMode(this.mode);

  final ThemeMode mode;

  @override
  List<Object> get props => [mode];
}
