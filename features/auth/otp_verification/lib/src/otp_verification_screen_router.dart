import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:otp_verification/otp_verification.dart';

final class OtpVerificationScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.otpVerificationPath,
        name: AppRouteName.otpVerificationScreen,
        pageBuilder: (context, state) {
          final phone = state.extra as String? ?? '';
          return buildPageWithTransition(
            context: context,
            state: state,
            child: OtpVerificationScreen(phone: phone),
          );
        },
        routes: children,
      ),
    ];
  }
}
