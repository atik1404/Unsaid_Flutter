import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: AppSvg.asset(AppDrawables.appBackground, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
    );
  }
}
