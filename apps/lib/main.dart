import 'package:app/app_di.dart';
import 'package:app/app_entry.dart';
import 'package:di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:pref_storage/pref_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final getIt = GetIt.instance;
  await configureDependencies(getIt);
  await getIt<StorageRepository>().onAppStart();
  await registerAppDiModule();
  runApp(const AppEntry());
}
