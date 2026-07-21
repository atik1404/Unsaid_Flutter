import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui/ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopicPillItem extends StatelessWidget {
  final String topic;
  final bool isSelected;
  final VoidCallback onTap;

  const TopicPillItem({
    super.key,
    required this.topic,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _buildTopicPillItem(context);
  }

  Widget _buildTopicPillItem(
    BuildContext context,
  ) {
    final contentColor = isSelected
        ? context.appColors.contentPrimary
        : context.appColors.contentSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s8.w,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColors.borderCard
              : context.appColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadius.rFull),
          border: Border.all(
            color: isSelected
                ? context.appColors.borderPrimary
                : context.appColors.borderSecondary,
          ),
        ),
        child: Center(
          child: InlineIconLabel(
            text: AppText.captionSmall(
              topic.toUpperCase(),
              textAlign: TextAlign.center,
              color: contentColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            horizontalGap: AppSpacing.s4.w,
          ),
        ),
      ),
    );
  }
}
