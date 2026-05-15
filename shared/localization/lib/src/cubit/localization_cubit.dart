import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref_storage/pref_storage.dart';

final class LocalizationCubit extends Cubit<Locale> {
  final AppStorageRepository _appStorageRepository;
  LocalizationCubit(this._appStorageRepository) : super(const Locale(AppConstants.en));

  //Currently we only have one language (English), so we don't need to load it from storage.
  //But in the future we will need to load it from storage.

  Future<void> loadLocale() async {
    final languageCode = await _appStorageRepository.getAppLanguage();
    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  Future<void> changeLocale(String languageCode) async {
    await _appStorageRepository.saveAppLanguage(languageCode);
    emit(Locale(languageCode));
  }
}
