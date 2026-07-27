import 'package:common/common.dart';
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
  final AnalyticsTracker _analytics;

  SettingCubit({required this._prefStorage, required this._analytics})
    : super(const SettingState());

  /// Emits a single `setting_toggled` event carrying which preference changed
  /// and its new value, so every switch on the screen is tracked consistently
  /// without one event name per toggle.
  void _trackToggle(String setting, {required bool value}) {
    _analytics.logEvent(
      BusinessEvent(
        AnalyticsEventName.settingToggled,
        parameters: {'setting': setting, 'value': value},
      ),
    );
  }

  /// Loads the current user's profile summary from persistent storage.
  void loadUserProfile() {
    final name = _prefStorage.getString(PrefKey.anonymousName);
    final avatar = _prefStorage.getString(PrefKey.profilePicture);
    final phone = _prefStorage.getString(PrefKey.phoneNumber);
    final isNotificationEnable = _prefStorage.getBoolean(
      PrefKey.appNotification,
    );
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
    _trackToggle('push_notifications', value: value);
    emit(state.copyWith(pushNotifications: value));
  }

  /// Toggles in-app notification sounds.
  void setSoundEnabled({required bool value}) {
    _prefStorage.write(PrefKey.appNotificationSound, value);
    _trackToggle('notification_sound', value: value);
    emit(state.copyWith(soundEnabled: value));
  }
}
