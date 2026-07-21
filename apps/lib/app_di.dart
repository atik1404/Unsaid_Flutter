import 'package:app_env/environment.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:get_it/get_it.dart';

Future<void> configureDependencies(
  GetIt getIt,
  AppEnvironment environment,
) async {
  await PrefStorageDi.init(getIt);
  DataDiModule.init(getIt);
  DomainDi.init(getIt);
}
