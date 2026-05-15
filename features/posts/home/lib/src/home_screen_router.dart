import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:home/src/home_screen.dart';
import 'package:home/src/state/home_cubit.dart';
import 'package:navigation/navigation.dart';

final class HomeScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.homePath,
        name: AppRouteName.homeScreen,
        pageBuilder: (_, state) => buildPageWithTransition(
          state: state,
          child: BlocProvider(
            create: (_) => HomeCubit(),
            child: const HomeScreen(),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
