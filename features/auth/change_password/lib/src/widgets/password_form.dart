import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
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
  })
  onSubmit;

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

  bool _oldPasswordVisible = true;
  bool _newPasswordVisible = true;
  bool _confirmPasswordVisible = true;

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
        _buildTitle(context, context.l10n.change_password_label_old),
        SizedBox(height: AppSpacing.s4.h),
        _buildPasswordField(
          hint: context.l10n.change_password_hint_old,
          isPasswordVisible: _oldPasswordVisible,
          onToggleVisibility: () {
            setState(() => _oldPasswordVisible = !_oldPasswordVisible);
          },
        ),
        gap,

        // New password
        _buildTitle(context, context.l10n.change_password_label_new),
        SizedBox(height: AppSpacing.s4.h),
        _buildPasswordField(
          hint: context.l10n.change_password_hint_new,
          isPasswordVisible: _newPasswordVisible,
          onToggleVisibility: () {
            setState(() => _newPasswordVisible = !_newPasswordVisible);
          },
        ),
        gap,

        // Confirm password
        _buildTitle(context, context.l10n.change_password_label_confirm),
        SizedBox(height: AppSpacing.s4.h),
        _buildPasswordField(
          isPasswordVisible: _confirmPasswordVisible,
          hint: context.l10n.change_password_hint_confirm,
          onToggleVisibility: () {
            setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
          },
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

  Widget _buildTitle(BuildContext context, String text) {
    return AppText.bodySmall(
      text,
      textWeight: AppTextWeight.medium,
      color: context.appColors.contentTertiary,
    );
  }

  Widget _buildPasswordField({required String hint, required bool isPasswordVisible, required VoidCallback onToggleVisibility}) {
    return AppInputField(
      hint: hint,
      obscureText: !isPasswordVisible,
      variant: AppInputFieldVariant.filled,
      textInputAction: TextInputAction.done,
      maxLength: 20,
      suffixIcon: AppIcon(
        GestureDetector(
          onTap: onToggleVisibility,
          child: Icon(isPasswordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
        ),
      ),
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
