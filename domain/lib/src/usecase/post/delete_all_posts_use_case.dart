import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';

/// Permanently deletes all posts authored by the authenticated user
/// (`DELETE /profile/posts`).
///
/// Takes no parameters, so it extends [UseCaseNoParams]. Returns the server
/// success message (a plain [String]) on success.
final class DeleteAllPostsUseCase extends UseCaseNoParams<String> {
  final PostRepository _repository;

  DeleteAllPostsUseCase(this._repository);

  @override
  Future<Result<String, Failure>> call() {
    return _repository.deleteAllPosts();
  }
}
