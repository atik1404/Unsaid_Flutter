import 'package:create_post/src/state/create_post_bloc.dart';
import 'package:create_post/src/state/create_post_state.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:ui/ui.dart';

class TopicSelector extends StatefulWidget {
  const TopicSelector({super.key});

  @override
  State<TopicSelector> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  /// How many topics to show before the list is expanded.
  static const _collapsedCount = 5;

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      //buildWhen: (prev, curr) => prev.selectedTopic != curr.selectedTopic,
      builder: (context, state) {
        final topics = state.topics;
        final hasMore = topics.length > _collapsedCount;
        final visibleCount = _expanded || !hasMore ? topics.length : _collapsedCount;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppSpacing.s8.w,
                crossAxisSpacing: AppSpacing.s8.w,
                childAspectRatio: 3.5,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleCount,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return TopicPillItem(
                  topic: topic.name,
                  isSelected: topic.id == state.selectedTopic,
                  onTap: () => context.read<CreatePostBloc>().add(TopicSelected(topic.id)),
                );
              },
            ),
            if (hasMore)
              AppTextButton(
                _expanded ? context.l10n.create_post_topics_show_less : context.l10n.create_post_topics_show_more,
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
          ],
        );
      },
    );
  }
}
