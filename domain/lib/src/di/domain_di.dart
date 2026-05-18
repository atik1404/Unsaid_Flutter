import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

final class DomainDi {
  DomainDi._();

  static void init(GetIt getIt) {
    getIt
      ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()))
      ..registerLazySingleton<AuthRepository>(() => getIt<AuthRepository>());
  }
}
