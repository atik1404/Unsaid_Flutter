import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

Future<void> registerDomainModule(GetIt locator) async {
  locator
    ..registerFactory<LoginUseCase>(() => LoginUseCase(locator()))
    ..registerFactory<FetchProfileUseCase>(
      () => FetchProfileUseCase(locator()),
    );
}
