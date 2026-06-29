/// Domain representation of a successful post creation.
///
/// Mirrors the lightweight acknowledgement returned by `POST /posts`.
final class CreatePostEntity {
  final int statusCode;
  final String message;

  const CreatePostEntity({required this.statusCode, required this.message});
}
