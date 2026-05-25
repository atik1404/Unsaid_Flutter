import 'package:common/common.dart';
import 'package:entity/entity.dart';

abstract class PostRepository {
  Future<Result<List<PostEntity>, Failure>> fetchPosts();
}
