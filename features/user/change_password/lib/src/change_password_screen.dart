import 'package:change_password/src/state/change_password_cubit.dart';
import 'package:change_password/src/state/change_password_state.dart';
import 'package:change_password/src/widgets/password_form.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:localization/localization.dart';
import 'package:ui/ui.dart';

/// The Change Password screen (the "smart" widget).
///
/// Owns the [BlocListener] that reacts to terminal submission states —
/// toasting success/failure feedback — and lays out the static page chrome.
/// The form fields themselves live in the const [PasswordForm] "dumb" widget,
/// which talks back to [ChangePasswordCubit] directly.
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        // Only react when the submission status changes to avoid duplicate
        // toasts triggered by unrelated field updates.
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: _onStateChanged,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.s24.r),
          child: const PasswordForm(),
        ),
      ),
    );
  }

  /// Handles terminal states: toast on success then reset the form, toast on
  /// failure. Pure side effects — no rebuilding happens here.
  void _onStateChanged(BuildContext context, ChangePasswordState state) {
    if (state.status.isSuccess) {
      AppToast.toast(
        message: context.l10n.change_password_success,
        toastType: ToastType.success,
      );
      // Reset so the form can be reused.
      context.read<ChangePasswordCubit>().resetState();
    } else if (state.status.isFailure && state.errorMessage != null) {
      AppToast.toast(message: state.errorMessage!, toastType: ToastType.error);
    }
  }
}
