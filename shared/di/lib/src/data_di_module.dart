import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:pref_storage/pref_storage.dart';

Future<void> registerDataDiModule(GetIt locator) async {
  locator
    ..registerSingleton<Dio>(
      NetworkFactory.create(locator<AuthStorageRepository>()),
    )
    ..registerSingleton<NetworkClient>(NetworkClient(locator<Dio>()))
    ..registerSingleton<AuthRepository>(AuthRepoImpl(locator<NetworkClient>()));

  return;
}
