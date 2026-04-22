import 'package:designsystem/src/components/button/button.dart';
import 'package:flutter/material.dart';

class AppFilledButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonHeight height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final AppFilledButtonStyle style;

  const AppFilledButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isLoading = false,
    this.height = AppButtonHeight.md,
    this.width,
    this.padding,
    this.style = const AppFilledButtonStyle(),
  });

  factory AppFilledButton.text(
    String label, {
    required VoidCallback? onPressed,
    bool isLoading = false,
    AppButtonHeight height = AppButtonHeight.md,
    double width = double.maxFinite,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 8),
    AppFilledButtonStyle style = const AppFilledButtonStyle(),
  }) {
    return AppFilledButton(
      onPressed: onPressed,
      isLoading: isLoading,
      height: height,
      width: width,
      padding: padding,
      style: style,
      child: Text(label),
    );
  }

  factory AppFilledButton.icon(
    Widget icon, {
    required VoidCallback? onPressed,
    bool isLoading = false,
    AppButtonHeight height = AppButtonHeight.md,
    double? width,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 8),
    AppFilledButtonStyle style = const AppFilledButtonStyle(),
  }) {
    return AppFilledButton(
      onPressed: onPressed,
      isLoading: isLoading,
      height: height,
      width: width,
      padding: padding,
      style: style,
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppButtonCore(
      variant: AppButtonVariant.filled,
      onPressed: onPressed,
      isLoading: isLoading,
      leading: style.leading,
      trailing: style.trailing,
      intent: style.intent,
      width: width,
      height: height,
      shape: style.shape,
      padding: padding,
      shrinkWrap: style.shrinkWrap,
      child: child,
    );
  }
}

final class AppFilledButtonStyle {
  final AppButtonIntent intent;
  final AppButtonShape shape;
  final Widget? leading;
  final Widget? trailing;
  final bool shrinkWrap;

  const AppFilledButtonStyle({
    this.leading,
    this.trailing,
    this.intent = const AppButtonIntent.brand(),
    this.shape = AppButtonShape.rounded,
    this.shrinkWrap = false,
  });

  AppFilledButtonStyle copyWith({
    AppButtonIntent? intent,
    AppButtonShape? shape,
    Widget? leading,
    Widget? trailing,
    bool? shrinkWrap,
  }) {
    return AppFilledButtonStyle(
      intent: intent ?? this.intent,
      shape: shape ?? this.shape,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
    );
  }
}
