import 'package:designsystem/src/components/button/button.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final AppButtonIntent intent;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EdgeInsetsGeometry padding;

  const AppIconButton(
    this.icon, {
    super.key,
    this.intent = const AppButtonIntent.brand(),
    required this.onPressed,
    this.isLoading = false,
    this.padding = const EdgeInsets.all(4),
  });

  @override
  Widget build(BuildContext context) {
    return AppButtonCore(
      variant: AppButtonVariant.text,
      onPressed: onPressed,
      isLoading: isLoading,
      intent: intent,
      shape: AppButtonShape.pill,
      padding: padding,
      shrinkWrap: true,
      child: icon,
    );
  }
}
