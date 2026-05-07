import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home/src/widgets/post_card.dart';
import 'package:localization/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/state/home_cubit.dart';
import 'package:home/src/state/home_state.dart';

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
      appBar: AppTopBar(
        onBackPressed: () {},
        titleWidget: AppText.titleMedium(
          context.l10n.home_title,
          textWeight: AppTextWeight.extraBold,
        ),
        leading: const AppIcon(Icon(Icons.menu)),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.posts.isEmpty && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.posts.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          return ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.all(AppSpacing.s16.r),
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
      ),
    );
  }
}
