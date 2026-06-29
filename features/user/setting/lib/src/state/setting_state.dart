import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_state.freezed.dart';

/// Holds the current state of the Settings screen.
///
/// [fullname], [phone] and [avatarUrl] feed the profile summary card, while
/// the boolean flags back the privacy/notification toggle rows. Keeping the
/// toggles here (instead of local widget state) lets each row rebuild in
/// isolation through a narrowly-scoped `BlocSelector`.
@freezed
abstract class SettingState with _$SettingState {
  const factory SettingState({
    @Default('') String fullname,
    @Default('') String phone,
    @Default('') String avatarUrl,
    @Default(true) bool allowAnonymousDms,
    @Default(true) bool ghostMode,
    @Default(true) bool pushNotifications,
    @Default(true) bool soundEnabled,
  }) = _SettingState;
}
