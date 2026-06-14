import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:post_details/src/post_details_screen.dart';
import 'package:post_details/src/state/post_details_cubit.dart';
import 'package:domain/domain.dart';

/// Router definition for the Post Details screen.
///
/// Expects a [PostDetailsEntity] to be passed via [GoRouterState.extra].
/// Creates a [PostDetailsCubit] and immediately sets the post data.
final class PostDetailsScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.postDetailsPath,
        name: AppRouteName.postDetailsScreen,
        pageBuilder: (_, state) {
          final postId = state.extra as String?;
          return buildPageWithTransition(
            state: state,
            child: BlocProvider(
              create: (_) => PostDetailsCubit(fetchPostDetailsUseCase: GetIt.I<FetchPostDetailsUseCase>())..fetchPostDetails(postId ?? ''),
              child: const PostDetailsScreen(),
            ),
          );
        },
        routes: children,
      ),
    ];
  }
}
