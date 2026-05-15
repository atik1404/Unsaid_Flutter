import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:otp_verification/src/otp_verification_screen.dart';

final class OtpVerificationScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.otpVerificationPath,
        name: AppRouteName.otpVerificationScreen,
        pageBuilder: (_, state) {
          final phone = state.extra as String? ?? '';
          return buildPageWithTransition(
            state: state,
            child: OtpVerificationScreen(phone: phone),
          );
        },
        routes: children,
      ),
    ];
  }
}
