import 'package:designsystem/designsystem.dart';
import 'package:entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:onboarding/src/state/onboarding_cubit.dart';
import 'package:onboarding/src/state/onboarding_state.dart';

/// OnboardingScreen displays a multi-page onboarding flow with page indicator and animated button.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Enable immersive mode for a full-screen onboarding experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final l10n = context.l10n;
    final onboardingPagerList = [
      OnboardingPagerEntity(
        title: l10n.onboarding_title_1,
        subTitle: l10n.onboarding_subtitle_1,
        description: l10n.onboarding_description_1,
        image: AppDrawables.icShareYourMind,
      ),
      OnboardingPagerEntity(
        title: l10n.onboarding_title_2,
        subTitle: l10n.onboarding_subtitle_2,
        description: l10n.onboarding_description_2,
        image: AppDrawables.icShareAnonymously,
      ),
      OnboardingPagerEntity(
        title: l10n.onboarding_title_3,
        subTitle: l10n.onboarding_subtitle_3,
        description: l10n.onboarding_description_3,
        image: AppDrawables.icShareAnything,
      ),
    ];

    final screenSize = MediaQuery.sizeOf(context);

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        // Listen for navigation events to next screen
        if (state.shouldNavigateToNextScreen) {
          context.goNamed(AppRouteName.loginScreen);
          context
              .read<OnboardingCubit>()
              .resetState(); //reset state after navigation
        }
      },
      child: AppScaffold(
        body: Stack(
          children: [
            const Positioned.fill(
              child: AppImage.asset(
                AppDrawables.appBackground,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.s16).r,
              child: Column(
                children: [
                  // PagerView for onboarding screens
                  _buildPagerView(onboardingPagerList),
                  // Page indicator dots
                  _buildPageIndicator(context, onboardingPagerList.length),
                  SizedBox(height: AppSpacing.s48.h),
                  _buildAnimatedButton(),
                  SizedBox(height: screenSize.height * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the onboarding pager with swipeable pages
  Widget _buildPagerView(List<OnboardingPagerEntity> onboardingPagerList) {
    return Expanded(
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        buildWhen: (prev, curr) => prev.currentPage != curr.currentPage,
        builder: (context, state) {
          return PageView.builder(
            itemCount: onboardingPagerList.length,
            controller: PageController(initialPage: state.currentPage),
            itemBuilder: (context, index) =>
                _buildPageItem(context, onboardingPagerList[index]),
            onPageChanged: (index) {
              // Notify cubit about page change
              context.read<OnboardingCubit>().onPageChanged(
                index: index,
                totalPages: onboardingPagerList.length,
              );
            },
          );
        },
      ),
    );
  }

  /// Builds a single onboarding page
  Widget _buildPageItem(BuildContext context, OnboardingPagerEntity item) {
    final contentMargin = MediaQuery.sizeOf(context).height * 0.1;

    return Column(
      children: [
        SizedBox(height: contentMargin),
        AppImage.asset(
          item.image,
          height: 250.h,
        ),
        SizedBox(height: contentMargin),
        Column(
          children: [
            // Title text
            AppText.titleLarge(
              item.title,
              textAlign: TextAlign.center,
              textWeight: AppTextWeight.extraBold,
            ),
            SizedBox(height: AppSpacing.s16.h),
            // Subtitle text
            AppText.titleMedium(
              item.subTitle,
              textAlign: TextAlign.center,
              textWeight: AppTextWeight.semiBold,
              color: context.colorScheme.contentTertiary,
            ),
            SizedBox(height: AppSpacing.s16.h),
            // Description text
            AppText.bodySmall(
              item.description,
              textAlign: TextAlign.center,
              textWeight: AppTextWeight.light,
              color: context.colorScheme.contentTertiary,
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the animated page indicator dots
  Widget _buildPageIndicator(
    BuildContext context,
    int length,
  ) {
    final colorScheme = context.colorScheme;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (prev, curr) => prev.currentPage != curr.currentPage,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(length, (index) {
            final isActive = state.currentPage == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: AppSpacing.s8.w),
              width: 30.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: isActive
                    ? colorScheme.contentWarning
                    : colorScheme.contentOnBrand,
                borderRadius: BorderRadius.circular(5.r),
              ),
            );
          }),
        );
      },
    );
  }

  /// Builds the animated "Get Started" button, visible only on the last page.
  /// Uses [AnimatedOpacity] and [AnimatedContainer] for smooth appearance and slide transition.
  Widget _buildAnimatedButton() {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (prev, curr) => prev.isLastPage != curr.isLastPage,
      builder: (context, state) {
        // Show button only when last page is reached
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: state.isLastPage ? 1.0 : 0.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            transform: Matrix4.translationValues(
              0,
              state.isLastPage ? 0 : 50, // Slide up when visible
              0,
            ),
            child: AppFilledButton.text(
              context.l10n.onboarding_get_started,
              onPressed: () {
                context.read<OnboardingCubit>().navigateToNextScreen();
              },
            ),
          ),
        );
      },
    );
  }
}
