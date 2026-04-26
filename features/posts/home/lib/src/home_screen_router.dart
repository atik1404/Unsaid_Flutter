import 'package:go_router/go_router.dart';
import 'package:home/src/home_screen.dart';
import 'package:navigation/navigation.dart';

final class HomeScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.homePath,
        name: AppRouteName.homeScreen,
        builder: (context, state) => const HomeScreen(),
        routes: children,
      ),
    ];
  }
}