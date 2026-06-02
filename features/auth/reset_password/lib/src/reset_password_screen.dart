import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:reset_password/src/state/reset_password_cubit.dart';
import 'package:reset_password/src/state/reset_password_state.dart';
import 'package:reset_password/src/widgets/password_form.dart';
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
        titleWidget: AppText.headlineSmall(context.l10n.reset_password_title, textWeight: AppTextWeight.extraBold),
        elevation: 0,
        backgroundColor: context.scaffoldTheme.backgroundColor,
        foregroundColor: context.appColors.brand,
        onBackPressed: () => context.pop(),
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.s24.r),
            child: PasswordForm(
              isLoading: state.isLoading,
              onSubmit: ({required newPassword, required confirmPassword}) {
                context.read<ResetPasswordCubit>().resetPassword(newPassword: newPassword, confirmPassword: confirmPassword);
              },
            ),
          );
        },
      ),
    );
  }

  /// Reacts to cubit state changes by showing toast feedback.
  void _handleStateChanges(BuildContext context, ResetPasswordState state) {
    if (state.isSuccess) {
      AppToast.toast(message: context.l10n.change_password_success, toastType: ToastType.success);
      // Reset so the form can be reused
      context.read<ResetPasswordCubit>().resetState();
    }

    if (state.errorMessage != null) {
      // Map known error codes to localised messages
      final message = state.errorMessage == 'mismatch' ? context.l10n.change_password_error_mismatch : state.errorMessage!;

      AppToast.toast(message: message, toastType: ToastType.error);
    }
  }
}
