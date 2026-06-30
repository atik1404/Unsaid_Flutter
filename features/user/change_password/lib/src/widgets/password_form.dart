import 'package:change_password/src/state/change_password_cubit.dart';
import 'package:change_password/src/state/change_password_state.dart';
import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:localization/localization.dart';

/// Form body for the Change Password screen.
///
/// Each field and the submit button is wrapped in its own narrowly-scoped
/// [BlocBuilder] so a keystroke only rebuilds the field it affects. The
/// presentational pieces ([_PasswordField]) are dumb widgets that report
/// changes upward via callbacks and render whatever error text they're given.
class PasswordForm extends StatelessWidget {
  const PasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s16.h);
    final cubit = context.read<ChangePasswordCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Old password — rebuilds only when its value or error visibility changes.
        _FieldLabel(context.l10n.change_password_label_old),
        SizedBox(height: AppSpacing.s4.h),
        BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
          buildWhen: (prev, curr) => prev.oldPassword != curr.oldPassword || prev.showError != curr.showError,
          builder: (context, state) {
            return _PasswordField(
              hint: context.l10n.change_password_hint_old,
              errorText: state.showError ? _passwordErrorText(context, state.oldPassword.error) : null,
              onChanged: cubit.updateOldPassword,
            );
          },
        ),
        gap,

        // New password.
        _FieldLabel(context.l10n.change_password_label_new),
        SizedBox(height: AppSpacing.s4.h),
        BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
          buildWhen: (prev, curr) => prev.newPassword != curr.newPassword || prev.showError != curr.showError,
          builder: (context, state) {
            return _PasswordField(
              hint: context.l10n.change_password_hint_new,
              errorText: state.showError ? _passwordErrorText(context, state.newPassword.error) : null,
              onChanged: cubit.updateNewPassword,
            );
          },
        ),
        gap,

        // Confirm password — also surfaces the "passwords don't match" error.
        _FieldLabel(context.l10n.change_password_label_confirm),
        SizedBox(height: AppSpacing.s4.h),
        BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
          buildWhen: (prev, curr) =>
              prev.confirmPassword != curr.confirmPassword || prev.newPassword != curr.newPassword || prev.showError != curr.showError,
          builder: (context, state) {
            return _PasswordField(
              hint: context.l10n.change_password_hint_confirm,
              errorText: state.showError ? _confirmErrorText(context, state) : null,
              onChanged: cubit.updateConfirmPassword,
            );
          },
        ),
        SizedBox(height: AppSpacing.s32.h),

        // Submit button — rebuilds only when the submission status changes.
        BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (context, state) {
            final isLoading = state.status.isInProgress;
            return AppFilledButton.text(
              context.l10n.change_password_button,
              isLoading: isLoading,
              onPressed: isLoading ? null : cubit.changePassword,
            );
          },
        ),
      ],
    );
  }

  /// Maps a Formz [ValidationError] to a localized password-field message.
  String? _passwordErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.empty => context.l10n.validation_password_required,
      ValidationError.tooShort => context.l10n.validation_password_too_short,
      _ => null,
    };
  }

  /// Confirm field shows the standard field-level error first, then the
  /// mismatch error once the field itself is otherwise valid.
  String? _confirmErrorText(BuildContext context, ChangePasswordState state) {
    final fieldError = _passwordErrorText(context, state.confirmPassword.error);
    if (fieldError != null) return fieldError;
    if (state.confirmPassword.value != state.newPassword.value) {
      return context.l10n.change_password_error_mismatch;
    }
    return null;
  }
}

/// Small label shown above each password field.
class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return AppText.bodySmall(
      text,
      textWeight: AppTextWeight.medium,
      color: context.appColors.contentTertiary,
    );
  }
}

/// Dumb password input with a built-in visibility toggle.
///
/// Visibility is purely presentational local state; the field value itself is
/// owned by the cubit and reported upward via [onChanged].
class _PasswordField extends StatefulWidget {
  final String hint;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _PasswordField({required this.hint, required this.onChanged, this.errorText});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: widget.hint,
      obscureText: _obscured,
      variant: AppInputFieldVariant.filled,
      textInputAction: TextInputAction.done,
      maxLength: 20,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      suffixIcon: AppIcon(
        GestureDetector(
          onTap: () => setState(() => _obscured = !_obscured),
          child: Icon(_obscured ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
        ),
      ),
    );
  }
}
