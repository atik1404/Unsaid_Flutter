import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup/src/state/signup_cubit.dart';
import 'package:signup/src/state/signup_state.dart';
import 'package:ui/ui.dart';

/// Entry point for the signup feature.
///
/// Owns the page-level wiring: text controllers, the [SignupCubit] listener and
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
  // Controllers are owned by the smart widget so their lifecycle (and disposal)
  // is managed in a single place.
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);
    final gap = SizedBox(height: AppSpacing.s12.h);

    return AppScaffold(
      enableGradientBackground: true,
      body: BlocListener<SignupCubit, SignupState>(
        // Only react to the terminal outcomes (success/error), not every keystroke.
        listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess || prev.errorMessage != curr.errorMessage,
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
                    const _SignupHeader(),
                    gap,
                    gap,
                    _SignupForm(nameController: _nameController, phoneController: _phoneController, emailController: _emailController, passwordController: _passwordController),
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
    } else if (state.isSuccess) {
      widget.onSignUpSuccess();
    }
  }

  /// Verifies the user's phone first, then submits the account.
  ///
  /// We await the verification flow (owned by the router) and only continue if
  /// the screen is still mounted, avoiding a "setState after dispose" if the
  /// user navigated away.
  Future<void> _onSignUpPressed() async {
    final cubit = context.read<SignupCubit>();
    await widget.onVerifyPhone(cubit.state.phone.value);
    if (!mounted) return;
    cubit.submit();
  }
}

// ── Form ──────────────────────────────────────────────────────────────────

/// Groups the labelled input fields. Stateless: every field reports changes
/// straight to the [SignupCubit] and reads its visibility flag from state.
class _SignupForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _SignupForm({required this.nameController, required this.phoneController, required this.emailController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    final cubit = context.read<SignupCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        _FieldLabel(context.l10n.signup_label_name),
        _NameInput(controller: nameController, onChanged: cubit.updateName),
        gap,

        // Phone
        _FieldLabel(context.l10n.signup_label_phone),
        _PhoneInput(controller: phoneController, onChanged: cubit.updatePhone),
        gap,

        // Email
        _FieldLabel(context.l10n.signup_label_email),
        _EmailInput(controller: emailController, onChanged: cubit.updateEmail),
        gap,

        // Password
        _FieldLabel(context.l10n.signup_label_password),
        BlocBuilder<SignupCubit, SignupState>(
          // Rebuild only when the visibility toggle changes.
          buildWhen: (prev, curr) => prev.showPassword != curr.showPassword,
          builder: (context, state) {
            return _PasswordInput(controller: passwordController, showPassword: state.showPassword, onChanged: cubit.updatePassword, onToggleVisibility: cubit.togglePasswordVisibility);
          },
        ),
        gap,
        gap,
      ],
    );
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
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _NameInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_name,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      variant: AppInputFieldVariant.filledOpt,
      controller: controller,
      onChanged: onChanged,
    );
  }
}

class _PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _PhoneInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_phone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      variant: AppInputFieldVariant.filledOpt,
      maxLength: 11,
      controller: controller,
      onChanged: onChanged,
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _EmailInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      variant: AppInputFieldVariant.filledOpt,
      controller: controller,
      onChanged: onChanged,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final bool showPassword;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleVisibility;

  const _PasswordInput({required this.controller, required this.showPassword, required this.onChanged, required this.onToggleVisibility});

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_password,
      obscureText: !showPassword,
      textInputAction: TextInputAction.done,
      variant: AppInputFieldVariant.filledOpt,
      maxLength: 20,
      controller: controller,
      onChanged: onChanged,
      suffixIcon: AppIcon(GestureDetector(onTap: onToggleVisibility, child: Icon(showPassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash))),
    );
  }
}

// ── Actions & footer ────────────────────────────────────────────────────────

/// Primary call-to-action. Disabled while a submission is in progress so the
/// user can't trigger duplicate requests.
class _SignupButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SignupButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (prev, curr) => prev.isSubmitting != curr.isSubmitting,
      builder: (context, state) {
        return AppFilledButton.text(context.l10n.signup_button, isLoading: state.isSubmitting, onPressed: state.isSubmitting ? null : onPressed);
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
