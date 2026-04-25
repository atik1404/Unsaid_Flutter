import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final topMargin = MediaQuery.sizeOf(context).height * 0.1;
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
          const AppText.bodySmall(
            "Phone number",
            textWeight: AppTextWeight.light,
          ),
          const SizedBox(height: AppSpacing.s8),
          _buildPhoneNumber(context),
          gap,
          const AppText.bodySmall(
            "Password",
            textWeight: AppTextWeight.light,
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
        const AppText.titleLarge(
          "Let’s Get You In",
          textWeight: AppTextWeight.extraBold,
        ),
        const SizedBox(height: AppSpacing.s8),
        AppText.bodyLarge(
          "Sign in to connect through honest, anonymous conversations.",
          textAlign: TextAlign.center,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentInfo,
        ),
      ],
    );
  }

  Widget _buildPhoneNumber(BuildContext context) {
    return const AppInputField(
      hint: "Enter your phone number",
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildPassword(BuildContext context) {
    return const AppInputField(
      hint: "Enter your password",
      obscureText: true,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return AppFilledButton.text(
      "Login",
      onPressed: () {
        // Handle login logic
      },
    );
  }
}
