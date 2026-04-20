import 'package:go_router/go_router.dart';

abstract class BaseRouter {
  List<RouteBase> routes({List<RouteBase> children = const []});
}
