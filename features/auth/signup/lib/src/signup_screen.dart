import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:localization/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup/src/state/signup_bloc.dart';
import 'package:signup/src/state/signup_event.dart';
import 'package:signup/src/state/signup_state.dart';
import 'package:ui/ui.dart';

/// Entry point for the signup feature.
///
/// Owns the page-level wiring: text controllers, the [SignupBloc] listener and
/// the orchestration between phone verification and account creation. All
/// navigation is delegated to callbacks supplied by the router so this widget
/// stays decoupled from the routing layer and remains easy to test.
///
/// Rendering is split into small, stateless "dumb" widgets (see below) that
/// receive everything they need through their constructors — mirroring the
/// login feature's smart/dumb structure.
class SignupScreen extends StatefulWidget {
  /// Called once an account has been created successfully (e.g. go to home).
  final VoidCallback onSignUpSuccess;

  /// Called when the user wants to go back to the sign-in screen.
  final VoidCallback onSignInPressed;

  /// Starts the phone verification flow for [phoneNumber] and completes when
  /// the user returns from it. The screen awaits this before submitting so the
  /// router fully owns the OTP navigation.
  final Future<void> Function(String phoneNumber) onVerifyPhone;

  const SignupScreen({super.key, required this.onSignUpSuccess, required this.onSignInPressed, required this.onVerifyPhone});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);
    final gap = SizedBox(height: AppSpacing.s12.h);

    return AppScaffold(
      enableGradientBackground: true,
      body: BlocListener<SignupBloc, SignupState>(
        // Only react to the terminal outcomes (success/error), not every keystroke.
        listenWhen: (prev, curr) => prev.status != curr.status || prev.errorMessage != curr.errorMessage,
        listener: _onStateChanged,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: pagePadding,
              // Lets the content centre vertically while still scrolling when the
              // keyboard shrinks the available height.
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - pagePadding.vertical),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    gap,
                    gap,
                    const _SignupHeader(),
                    gap,
                    gap,
                    _SignupForm(),
                    _SignupButton(onPressed: _onSignUpPressed),
                    gap,
                    _SignInPrompt(onSignInPressed: widget.onSignInPressed),
                    gap,
                    const _SocialSignupOptions(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Reacts to terminal cubit states: surface errors and hand success back to
  /// the router via [SignupScreen.onSignUpSuccess].
  void _onStateChanged(BuildContext context, SignupState state) {
    if (state.errorMessage != null) {
      AppToast.toast(message: state.errorMessage!, toastType: ToastType.error);
    } else if (state.status == FormzSubmissionStatus.success) {
      widget.onSignUpSuccess();
    }
  }

  /// Verifies the user's phone first, then submits the account.
  ///
  /// We await the verification flow (owned by the router) and only continue if
  /// the screen is still mounted, avoiding a "setState after dispose" if the
  /// user navigated away.
  Future<void> _onSignUpPressed() async {
    final bloc = context.read<SignupBloc>();
    //await widget.onVerifyPhone(bloc.state.phone.value);
    if (!mounted) return;
    bloc.add(SignupSubmitted());
  }
}

// ── Form ──────────────────────────────────────────────────────────────────

/// Groups the labelled input fields. Stateless: every field reports changes
/// straight to the [SignupBloc] and reads its visibility flag from state.
class _SignupForm extends StatelessWidget {
  const _SignupForm();

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    final bloc = context.read<SignupBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        _FieldLabel(context.l10n.signup_label_name),
        BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return _NameInput(
              name: state.name.value,
              onChanged: (value) => bloc.add(NameUpdate(value)),
              errorText: state.showValidationError && state.name.isNotValid ? _nameValidationErrorText(context, state.name.error) : null,
            );
          },
        ),
        gap,

        // Phone
        _FieldLabel(context.l10n.signup_label_phone),
        BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return _PhoneInput(
              phone: state.phone.value,
              onChanged: (value) => bloc.add(PhoneUpdate(value)),
              errorText: state.showValidationError && state.phone.isNotValid ? _phoneErrorText(context, state.phone.error) : null,
            );
          },
        ),
        gap,

        // Email
        _FieldLabel(context.l10n.signup_label_email),
        BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return _EmailInput(
              email: state.email.value,
              onChanged: (value) => bloc.add(EmailUpdate(value)),
              errorText: state.showValidationError && state.email.isNotValid ? _emailErrorText(context, state.email.error) : null,
            );
          },
        ),
        gap,

        // Password
        _FieldLabel(context.l10n.signup_label_password),
        BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return _PasswordInput(
              password: state.password.value,
              errorText: state.showValidationError && state.password.isNotValid ? _passwordErrorText(context, state.password.error) : null,
              showPassword: state.showPassword,
              onChanged: (value) => bloc.add(PasswordUpdate(value)),
              onToggleVisibility: () => bloc.add(TogglePasswordVisibility()),
            );
          },
        ),
        gap,
        gap,
      ],
    );
  }

  String _nameValidationErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.empty => 'The name field is required',
      ValidationError.invalid => 'The name is invalid',
      ValidationError.tooShort => 'The name must be at least 3 characters long',
      ValidationError.tooLong => 'The name must be less than 32 characters long',
      _ => '',
    };
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

  String _emailErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.invalid => 'The email is invalid',
      _ => '',
    };
  }
}

