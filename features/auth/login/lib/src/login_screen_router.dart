import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:login/src/bloc/login_bloc.dart';
import 'package:login/src/login_screen.dart';
import 'package:navigation/navigation.dart';
import 'package:pref_storage/pref_storage.dart';

final class LoginScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.loginPath,
        name: AppRouteName.loginScreen,
        pageBuilder: (context, state) => buildPageWithTransition(
          state: state,
          child: BlocProvider(
            create: (_) => LoginBloc(
              loginUseCase: GetIt.instance<LoginUseCase>(),
              fetchProfileUseCase: GetIt.instance<FetchProfileUseCase>(),
              appPrefStorage: GetIt.instance<AppPrefStorage>(),
            ),
            child: LoginScreen(
              // Flipping the auth state makes GoRouter re-run the guard via
              // refreshListenable: the login route then redirects to the
              // pending `redirect` query param (or home).
              onLoginSuccess: () {
                authStateNotifier.setLoggedIn(isLoggedIn: true);
                context.goNamed(AppRouteName.homeScreen);
              },
              onSignUpPressed: () =>
                  context.pushNamed(AppRouteName.signupScreen),
              onForgotPasswordPressed: () =>
                  context.pushNamed(AppRouteName.forgotPasswordScreen),
            ),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
