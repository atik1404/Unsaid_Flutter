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

        Center(
          child: _buildLoginForm(context),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    return Padding(
      padding: EdgeInsets.all(AppSpacing.s24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLoginHeader(context),
          gap,
          AppText.bodySmall(
            context.l10n.login_label_phone,
            textWeight: AppTextWeight.light,
            color: context.colorScheme.contentInfo,
          ),
          const SizedBox(height: AppSpacing.s8),
          _buildPhoneNumber(context),
          gap,
          AppText.bodySmall(
            context.l10n.login_label_password,
            textWeight: AppTextWeight.light,
            color: context.colorScheme.contentInfo,
          ),
          const SizedBox(height: AppSpacing.s8),
          _buildPassword(context),
          gap,
          gap,
          gap,
          gap,
          _buildLoginButton(context),
        ],
      ),
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
        const SizedBox(height: AppSpacing.s16),
        AppText.titleLarge(
          context.l10n.login_title,
          textWeight: AppTextWeight.extraBold,
        ),
        const SizedBox(height: AppSpacing.s8),
        AppText.bodyLarge(
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
}
