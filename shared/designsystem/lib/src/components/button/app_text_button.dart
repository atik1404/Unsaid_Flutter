import 'package:designsystem/src/components/button/button.dart';
import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final AppTextButtonStyle style;

  const AppTextButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.padding = const EdgeInsets.all(4),
    this.style = const AppTextButtonStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return AppButtonCore(
      variant: AppButtonVariant.text,
      onPressed: onPressed,
      isLoading: isLoading,
      leading: style.leading,
      trailing: style.trailing,
      intent: style.intent,
      shape: AppButtonShape.pill,
      padding: padding,
      shrinkWrap: true,
      child: Text(label),
    );
  }
}

final class AppTextButtonStyle {
  final AppButtonIntent intent;
  final Widget? leading;
  final Widget? trailing;

  const AppTextButtonStyle({
    this.leading,
    this.trailing,
    this.intent = const AppButtonIntent.brand(),
  });

  AppTextButtonStyle copyWith({
    AppButtonIntent? intent,
    Widget? leading,
    Widget? trailing,
  }) {
    return AppTextButtonStyle(
      intent: intent ?? this.intent,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
    );
  }
}
