import 'package:common/common.dart';
import 'package:domain/src/params/fetch_posts_params.dart';
import 'package:entity/entity.dart';

abstract class PostRepository {
  Future<Result<PostPagerEntity, Failure>> fetchPosts(FetchPostsParams params);
}
