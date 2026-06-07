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

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeBloc>().add(const LoadPostsEvent());
    }
  }

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
            const AppIcon(
              Icon(CupertinoIcons.search),
            ),
            onPressed: () {},
          ),
          AppIconButton(
            const AppIcon(Icon(CupertinoIcons.bell)),
            onPressed: () {
              context.pushNamed(AppRouteName.notificationScreen);
            },
          ),
          AppIconButton(
            const AppIcon(Icon(CupertinoIcons.settings)),
            onPressed: () {
              context.pushNamed(AppRouteName.settingScreen);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMoodList(),
          SizedBox(height: AppSpacing.s16.h),
          Expanded(child: _buildPostList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRouteName.createPostScreen);
        },
        shape: const CircleBorder(),
        backgroundColor: context.appColors.contentBrand,
        child: Icon(CupertinoIcons.add, color: context.appColors.white),
      ),
    );
  }

  Widget _buildPostList() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        AppLog.log('HomeState: ${state.posts.length} posts, isLoading: ${state.isLoading}, hasReachedMax: ${state.hasReachedMax}');
        if (state.posts.isEmpty && state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.posts.isEmpty) {
          return Center(child: Text(context.l10n.home_no_posts_available));
        }

        return ListView.separated(
          controller: _scrollController,
          itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
          separatorBuilder: (context, index) => SizedBox(height: AppSpacing.s16.h),
          itemBuilder: (context, index) {
            if (index >= state.posts.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final post = state.posts[index];
            return PostCard(
              post: post,
              onTap: () {
                context.pushNamed(AppRouteName.postDetailsScreen);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMoodList() {
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
                onTap: () {
                  context.read<HomeBloc>().add(SelectMoodEvent(moodType));
                },
              );
            },
          ),
        );
      },
    );
  }
}
