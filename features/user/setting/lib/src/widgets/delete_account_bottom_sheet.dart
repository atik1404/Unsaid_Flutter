import 'package:designsystem/designsystem.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:setting/src/state/delete_account_cubit.dart';
import 'package:setting/src/state/delete_account_state.dart';
import 'package:ui/ui.dart';

/// Opens the delete-account confirmation bottom sheet.
///
/// The sheet owns its own [DeleteAccountCubit], scoped to the modal route, so
/// the destructive flow is fully self-contained and torn down on dismissal.
Future<void> showDeleteAccountBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => DeleteAccountCubit(deleteAccountUseCase: GetIt.I<DeleteAccountUseCase>()),
      child: const _DeleteAccountSheet(),
    ),
  );
}

/// Confirmation sheet for the destructive delete-account action.
///
/// The "smart" piece: it hosts the [BlocListener] that reacts to terminal
/// states — logging the user out on success, toasting on failure — and lays out
/// the header, warning, confirmation field and action buttons.
class _DeleteAccountSheet extends StatelessWidget {
  const _DeleteAccountSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocListener<DeleteAccountCubit, DeleteAccountState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: _onStateChanged,
      child: Padding(
        // Lift the sheet above the keyboard while the user types.
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Container(
          decoration: BoxDecoration(
            color: colors.backgroundPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.s24.r)),
          ),
          padding: EdgeInsets.fromLTRB(AppSpacing.s24.w, AppSpacing.s12.h, AppSpacing.s24.w, AppSpacing.s24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close icon (top-right).
              Align(
                alignment: Alignment.centerRight,
                child: AppIconButton(
                  Icon(CupertinoIcons.xmark, color: colors.contentSecondary, size: AppSpacing.s24.r),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Title.
              AppText.headlineSmall(
                context.l10n.delete_account_sheet_title,
                textWeight: AppTextWeight.extraBold,
                color: colors.contentError,
              ),
              SizedBox(height: AppSpacing.s8.h),
              // Warning / confirmation message.
              AppText.bodyMedium(
                context.l10n.delete_account_sheet_message,
                color: colors.contentSecondary,
                textWeight: AppTextWeight.regular,
              ),
              SizedBox(height: AppSpacing.s16.h),
              AppText.bodySmall(
                context.l10n.delete_account_sheet_prompt,
                color: colors.contentTertiary,
                textWeight: AppTextWeight.medium,
              ),
              SizedBox(height: AppSpacing.s8.h),
              // Confirmation input — rebuilds nothing; only reports upward.
              AppInputField(
                hint: context.l10n.delete_account_sheet_hint,
                variant: AppInputFieldVariant.filled,
                textInputAction: TextInputAction.done,
                onChanged: context.read<DeleteAccountCubit>().updateConfirmationText,
              ),
              SizedBox(height: AppSpacing.s24.h),
              const _ActionButtons(),
            ],
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
      final message = (state.successMessage?.isNotEmpty ?? false) ? state.successMessage! : context.l10n.delete_account_success;
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
    Navigator.of(context).pop(); // dismiss the sheet
    await GetIt.I<AppPrefStorage>().clear();
    authStateNotifier.setLoggedIn(isLoggedIn: false);
    router.goNamed(AppRouteName.homeScreen);
  }
}

/// Cancel + Delete action row. Delete stays disabled until the typed text
/// exactly matches the required keyword, and shows a spinner while in flight.
class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppOutlineButton.text(
            context.l10n.delete_account_cancel_button,
            onPressed: () => Navigator.of(context).pop(),
            style: const AppOutlineButtonStyle(shape: AppButtonShape.pill),
          ),
        ),
        SizedBox(width: AppSpacing.s12.w),
        Expanded(
          // Rebuilds only when the confirmation match or submission status changes.
          child: BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
            buildWhen: (prev, curr) => prev.isConfirmed != curr.isConfirmed || prev.status != curr.status,
            builder: (context, state) {
              final isLoading = state.status.isInProgress;
              return AppFilledButton.text(
                context.l10n.delete_account_delete_button,
                isLoading: isLoading,
                // Armed only when the keyword matches; null disables the button.
                onPressed: state.isConfirmed && !isLoading ? context.read<DeleteAccountCubit>().deleteAccount : null,
                style: AppFilledButtonStyle(
                  intent: AppButtonIntent.custom(
                    AppButtonVariantSet.standard(
                      solid: context.appColors.contentError,
                      onSolid: context.appColors.backgroundPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
