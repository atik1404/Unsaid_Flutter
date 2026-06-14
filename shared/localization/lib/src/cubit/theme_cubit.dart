import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref_storage/pref_storage.dart';

final class ThemeCubit extends Cubit<ThemeMode> {
  final AppPrefStorage _prefStorage;

  ThemeCubit(this._prefStorage) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final saved = _prefStorage.getString(PrefKey.appTheme);
    emit(saved == 'dark' ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setDarkMode(bool isDark) async {
    await _prefStorage.write(PrefKey.appTheme, isDark ? 'dark' : 'light');
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
