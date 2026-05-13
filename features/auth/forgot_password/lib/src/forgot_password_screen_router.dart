import 'package:forgot_password/forgot_password.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

final class ForgotPasswordScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.forgotPasswordPath,
        name: AppRouteName.forgotPasswordScreen,
        builder: (context, state) => const ForgotPasswordScreen(),
        routes: children,
      ),
    ];
  }
}
