import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguagePillToggle extends StatelessWidget {
  const LanguagePillToggle({super.key, required this.isEnglish, required this.onToggle});

  final bool isEnglish;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: AppSpacing.s32.h,
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppRadius.r8.r),
        border: Border.all(color: colors.borderPrimary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPillSegment(
            label: 'EN',
            selected: isEnglish,
            colors: colors,
            onTap: () => onToggle(true),
          ),
          _buildPillSegment(
            label: 'BN',
            selected: !isEnglish,
            colors: colors,
            onTap: () => onToggle(false),
          ),
        ],
      ),
    );
  }

  Widget _buildPillSegment({required String label, required bool selected, required AppColorScheme colors, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8.w, vertical: AppSpacing.s8.h),
        decoration: BoxDecoration(
          color: selected ? colors.brand : colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadius.r8.r),
        ),
        child: AppText.captionSmall(
          label,
          color: selected ? colors.white : colors.contentSecondary,
          textWeight: selected ? AppTextWeight.semiBold : AppTextWeight.regular,
        ),
      ),
    );
  }
}
