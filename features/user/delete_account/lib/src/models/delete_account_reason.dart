import 'package:flutter/widgets.dart';
import 'package:localization/localization.dart';

/// Predefined reasons a user can pick when deleting their account.
///
/// [apiKey] is the stable machine value sent to the backend as churn feedback —
/// it must never change once shipped. The human-readable label is resolved
/// separately via [labelOf] so it stays localized.
enum DeleteAccountReason {
  noLongerUse('no_longer_use'),
  privacyConcerns('privacy_concerns'),
  betterAlternative('better_alternative'),
  technicalIssues('technical_issues'),
  other('other');

  const DeleteAccountReason(this.apiKey);

  /// Stable identifier transmitted to the API. Not localized.
  final String apiKey;

  /// Whether this reason requires the free-text "details" field to be filled.
  bool get requiresDetails => this == DeleteAccountReason.other;
}

/// Localized label for each reason, kept as an extension so the enum stays free
/// of presentation concerns.
extension DeleteAccountReasonL10n on DeleteAccountReason {
  String label(BuildContext context) => switch (this) {
    DeleteAccountReason.noLongerUse => context.l10n.delete_account_reason_no_longer_use,
    DeleteAccountReason.privacyConcerns => context.l10n.delete_account_reason_privacy,
    DeleteAccountReason.betterAlternative => context.l10n.delete_account_reason_better_alternative,
    DeleteAccountReason.technicalIssues => context.l10n.delete_account_reason_technical,
    DeleteAccountReason.other => context.l10n.delete_account_reason_other,
  };
}
