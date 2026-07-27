import 'package:common/common.dart';
import 'package:create_post/src/create_post_screen.dart';
import 'package:create_post/src/state/create_post_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

final class CreatePostScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.createPostPath,
        name: AppRouteName.createPostScreen,
        pageBuilder: (_, state) {
          return buildPageWithTransition(
            state: state,
            child: BlocProvider(
              create: (_) => CreatePostBloc(
                createPostUseCase: GetIt.I.get(),
                fetchTopicsUseCase: GetIt.I.get(),
                analytics: GetIt.I<AnalyticsTracker>(),
              ),
              child: CreatePostScreen(),
            ),
          );
        },
        routes: children,
      ),
    ];
  }
}
