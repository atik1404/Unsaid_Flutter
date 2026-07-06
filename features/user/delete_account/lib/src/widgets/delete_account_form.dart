import 'package:delete_account/src/models/delete_account_reason.dart';
import 'package:delete_account/src/state/delete_account_cubit.dart';
import 'package:delete_account/src/state/delete_account_state.dart';
import 'package:delete_account/src/widgets/delete_reason_tile.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:localization/localization.dart';

/// Form body for the Delete Account screen.
///
/// Lays out the permanent-action warning, the single-selection reason list, a
/// conditional free-text field (only for "Other"), the typed `DELETE`
/// confirmation, and the destructive submit button. Each interactive section
/// sits behind its own narrowly-scoped [BlocBuilder] so a keystroke or a
/// selection only rebuilds the piece it affects.
class DeleteAccountForm extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteAccountForm({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeleteAccountCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _WarningCard(),
        SizedBox(height: AppSpacing.s24.h),

        // Reason picker — rebuilds when the selection or error visibility changes.
        _SectionLabel(context.l10n.delete_account_reason_title),
        SizedBox(height: AppSpacing.s8.h),
        BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
          buildWhen: (prev, curr) => prev.selectedReason != curr.selectedReason || prev.showError != curr.showError,
          builder: (context, state) {
            final showReasonError = state.showError && state.selectedReason == null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard.rounded(
                  cornerRadius: AppCardCornerRadius.lg,
                  child: Column(
                    children: [
                      for (final reason in DeleteAccountReason.values) ...[
                        if (reason != DeleteAccountReason.values.first) const AppDivider(),
                        DeleteReasonTile(
                          label: reason.label(context),
                          selected: state.selectedReason == reason,
                          onTap: () => cubit.selectReason(reason),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showReasonError) _ErrorText(context.l10n.delete_account_reason_error),
              ],
            );
          },
        ),

        // "Other" free-text details — only shown when "Other" is selected.
        BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
          buildWhen: (prev, curr) => prev.selectedReason != curr.selectedReason || prev.showError != curr.showError || prev.isOtherDetailsMissing != curr.isOtherDetailsMissing,
          builder: (context, state) {
            if (state.selectedReason?.requiresDetails != true) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.only(top: AppSpacing.s16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(context.l10n.delete_account_other_label),
                  SizedBox(height: AppSpacing.s8.h),
                  AppInputField(
                    hint: context.l10n.delete_account_other_hint,
                    variant: AppInputFieldVariant.filled,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 300,
                    errorText: state.showError && state.isOtherDetailsMissing ? context.l10n.delete_account_other_error : null,
                    onChanged: cubit.updateOtherDetails,
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: AppSpacing.s24.h),

        // Typed confirmation — rebuilds only when the match or error visibility changes.
        _SectionLabel(context.l10n.delete_account_confirm_title),
        SizedBox(height: AppSpacing.s8.h),
        BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
          buildWhen: (prev, curr) => prev.isConfirmed != curr.isConfirmed || prev.showError != curr.showError,
          builder: (context, state) {
            return AppInputField(
              hint: context.l10n.delete_account_confirm_hint,
              variant: AppInputFieldVariant.filled,
              textInputAction: TextInputAction.done,
              errorText: state.showError && !state.isConfirmed ? context.l10n.delete_account_confirm_error : null,
              onChanged: cubit.updateConfirmationText,
            );
          },
        ),
        SizedBox(height: AppSpacing.s32.h),

        // Destructive submit — armed only when every precondition passes; shows a
        // spinner while the request is in flight.
        BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
          buildWhen: (prev, curr) => prev.canSubmit != curr.canSubmit || prev.status != curr.status,
          builder: (context, state) {
            final isLoading = state.status.isInProgress;
            return AppFilledButton.text(
              context.l10n.delete_account_button,
              isLoading: isLoading,
              style: AppFilledButtonStyle(
                intent: AppButtonIntent.custom(
                  AppButtonVariantSet.standard(
                    solid: context.appColors.contentError,
                    onSolid: context.appColors.backgroundPrimary,
                  ),
                ),
              ),
              // Armed only when the form is complete; null disables the button.
              onPressed: state.canSubmit && !isLoading ? onDelete : null,
            );
          },
        ),
      ],
    );
  }
}

/// Permanent-action warning banner. Static content, so it never rebuilds.
class _WarningCard extends StatelessWidget {
  const _WarningCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppCard.rounded(
      tone: AppCardTone.danzer,
      cornerRadius: AppCardCornerRadius.lg,
      padding: EdgeInsets.all(AppSpacing.s16.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.exclamationmark_triangle_fill, color: colors.contentError, size: AppSpacing.s24.r),
          SizedBox(width: AppSpacing.s12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bodyMedium(
                  context.l10n.delete_account_warning_title,
                  color: colors.contentError,
                  textWeight: AppTextWeight.bold,
                ),
                SizedBox(height: AppSpacing.s4.h),
                AppText.bodySmall(
                  context.l10n.delete_account_warning_message,
                  color: colors.contentSecondary,
                  textWeight: AppTextWeight.regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small section heading shown above each group.
class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return AppText.bodySmall(
      text,
      textWeight: AppTextWeight.medium,
      color: context.appColors.contentTertiary,
    );
  }
}

/// Inline validation message shown beneath a group.
class _ErrorText extends StatelessWidget {
  final String text;

  const _ErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.s8.h, left: AppSpacing.s4.w),
      child: AppText.captionSmall(
        text,
        color: context.appColors.contentError,
        textWeight: AppTextWeight.regular,
      ),
    );
  }
}
