import 'package:designsystem/designsystem.dart';
import 'package:entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:onboarding/src/state/onboarding_cubit.dart';
import 'package:onboarding/src/state/onboarding_state.dart';

/// Entry point for the onboarding flow.
///
/// Renders a full-screen, multi-page walkthrough that introduces the app's
/// core value propositions. The flow has three pages; on the last page an
/// animated "Get Started" button appears. Tapping it marks onboarding as
/// complete and navigates the user to the login screen.
///
/// State is managed by [OnboardingCubit], provided by [OnboardingScreenRouter].
class OnboardingScreen extends StatelessWidget {
  final VoidCallback onNavigateToLoginScreen;
  const OnboardingScreen({super.key, required this.onNavigateToLoginScreen});

  @override
  Widget build(BuildContext context) {
    // Hide status/navigation bars for a fully immersive first-run experience.
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
        if (state.shouldNavigateToNextScreen) {
          onNavigateToLoginScreen();
        }
      },
      child: AppScaffold(
        enableGradientBackground: true,
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16).r,
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            // Rebuild only when the active page changes to avoid redundant layouts.
            buildWhen: (prev, curr) => prev.currentPage != curr.currentPage,
            builder: (context, state) {
              return Column(
                children: [
                  SizedBox(
                    // Reserve 70 % of the screen height for the pager so the
                    // indicator and button always stay visible below it.
                    height: screenSize.height * 0.7,
                    child: _PagerView(
                      onboardingPagerList: onboardingPagerList,
                      currentPage: state.currentPage,
                    ),
                  ),
                  _PageIndicator(
                    length: onboardingPagerList.length,
                    currentPage: state.currentPage,
                  ),
                  SizedBox(height: AppSpacing.s48.h),
                  _AnimatedButton(
                    onPressed: () => {
                      context.read<OnboardingCubit>().navigateToLoginScreen(),
                    },
                    isLastPage: state.isLastPage,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Horizontal [PageView] that renders one [_PageItem] per onboarding step.
///
/// Page-change events are forwarded to [OnboardingCubit] so the indicator
/// and button stay in sync with the visible page.
final class _PagerView extends StatelessWidget {
  final List<OnboardingPagerEntity> onboardingPagerList;
  final int currentPage;

  const _PagerView({required this.onboardingPagerList, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: onboardingPagerList.length,
      controller: PageController(initialPage: currentPage),
      itemBuilder: (context, index) => _PageItem(item: onboardingPagerList[index]),
      onPageChanged: (index) {
        context.read<OnboardingCubit>().onPageChanged(
          index: index,
          totalPages: onboardingPagerList.length,
        );
      },
    );
  }
}

/// A single onboarding page: illustration + title + subtitle + description.
/// Vertical margins are derived from screen height so the layout scales
/// gracefully across different device sizes.
final class _PageItem extends StatelessWidget {
  final OnboardingPagerEntity item;

  const _PageItem({required this.item});

  @override
  Widget build(BuildContext context) {
    // Use 10 % of screen height as breathing room above and below the image.
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
            AppText.titleLarge(
              item.title,
              textAlign: TextAlign.center,
              textWeight: AppTextWeight.extraBold,
            ),
            SizedBox(height: AppSpacing.s16.h),
            AppText.titleMedium(
              item.subTitle,
              textAlign: TextAlign.center,
              textWeight: AppTextWeight.semiBold,
              color: context.appColors.contentSubtle,
            ),
            SizedBox(height: AppSpacing.s16.h),
            AppText.bodySmall(
              item.description,
              textAlign: TextAlign.center,
              textWeight: AppTextWeight.light,
              color: context.appColors.contentSubtle,
            ),
          ],
        ),
      ],
    );
  }
}

/// Animated dot indicator showing which page is currently active.
///
/// Each dot transitions its color and can be extended to change its width
/// for a "pill" active-state effect — the [AnimatedContainer] is already in
/// place for that upgrade.
final class _PageIndicator extends StatelessWidget {
  /// Total number of pages in the pager.
  final int length;

  /// Zero-based index of the currently visible page.
  final int currentPage;

  const _PageIndicator({required this.length, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: AppSpacing.s8.w),
          width: 30.w,
          height: 5.h,
          decoration: BoxDecoration(
            color: index == currentPage ? colorScheme.contentWarning : colorScheme.contentSubtle,
            borderRadius: BorderRadius.circular(5.r),
          ),
        );
      }),
    );
  }
}

/// "Get Started" button that fades and slides in only on the last onboarding page.
///
/// [AnimatedOpacity] handles the fade; [AnimatedContainer] applies a vertical
/// translation so the button appears to rise up from below when revealed.
/// While invisible the button is still present in the layout — use a
/// [Visibility] wrapper if zero-height behaviour is ever needed.
final class _AnimatedButton extends StatelessWidget {
  /// Callback invoked when the user taps the button.
  final VoidCallback onPressed;

  /// When `true` the button becomes fully opaque and slides into position.
  final bool isLastPage;

  const _AnimatedButton({required this.onPressed, required this.isLastPage});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: isLastPage ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        // Slide up from 50 px below when transitioning to the last page.
        transform: Matrix4.translationValues(0, isLastPage ? 0 : 50, 0),
        child: AppFilledButton.text(
          context.l10n.onboarding_get_started,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
