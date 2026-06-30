import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref_storage/pref_storage.dart';

final class LocalizationCubit extends Cubit<Locale> {
  final AppPrefStorage _prefStorage;
  LocalizationCubit(this._prefStorage) : super(const Locale(AppConstants.en)) {
    _loadLocale();
  }

  void _loadLocale() {
    var languageCode = _prefStorage.getString(PrefKey.appLanguage);
    if(languageCode.isEmpty) {
      languageCode = AppConstants.en;
    }
    emit(Locale(languageCode));
  }

  Future<void> changeLocale(String languageCode) async {
    await _prefStorage.write(PrefKey.appLanguage, languageCode);
    emit(Locale(languageCode));
  }
}
