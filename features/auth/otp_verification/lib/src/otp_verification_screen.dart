import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:otp_verification/src/state/otp_verification_cubit.dart';
import 'package:otp_verification/src/state/otp_verification_state.dart';
import 'package:ui/ui.dart';

/// Entry point for the OTP verification feature (the "smart" widget).
///
/// This widget is stateful because it owns the per-digit [TextEditingController]s
/// and [FocusNode]s that drive the code boxes — concerns that don't belong in
/// the BLoC. It hosts the [BlocListener] for side effects (toast on error,
/// navigation on success) and delegates all rendering to the const "dumb"
/// widgets below so only the subtrees wrapped in a [BlocBuilder] rebuild.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.phone, required this.verificationId, required this.otpPurpose});

  final String phone;
  final String verificationId;
  final String otpPurpose;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  /// One controller/focus node per digit box.
  final List<TextEditingController> _controllers = List.generate(AppConstants.otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(AppConstants.otpLength, (_) => FocusNode());

  String get _otpCode => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);

    return AppScaffold(
      enableGradientBackground: true,
      // Keep the keyboard up while entering the code: stray taps in the gaps
      // between the small digit boxes must not collapse the soft keyboard.
      dismissKeyboardOnTap: false,
      body: BlocListener<OtpVerificationCubit, OtpVerificationState>(
        // React only to error/success transitions, not to every timer tick.
        listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage || prev.isSuccess != curr.isSuccess,
        listener: _onStateChanged,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: pagePadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - pagePadding.vertical),
                child: _buildContent(context),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _OtpHeader(phone: widget.phone),
        SizedBox(height: AppSpacing.s32.h),

        // The code boxes are owned by this stateful widget (controllers/focus),
        // so they live here rather than in a const widget.
        _buildOtpFields(),
        SizedBox(height: AppSpacing.s32.h),

        // Rebuilds only while a verification request is in flight.
        BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
          buildWhen: (prev, curr) => prev.isVerifying != curr.isVerifying,
          builder: (context, state) {
            return _VerifyButton(isLoading: state.isVerifying, onPressed: () => context.read<OtpVerificationCubit>().verifyOtp());
          },
        ),
        gap,

        // Rebuilds once per second (timer) — scoped so nothing else rebuilds.
        BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
          buildWhen: (prev, curr) => prev.canResend != curr.canResend || prev.timerSeconds != curr.timerSeconds,
          builder: (context, state) {
            return _ResendSection(canResend: state.canResend, timerSeconds: state.timerSeconds, onResend: _onResend);
          },
        ),
        gap,
        _BackToLoginLink(onPressed: () => context.goNamed(AppRouteName.loginScreen)),
      ],
    );
  }

  /// Lays out the row of single-digit input boxes.
  Widget _buildOtpFields() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s16.w,
      children: List.generate(
        AppConstants.otpLength,
        (index) => _OtpBox(controller: _controllers[index], focusNode: _focusNodes[index], isLast: index == AppConstants.otpLength - 1, onChanged: (value) => _onDigitChanged(value, index)),
      ),
    );
  }

  /// Advances/retreats focus as digits are typed or cleared, then pushes the
  /// concatenated code into the cubit.
  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < AppConstants.otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    // Move focus backward when a digit is cleared.
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    context.read<OtpVerificationCubit>().updateOtp(_otpCode);
  }

  /// Clears the boxes, refocuses the first one and requests a new code.
  void _onResend() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    context.read<OtpVerificationCubit>().resendOtp();
  }

  /// Side-effect handler for terminal states: toast on error, route on success.
  void _onStateChanged(BuildContext context, OtpVerificationState state) {
    if (state.errorMessage != null) {
      final message = switch (state.errorMessage) {
        'incomplete' => context.l10n.otp_error_incomplete,
        'invalid' => context.l10n.otp_error_invalid,
        _ => state.errorMessage!,
      };
      AppToast.toast(message: message, toastType: ToastType.error);
    } else if (state.isSuccess) {
      _onOtpVerificationSuccess();
    }
  }

  /// Routes onward based on why OTP verification was requested.
  void _onOtpVerificationSuccess() {
    if (widget.otpPurpose == AppConstants.otpVerificationForResetPassword) {
      context.pushReplacementNamed(AppRouteName.resetPasswordScreen);
    } else if (widget.otpPurpose == AppConstants.otpVerificationForSignUp) {
      context.pop(true); // Return true to indicate successful OTP verification for sign-up flow.
    }
  }
}

/// Logo, title and subtitle (which echoes the destination [phone] number).
class _OtpHeader extends StatelessWidget {
  final String phone;

  const _OtpHeader({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppImage.asset(AppDrawables.logoTransparent, width: IconSizes.display.w, height: IconSizes.display.h),
        SizedBox(height: AppSpacing.s16.h),
        AppText.titleLarge(context.l10n.otp_title, textWeight: AppTextWeight.extraBold),
        SizedBox(height: AppSpacing.s8.h),
        AppText.bodySmall(context.l10n.otp_subtitle(phone), textAlign: TextAlign.center, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
      ],
    );
  }
}

/// A single OTP digit box. Stateless: the controller/focus are owned by the
/// parent so this widget only describes how one box looks and behaves.
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLast;
  final ValueChanged<String> onChanged;

  const _OtpBox({required this.controller, required this.focusNode, required this.isLast, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54.w,
      height: 54.h,
      child: AppInputField(
        controller: controller,
        focusNode: focusNode,
        variant: AppInputFieldVariant.filledOpt,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
        maxLength: 1,
        size: AppInputFieldSize.md,
        onChanged: onChanged,
      ),
    );
  }
}

/// Submit button with an inline spinner while verifying; disabled in flight to
/// prevent duplicate submissions.
class _VerifyButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _VerifyButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppFilledButton.text(context.l10n.otp_button, isLoading: isLoading, onPressed: isLoading ? null : onPressed);
  }
}

/// Resend prompt: shows the countdown until the code can be resent, then swaps
/// to a tappable resend action once [canResend] is true.
class _ResendSection extends StatelessWidget {
  final bool canResend;
  final int timerSeconds;
  final VoidCallback onResend;

  const _ResendSection({required this.canResend, required this.timerSeconds, required this.onResend});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText.bodySmall(context.l10n.otp_resend_prompt, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
        SizedBox(height: AppSpacing.s4.h),
        if (canResend)
          AppTextButton(
            context.l10n.otp_resend_button,
            onPressed: onResend,
            style: const AppTextButtonStyle(intent: AppButtonIntent.secondary()),
          )
        else
          AppText.bodySmall(context.l10n.otp_resend_timer(timerSeconds), textWeight: AppTextWeight.medium, color: context.appColors.contentSubtle),
      ],
    );
  }
}

/// Link that abandons verification and returns to the login screen.
class _BackToLoginLink extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackToLoginLink({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      context.l10n.forgot_password_back_to_login,
      onPressed: onPressed,
      style: const AppTextButtonStyle(intent: AppButtonIntent.secondary()),
    );
  }
}
