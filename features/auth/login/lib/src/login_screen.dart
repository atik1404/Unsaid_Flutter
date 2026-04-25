import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildLoginUi(context),
    );
  }

  Widget _buildLoginUi(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: AppSvg.asset(
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
              padding: EdgeInsets.all(AppSpacing.s24.r),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: _buildLoginForm(context),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    final gapS48 = SizedBox(height: AppSpacing.s48.h);
    final topMargin = MediaQuery.sizeOf(context).height * 0.08;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topMargin),
        _buildLoginHeader(context),
        gapS48,
        AppText.bodySmall(
          context.l10n.login_label_phone,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s4.h),
        _buildPhoneNumber(context),
        gap,
        AppText.bodySmall(
          context.l10n.login_label_password,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s4.h),
        _buildPassword(context),
        gapS48,
        _buildLoginButton(context),
        gap,
        Align(
          child: AppTextButton(
            context.l10n.login_forgot_password,
            onPressed: () {},
            style: const AppTextButtonStyle(
              intent: AppButtonIntent.secondary(),
            ),
          ),
        ),
        gap,
        _buildCreateAccount(context),
        _buildSocialLoginOptions(context),
      ],
    );
  }

  Widget _buildLoginHeader(BuildContext context) {
    return Column(
      children: [
        AppImage.asset(
          AppDrawables.logoTransparent,
          width: 120.w,
          height: 120.h,
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
          color: context.colorScheme.contentInfo,
        ),
      ],
    );
  }

  Widget _buildPhoneNumber(BuildContext context) {
    return AppInputField(
      hint: context.l10n.login_hint_phone,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildPassword(BuildContext context) {
    return AppInputField(
      hint: context.l10n.login_hint_password,
      obscureText: true,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return AppFilledButton.text(
      context.l10n.login_button,
      onPressed: () {
        // Handle login logic
      },
    );
  }

  Widget _buildCreateAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.bodySmall(
          context.l10n.login_create_account_prompt,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
        AppTextButton(
          context.l10n.login_sign_up,
          onPressed: () {},
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
