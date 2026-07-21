import 'package:change_password/src/change_password_screen.dart';
import 'package:change_password/src/state/change_password_cubit.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

/// Router definition for the Change Password screen.
///
/// Wraps [ChangePasswordScreen] in a [BlocProvider] so the cubit — with its
/// injected [ChangePasswordUseCase] — is scoped to this route's sub-tree.
final class ChangePasswordScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.changePasswordPath,
        name: AppRouteName.changePasswordScreen,
        pageBuilder: (_, state) => buildPageWithTransition(
          state: state,
          child: BlocProvider(
            create: (_) => ChangePasswordCubit(
              changePasswordUseCase: GetIt.I<ChangePasswordUseCase>(),
            ),
            child: const ChangePasswordScreen(),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
