import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:splash/src/splash_screen.dart';
import 'package:splash/src/state/splash_cubit.dart';

final class SplashScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: '/',
        name: AppRouteName.splash,
        pageBuilder: (context, state) => buildPageWithTransition(
          state: state,
          child: BlocProvider(
            create: (_) => SplashCubit(),
            child: SplashScreen(
              navigateToNextScreen: (redirect) => context.goNamed(redirect),
            ),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
