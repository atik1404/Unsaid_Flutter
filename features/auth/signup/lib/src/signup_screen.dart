import 'package:designsystem/designsystem.dart';
import 'package:entity/entity.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:signup/src/state/signup_cubit.dart';
import 'package:signup/src/state/signup_state.dart';
import 'package:ui/ui.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => SignupCubit(), child: const _SignupScreenView());
  }
}

class _SignupScreenView extends StatefulWidget {
  const _SignupScreenView();

  @override
  State<_SignupScreenView> createState() => _SignupScreenViewState();
}

class _SignupScreenViewState extends State<_SignupScreenView> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(body: _buildSignupUi(context), enableGradientBackground: true);
  }

  Widget _buildSignupUi(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: pagePadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - pagePadding.vertical),
            child: BlocListener<SignupCubit, SignupState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  AppToast.toast(message: state.errorMessage!, toastType: ToastType.error);
                } else if (state.isSuccess) {
                  // Handle successful signup
                  context.goNamed(AppRouteName.homeScreen);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_buildSignupHeader(context), _buildSignupForm(context), _buildSignupButton(context), _buildLoginFooter(context)],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        gap,
        gap,

        // Name
        AppText.bodySmall(context.l10n.signup_label_name, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
        SizedBox(height: AppSpacing.s4.h),
        _buildNameInput(context),
        gap,

        // Phone
        AppText.bodySmall(context.l10n.signup_label_phone, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
        SizedBox(height: AppSpacing.s4.h),
        _buildPhoneInput(context),
        gap,

        // Email
        AppText.bodySmall(context.l10n.signup_label_email, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
        SizedBox(height: AppSpacing.s4.h),
        _buildEmailInput(context),
        gap,

        // Password
        AppText.bodySmall(context.l10n.signup_label_password, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
        SizedBox(height: AppSpacing.s4.h),
        _buildPasswordInput(context),
        gap,
        gap,
      ],
    );
  }

  Widget _buildSignupHeader(BuildContext context) {
    return Column(
      children: [
        AppImage.asset(AppDrawables.logoTransparent, width: 100.w, height: 100.h),
        SizedBox(height: AppSpacing.s16.h),
        AppText.titleLarge(context.l10n.signup_title, textWeight: AppTextWeight.extraBold),
        SizedBox(height: AppSpacing.s8.h),
        AppText.bodySmall(context.l10n.signup_subtitle, textAlign: TextAlign.center, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
      ],
    );
  }

  Widget _buildNameInput(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_name,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      onChanged: (value) => context.read<SignupCubit>().updateName(value),
      variant: AppInputFieldVariant.filledOpt,
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_phone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onChanged: (value) => context.read<SignupCubit>().updatePhone(value),
      variant: AppInputFieldVariant.filledOpt,
    );
  }

  Widget _buildEmailInput(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (value) => context.read<SignupCubit>().updateEmail(value),
      variant: AppInputFieldVariant.filledOpt,
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_password,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      variant: AppInputFieldVariant.filledOpt,
      suffixIcon: AppIcon(
        GestureDetector(onTap: () => setState(() => _obscurePassword = !_obscurePassword), child: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined)),
      ),
      onChanged: (value) => context.read<SignupCubit>().updatePassword(value),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return AppFilledButton.text(
          context.l10n.signup_button,
          isLoading: state.isSubmitting,
          onPressed: () {
            context
                .pushNamed(
                  AppRouteName.otpVerificationScreen,
                  extra: OtpVerificationArgs(verificationId: '', phoneNumber: state.phone, otpPurpose: AppConstants.otpVerificationForSignUp),
                )
                .then((value) {
                  context.read<SignupCubit>().submit();
                });
          },
        );
      },
    );
  }

  Widget _buildLoginFooter(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    return Column(children: [gap, _buildSignInPrompt(context), _buildSocialSignupOptions(context)]);
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.bodySmall(context.l10n.signup_already_have_account, textWeight: AppTextWeight.light, color: context.appColors.contentSubtle),
        AppTextButton(
          context.l10n.signup_sign_in,
          onPressed: () {
            context.pop();
          },
          style: const AppTextButtonStyle(intent: AppButtonIntent.secondary()),
        ),
      ],
    );
  }

  Widget _buildSocialSignupOptions(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    return Column(
      children: [
        gap,
        AppText.bodySmall(context.l10n.login_social_sign_in, textWeight: AppTextWeight.extraBold, color: context.appColors.contentSubtle),
        gap,
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
