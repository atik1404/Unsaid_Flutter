import 'package:entity/entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:common/common.dart';
import 'package:signup/src/signup_screen.dart';
import 'package:navigation/navigation.dart';
import 'package:signup/src/state/signup_bloc.dart';

final class SignupScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.signupPath,
        name: AppRouteName.signupScreen,
        pageBuilder: (context, state) => buildPageWithTransition(
          state: state,
          // Navigation is owned by the router and injected into the screen,
          // keeping the widget free of routing concerns and easy to test.
          child: BlocProvider(
            create: (context) => SignupBloc(),
            child: SignupScreen(
              onSignUpSuccess: () => context.goNamed(AppRouteName.homeScreen),
              onSignInPressed: () => context.pop(),
              onVerifyPhone: (phoneNumber) => context.pushNamed(
                AppRouteName.otpVerificationScreen,
                extra: OtpVerificationArgs(verificationId: '', phoneNumber: phoneNumber, otpPurpose: AppConstants.otpVerificationForSignUp),
              ),
            ),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
