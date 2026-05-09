import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:post_details/src/post_details_screen.dart';
import 'package:post_details/src/state/post_details_cubit.dart';
import 'package:post_details/src/state/post_details_model.dart';

/// Router definition for the Post Details screen.
///
/// Expects a [PostDetailsModel] to be passed via [GoRouterState.extra].
/// Creates a [PostDetailsCubit] and immediately sets the post data.
final class PostDetailsScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.postDetailsPath,
        name: AppRouteName.postDetailsScreen,
        builder: (context, state) {
          final postId = state.extra as String?;
          return BlocProvider(
            create: (_) => PostDetailsCubit()..fetchPostDetails(postId ?? ''),
            child: const PostDetailsScreen(),
          );
        },
        routes: children,
      ),
    ];
  }
}
