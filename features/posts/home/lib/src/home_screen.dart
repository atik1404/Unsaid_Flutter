import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home/src/state/post_model.dart';
import 'package:localization/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/state/home_cubit.dart';
import 'package:home/src/state/home_state.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadPosts(),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
      appBar: AppBar(
        title: AppText.titleMedium(
          context.l10n.home_title,
          textWeight: AppTextWeight.extraBold,
        ),
        backgroundColor: context.colorScheme.backgroundBrand,
        elevation: 0,
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
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final post = state.posts[index];
              return _PostCard(post: post);
            },
          );
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostModel post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.s16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText.titleSmall(
                  post.title,
                  textWeight: AppTextWeight.bold,
                ),
              ),
              AppText.labelSmall(
                DateFormat('MMM dd, yyyy - hh:mm a').format(post.dateTime),
                color: context.colorScheme.contentInfo,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.s8.h),
          AppText.bodyMedium(
            post.description,
            color: context.colorScheme.contentPrimary,
          ),
          SizedBox(height: AppSpacing.s12.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s12.w,
              vertical: AppSpacing.s4.h,
            ),
            decoration: BoxDecoration(
              color: context.colorScheme.borderBrand.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.s8.r),
            ),
            child: AppText.labelSmall(
              post.tag,
              color: context.colorScheme.contentPrimary,
              textWeight: AppTextWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
