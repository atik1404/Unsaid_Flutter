import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:onboarding/src/onboarding_screen.dart';
import 'package:onboarding/src/state/onboarding_cubit.dart';
import 'package:pref_storage/pref_storage.dart';

/// GoRouter configuration for the onboarding feature.
///
/// Provides [OnboardingCubit] via [BlocProvider] so the cubit's lifetime is
/// scoped to this route — it is created on entry and disposed on exit.
/// [AppPrefStorage] is resolved from the service locator so this router
/// has no direct dependency on the DI setup.
final class OnboardingScreenRouter implements BaseRouter {
  /// Returns the [GoRoute] for the onboarding screen.
  ///
  /// Pass [children] to nest sub-routes under this route (rarely needed for
  /// onboarding, but the parameter keeps the API consistent with other routers).
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.onboardingPath,
        name: AppRouteName.onboardingScreen,
        pageBuilder: (context, state) => buildPageWithTransition(
          state: state,
          child: BlocProvider(
            create: (_) => OnboardingCubit(
              prefStorage: GetIt.I.get<AppPrefStorage>(),
              analytics: GetIt.I.get<AnalyticsTracker>(),
            ),
            child: OnboardingScreen(
              onNavigateToHomeScreen: () {
                context.goNamed(AppRouteName.homeScreen);
              },
            ),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
