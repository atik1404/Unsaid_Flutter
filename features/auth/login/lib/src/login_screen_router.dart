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
        builder: (context, state) => const LoginScreen(),
        routes: children,
      ),
    ];
  }
}
