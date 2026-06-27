import 'package:json_annotation/json_annotation.dart';
part 'fetch_posts_params.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
final class FetchPostsParams {
  @JsonKey(name: 'page_size')
  final int pageSize;
  @JsonKey(name: 'page_no')
  final int pageNo;
  final String? mood;

  const FetchPostsParams({
    this.pageSize = 20,
    this.pageNo = 1,
    this.mood,
  });

  Map<String, dynamic> toJson() => _$FetchPostsParamsToJson(this);
}
