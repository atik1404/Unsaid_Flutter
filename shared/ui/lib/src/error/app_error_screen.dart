import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class AppErrorScreen extends StatefulWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const AppErrorScreen({super.key, this.title, this.message, this.onRetry});

  @override
  State<AppErrorScreen> createState() => _AppErrorScreenState();
}

class _AppErrorScreenState extends State<AppErrorScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: AppImage.asset(
              AppDrawables.appBackground,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),

                // ১. Animated Icon Hero
                _AnimatedIconHero(floatAnimation: _floatAnimation),

                const Spacer(),

                // ২. contentError Title
                StaggeredFadeSlide(
                  delay: 0,
                  duration: const Duration(milliseconds: 600),
                  child: AppText.headlineMedium(
                    widget.title ?? context.l10n.message_connection_timeout,
                    textAlign: TextAlign.center,
                    textWeight: AppTextWeight.bold,
                    color: context.appColors.contentError,
                    maxLines: 1,
                  ),
                ),

                // ৩. contentError Message (20% Delay)
                const SizedBox(height: 8),
                StaggeredFadeSlide(
                  delay: 0.2,
                  duration: const Duration(milliseconds: 600),
                  child: AppText.bodyMedium(
                    widget.message ?? context.l10n.message_something_went_wrong,
                    textAlign: TextAlign.center,
                    textWeight: AppTextWeight.regular,
                    color: context.appColors.white,
                    maxLines: 5,
                  ),
                ),

                const Spacer(flex: 2),

                // ৪. Retry Button (40% Delay)
                if (widget.onRetry != null) ...[
                  StaggeredFadeSlide(
                    delay: 0.4,
                    duration: const Duration(milliseconds: 800),
                    child: AppFilledButton.text(
                      context.l10n.action_retry,
                      onPressed: widget.onRetry,
                      height: AppButtonHeight.lg,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StaggeredFadeSlide extends StatelessWidget {
  final Widget child;
  final double delay;
  final Duration duration;

  const StaggeredFadeSlide({
    super.key,
    required this.child,
    required this.delay,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final remainingTime = 1.0 - delay;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final adjustedValue = (value - delay).clamp(0.0, 1.0) * (1 / remainingTime);

        return Transform.translate(
          offset: Offset(0, 20 * (1 - adjustedValue)),
          child: Opacity(
            opacity: adjustedValue,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _AnimatedIconHero extends StatelessWidget {
  final Animation<double> floatAnimation;

  const _AnimatedIconHero({required this.floatAnimation});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.appColors;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, floatAnimation.value),
            child: child,
          );
        },
        child: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.contentError.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.contentError.withValues(alpha: 0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 50,
                  right: 50,
                  child: Icon(
                    Icons.language_outlined,
                    size: 30,
                    color: colorScheme.contentError.withValues(alpha: 0.5),
                  ),
                ),
                Positioned(
                  bottom: 45,
                  left: 45,
                  child: Icon(
                    Icons.signal_wifi_bad_rounded,
                    size: 30,
                    color: colorScheme.contentError.withValues(alpha: 0.3),
                  ),
                ),
                Icon(
                  Icons.cloud_off_rounded,
                  size: 80,
                  color: colorScheme.contentError,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
