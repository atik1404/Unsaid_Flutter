import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/src/state/profile_post_model.dart';
import 'package:profile/src/state/profile_state.dart';

/// Manages the state for the Profile screen.
///
/// Loads the user's personal information and their own posts.
/// In production this would delegate to a repository; here we use
/// simulated data so the UI can be verified independently.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  /// Fetches the profile owner's data and their posts.
  void loadProfile() async {
    emit(state.copyWith(isLoading: true));

    // Simulate a network call
    await Future.delayed(const Duration(milliseconds: 600));

    final posts = List.generate(
      5,
      (index) => ProfilePostModel(
        id: 'profile_$index',
        title: 'My Post ${index + 1}',
        dateTime: DateTime.now().subtract(Duration(days: index * 2)),
        description:
            'This is a description for my post ${index + 1}. '
            'It shares thoughts and ideas about everyday topics.',
        tag: 'Personal',
      ),
    );

    emit(
      state.copyWith(
        isLoading: false,
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1 234 567 890',
        bio: 'Flutter developer | Open-source enthusiast',
        avatarUrl: '',
        posts: posts,
      ),
    );
  }
}
