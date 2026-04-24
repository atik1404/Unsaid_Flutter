import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:splash/src/state/splash_cubit.dart';
import 'package:splash/src/state/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        state.maybeMap(
          success: (_) => context.goNamed(AppRouteName.loginScreen),
          orElse: () {},
        );
      },
      child: _buildMainContent(context),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final topMargin = MediaQuery.sizeOf(context).height * 0.2;
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

          Positioned(
            top: topMargin,
            left: 0,
            right: 0,
            child: const Center(
              child: AppImage.asset(
                AppDrawables.logoTransparent,
                width: 120,
                height: 120,
              ),
            ),
          ),

          Center(child: _buildContent(context)),

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

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.s48),
        const AppText.headlineLarge(
          'Unsaid',
          textWeight: AppTextWeight.extraBold,
        ),
        const SizedBox(height: AppSpacing.s12),
        AppText.bodyLarge(
          textAlign: TextAlign.center,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.white,
          'Things you couldn’t say anywhere else.',
        ),
        const SizedBox(height: AppSpacing.s12),
        AppText.bodyLarge(
          textAlign: TextAlign.center,
          textWeight: AppTextWeight.light,
          color: context.colorScheme.white,
          'Shed your identity, not your voice',
        ),
        const SizedBox(height: AppSpacing.s48),
      ],
    );
  }
}
