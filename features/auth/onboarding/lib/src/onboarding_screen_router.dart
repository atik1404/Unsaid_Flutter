import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:onboarding/src/onboarding_screen.dart';
import 'package:onboarding/src/state/onboarding_cubit.dart';
import 'package:sharedpref/sharedpref.dart';

final class OnboardingScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.onboardingPath,
        name: AppRouteName.onboardingScreen,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => OnboardingCubit(sharedPrefs: GetIt.I.get<SharedPrefManager>()),
            child: OnboardingScreen(),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
