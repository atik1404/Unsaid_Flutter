import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:splash/src/state/splash_cubit.dart';
import 'package:splash/src/state/splash_state.dart';
import 'package:ui/ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        state.maybeMap(
          navigateToOnboarding: (_) => context.goNamed(AppRouteName.onboardingScreen),
          navigateToLogin: (_) => context.goNamed(AppRouteName.homeScreen),
          navigateToHome: (_) => context.goNamed(AppRouteName.homeScreen),
          orElse: () {},
        );
      },
      child: AppScaffold(
        enableGradientBackground: true,
        body: _buildMainContent(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final topMargin = MediaQuery.sizeOf(context).height * 0.2;
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        if (state is SplashError) {
          return AppErrorScreen(
            message: state.message,
            onRetry: () => context.read<SplashCubit>().checkAuthorization(),
          );
        }

        return Stack(
          children: [
            Positioned(
              top: topMargin,
              left: 0,
              right: 0,
              child: Center(
                child: AppImage.asset(
                  AppDrawables.logoTransparent,
                  width: 120.w,
                  height: 120.h,
                ),
              ),
            ),

            Center(child: _buildContent(context)),

            Positioned(
              bottom: AppSpacing.s48,
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(
                  color: context.appColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.s48),
        AppText.headlineLarge(
          context.l10n.splash_brand_name,
          textWeight: AppTextWeight.extraBold,
        ),
        const SizedBox(height: AppSpacing.s12),
        AppText.bodyLarge(
          textAlign: TextAlign.center,
          textWeight: AppTextWeight.light,
          color: context.appColors.white,
          context.l10n.splash_tagline_primary,
        ),
        const SizedBox(height: AppSpacing.s12),
        AppText.bodyLarge(
          textAlign: TextAlign.center,
          textWeight: AppTextWeight.light,
          color: context.appColors.white,
          context.l10n.splash_tagline_secondary,
        ),
        const SizedBox(height: AppSpacing.s48),
      ],
    );
  }
}
