import 'package:flutter/material.dart';
import 'package:designsystem/designsystem.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

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
        elevation: 0,
      ),
      body: Center(
        child: AppText.bodyMedium('This is the Create Post Screen'),
      ),
    );
  }
}
