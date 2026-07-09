import 'package:domain/domain.dart';
import 'package:edit_profile/src/edit_profile_screen.dart';
import 'package:edit_profile/src/state/edit_profile_cubit.dart';
import 'package:entity/entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

/// Router definition for the Edit Profile screen.
///
/// Wraps [EditProfileScreen] in a [BlocProvider] so the cubit — seeded with the
/// [ProfileEntity] passed as the route's `extra` and its injected
/// [UpdateProfileUseCase] — is scoped to this route's sub-tree.
final class EditProfileScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.editProfilePath,
        name: AppRouteName.editProfileScreen,
        pageBuilder: (_, state) {
          final profile = state.extra as ProfileEntity;
          return buildPageWithTransition(
            state: state,
            child: BlocProvider(
              create: (_) => EditProfileCubit(
                updateProfileUseCase: GetIt.I<UpdateProfileUseCase>(),
                profile: profile,
              ),
              child: const EditProfileScreen(),
            ),
          );
        },
        routes: children,
      ),
    ];
  }
}
