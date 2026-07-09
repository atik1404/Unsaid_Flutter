import 'package:designsystem/designsystem.dart';
import 'package:edit_profile/src/state/edit_profile_cubit.dart';
import 'package:edit_profile/src/state/edit_profile_state.dart';
import 'package:edit_profile/src/widgets/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:ui/ui.dart';

/// The Edit Profile screen (the "smart" widget).
///
/// Owns the [BlocListener] that reacts to terminal submission states — toasting
/// success/failure feedback and, on success, popping back to the Profile screen
/// with a `true` result so it can refresh. The form fields themselves live in
/// the const [EditProfileForm] "dumb" widget.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        titleWidget: AppText.headlineSmall(
          context.l10n.edit_profile_title,
          textWeight: AppTextWeight.extraBold,
        ),
        elevation: 0,
        backgroundColor: context.scaffoldTheme.backgroundColor,
        foregroundColor: context.appColors.brand,
      ),
      body: BlocListener<EditProfileCubit, EditProfileState>(
        // Only react when the submission status changes to avoid duplicate
        // toasts triggered by unrelated field updates.
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: _onStateChanged,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.s24.r),
          child: const EditProfileForm(),
        ),
      ),
    );
  }

  /// Handles terminal states: on success toast then pop back with `true` so the
  /// Profile screen refreshes; on failure toast the error. Pure side effects.
  void _onStateChanged(BuildContext context, EditProfileState state) {
    if (state.status.isSuccess) {
      AppToast.toast(
        message: state.successMessage?.isNotEmpty == true
            ? state.successMessage!
            : context.l10n.edit_profile_success,
        toastType: ToastType.success,
      );
      context.pop(true);
    } else if (state.status.isFailure && state.errorMessage != null) {
      AppToast.toast(message: state.errorMessage!, toastType: ToastType.error);
    }
  }
}
