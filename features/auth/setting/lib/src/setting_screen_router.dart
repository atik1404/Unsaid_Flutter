import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:setting/src/setting_screen.dart';
import 'package:setting/src/state/setting_cubit.dart';

/// Router definition for the Settings screen.
///
/// Wraps [SettingScreen] in a [BlocProvider] so the cubit is scoped
/// to this route's widget sub-tree.
final class SettingScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.settingPath,
        name: AppRouteName.settingScreen,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => SettingCubit(),
            child: const SettingScreen(),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
