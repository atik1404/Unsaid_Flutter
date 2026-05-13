import 'package:common/common.dart';
import 'package:create_post/src/widgets/anonymous_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String selectedMood = "ALL";
  final TextEditingController _postController = TextEditingController();

  _CreatePostScreenState();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        titleWidget: AppText.displaySmall(
          'New Post',
          textWeight: AppTextWeight.extraBold,
          color: context.appColors.contentBrand,
        ),
        backgroundColor: context.scaffoldTheme.backgroundColor,
        foregroundColor: context.appColors.brand,
        leading: AppIcon(
          const Icon(CupertinoIcons.clear),
          color: context.appColors.brand,
        ),
        actions: [
          AppTextButton(
            'Post',
            onPressed: () {
              // Handle post creation logic here
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppSpacing.s1.h),
          child: _buildFooter(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.s16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnonymousCard(),
              SizedBox(height: AppSpacing.s16.h),
              AppText.bodyLarge('How are you feeling today?', textWeight: AppTextWeight.semiBold, color: context.appColors.contentPrimary),
              SizedBox(height: AppSpacing.s12.h),
              _buildMoodList(),
              SizedBox(height: AppSpacing.s8.h),
              const AppDivider(),
              SizedBox(height: AppSpacing.s8.h),
              _buildInputBox(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodList() {
    final moods = MoodType.values.map((e) => e.name).toList();

    return SizedBox(
      height: AppSpacing.s24.h,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final moodType = MoodType.values[index];
          return MoodPillItem(
            mood: moodType.name,
            isSelected: moodType.name.toUpperCase() == selectedMood, // Replace with your selection logic
            onTap: () {
              setState(() {
                if (selectedMood == moodType.name.toUpperCase()) {
                  return;
                }
                selectedMood = moodType.name.toUpperCase(); // Update selected mood
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildInputBox(BuildContext context) {
    return AppInputField(
      controller: _postController,
      hint: "What's on your mind?",
      minLines: 5,
      maxLines: 15,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        AppIcon(
          const Icon(CupertinoIcons.info),
          color: context.appColors.contentSecondary,
        ),
        SizedBox(width: AppSpacing.s8.w),
        AppText.captionSmall(
          "Your post will be visible to everyone. Be mindful of what you share.",
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSecondary,
        ),
      ],
    );
  }
}
