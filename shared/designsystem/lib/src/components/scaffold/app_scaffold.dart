import 'package:designsystem/src/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;

  // Layout
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool extendBodyBehindAppBar;
  final bool enableGradientBackground;

  // Behavior
  final bool resizeToAvoidBottomInset;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final EdgeInsetsGeometry? padding;
  final bool dismissKeyboardOnTap;
  final bool selectableText;

  // State
  final bool isLoading;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.enableGradientBackground = false,
    this.safeAreaTop = false,
    this.safeAreaBottom = false,
    this.padding,
    this.dismissKeyboardOnTap = true,
    this.selectableText = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.scaffoldTheme;
    final hasGradientBackground = enableGradientBackground && theme.gradientColor != null;

    // The body, with optional padding and selection support.
    var content = body;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }
    if (selectableText) {
      content = SelectionArea(child: content);
    }

    // Respect extendBodyBehindAppBar by disabling top safe area when it's on.
    final effectiveSafeAreaTop = safeAreaTop && !extendBodyBehindAppBar;

    content = SafeArea(
      top: effectiveSafeAreaTop,
      bottom: safeAreaBottom,
      child: content,
    );

    Widget scaffold = Scaffold(
      backgroundColor: hasGradientBackground ? Colors.transparent : theme.backgroundColor,
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    if (hasGradientBackground) {
      scaffold = DecoratedBox(
        decoration: BoxDecoration(gradient: theme.gradientColor),
        child: scaffold,
      );
    }

    // Keyboard dismissal: translucent so empty space is hit-testable.
    if (dismissKeyboardOnTap) {
      scaffold = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: scaffold,
      );
    }

    // Loading overlay: absorbs pointers, blocks back navigation.
    final stack = Stack(
      children: [
        scaffold,
        if (isLoading)
          Positioned.fill(
            child: PopScope(
              canPop: false,
              child: AbsorbPointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.overlayStyle,
      child: stack,
    );
  }
}
