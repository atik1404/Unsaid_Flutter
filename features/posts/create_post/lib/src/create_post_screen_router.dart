import 'package:create_post/src/create_post_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

final class CreatePostScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.createPostPath,
        name: AppRouteName.createPostScreen,
        builder: (context, state) => const CreatePostScreen(),
        routes: children,
      ),
    ];
  }
}
