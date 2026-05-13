import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:otp_verification/src/state/otp_verification_cubit.dart';
import 'package:otp_verification/src/state/otp_verification_state.dart';
import 'package:ui/ui.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpVerificationCubit(),
      child: _OtpVerificationScreenView(phone: phone),
    );
  }
}

class _OtpVerificationScreenView extends StatefulWidget {
  const _OtpVerificationScreenView({required this.phone});

  final String phone;

  @override
  State<_OtpVerificationScreenView> createState() =>
      _OtpVerificationScreenViewState();
}

class _OtpVerificationScreenViewState
    extends State<_OtpVerificationScreenView> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

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

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    final otp = _controllers.map((c) => c.text).join();
    context.read<OtpVerificationCubit>().updateOtp(otp);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableGradientBackground: true,
      body: _buildOtpUi(context),
    );
  }

  Widget _buildOtpUi(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: pagePadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - pagePadding.vertical,
            ),
            child: BlocListener<OtpVerificationCubit, OtpVerificationState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  final message = switch (state.errorMessage) {
                    'incomplete' => context.l10n.otp_error_incomplete,
                    'invalid' => context.l10n.otp_error_invalid,
                    _ => state.errorMessage!,
                  };
                  AppToast.toast(message: message, toastType: ToastType.error);
                } else if (state.isSuccess) {
                  AppToast.toast(
                    message: context.l10n.otp_success,
                    toastType: ToastType.success,
                  );
                  context.goNamed(AppRouteName.homeScreen);
                }
              },
              child: _buildContent(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(context),
        SizedBox(height: AppSpacing.s32.h),
        _buildOtpBoxes(context),
        SizedBox(height: AppSpacing.s32.h),
        _buildVerifyButton(context),
        gap,
        _buildResendSection(context),
        gap,
        _buildBackToLoginLink(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppImage.asset(
          AppDrawables.logoTransparent,
          width: 100.w,
          height: 100.h,
        ),
        SizedBox(height: AppSpacing.s16.h),
        AppText.titleLarge(
          context.l10n.otp_title,
          textWeight: AppTextWeight.extraBold,
        ),
        SizedBox(height: AppSpacing.s8.h),
        AppText.bodySmall(
          context.l10n.otp_subtitle(widget.phone),
          textAlign: TextAlign.center,
          textWeight: AppTextWeight.light,
          color: context.appColors.white,
        ),
      ],
    );
  }

  Widget _buildOtpBoxes(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => _buildOtpBox(context, index),
      ),
    );
  }

  Widget _buildOtpBox(BuildContext context, int index) {
    final colors = context.appColors;
    return SizedBox(
      width: 44.w,
      height: 54.h,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[index].text.isEmpty &&
              index > 0) {
            _focusNodes[index - 1].requestFocus();
            _controllers[index - 1].clear();
            final otp = _controllers.map((c) => c.text).join();
            context.read<OtpVerificationCubit>().updateOtp(otp);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          maxLength: 1,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: colors.white,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: colors.white.withValues(alpha: 0.12),
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: BorderSide(
                color: colors.white.withValues(alpha: 0.3),
                width: AppBorderWidth.thin,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: BorderSide(
                color: colors.white,
                width: AppBorderWidth.thick,
              ),
            ),
          ),
          onChanged: (value) => _onDigitChanged(value, index),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
      builder: (context, state) {
        return AppFilledButton.text(
          context.l10n.otp_button,
          isLoading: state.isVerifying,
          onPressed: () => context.read<OtpVerificationCubit>().verify(),
        );
      },
    );
  }

  Widget _buildResendSection(BuildContext context) {
    return BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
      builder: (context, state) {
        return Column(
          children: [
            AppText.bodySmall(
              context.l10n.otp_resend_prompt,
              textWeight: AppTextWeight.light,
              color: context.appColors.white,
            ),
            SizedBox(height: AppSpacing.s4.h),
            if (state.canResend)
              AppTextButton(
                context.l10n.otp_resend_button,
                onPressed: () {
                  for (final c in _controllers) {
                    c.clear();
                  }
                  _focusNodes.first.requestFocus();
                  context.read<OtpVerificationCubit>().resendOtp();
                },
                style: const AppTextButtonStyle(
                  intent: AppButtonIntent.secondary(),
                ),
              )
            else
              AppText.bodySmall(
                context.l10n.otp_resend_timer(state.timerSeconds),
                textWeight: AppTextWeight.medium,
                color: context.appColors.white.withValues(alpha: 0.6),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBackToLoginLink(BuildContext context) {
    return AppTextButton(
      context.l10n.forgot_password_back_to_login,
      onPressed: () => context.goNamed(AppRouteName.loginScreen),
      style: const AppTextButtonStyle(
        intent: AppButtonIntent.secondary(),
      ),
    );
  }
}
