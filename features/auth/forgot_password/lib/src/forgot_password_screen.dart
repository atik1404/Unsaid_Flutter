import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forgot_password/src/state/forgot_password_cubit.dart';
import 'package:forgot_password/src/state/forgot_password_state.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:ui/ui.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(enableGradientBackground: true, body: _buildForgotPasswordUi(context));
  }

  Widget _buildForgotPasswordUi(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: pagePadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - pagePadding.vertical),
            child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  final message = state.errorMessage == 'empty_phone' ? context.l10n.forgot_password_error_empty_phone : state.errorMessage!;
                  AppLog.log('  ForgotPasswordScreen - OTP send error: $message');
                  AppToast.toast(message: message, toastType: ToastType.error);
                } else if (state.isSuccess) {
                  AppToast.toast(message: context.l10n.forgot_password_success, toastType: ToastType.success);
                  context.goNamed(AppRouteName.otpVerificationScreen, extra: {'phone': state.phone.value, 'verificationId': state.verificationId ?? ''});
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(context),
        gap,
        gap,
        AppText.bodySmall(context.l10n.forgot_password_label_phone, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
        SizedBox(height: AppSpacing.s4.h),
        _buildPhoneInput(context),

        gap,
        gap,
        _buildSendOtpButton(context),
        gap,
        _buildBackToLoginLink(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppImage.asset(AppDrawables.logoTransparent, width: IconSizes.display.w, height: IconSizes.display.h),
        SizedBox(height: AppSpacing.s16.h),
        AppText.titleLarge(context.l10n.forgot_password_title, textWeight: AppTextWeight.extraBold),
        SizedBox(height: AppSpacing.s8.h),
        AppText.bodySmall(context.l10n.forgot_password_subtitle, textAlign: TextAlign.center, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
      ],
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInputField(
              hint: context.l10n.forgot_password_hint_phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              variant: AppInputFieldVariant.filledOpt,
              maxLength: 11,
              onChanged: (value) => context.read<ForgotPasswordCubit>().updatePhone(value),
            ),
            if (state.showError && state.phone.isNotValid) _buildFieldError(context, _phoneErrorText(context, state.phone.error)),
          ],
        );
      },
    );
  }

  /// A small red text widget shown below an invalid field.
  Widget _buildFieldError(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.s4.h),
      child: AppText.bodySmall(message, color: context.appColors.contentError, textWeight: AppTextWeight.light),
    );
  }

  String _phoneErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.empty => context.l10n.validation_phone_required,
      ValidationError.invalid => context.l10n.validation_phone_invalid,
      _ => '',
    };
  }

  Widget _buildSendOtpButton(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return AppFilledButton.text(context.l10n.forgot_password_button, isLoading: state.isSubmitting, onPressed: () => context.read<ForgotPasswordCubit>().sendOtp());
      },
    );
  }

  Widget _buildBackToLoginLink(BuildContext context) {
    return Align(
      child: AppTextButton(
        context.l10n.forgot_password_back_to_login,
        onPressed: () => context.pop(),
        style: const AppTextButtonStyle(intent: AppButtonIntent.secondary()),
      ),
    );
  }
}
