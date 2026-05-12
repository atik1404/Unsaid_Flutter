import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setting/src/state/setting_state.dart';

/// Manages the state for the Settings screen.
///
/// On creation, [loadUserProfile] fetches (simulated) user data
/// so the profile summary card can display the current user's info.
class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(const SettingState());

  /// Loads the current user's profile summary.
  ///
  /// In a real app this would call a repository; here we simulate
  /// the fetch with a short delay.
  void loadUserProfile() {
    emit(
      state.copyWith(
        isLoading: false,
        userName: 'Atik Faysal',
        userEmail: 'atik.faysal@example.com',
        avatarUrl: '',
      ),
    );
  }
}