/// A small subtitle-styled label shown above each input field.
class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.s4.h),
      child: AppText.bodySmall(text, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────────────────

/// App logo, title and subtitle shown at the top of the page.
class _SignupHeader extends StatelessWidget {
  const _SignupHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppImage.asset(AppDrawables.logoTransparent, width: 100.w, height: 100.h),
        SizedBox(height: AppSpacing.s16.h),
        AppText.titleLarge(context.l10n.signup_title, textWeight: AppTextWeight.extraBold),
        SizedBox(height: AppSpacing.s8.h),
        AppText.bodySmall(context.l10n.signup_subtitle, textAlign: TextAlign.center, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
      ],
    );
  }
}

// ── Inputs ────────────────────────────────────────────────────────────────
class _NameInput extends StatelessWidget {
  final String name;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _NameInput({required this.name, required this.onChanged, this.errorText});

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_name,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      variant: AppInputFieldVariant.filledOpt,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}

class _PhoneInput extends StatelessWidget {
  final String phone;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _PhoneInput({required this.phone, required this.onChanged, this.errorText});

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_phone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      variant: AppInputFieldVariant.filledOpt,
      maxLength: 11,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}

class _EmailInput extends StatelessWidget {
  final String email;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _EmailInput({required this.email, required this.onChanged, this.errorText});

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      variant: AppInputFieldVariant.filledOpt,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final String password;
  final String? errorText;
  final bool showPassword;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleVisibility;

  const _PasswordInput({required this.password, required this.showPassword, required this.onChanged, required this.onToggleVisibility, this.errorText});

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_password,
      obscureText: !showPassword,
      textInputAction: TextInputAction.done,
      variant: AppInputFieldVariant.filledOpt,
      maxLength: 25,
      errorText: errorText,
      onChanged: onChanged,
      suffixIcon: AppIcon(GestureDetector(onTap: onToggleVisibility, child: Icon(showPassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash))),
    );
  }
}

/// Primary call-to-action. Disabled while a submission is in progress so the
/// user can't trigger duplicate requests.
class _SignupButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SignupButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return AppFilledButton.text(context.l10n.signup_button, isLoading: state.isLoading, onPressed: state.isLoading ? null : onPressed);
      },
    );
  }
}

/// "Already have an account? Sign in" row.
class _SignInPrompt extends StatelessWidget {
  final VoidCallback onSignInPressed;

  const _SignInPrompt({required this.onSignInPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.bodySmall(context.l10n.signup_already_have_account, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
        AppTextButton(
          context.l10n.signup_sign_in,
          onPressed: onSignInPressed,
          style: const AppTextButtonStyle(intent: AppButtonIntent.secondary()),
        ),
      ],
    );
  }
}

/// Social sign-up providers. Handlers are placeholders until the providers are
/// wired up.
class _SocialSignupOptions extends StatelessWidget {
  const _SocialSignupOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText.bodySmall(context.l10n.login_social_sign_in, textWeight: AppTextWeight.extraBold, color: context.appColors.contentSubtle),
        SizedBox(height: AppSpacing.s12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: AppFilledButton.text(context.l10n.login_google, onPressed: () {})),
            SizedBox(width: AppSpacing.s16.w),
            Expanded(child: AppFilledButton.text(context.l10n.login_facebook, onPressed: () {})),
          ],
        ),
      ],
    );
  }
}
