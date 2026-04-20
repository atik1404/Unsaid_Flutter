import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: AppSvg.asset(
              AppDrawables.appBackground,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          Center(child: _buildContent()),

          const Positioned(
            bottom: AppSpacing.s48,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppImage.asset(
          AppDrawables.logoTransparent,
          width: 120,
          height: 120,
        ),
        SizedBox(height: AppSpacing.s48),
        AppText.headlineLarge(
          'Unmasked voice',
        ),
        SizedBox(height: AppSpacing.s12),
        AppText.bodyLarge(
          textAlign: TextAlign.center,
          'Every user is anonymous, post & message freely.',
        ),
        SizedBox(height: AppSpacing.s12),
        AppText.bodySmall(
          textAlign: TextAlign.center,
          'Shed your identity, not your voice',
        ),
        SizedBox(height: AppSpacing.s48),
      ],
    );
  }
}
