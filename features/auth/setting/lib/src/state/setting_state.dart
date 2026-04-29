import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_state.freezed.dart';

/// Holds the current state of the Settings screen.
///
/// [userName] and [userEmail] are used by the profile summary card,
/// while [isLoading] gates the initial data fetch.
@freezed
abstract class SettingState with _$SettingState {
  const factory SettingState({
    @Default('') String userName,
    @Default('') String userEmail,
    @Default('') String avatarUrl,
    @Default(false) bool isLoading,
  }) = _SettingState;
}
