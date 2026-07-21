import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:localization/localization.dart';
import 'package:setting/src/state/delete_all_posts_cubit.dart';
import 'package:setting/src/state/delete_all_posts_state.dart';
import 'package:ui/ui.dart';

/// Confirmation sheet for the destructive delete-all-posts action.
///
/// Hosts the [BlocListener] that reacts to terminal states — dismissing on
/// success, toasting on failure — and lays out the header, warning,
/// confirmation field and action buttons.
class DeleteAllPostsBottomSheet extends StatelessWidget {
  const DeleteAllPostsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocListener<DeleteAllPostsCubit, DeleteAllPostsState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: _onStateChanged,
      child: Padding(
        // Lift the sheet above the keyboard while the user types.
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colors.backgroundPrimary,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.s24.r),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s24.w,
            AppSpacing.s12.h,
            AppSpacing.s24.w,
            AppSpacing.s24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close icon (top-right).
              Align(
                alignment: Alignment.centerRight,
                child: AppIconButton(
                  Icon(
                    CupertinoIcons.xmark,
                    color: colors.contentSecondary,
                    size: AppSpacing.s24.r,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Title.
              AppText.headlineSmall(
                context.l10n.delete_all_posts_title,
                textWeight: AppTextWeight.extraBold,
                color: colors.contentError,
              ),
              SizedBox(height: AppSpacing.s8.h),
              // Warning / confirmation message.
              AppText.bodyMedium(
                context.l10n.delete_all_posts_message,
                color: colors.contentSecondary,
                textWeight: AppTextWeight.regular,
              ),
              SizedBox(height: AppSpacing.s16.h),
              AppText.bodySmall(
                context.l10n.delete_all_posts_prompt,
                color: colors.contentTertiary,
                textWeight: AppTextWeight.medium,
              ),
              SizedBox(height: AppSpacing.s8.h),
              // Confirmation input — rebuilds nothing; only reports upward.
              AppInputField(
                hint: context.l10n.delete_all_posts_hint,
                variant: AppInputFieldVariant.filled,
                textInputAction: TextInputAction.done,
                onChanged: context
                    .read<DeleteAllPostsCubit>()
                    .updateConfirmationText,
              ),
              SizedBox(height: AppSpacing.s24.h),
              const _ActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Terminal-state side effects. On success: toast and dismiss the sheet. On
  /// failure: surface the error via a toast.
  void _onStateChanged(BuildContext context, DeleteAllPostsState state) {
    if (state.status.isSuccess) {
      final message = (state.successMessage?.isNotEmpty ?? false)
          ? state.successMessage!
          : context.l10n.delete_all_posts_success;
      AppToast.toast(message: message, toastType: ToastType.success);
      Navigator.of(context).pop();
    } else if (state.status.isFailure && state.errorMessage != null) {
      AppToast.toast(message: state.errorMessage!, toastType: ToastType.error);
    }
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
            context.l10n.delete_all_posts_cancel_button,
            onPressed: () => Navigator.of(context).pop(),
            style: const AppOutlineButtonStyle(shape: AppButtonShape.pill),
          ),
        ),
        SizedBox(width: AppSpacing.s12.w),
        Expanded(
          // Rebuilds only when the confirmation match or submission status changes.
          child: BlocBuilder<DeleteAllPostsCubit, DeleteAllPostsState>(
            buildWhen: (prev, curr) =>
                prev.isConfirmed != curr.isConfirmed ||
                prev.status != curr.status,
            builder: (context, state) {
              final isLoading = state.status.isInProgress;
              return AppFilledButton.text(
                context.l10n.delete_all_posts_delete_button,
                isLoading: isLoading,
                // Armed only when the keyword matches; null disables the button.
                onPressed: state.isConfirmed && !isLoading
                    ? context.read<DeleteAllPostsCubit>().deleteAllPosts
                    : null,
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
