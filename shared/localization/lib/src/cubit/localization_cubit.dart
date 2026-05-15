import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref_storage/pref_storage.dart';

final class LocalizationCubit extends Cubit<Locale> {
  final AppStorageRepository _appStorageRepository;
  LocalizationCubit(this._appStorageRepository) : super(const Locale(AppConstants.en)) {
    _loadLocale();
  }

  void _loadLocale() {
    final languageCode = _appStorageRepository.getAppLanguage();
    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  Future<void> changeLocale(String languageCode) async {
    await _appStorageRepository.saveAppLanguage(languageCode);
    emit(Locale(languageCode));
  }
}
