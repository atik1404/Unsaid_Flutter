import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:setting/src/state/setting_state.dart';

/// Manages the state for the Settings screen.
///
/// On creation, [loadUserProfile] hydrates the profile summary card from
/// persisted user data. The toggle handlers below flip individual privacy and
/// notification flags; each emits a fresh state so only the affected row
/// rebuilds via its `BlocSelector`.
class SettingCubit extends Cubit<SettingState> {
  final AppPrefStorage _prefStorage;

  SettingCubit({required AppPrefStorage prefStorage}) : _prefStorage = prefStorage, super(const SettingState());

  /// Loads the current user's profile summary from persistent storage.
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

  /// Toggles whether strangers are allowed to send anonymous DMs.
  void setAllowAnonymousDms({required bool value}) => emit(state.copyWith(allowAnonymousDms: value));

  /// Toggles ghost mode, which hides the user's online status.
  void setGhostMode({required bool value}) => emit(state.copyWith(ghostMode: value));

  /// Toggles push notifications.
  void setPushNotifications({required bool value}) => emit(state.copyWith(pushNotifications: value));

  /// Toggles in-app notification sounds.
  void setSoundEnabled({required bool value}) => emit(state.copyWith(soundEnabled: value));
}
