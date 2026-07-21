import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:edit_profile/src/state/edit_profile_cubit.dart';
import 'package:edit_profile/src/state/edit_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

/// Form body for the Edit Profile screen.
///
/// Each field and the submit button is wrapped in its own narrowly-scoped
/// [BlocBuilder] so a keystroke only rebuilds the field it affects. The
/// presentational [_ProfileField] widgets are pre-populated from the cubit's
/// seeded state and report changes upward via callbacks.
class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s16.h);
    final cubit = context.read<EditProfileCubit>();
    final initial = cubit.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full name.
        _FieldLabel(context.l10n.edit_profile_label_name),
        SizedBox(height: AppSpacing.s4.h),
        BlocBuilder<EditProfileCubit, EditProfileState>(
          buildWhen: (prev, curr) =>
              prev.fullName != curr.fullName ||
              prev.showError != curr.showError,
          builder: (context, state) {
            return _ProfileField(
              initialValue: initial.initialFullName,
              hint: context.l10n.edit_profile_hint_name,
              keyboardType: TextInputType.name,
              maxLength: 30,
              errorText: state.showError
                  ? _nameErrorText(context, state.fullName.error)
                  : null,
              onChanged: cubit.updateFullName,
            );
          },
        ),
        gap,

        // Email.
        _FieldLabel(context.l10n.edit_profile_label_email),
        SizedBox(height: AppSpacing.s4.h),
        BlocBuilder<EditProfileCubit, EditProfileState>(
          buildWhen: (prev, curr) =>
              prev.email != curr.email || prev.showError != curr.showError,
          builder: (context, state) {
            return _ProfileField(
              initialValue: initial.initialEmail,
              hint: context.l10n.edit_profile_hint_email,
              keyboardType: TextInputType.emailAddress,
              errorText: state.showError
                  ? _emailErrorText(context, state.email.error)
                  : null,
              onChanged: cubit.updateEmail,
            );
          },
        ),
        gap,

        // Phone.
        _FieldLabel(context.l10n.edit_profile_label_phone),
        SizedBox(height: AppSpacing.s4.h),
        BlocBuilder<EditProfileCubit, EditProfileState>(
          buildWhen: (prev, curr) =>
              prev.phone != curr.phone || prev.showError != curr.showError,
          builder: (context, state) {
            return _ProfileField(
              initialValue: initial.initialPhone,
              hint: context.l10n.edit_profile_hint_phone,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              errorText: state.showError
                  ? _phoneErrorText(context, state.phone.error)
                  : null,
              onChanged: cubit.updatePhone,
            );
          },
        ),
        gap,

        // Bio (optional, max length).
        _FieldLabel(context.l10n.edit_profile_label_bio),
        SizedBox(height: AppSpacing.s4.h),
        BlocBuilder<EditProfileCubit, EditProfileState>(
          buildWhen: (prev, curr) =>
              prev.bio != curr.bio || prev.showError != curr.showError,
          builder: (context, state) {
            return _ProfileField(
              initialValue: initial.initialBio,
              hint: context.l10n.edit_profile_hint_bio,
              keyboardType: TextInputType.multiline,
              maxLength: BioInputValidator.maxLength,
              maxLines: 4,
              minLines: 3,
              textInputAction: TextInputAction.newline,
              errorText: state.showError
                  ? _bioErrorText(context, state.bio.error)
                  : null,
              onChanged: cubit.updateBio,
            );
          },
        ),
        SizedBox(height: AppSpacing.s32.h),

        // Save button — disabled until the form is valid and something changed;
        // shows a spinner while the update request is in flight.
        BlocBuilder<EditProfileCubit, EditProfileState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.fullName != curr.fullName ||
              prev.email != curr.email ||
              prev.phone != curr.phone ||
              prev.bio != curr.bio,
          builder: (context, state) {
            return AppFilledButton.text(
              context.l10n.edit_profile_button,
              isLoading: state.isSubmitting,
              onPressed: state.canSubmit ? cubit.save : null,
            );
          },
        ),
      ],
    );
  }

  String? _nameErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.empty => context.l10n.validation_name_required,
      ValidationError.tooShort => context.l10n.validation_name_too_short,
      ValidationError.tooLong => context.l10n.validation_name_too_long,
      _ => null,
    };
  }

  String? _emailErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.empty => context.l10n.validation_email_required,
      ValidationError.invalid => context.l10n.validation_email_invalid,
      _ => null,
    };
  }

  String? _phoneErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.empty => context.l10n.validation_phone_required,
      ValidationError.invalid => context.l10n.validation_phone_invalid,
      _ => null,
    };
  }

  String? _bioErrorText(BuildContext context, ValidationError? error) {
    return switch (error) {
      ValidationError.tooLong => context.l10n.validation_bio_too_long,
      _ => null,
    };
  }
}

/// Small label shown above each field.
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

/// Dumb, pre-populated text input.
///
/// Owns a [TextEditingController] seeded with [initialValue] so the field shows
/// the user's current data; the value itself is owned by the cubit and reported
/// upward via [onChanged].
class _ProfileField extends StatefulWidget {
  final String initialValue;
  final String hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String> onChanged;

  const _ProfileField({
    required this.initialValue,
    required this.hint,
    required this.onChanged,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  State<_ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<_ProfileField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      controller: _controller,
      hint: widget.hint,
      variant: AppInputFieldVariant.filled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
    );
  }
}
