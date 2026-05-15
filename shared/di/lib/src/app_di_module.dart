import 'package:di/src/data_di_module.dart';
import 'package:di/src/domain_di_module.dart';
import 'package:di/src/navigation_di_module.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> registerAppDiModule() async {
  await registerDataDiModule(locator);
  await registerDomainModule(locator);
  await registerNavigationModule(locator);
}
