import 'package:designsystem/src/components/button/button.dart';
import 'package:flutter/material.dart';

class AppOutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonHeight height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final AppOutlineButtonStyle style;

  const AppOutlineButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isLoading = false,
    this.height = AppButtonHeight.md,
    this.width,
    this.padding,
    this.style = const AppOutlineButtonStyle(),
  });

  factory AppOutlineButton.text(
    String label, {
    required VoidCallback? onPressed,
    bool isLoading = false,
    AppButtonHeight height = AppButtonHeight.md,
    double width = double.maxFinite,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
    AppOutlineButtonStyle style = const AppOutlineButtonStyle(),
  }) {
    return AppOutlineButton(
      onPressed: onPressed,
      isLoading: isLoading,
      height: height,
      width: width,
      padding: padding,
      style: style,
      child: Text(label),
    );
  }

  factory AppOutlineButton.icon(
    Widget icon, {
    required VoidCallback? onPressed,
    bool isLoading = false,
    AppButtonHeight height = AppButtonHeight.md,
    double? width,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
    AppOutlineButtonStyle style = const AppOutlineButtonStyle(),
  }) {
    return AppOutlineButton(
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
      variant: AppButtonVariant.outline,
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

final class AppOutlineButtonStyle {
  final AppButtonIntent intent;
  final AppButtonShape shape;
  final Widget? leading;
  final Widget? trailing;
  final bool shrinkWrap;

  const AppOutlineButtonStyle({
    this.leading,
    this.trailing,
    this.intent = const AppButtonIntent.brand(),
    this.shape = AppButtonShape.rounded,
    this.shrinkWrap = false,
  });

  AppOutlineButtonStyle copyWith({
    AppButtonIntent? intent,
    AppButtonShape? shape,
    Widget? leading,
    Widget? trailing,
    bool? shrinkWrap,
  }) {
    return AppOutlineButtonStyle(
      intent: intent ?? this.intent,
      shape: shape ?? this.shape,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
    );
  }
}
