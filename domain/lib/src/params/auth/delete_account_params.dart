import 'package:json_annotation/json_annotation.dart';

part 'delete_account_params.g.dart';

/// Request payload for the `DELETE /profile` (delete account) endpoint.
///
/// Carries the reason the user selected for leaving so the backend can capture
/// churn feedback. [reason] is a stable machine key (e.g. `no_longer_use`) and
/// [details] holds the free-text explanation supplied when the user picks the
/// "Other" reason. [details] is omitted from the payload when empty.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class DeleteAccountParams {
  final String reason;
  final String? details;

  const DeleteAccountParams({
    required this.reason,
    this.details,
  });

  Map<String, dynamic> toJson() => _$DeleteAccountParamsToJson(this);
}
