import 'package:change_password/src/change_password_screen.dart';
import 'package:change_password/src/state/change_password_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

/// Router definition for the Change Password screen.
///
/// Wraps [ChangePasswordScreen] in a [BlocProvider] so the cubit is
/// scoped to this route's widget sub-tree.
final class ChangePasswordScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.changePasswordPath,
        name: AppRouteName.changePasswordScreen,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => ChangePasswordCubit(),
            child: const ChangePasswordScreen(),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
