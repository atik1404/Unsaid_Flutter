import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/profile_screen.dart';
import 'package:profile/src/state/profile_bloc.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

/// Router definition for the Profile screen.
///
/// Wraps [ProfileScreen] in a [BlocProvider] so the cubit is scoped
/// to this route's widget sub-tree.
final class ProfileScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.profilePath,
        name: AppRouteName.profileScreen,
        pageBuilder: (_, state) => buildPageWithTransition(
          state: state,
          child: BlocProvider(
            create: (_) => ProfileBloc(
              fetchProfileUseCase: GetIt.I.get<FetchProfileUseCase>(),
              fetchMyPostsUseCase: GetIt.I.get<FetchMyPostsUseCase>(),
            ),
            child: const ProfileScreen(),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
