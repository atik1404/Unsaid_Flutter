import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:ui/ui.dart';

/// Entry point for the login feature.
///
/// Provides a fresh [LoginBloc] instance and delegates rendering to
/// [_LoginView] so the BLoC is always available in the widget subtree.
class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onSignUpPressed;
  final VoidCallback? onForgotPasswordPressed;

  const LoginScreen({super.key, required this.onLoginSuccess, required this.onSignUpPressed, required this.onForgotPasswordPressed});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// The stateful UI layer of the login screen.
///
/// Reads [LoginBloc] from context — always available because [LoginScreen]
class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);
    final verticalSpacing = SizedBox(height: AppSpacing.s32.h);

    return BlocListener<LoginBloc, LoginState>(
      // Listen for terminal states to trigger navigation or error feedback.
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) => _onStateChanged(state),
      child: AppScaffold(
        enableGradientBackground: true,
        body: LayoutBuilder(
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
                    const _LoginHeader(),
                    verticalSpacing,

                    _LoginView(_phoneController, _passwordController),
                    verticalSpacing,
                    _CreateAccountPrompt(onSignUpPressed: () => {}),

                    verticalSpacing,
                    _SocialLoginOptions(
                      onGooglePressed: () => {},
                      onFacebookPressed: () => {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onStateChanged(LoginState state) {
    if (state.status == FormzSubmissionStatus.success) {
      AppToast.toast(message: 'Login successful', toastType: ToastType.success);
      //context.goNamed(AppRouteName.homeScreen);
    } else if (state.status == FormzSubmissionStatus.failure) {
      final message = state.errorMessage ?? 'Something went wrong';
      AppToast.toast(message: message, toastType: ToastType.error);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

final class _LoginView extends StatelessWidget {
  final TextEditingController _phoneController;
  final TextEditingController _passwordController;

  const _LoginView(this._phoneController, this._passwordController);

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
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

        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return _PhoneInput(
              errorText: state.showErrors && state.phone.isNotValid ? _phoneErrorText(context, state.phone.error) : null,
              controller: _phoneController,
              onChanged: (value) => context.read<LoginBloc>().add(LoginPhoneChanged(value)),
            );
          },
        ),

        gap,
        AppText.bodySmall(
          context.l10n.login_label_password,
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSubtle,
        ),
        SizedBox(height: AppSpacing.s4.h),

        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return _PasswordInput(
              errorText: state.showErrors && state.password.isNotValid ? _passwordErrorText(context, state.password.error) : null,
              controller: _passwordController,
              onChanged: (value) => context.read<LoginBloc>().add(LoginPasswordChanged(value)),
              showPassword: state.showPassword,
              onToggleVisibility: () => context.read<LoginBloc>().add(const LoginTogglePasswordVisibility()),
            );
          },
        ),
        gap,
        gap,
        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return _LoginButton(
              onPressed: () => context.read<LoginBloc>().add(const LoginSubmitted()),
              isLoading: state.status == FormzSubmissionStatus.inProgress,
            );
          },
        ),
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
}
// ── Header ────────────────────────────────────────────────────────────────
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
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
}
class _PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final void Function(String) onChanged;

  const _PhoneInput({
    required this.controller,
    this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.login_hint_phone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      variant: AppInputFieldVariant.filledOpt,
      maxLength: 11,
      controller: controller,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}
class _PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final bool showPassword;
  final void Function(String) onChanged;
  final VoidCallback onToggleVisibility;

  const _PasswordInput({
    required this.controller,
    this.errorText,
    required this.showPassword,
    required this.onChanged,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.login_hint_password,
      obscureText: !showPassword,
      variant: AppInputFieldVariant.filledOpt,
      textInputAction: TextInputAction.done,
      maxLength: 20,
      controller: controller,
      errorText: errorText,
      onChanged: onChanged,
      suffixIcon: AppIcon(
        GestureDetector(
          onTap: onToggleVisibility,
          child: Icon(
            showPassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          ),
        ),
      ),
    );
  }
}
class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _LoginButton({
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppFilledButton.text(
      context.l10n.login_button,
      isLoading: isLoading,
      onPressed: isLoading ? null : onPressed,
    );
  }
}
class _CreateAccountPrompt extends StatelessWidget {
  final VoidCallback onSignUpPressed;

  const _CreateAccountPrompt({
    required this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.bodySmall(
          context.l10n.login_create_account_prompt,
          textWeight: AppTextWeight.light,
          color: context.appColors.white,
        ),
        AppTextButton(
          context.l10n.login_sign_up,
          onPressed: onSignUpPressed,
          style: const AppTextButtonStyle(
            intent: AppButtonIntent.secondary(),
          ),
        ),
      ],
    );
  }
}
class _SocialLoginOptions extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  const _SocialLoginOptions({
    required this.onGooglePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                onPressed: onGooglePressed,
              ),
            ),
            SizedBox(width: AppSpacing.s16.w),
            Expanded(
              child: AppFilledButton.text(
                context.l10n.login_facebook,
                onPressed: onFacebookPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
