import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:splash/src/splash_screen.dart';

final class SplashScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: '/',
        name: AppRouteName.splash,
        builder: (context, state) => const SplashScreen(),
        routes: children,
      ),
    ];
  }
}
