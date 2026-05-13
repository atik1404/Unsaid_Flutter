import 'package:go_router/go_router.dart';
import 'package:login/src/login_screen.dart';
import 'package:navigation/navigation.dart';

final class LoginScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.loginPath,
        name: AppRouteName.loginScreen,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
        routes: children,
      ),
    ];
  }
}
