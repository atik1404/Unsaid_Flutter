import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LocalizationCubit extends Cubit<Locale> {
  //final AppPreferencesStorage _appDataRepository;
  LocalizationCubit() : super(const Locale('en'));

  //Currently we only have one language (English), so we don't need to load it from storage.
  //But in the future we will need to load it from storage.

  // Future<void> loadLocale() async {
  //   final languageCode = await _appDataRepository.getLanguageCode();
  //   if (languageCode != null) {
  //     emit(Locale(languageCode));
  //   }
  // }

  Future<void> changeLocale(String languageCode) async {
    //await _appDataRepository.saveLanguageCode(languageCode);
    emit(Locale(languageCode));
  }
}
