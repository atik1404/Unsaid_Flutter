import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:home/src/state/home_event.dart';
import 'package:home/src/widgets/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/state/home_bloc.dart';
import 'package:home/src/state/home_state.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:ui/ui.dart';

/// Main feed screen showing a paginated list of posts filtered by mood.
///
/// Listens to scroll position to trigger pagination via [HomeBloc],
/// and renders a sticky mood-filter row above the post list.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<HomeBloc>().add(const LoadPostsEvent());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Fires [LoadPostsEvent] when the user scrolls near the bottom of the list.
  void _onScroll() {
    if (_isBottom) {
      context.read<HomeBloc>().add(const LoadPostsEvent());
    }
  }

  /// Returns true when the scroll position is within 90 % of the max extent.
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16.w),
      appBar: AppTopBar(
        showBackButton: false,
        backgroundColor: context.scaffoldTheme.backgroundColor,
        titleWidget: AppText.headlineSmall(
          context.l10n.splash_brand_name,
          color: context.appColors.contentBrand,
          textWeight: AppTextWeight.extraBold,
        ),
        foregroundColor: context.appColors.contentTertiary,
        actionSpacing: AppSpacing.s16.w,
        trailingPadding: AppSpacing.s16.w,
        actions: [
          AppIconButton(
            const AppIcon(Icon(CupertinoIcons.layers)),
            onPressed: () {},
          ),
          AppIconButton(
            const AppIcon(Icon(CupertinoIcons.bell)),
            onPressed: () => context.pushNamed(AppRouteName.notificationScreen),
          ),
          AppIconButton(
            const AppIcon(Icon(CupertinoIcons.settings)),
            onPressed: () => context.pushNamed(AppRouteName.settingScreen),
          ),
        ],
      ),
      body: Column(
        children: [
          const _MoodListHorizontalView(),
          SizedBox(height: AppSpacing.s16.h),
          Expanded(child: _PostListView(scrollController: _scrollController)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRouteName.createPostScreen),
        shape: const CircleBorder(),
        backgroundColor: context.appColors.contentBrand,
        child: Icon(CupertinoIcons.add, color: context.appColors.white),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private widgets
// ---------------------------------------------------------------------------

/// Horizontal scrollable row of mood-filter pills.
///
/// Reads [HomeBloc] from context and dispatches [SelectMoodEvent] on tap.
class _MoodListHorizontalView extends StatelessWidget {
  const _MoodListHorizontalView();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, MoodType>(
      selector: (state) => state.mood,
      builder: (context, selectedMood) {
        return SizedBox(
          height: AppSpacing.s24.h,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: MoodType.values.length,
            itemBuilder: (context, index) {
              final moodType = MoodType.values[index];
              return MoodPillItem(
                mood: moodType.name,
                isSelected: moodType == selectedMood,
                onTap: () => context.read<HomeBloc>().add(SelectMoodEvent(moodType)),
              );
            },
          ),
        );
      },
    );
  }
}

/// Paginated list of [PostCard]s driven by [HomeBloc].
///
/// Shows a loading indicator at the bottom while fetching the next page,
/// and an empty-state message when no posts are available.
class _PostListView extends StatelessWidget {
  final ScrollController scrollController;

  const _PostListView({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.posts.isEmpty && state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.posts.isEmpty) {
          return Center(
            child: AppText.bodyLarge(
              textAlign: TextAlign.center,
              'No posts found. Try selecting a different mood filter!',
              color: context.appColors.contentError,
            ),
          );
        }

        return ListView.separated(
          controller: scrollController,
          itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.s16.h),
          itemBuilder: (context, index) {
            if (index >= state.posts.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return PostCard(
              post: state.posts[index],
              onTap: () => context.pushNamed(AppRouteName.postDetailsScreen, extra: state.posts[index].id),
              onReact: () {
                if (state.posts[index].isReacted) {
                  context.read<HomeBloc>().add(RemoveReactEvent(state.posts[index].id));
                } else {
                  context.read<HomeBloc>().add(AddReactEvent(state.posts[index].id));
                }
              },
            );
          },
        );
      },
    );
  }
}
