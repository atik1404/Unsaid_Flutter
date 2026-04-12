import 'package:get_it/get_it.dart';
import 'package:secured/secured.dart';
import 'package:sharedpref/sharedpref.dart';

Future<void> registerCacheModule(GetIt locator) async {
  locator.registerSingleton<SecuredStorage>(SecuredStorage());

  final sharedPrefManager = SharedPrefManager();
  await sharedPrefManager.init();

  locator.registerSingleton<SharedPrefManager>(sharedPrefManager);
}
