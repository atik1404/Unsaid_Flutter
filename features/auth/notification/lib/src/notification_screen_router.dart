import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:notification/src/notification_screen.dart';
import 'package:notification/src/state/notification_cubit.dart';

final class NotificationScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.notificationPath,
        name: AppRouteName.notificationScreen,
        builder: (context, state) => BlocProvider(
          create: (_) => NotificationCubit(),
          child: const NotificationScreen(),
        ),
        routes: children,
      ),
    ];
  }
}
