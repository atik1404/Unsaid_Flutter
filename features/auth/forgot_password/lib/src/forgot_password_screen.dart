import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:entity/entity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forgot_password/src/state/forgot_password_cubit.dart';
import 'package:forgot_password/src/state/forgot_password_state.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:ui/ui.dart';

/// Entry point for the forgot-password feature (the "smart" widget).
///
/// Owns the [BlocListener] that reacts to terminal submission states —
/// navigating to OTP verification on success and surfacing a toast on
/// failure — and lays out the static page chrome. Every presentational piece
/// is extracted into a const "dumb" widget below, so only the small subtrees
/// wrapped in a [BlocBuilder] rebuild when state changes.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);

    return AppScaffold(
      enableGradientBackground: true,
      body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        // Only react when the submission status changes to avoid duplicate
        // navigation/toasts triggered by unrelated field updates.
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: _onStateChanged,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: pagePadding,
              child: ConstrainedBox(
                // Let the form fill the viewport so it can center vertically.
                constraints: BoxConstraints(minHeight: constraints.maxHeight - pagePadding.vertical),
                child: const _ForgotPasswordForm(),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Handles terminal states: go to OTP verification on success, toast on
  /// failure. Pure side effects — no rebuilding happens here.
  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    if (state.status.isSuccess) {
      context.pushReplacementNamed(
        AppRouteName.otpVerificationScreen,
        extra: OtpVerificationArgs(verificationId: state.accountId ?? '', phoneNumber: state.phone.value, otpPurpose: AppConstants.otpVerificationForResetPassword),
      );
    } else if (state.status.isFailure && state.errorMessage != null) {
      AppToast.toast(message: state.errorMessage!, toastType: ToastType.error);
    }
  }
}

/// The form body. Static text and layout live here directly; the phone field
/// and submit button are each wrapped in their own narrowly-scoped
/// [BlocBuilder] so a keystroke only rebuilds the field it affects rather than
/// the whole form.
class _ForgotPasswordForm extends StatelessWidget {
  const _ForgotPasswordForm();

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _ForgotPasswordHeader(),
        gap,
        gap,
        AppText.bodySmall(context.l10n.forgot_password_label_phone, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
        SizedBox(height: AppSpacing.s4.h),

        // Rebuilds only when the phone input or its error visibility changes.
        BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          buildWhen: (prev, curr) => prev.phone != curr.phone || prev.showError != curr.showError,
          builder: (context, state) {
            return _PhoneInput(
              errorText: state.showError && state.phone.isNotValid ? _phoneErrorText(context, state.phone.error) : null,
              onChanged: (value) => context.read<ForgotPasswordCubit>().updatePhone(value),
            );
          },
        ),

        gap,
        gap,
        // Rebuilds only when the submission status (loading) changes.
        BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (context, state) {
            return _SendOtpButton(
              isLoading: state.status.isInProgress,
              onPressed: () => {
                //context.read<ForgotPasswordCubit>().checkUserExistence()
                context.pushNamed(
                  AppRouteName.otpVerificationScreen,
                  extra: OtpVerificationArgs(otpPurpose: '', phoneNumber: '', verificationId: ''),
                ),
              },
            );
          },
        ),
        gap,
        const _BackToLoginLink(),
      ],
    );
  }

  /// Maps a Formz [ValidationError] to a localized phone-field message.
  String _phoneErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.empty => context.l10n.validation_phone_required,
      ValidationError.invalid => context.l10n.validation_phone_invalid,
      _ => '',
    };
  }
}

// ── Dumb presentational widgets ─────────────────────────────────────────────

/// Logo, title and subtitle. Fully static, so it can be `const`.
class _ForgotPasswordHeader extends StatelessWidget {
  const _ForgotPasswordHeader();

  @override
  Widget build(BuildContext context) {
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
}

/// Phone number field. Stateless: receives the (optional) error text and
/// reports changes upward via [onChanged].
class _PhoneInput extends StatelessWidget {
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _PhoneInput({this.errorText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.forgot_password_hint_phone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      variant: AppInputFieldVariant.filledOpt,
      maxLength: 11,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}

/// Submit button that shows a spinner while the request is in flight and is
/// disabled to prevent duplicate submissions.
class _SendOtpButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SendOtpButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppFilledButton.text(context.l10n.forgot_password_button, isLoading: isLoading, onPressed: isLoading ? null : onPressed);
  }
}

/// Link that pops back to the login screen.
class _BackToLoginLink extends StatelessWidget {
  const _BackToLoginLink();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: AppTextButton(
        context.l10n.forgot_password_back_to_login,
        onPressed: () => context.pop(),
        style: const AppTextButtonStyle(intent: AppButtonIntent.secondary()),
      ),
    );
  }
}
