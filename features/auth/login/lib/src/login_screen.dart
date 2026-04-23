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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _buildLoginForm(),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    const gap = SizedBox(height: AppSpacing.s16);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppInputField(
          hint: "Enter your email",
        ),
        gap,
        const AppInputField(
          hint: "Enter your password",
          obscureText: true,
        ),
        gap,
        AppFilledButton.text(
          "Login",
          onPressed: () {
            // Handle login logic
          },
        ),
      ],
    );
  }
}
