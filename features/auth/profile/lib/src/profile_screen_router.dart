import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/profile_screen.dart';
import 'package:profile/src/state/profile_cubit.dart';

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
        builder: (context, state) => BlocProvider(
          create: (_) => ProfileCubit(),
          child: const ProfileScreen(),
        ),
        routes: children,
      ),
    ];
  }
}
