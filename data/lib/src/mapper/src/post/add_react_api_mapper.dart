import 'package:data/src/dto/src/post/add_react_dto.dart';
import 'package:entity/entity.dart';

extension AddReactApiMapper on AddReactDto {
  ReactionEntity toEntity() {
    final reaction = data;

    return reaction.toEntity();
  }
}

extension AddReactDataMapper on AddReactData? {
  ReactionEntity toEntity() => ReactionEntity(
    postId: this?.postId ?? '',
    react: this?.react ?? '',
    reactionCount: this?.reactionCount ?? 0,
  );
}
