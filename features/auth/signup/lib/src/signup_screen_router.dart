import 'package:go_router/go_router.dart';
import 'package:signup/src/signup_screen.dart';
import 'package:navigation/navigation.dart';

final class SignupScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.signupPath,
        name: AppRouteName.signupScreen,
        builder: (context, state) => const SignupScreen(),
        routes: children,
      ),
    ];
  }
}
