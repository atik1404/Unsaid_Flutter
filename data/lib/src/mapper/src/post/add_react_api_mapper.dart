import 'package:data/src/dto/src/post/post_react_submit_dto.dart';
import 'package:entity/entity.dart';

extension AddReactApiMapper on PostReactSubmitDto {
  ReactionEntity toEntity() {
    final reaction = data;

    return reaction.toEntity();
  }
}

extension AddReactDataMapper on ReactData? {
  ReactionEntity toEntity() => ReactionEntity(
    postId: this?.postId ?? '',
    react: this?.react ?? '',
    reactionCount: this?.reactionCount ?? 0,
  );
}
