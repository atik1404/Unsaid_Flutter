import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home/src/widgets/category_list.dart';
import 'package:home/src/widgets/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/state/home_cubit.dart';
import 'package:home/src/state/home_state.dart';
import 'package:localization/localization.dart';

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
    context.read<HomeCubit>().loadPosts();
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
      context.read<HomeCubit>().loadPosts();
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
        centerTitle: false,
        backgroundColor: context.scaffoldTheme.backgroundColor,
        titleWidget: AppText.displaySmall(
          context.l10n.splash_brand_name,
          color: context.colorScheme.contentBrand,
        ),
        foregroundColor: context.colorScheme.contentTertiary,
        actionSpacing: AppSpacing.s16.w,
        actions: [
          AppIconButton(
            const AppIcon(
              Icon(CupertinoIcons.search),
            ),
            onPressed: () {},
          ),
          AppIconButton(const AppIcon(Icon(CupertinoIcons.bell)), onPressed: () {}),
          AppIconButton(const AppIcon(Icon(CupertinoIcons.chat_bubble)), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          CategoryList(),
          SizedBox(height: AppSpacing.s16.h),
          Expanded(child: _buildPostList()),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
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
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.s16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final post = state.posts[index];
            return PostCard(post: post);
          },
        );
      },
    );
  }
}
