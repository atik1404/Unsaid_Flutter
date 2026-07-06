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

  SettingCubit({required this._prefStorage}) : super(const SettingState());

  /// Loads the current user's profile summary from persistent storage.
  void loadUserProfile() {
    final name = _prefStorage.getString(PrefKey.anonymousName);
    final avatar = _prefStorage.getString(PrefKey.profilePicture);
    final phone = _prefStorage.getString(PrefKey.phoneNumber);
    final isNotificationEnable = _prefStorage.getBoolean(PrefKey.appNotification);
    final isSoundEnable = _prefStorage.getBoolean(PrefKey.appNotificationSound);
    emit(
      state.copyWith(
        fullname: name,
        phone: phone,
        avatarUrl: avatar,
        pushNotifications: isNotificationEnable,
        soundEnabled: isSoundEnable,
      ),
    );
  }

  /// Toggles push notifications.
  void setPushNotifications({required bool value}) {
    _prefStorage.write(PrefKey.appNotification, value);
    emit(state.copyWith(pushNotifications: value));
  }

  /// Toggles in-app notification sounds.
  void setSoundEnabled({required bool value}) {
    _prefStorage.write(PrefKey.appNotificationSound, value);
    emit(state.copyWith(soundEnabled: value));
  }
}
