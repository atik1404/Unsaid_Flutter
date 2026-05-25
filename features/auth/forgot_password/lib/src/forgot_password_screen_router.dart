import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgot_password/forgot_password.dart';
import 'package:forgot_password/src/state/forgot_password_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:domain/domain.dart';

final class ForgotPasswordScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.forgotPasswordPath,
        name: AppRouteName.forgotPasswordScreen,
        pageBuilder: (_, state) => buildPageWithTransition(
          state: state,
          child: BlocProvider(create: (_) => ForgotPasswordCubit(GetIt.I<FetchUserExistenceUseCase>()), child: const ForgotPasswordScreen()),
        ),
        routes: children,
      ),
    ];
  }
}
