import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Returns a [CustomTransitionPage] with a smooth fade + slide-up animation.
///
/// Use this in every router's [GoRoute.pageBuilder] to get consistent
/// transitions across the whole app.
CustomTransitionPage<void> buildPageWithTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    reverseTransitionDuration: const Duration(milliseconds: 450),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeTween = CurveTween(curve: Curves.easeInOut);
      final slideTween = Tween(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );
}
