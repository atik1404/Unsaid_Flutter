import 'package:change_password/src/state/change_password_cubit.dart';
import 'package:change_password/src/state/change_password_state.dart';
import 'package:change_password/src/widgets/password_form.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:ui/ui.dart';

/// The Change Password screen.
///
/// Presents a form with old, new, and confirm password fields.
/// Uses [BlocConsumer] to react to validation errors and success events.
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        titleWidget: AppText.headlineSmall(
          context.l10n.change_password_title,
          textWeight: AppTextWeight.extraBold,
        ),
        elevation: 0,
        backgroundColor: context.scaffoldTheme.backgroundColor,
        foregroundColor: context.appColors.brand,
      ),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.s24.r),
            child: PasswordForm(
              isLoading: state.isLoading,
              onSubmit:
                  ({
                    required oldPassword,
                    required newPassword,
                    required confirmPassword,
                  }) {
                    context.read<ChangePasswordCubit>().changePassword(
                      oldPassword: oldPassword,
                      newPassword: newPassword,
                      confirmPassword: confirmPassword,
                    );
                  },
            ),
          );
        },
      ),
    );
  }

  /// Reacts to cubit state changes by showing toast feedback.
  void _handleStateChanges(
    BuildContext context,
    ChangePasswordState state,
  ) {
    if (state.isSuccess) {
      AppToast.toast(message: context.l10n.change_password_success, toastType: ToastType.success);
      // Reset so the form can be reused
      context.read<ChangePasswordCubit>().resetState();
    }

    if (state.errorMessage != null) {
      // Map known error codes to localised messages
      final message = state.errorMessage == 'mismatch' ? context.l10n.change_password_error_mismatch : state.errorMessage!;

      AppToast.toast(message: message, toastType: ToastType.error);
    }
  }
}
