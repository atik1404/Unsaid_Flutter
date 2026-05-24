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
          final extra = state.extra as Map<String, String>? ?? {};
          final phone = extra['phone'] ?? '';
          final verificationId = extra['verificationId'] ?? '';
          return buildPageWithTransition(
            state: state,
            child: OtpVerificationScreen(phone: phone, verificationId: verificationId),
          );
        },
        routes: children,
      ),
    ];
  }
}
