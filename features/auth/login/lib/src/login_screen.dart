import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

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

        _buildLoginForm(context),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    const gap = SizedBox(height: AppSpacing.s16);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLoginHeader(context),
        gap,
        _buildPhoneNumber(context),
        gap,
        _buildPassword(context),
        gap,
        _buildLoginButton(context),
      ],
    );
  }

  Widget _buildLoginHeader(BuildContext context) {
    return Column(
      children: [
        const AppImage.asset(
          AppDrawables.logoTransparent,
          width: 120,
          height: 120,
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          "Welcome Back",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.s8),
        const Text(
          "Enter your credentials to login to your account",
          style: TextStyle(fontSize: 16, color: Colors.grey),
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
