import 'package:pref_storage/pref_storage.dart';
import 'package:get_it/get_it.dart';

Future<void> configureDependencies(GetIt getIt) async {
  await PrefStorageDi.init(getIt);
}
