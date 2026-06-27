import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class AddCommentUseCase extends UseCase<CommentEntity, AddCommentParams> {
  final PostRepository _repository;

  AddCommentUseCase(this._repository);

  @override
  Future<Result<CommentEntity, Failure>> call(AddCommentParams params) async {
    final result = await _repository.addComment(params);

    return result;
  }
}
