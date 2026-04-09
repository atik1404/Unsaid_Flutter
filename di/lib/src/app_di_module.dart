import 'package:get_it/get_it.dart';
import 'package:secured/secured.dart';

final locator = GetIt.instance;

Future<void> registerAppDiModule() async {
  locator.registerSingleton<SecuredStorage>(SecuredStorage());
}
