import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

/// A form widget containing the three password input fields and the
/// submit button for the Change Password screen.
///
/// Delegates actual submission back to the parent via [onSubmit].
class PasswordForm extends StatefulWidget {
  /// Called when the user taps the submit button.
  ///
  /// Receives the old, new, and confirm password values.
  final void Function({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) onSubmit;

  /// Whether the form is currently submitting (disables the button).
  final bool isLoading;

  const PasswordForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s16.h);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Old password
        AppText.bodySmall(
          context.l10n.change_password_label_old,
          textWeight: AppTextWeight.medium,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s4.h),
        AppInputField(
          controller: _oldPasswordController,
          hint: context.l10n.change_password_hint_old,
          obscureText: true,
        ),
        gap,

        // New password
        AppText.bodySmall(
          context.l10n.change_password_label_new,
          textWeight: AppTextWeight.medium,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s4.h),
        AppInputField(
          controller: _newPasswordController,
          hint: context.l10n.change_password_hint_new,
          obscureText: true,
        ),
        gap,

        // Confirm password
        AppText.bodySmall(
          context.l10n.change_password_label_confirm,
          textWeight: AppTextWeight.medium,
          color: context.colorScheme.contentInfo,
        ),
        SizedBox(height: AppSpacing.s4.h),
        AppInputField(
          controller: _confirmPasswordController,
          hint: context.l10n.change_password_hint_confirm,
          obscureText: true,
        ),
        SizedBox(height: AppSpacing.s32.h),

        // Submit button
        AppFilledButton.text(
          context.l10n.change_password_button,
          onPressed: widget.isLoading ? null : _handleSubmit,
        ),
      ],
    );
  }

  /// Gathers the form values and calls the parent's [onSubmit] callback.
  void _handleSubmit() {
    widget.onSubmit(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }
}
