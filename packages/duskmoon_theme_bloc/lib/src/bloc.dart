import 'package:bloc/bloc.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event.dart';
import 'state.dart';

const _keyThemeName = 'dm_theme_name';
const _keyThemeMode = 'dm_theme_mode';

class DmThemeBloc extends Bloc<DmThemeEvent, DmThemeState> {
  DmThemeBloc({required SharedPreferences prefs})
      : _prefs = prefs,
        super(
          DmThemeState(
            themeName:
                prefs.getString(_keyThemeName) ?? DmThemeData.themes.first.name,
            themeMode:
                ThemeModeExtension.fromString(prefs.getString(_keyThemeMode)),
          ),
        ) {
    on<DmSetTheme>(_onSetTheme);
    on<DmSetThemeMode>(_onSetThemeMode);
  }

  final SharedPreferences _prefs;

  void _onSetTheme(DmSetTheme event, Emitter<DmThemeState> emit) {
    emit(state.copyWith(themeName: event.name));
    _prefs.setString(_keyThemeName, event.name);
  }

  void _onSetThemeMode(DmSetThemeMode event, Emitter<DmThemeState> emit) {
    emit(state.copyWith(themeMode: event.mode));
    _prefs.setString(_keyThemeMode, event.mode.name);
  }
}
