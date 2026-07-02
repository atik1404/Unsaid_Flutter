import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

/// Use case that fetches the list of available topics (`GET /get_topics`).
///
/// Takes no parameters, so it extends [UseCaseNoParams]. It simply delegates to
/// the [PostRepository], keeping the domain layer free of transport details and
/// preserving the `Result<Success, Failure>` error-wrapping convention used
/// across the codebase.
final class FetchTopicsUseCase extends UseCaseNoParams<List<TopicEntity>> {
  final PostRepository _repository;

  FetchTopicsUseCase(this._repository);

  @override
  Future<Result<List<TopicEntity>, Failure>> call() {
    return _repository.fetchTopics();
  }
}
