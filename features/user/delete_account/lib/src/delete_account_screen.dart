import 'package:delete_account/src/state/delete_account_cubit.dart';
import 'package:delete_account/src/state/delete_account_state.dart';
import 'package:delete_account/src/widgets/delete_account_form.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:ui/ui.dart';

/// The Delete Account screen (the "smart" widget).
///
/// Owns the [BlocListener] that reacts to terminal submission states — logging
/// the user out on success and toasting on failure — and lays out the static
/// page chrome. The interactive fields live in the const [DeleteAccountForm]
/// "dumb" widget, which talks back to [DeleteAccountCubit] directly.
class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        titleWidget: AppText.headlineSmall(
          context.l10n.delete_account_title,
          textWeight: AppTextWeight.extraBold,
          color: context.appColors.contentError,
        ),
        elevation: 0,
        backgroundColor: context.scaffoldTheme.backgroundColor,
        foregroundColor: context.appColors.brand,
      ),
      body: BlocListener<DeleteAccountCubit, DeleteAccountState>(
        // Only react when the submission status changes to avoid duplicate
        // toasts triggered by unrelated field updates.
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: _onStateChanged,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.s24.r),
          child: DeleteAccountForm(
            onDelete: () {
              context
                  .read<DeleteAccountCubit>()
                  .deleteAccount(); //call delete api
            },
          ),
        ),
      ),
    );
  }

  /// Terminal-state side effects. On success: toast, clear all local session
  /// data, flip the router's auth guard and land on a clean location. On
  /// failure: surface the error via a toast.
  void _onStateChanged(BuildContext context, DeleteAccountState state) {
    if (state.status.isSuccess) {
      final message = (state.successMessage?.isNotEmpty ?? false)
          ? state.successMessage!
          : context.l10n.delete_account_success;
      AppToast.toast(message: message, toastType: ToastType.success);
      _logoutAndLeave(context);
    } else if (state.status.isFailure && state.errorMessage != null) {
      AppToast.toast(message: state.errorMessage!, toastType: ToastType.error);
    }
  }

  /// Clears persisted data, flips the auth guard and navigates to a clean
  /// location — mirroring the sign-out flow.
  Future<void> _logoutAndLeave(BuildContext context) async {
    // Capture the router before any await so we never touch a stale context.
    final router = GoRouter.of(context);
    await GetIt.I<AppPrefStorage>().clear();
    authStateNotifier.setLoggedIn(isLoggedIn: false);
    router.goNamed(AppRouteName.homeScreen);
  }
}
