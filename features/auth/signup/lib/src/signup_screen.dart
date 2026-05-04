import 'package:designsystem/designsystem.dart';
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
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: const _SignupScreenView(),
    );
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
    return AppScaffold(body: _buildSignupUi(context));
  }

  Widget _buildSignupUi(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);

    return Stack(
      children: [
        const Positioned.fill(
          child: AppImage.asset(
            AppDrawables.appBackground,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: pagePadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - pagePadding.vertical,
                ),
                child: BlocListener<SignupCubit, SignupState>(
                  listener: (context, state) {
                    if (state.errorMessage != null) {
                      AppToast.toast(
                        message: state.errorMessage!,
                        toastType: ToastType.error,
                      );
                    } else if (state.isSuccess) {
                      // Handle successful signup
                      context.goNamed(AppRouteName.homeScreen);
                    }
                  },
                  child: _buildSignupForm(context),
                ),
              ),
            );
          },
        ),
        Positioned(
          top: pagePadding.top,
          left: pagePadding.left,
          child: SafeArea(
            bottom: false,
            child: AppIconButton(
              AppIcon(AppImage.asset(AppDrawables.icBack)),
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    final topMargin = MediaQuery.sizeOf(context).height * 0.1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topMargin),
        _buildSignupHeader(context),
        gap,
        gap,

        // Name
        AppText.bodySmall(
          context.l10n.signup_label_name,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s4.h),
        _buildNameInput(context),
        gap,

        // Phone
        AppText.bodySmall(
          context.l10n.signup_label_phone,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s4.h),
        _buildPhoneInput(context),
        gap,

        // Email
        AppText.bodySmall(
          context.l10n.signup_label_email,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s4.h),
        _buildEmailInput(context),
        gap,

        // Password
        AppText.bodySmall(
          context.l10n.signup_label_password,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s4.h),
        _buildPasswordInput(context),
        gap,
        gap,

        _buildSignupButton(context),
        gap,
        _buildSignInPrompt(context),
        gap,
        _buildSocialSignupOptions(context),
      ],
    );
  }

  Widget _buildSignupHeader(BuildContext context) {
    return Column(
      children: [
        AppImage.asset(
          AppDrawables.logoTransparent,
          width: 120.w,
          height: 120.h,
        ),
        SizedBox(height: AppSpacing.s16.h),
        AppText.titleLarge(
          context.l10n.signup_title,
          textWeight: AppTextWeight.extraBold,
        ),
        SizedBox(height: AppSpacing.s8.h),
        AppText.bodySmall(
          context.l10n.signup_subtitle,
          textAlign: TextAlign.center,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
      ],
    );
  }

  Widget _buildNameInput(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_name,
      keyboardType: TextInputType.name,
      onChanged: (value) => context.read<SignupCubit>().updateName(value),
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_phone,
      keyboardType: TextInputType.phone,
      onChanged: (value) => context.read<SignupCubit>().updatePhone(value),
    );
  }

  Widget _buildEmailInput(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_email,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => context.read<SignupCubit>().updateEmail(value),
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return AppInputField(
      hint: context.l10n.signup_hint_password,
      obscureText: _obscurePassword,
      suffixIcon: AppIcon(
        GestureDetector(
          onTap: () => setState(() => _obscurePassword = !_obscurePassword),
          child: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
        ),
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
          onPressed: () => context.read<SignupCubit>().submit(),
        );
      },
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.bodySmall(
          context.l10n.signup_already_have_account,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
        AppTextButton(
          context.l10n.signup_sign_in,
          onPressed: () {
            context.goNamed(AppRouteName.loginScreen);
          },
          style: const AppTextButtonStyle(intent: AppButtonIntent.secondary()),
        ),
      ],
    );
  }

  Widget _buildSocialSignupOptions(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.s24.h),
        AppText.bodySmall(
          context.l10n.login_social_sign_in,
          textWeight: AppTextWeight.extraBold,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s32.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AppFilledButton.text(
                context.l10n.login_google,
                onPressed: () {},
              ),
            ),
            SizedBox(width: AppSpacing.s16.w),
            Expanded(
              child: AppFilledButton.text(
                context.l10n.login_facebook,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
