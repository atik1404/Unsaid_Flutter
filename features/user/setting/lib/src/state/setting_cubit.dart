import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:setting/src/state/setting_state.dart';

/// Manages the state for the Settings screen.
///
/// On creation, [loadUserProfile] fetches (simulated) user data
/// so the profile summary card can display the current user's info.
class SettingCubit extends Cubit<SettingState> {
  final AppPrefStorage _prefStorage;

  SettingCubit({required AppPrefStorage prefStorage}) : _prefStorage = prefStorage, super(const SettingState());

  /// Loads the current user's profile summary.
  ///
  /// In a real app this would call a repository; here we simulate
  /// the fetch with a short delay.
  void loadUserProfile() async {
    final name = await _prefStorage.getString(PrefKey.anonymousName);
    final avatar = await _prefStorage.getString(PrefKey.profilePicture);
    final phone = await _prefStorage.getString(PrefKey.phoneNumber);
    emit(
      state.copyWith(
        fullname: name,
        phone: phone,
        avatarUrl: avatar,
      ),
    );
  }
}
