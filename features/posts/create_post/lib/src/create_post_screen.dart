import 'package:flutter/material.dart';
import 'package:designsystem/designsystem.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      appBar: AppTopBar(
        titleWidget: AppText.displaySmall('Create Post'),
      ),
      body: Center(
        child: AppText.bodyMedium('This is the Create Post Screen'),
      ),
    );
  }
}
