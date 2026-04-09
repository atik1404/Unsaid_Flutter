import 'package:common/common.dart';

final class BaseUseCase {
  const BaseUseCase();
}

/// Remote use case with parameters.
/// [Params] - the input parameter type.
/// [S] - the success return type.
///
/// For local database use cases, create separate base classes
/// (e.g. `LocalUseCase`, `LocalUseCaseNoParams`).
abstract class UseCase<S, Params> {
  Future<Result<S, Failure>> call(Params params);
}

/// Remote use case without parameters.
/// [S] - the success return type.
abstract class UseCaseNoParams<S> {
  Future<Result<S, Failure>> call();
}
