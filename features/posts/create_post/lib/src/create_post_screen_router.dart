import 'package:create_post/src/create_post_screen.dart';
import 'package:create_post/src/state/create_post_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:pref_storage/pref_storage.dart';

final class CreatePostScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.createPostPath,
        name: AppRouteName.createPostScreen,
        pageBuilder: (_, state) {
          final prefStorage = GetIt.I.get<AppPrefStorage>();
          final fullname = prefStorage.getString(PrefKey.fullName);
          return buildPageWithTransition(
            state: state,
            child: BlocProvider(
              create: (_) => CreatePostBloc(createPostUseCase: GetIt.I.get()),
              child: CreatePostScreen(fullname: fullname.toString()),
            ),
          );
        },
        routes: children,
      ),
    ];
  }
}
