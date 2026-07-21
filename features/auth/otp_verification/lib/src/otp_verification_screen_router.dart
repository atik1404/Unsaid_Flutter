import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:entity/entity.dart';
import 'package:otp_verification/src/otp_verification_screen.dart';
import 'package:otp_verification/src/state/otp_verification_cubit.dart';

final class OtpVerificationScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.otpVerificationPath,
        name: AppRouteName.otpVerificationScreen,
        pageBuilder: (_, state) {
          final extra = state.extra! as OtpVerificationArgs;
          final phone = extra.phoneNumber;
          final verificationId = extra.verificationId;
          final otpPurpose = extra.otpPurpose;
          return buildPageWithTransition(
            state: state,
            child: BlocProvider(
              create: (_) => OtpVerificationCubit(
                phone: phone,
                verificationId: verificationId,
              ),
              child: OtpVerificationScreen(
                phone: phone,
                verificationId: verificationId,
                otpPurpose: otpPurpose,
              ),
            ),
          );
        },
        routes: children,
      ),
    ];
  }
}
