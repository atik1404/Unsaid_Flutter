import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref_storage/pref_storage.dart';

final class ThemeCubit extends Cubit<ThemeMode> {
  final AppStorageRepository _appStorageRepository;

  ThemeCubit(this._appStorageRepository) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final saved = _appStorageRepository.getAppTheme();
    emit(saved == 'dark' ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setDarkMode(bool isDark) async {
    await _appStorageRepository.saveAppTheme(isDark ? 'dark' : 'light');
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
