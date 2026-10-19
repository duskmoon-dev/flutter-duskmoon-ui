import 'package:bloc/bloc.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event.dart';
import 'state.dart';

const _keyThemeName = 'dm_theme_name';
const _keyThemeMode = 'dm_theme_mode';

/// BLoC that manages theme selection and mode with SharedPreferences persistence.
class DmThemeBloc extends Bloc<DmThemeEvent, DmThemeState> {
  /// Creates a [DmThemeBloc], restoring persisted theme from [prefs].
  DmThemeBloc({required SharedPreferences prefs})
      : this._(
          _restoredState(
            prefs.getString(_keyThemeName),
            prefs.getString(_keyThemeMode),
          ),
          (key, value) async {
            await prefs.setString(key, value);
          },
        );

  /// Restores theme preferences from an initialized modern cache.
  ///
  /// The cache must allow the `dm_theme_name` and `dm_theme_mode` keys.
  DmThemeBloc.withCache({required SharedPreferencesWithCache prefs})
      : this._(
          _restoredState(
            prefs.getString(_keyThemeName),
            prefs.getString(_keyThemeMode),
          ),
          prefs.setString,
        );

  /// Reads persisted theme preferences before creating the bloc.
  ///
  /// Existing legacy preferences must be migrated by the application before
  /// calling this method. The supplied instance is also used for future writes.
  static Future<DmThemeBloc> fromAsync({
    required SharedPreferencesAsync prefs,
  }) async {
    final values = await Future.wait([
      prefs.getString(_keyThemeName),
      prefs.getString(_keyThemeMode),
    ]);
    return DmThemeBloc._(
      _restoredState(values[0], values[1]),
      prefs.setString,
    );
  }

  DmThemeBloc._(super.initialState, this._writeString) {
    on<DmSetTheme>(_onSetTheme);
    on<DmSetThemeMode>(_onSetThemeMode);
  }

  final Future<void> Function(String key, String value) _writeString;
  Future<void> _pendingWrite = Future.value();

  static DmThemeState _restoredState(String? name, String? mode) =>
      DmThemeState(
        themeName: name ?? DmThemeData.themes.first.name,
        themeMode: ThemeModeExtension.fromString(mode),
      );

  Future<void> _persist(String key, String value) {
    final write = _pendingWrite.then((_) => _writeString(key, value));
    // Report a failed write through its event handler while allowing later
    // preference changes to continue using the same queue.
    _pendingWrite =
        write.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return write;
  }

  Future<void> _onSetTheme(
    DmSetTheme event,
    Emitter<DmThemeState> emit,
  ) async {
    emit(state.copyWith(themeName: event.name));
    await _persist(_keyThemeName, event.name);
  }

  Future<void> _onSetThemeMode(
    DmSetThemeMode event,
    Emitter<DmThemeState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.mode));
    await _persist(_keyThemeMode, event.mode.name);
  }

  @override
  Future<void> close() async {
    await super.close();
    await _pendingWrite;
  }
}
