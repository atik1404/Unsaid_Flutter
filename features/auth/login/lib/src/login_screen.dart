import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:common/common.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildLoginUi(),
      //bottomNavigationBar: _buildLoginFooter(context),
    );
  }

  Widget _buildLoginUi() {
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLoginHeader(context),
                    SizedBox(height: AppSpacing.s32.h),
                    _buildLoginForm(context),
                    _buildLoginFooter(context),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        gap,
        AppText.bodySmall(
          context.l10n.login_label_phone,
          textWeight: AppTextWeight.light,
          color: context.appColors.white,
        ),
        SizedBox(height: AppSpacing.s4.h),
        _buildPhoneNumber(context),
        gap,
        AppText.bodySmall(
          context.l10n.login_label_password,
          textWeight: AppTextWeight.light,
          color: context.appColors.white,
        ),
        SizedBox(height: AppSpacing.s4.h),
        _buildPassword(context),
        gap,
        gap,
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
      ],
    );
  }

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
          color: context.appColors.white,
        ),
      ],
    );
  }

  Widget _buildPhoneNumber(BuildContext context) {
    return AppInputField(
      hint: context.l10n.login_hint_phone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      variant: AppInputFieldVariant.filledOpt,
      maxLength: 11,
    );
  }

  Widget _buildPassword(BuildContext context) {
    return AppInputField(
      hint: context.l10n.login_hint_password,
      obscureText: _obscurePassword,
      variant: AppInputFieldVariant.filledOpt,
      textInputAction: TextInputAction.done,
      maxLength: 20,
      suffixIcon: AppIcon(
        GestureDetector(
          onTap: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
          child: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return AppFilledButton.text(
      context.l10n.login_button,
      onPressed: () {
        context.goNamed(AppRouteName.homeScreen);
      },
    );
  }

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
          color: context.appColors.white,
        ),
        AppTextButton(
          context.l10n.login_sign_up,
          onPressed: () {
            context.pushNamed(AppRouteName.signupScreen);
          },
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
          color: context.appColors.white,
        ),
        SizedBox(height: AppSpacing.s24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AppFilledButton.text(
                context.l10n.login_google,
                onPressed: () {
                  AppLog.log('google login');
                },
              ),
            ),
            SizedBox(width: AppSpacing.s16.w),
            Expanded(
              child: AppFilledButton.text(
                context.l10n.login_facebook,
                onPressed: () {
                  AppLog.log('facebook login');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
