import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

final class DomainDi {
  DomainDi._();

  static void init(GetIt getIt) {
    getIt
      ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()))
      ..registerLazySingleton<SendOtpUseCase>(() => SendOtpUseCase(getIt<AuthRepository>()))
      ..registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(getIt<AuthRepository>()))
      ..registerLazySingleton<FetchProfileUseCase>(() => FetchProfileUseCase(getIt<AuthRepository>()))
      ..registerLazySingleton<FetchUserExistenceUseCase>(() => FetchUserExistenceUseCase(getIt<CommonRepository>()))
      ..registerLazySingleton<FetchPostsUseCase>(() => FetchPostsUseCase(getIt<PostRepository>()))
      ..registerLazySingleton<FetchMyPostsUseCase>(() => FetchMyPostsUseCase(getIt<PostRepository>()))
      ..registerLazySingleton<FetchPostDetailsUseCase>(() => FetchPostDetailsUseCase(getIt<PostRepository>()));
  }
}
