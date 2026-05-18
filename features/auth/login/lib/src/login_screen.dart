import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:login/src/bloc/login_bloc.dart';
import 'package:login/src/bloc/login_event.dart';
import 'package:login/src/bloc/login_state.dart';
import 'package:navigation/navigation.dart';
import 'package:common/common.dart';

/// Entry point for the login feature.
///
/// Provides a fresh [LoginBloc] instance and delegates rendering to
/// [_LoginView] so the BLoC is always available in the widget subtree.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// The stateful UI layer of the login screen.
///
/// Reads [LoginBloc] from context — always available because [LoginScreen]
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      // Listen for terminal states to trigger navigation or error feedback.
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: _onStateChanged,
      child: AppScaffold(
        enableGradientBackground: true,
        body: _buildBody(),
      ),
    );
  }

  void _onStateChanged(BuildContext context, LoginState state) {
    if (state.status == FormzSubmissionStatus.success) {
      context.goNamed(AppRouteName.homeScreen);
    } else if (state.status == FormzSubmissionStatus.failure) {
      final message = state.errorMessage ?? 'Something went wrong';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // ── Layout ────────────────────────────────────────────────────────────────

  Widget _buildBody() {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLoginHeader(context),
                SizedBox(height: AppSpacing.s32.h),
                _buildLoginForm(),
                _buildLoginFooter(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildLoginHeader(BuildContext context) {
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
          context.l10n.login_title,
          textWeight: AppTextWeight.extraBold,
        ),
        SizedBox(height: AppSpacing.s8.h),
        AppText.bodySmall(
          context.l10n.login_subtitle,
          textAlign: TextAlign.center,
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSubtle,
        ),
      ],
    );
  }

  // ── Form ──────────────────────────────────────────────────────────────────

  Widget _buildLoginForm() {
    final gap = SizedBox(height: AppSpacing.s12.h);

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap,
            AppText.bodySmall(
              context.l10n.login_label_phone,
              textWeight: AppTextWeight.light,
              color: context.appColors.contentSubtle,
            ),
            SizedBox(height: AppSpacing.s4.h),
            _buildPhoneField(context, state),
            // Show validation error only after the first submit attempt.
            if (state.showErrors && state.phone.isNotValid) _buildFieldError(context, _phoneErrorText(context, state.phone.error)),
            gap,
            AppText.bodySmall(
              context.l10n.login_label_password,
              textWeight: AppTextWeight.light,
              color: context.appColors.contentSubtle,
            ),
            SizedBox(height: AppSpacing.s4.h),
            _buildPasswordField(context, state),
            if (state.showErrors && state.password.isNotValid) _buildFieldError(context, _passwordErrorText(context, state.password.error)),
            gap,
            gap,
            _buildLoginButton(context, state),
            gap,
            Align(
              child: AppTextButton(
                context.l10n.login_forgot_password,
                onPressed: () => context.pushNamed(AppRouteName.forgotPasswordScreen),
                style: const AppTextButtonStyle(
                  intent: AppButtonIntent.secondary(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhoneField(BuildContext context, LoginState state) {
    return AppInputField(
      hint: context.l10n.login_hint_phone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      variant: AppInputFieldVariant.filledOpt,
      maxLength: 11,
      onChanged: (value) => context.read<LoginBloc>().add(LoginPhoneChanged(value)),
    );
  }

  Widget _buildPasswordField(BuildContext context, LoginState state) {
    return AppInputField(
      hint: context.l10n.login_hint_password,
      obscureText: !state.showPassword,
      variant: AppInputFieldVariant.filledOpt,
      textInputAction: TextInputAction.done,
      maxLength: 20,
      onChanged: (value) => context.read<LoginBloc>().add(LoginPasswordChanged(value)),
      suffixIcon: AppIcon(
        GestureDetector(
          onTap: () => context.read<LoginBloc>().add(const LoginTogglePasswordVisibility()),
          child: Icon(
            state.showPassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginState state) {
    return AppFilledButton.text(
      context.l10n.login_button,
      // Disable the button while a request is in flight.
      onPressed: state.isLoading ? null : () => context.read<LoginBloc>().add(const LoginSubmitted()),
    );
  }

  // ── Validation error helpers ──────────────────────────────────────────────

  /// A small red text widget shown below an invalid field.
  Widget _buildFieldError(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.s4.h),
      child: AppText.bodySmall(
        message,
        color: context.appColors.contentError,
        textWeight: AppTextWeight.light,
      ),
    );
  }

  String _phoneErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.empty => context.l10n.validation_phone_required,
      ValidationError.invalid => context.l10n.validation_phone_invalid,
      _ => '',
    };
  }

  String _passwordErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.empty => context.l10n.validation_password_required,
      ValidationError.tooShort => context.l10n.validation_password_too_short,
      _ => '',
    };
  }

  // ── Footer ────────────────────────────────────────────────────────────────
  Widget _buildLoginFooter(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    return Column(
      children: [
        gap,
        _buildCreateAccount(context),
        gap,
        _buildSocialLoginOptions(context),
      ],
    );
  }

  Widget _buildCreateAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.bodySmall(
          context.l10n.login_create_account_prompt,
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSubtle,
        ),
        AppTextButton(
          context.l10n.login_sign_up,
          onPressed: () => context.pushNamed(AppRouteName.signupScreen),
          style: const AppTextButtonStyle(
            intent: AppButtonIntent.secondary(),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginOptions(BuildContext context) {
    return Column(
      children: [
        AppText.bodySmall(
          context.l10n.login_social_sign_in,
          textWeight: AppTextWeight.extraBold,
          color: context.appColors.contentSubtle,
        ),
        SizedBox(height: AppSpacing.s24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AppFilledButton.text(
                context.l10n.login_google,
                onPressed: () => AppLog.log('google login'),
              ),
            ),
            SizedBox(width: AppSpacing.s16.w),
            Expanded(
              child: AppFilledButton.text(
                context.l10n.login_facebook,
                onPressed: () => AppLog.log('facebook login'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
