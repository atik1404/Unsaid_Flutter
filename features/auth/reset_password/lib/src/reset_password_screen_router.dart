import 'package:change_password/src/change_password_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:reset_password/src/reset_password_screen.dart';
import 'package:reset_password/src/state/reset_password_cubit.dart';

/// Router definition for the Change Password screen.
///
/// Wraps [ChangePasswordScreen] in a [BlocProvider] so the cubit is
/// scoped to this route's widget sub-tree.
final class ResetPasswordScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.resetPasswordPath,
        name: AppRouteName.resetPasswordScreen,
        pageBuilder: (_, state) => buildPageWithTransition(
          state: state,
          child: BlocProvider(create: (_) => ResetPasswordCubit(), child: const ResetPasswordScreen()),
        ),
        routes: children,
      ),
    ];
  }
}
