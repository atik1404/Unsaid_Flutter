import 'package:common/common.dart';
import 'package:create_post/src/state/create_post_bloc.dart';
import 'package:create_post/src/state/create_post_state.dart';
import 'package:create_post/src/widgets/anonymous_card.dart';
import 'package:create_post/src/widgets/topics_selection.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:ui/ui.dart';

/// Entry point for the Create Post feature ("smart" widget).
///
/// Owns the page-level wiring: the [BlocListener] that reacts to terminal
/// submission outcomes (success/error) and the scaffold scaffolding. All
/// rendering is delegated to small, stateless "dumb" widgets below that receive
/// everything they need through their constructors and report user intent back
/// to [CreatePostBloc].
class CreatePostScreen extends StatelessWidget {
  final AppPrefStorage _prefStorage = GetIt.I.get();

  CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      // Only react to lifecycle transitions, not to every keystroke/mood change.
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: _onStateChanged,
      child: AppScaffold(
        appBar: AppTopBar(
          titleWidget: AppText.headlineSmall(
            context.l10n.create_post_title,
            textWeight: AppTextWeight.extraBold,
            color: context.appColors.contentBrand,
          ),
          backgroundColor: context.scaffoldTheme.backgroundColor,
          foregroundColor: context.appColors.brand,
          leading: AppIconButton(
            AppIcon(const Icon(CupertinoIcons.clear), color: context.appColors.brand),
            onPressed: () => context.pop(),
          ),
          actions: const [_PostActionButton()],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(AppSpacing.s24.r),
          child: const _VisibilityFooter(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.s16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnonymousCard(anonymousName: _prefStorage.getString(PrefKey.anonymousName), avatar: _prefStorage.getString(PrefKey.profilePicture)),
                SizedBox(height: AppSpacing.s16.h),
                AppText.bodyLarge(
                  context.l10n.create_post_mood_label,
                  textWeight: AppTextWeight.semiBold,
                  color: context.appColors.contentPrimary,
                ),
                SizedBox(height: AppSpacing.s12.h),
                const _MoodSelector(),
                SizedBox(height: AppSpacing.s8.h),

                const AppDivider(),
                SizedBox(height: AppSpacing.s8.h),
                const _PostInputField(),
                SizedBox(height: AppSpacing.s8.h),
                AppText.bodyLarge(
                  'Topics',
                  textWeight: AppTextWeight.semiBold,
                  color: context.appColors.contentPrimary,
                ),
                SizedBox(height: AppSpacing.s12.h),
                const TopicSelector(),
                SizedBox(height: AppSpacing.s8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles terminal submission states: surface a toast and, on success, close
  /// the screen so the user returns to the feed.
  void _onStateChanged(BuildContext context, CreatePostState state) {
    switch (state.status) {
      case CreatePostStatus.success:
        AppToast.toast(message: state.successMessage ?? '', toastType: ToastType.success);
        context.pop();
      case CreatePostStatus.failure:
        AppToast.toast(message: state.errorMessage?.resolveMessage(context) ?? '', toastType: ToastType.error);
      case CreatePostStatus.initial:
      case CreatePostStatus.submitting:
        break;
      case CreatePostStatus.loading:
        break;
    }
  }
}

// ── Post action ─────────────────────────────────────────────────────────────

/// The "Post" button in the app bar. Disabled until the draft is valid and
/// while a submission is in flight to avoid duplicate requests.
class _PostActionButton extends StatelessWidget {
  const _PostActionButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      buildWhen: (prev, curr) => prev.canSubmit != curr.canSubmit || prev.isSubmitting != curr.isSubmitting,
      builder: (context, state) {
        return AppTextButton(
          context.l10n.create_post_action_post,
          onPressed: state.canSubmit ? () => context.read<CreatePostBloc>().add(const CreatePostSubmitted()) : null,
        );
      },
    );
  }
}

// ── Mood selector ───────────────────────────────────────────────────────────

/// Horizontal list of selectable mood pills. Reads the current selection from
/// state and reports taps back to the bloc.
class _MoodSelector extends StatelessWidget {
  const _MoodSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      buildWhen: (prev, curr) => prev.selectedMood != curr.selectedMood,
      builder: (context, state) {
        final listMoods = List<MoodType>.from(MoodType.values)..remove(MoodType.all);
        return SizedBox(
          height: AppSpacing.s24.h,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: listMoods.length,
            itemBuilder: (context, index) {
              final mood = listMoods[index];
              return MoodPillItem(
                mood: mood.name,
                isSelected: mood == state.selectedMood,
                onTap: () => context.read<CreatePostBloc>().add(MoodSelected(mood)),
              );
            },
          ),
        );
      },
    );
  }
}

// ── Input field ─────────────────────────────────────────────────────────────

/// Multiline composer for the post body. Reports edits to the bloc; the bloc is
/// the single source of truth for the draft text.
class _PostInputField extends StatelessWidget {
  const _PostInputField();

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      hint: context.l10n.create_post_hint,
      minLines: 5,
      maxLines: 15,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      onChanged: (value) => context.read<CreatePostBloc>().add(PostBodyChanged(value)),
    );
  }
}

// ── Footer ──────────────────────────────────────────────────────────────────

/// Static visibility reminder pinned to the bottom of the screen.
class _VisibilityFooter extends StatelessWidget {
  const _VisibilityFooter();

  @override
  Widget build(BuildContext context) {
    return InlineIconLabel(
      leadingWidget: AppIcon(
        const Icon(CupertinoIcons.info),
        color: context.appColors.contentWarning,
        size: IconSizes.indicator,
        tint: true,
      ),
      horizontalGap: AppSpacing.s16.w,
      text: AppText.captionLarge(
        context.l10n.create_post_visibility_note,
        textWeight: AppTextWeight.light,
        color: context.appColors.contentBrand,
        maxLines: 2,
      ),
    );
  }
}
