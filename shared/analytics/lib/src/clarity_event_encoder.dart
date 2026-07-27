import 'package:common/common.dart';

/// ---------------------------------------------------------------------------
/// Hard limits enforced by the Clarity SDK.
///
/// The SDK **silently drops** any value that exceeds these bounds (it only logs
/// at its own log level, which we keep at [LogLevel.None]), so every string we
/// hand to Clarity is normalised here first. Keeping the numbers in one place
/// means a future SDK change is a one-line edit.
/// ---------------------------------------------------------------------------
abstract final class ClarityLimits {
  const ClarityLimits._();

  /// `Clarity.sendCustomEvent` — max 254 characters, non-blank.
  static const int customEventMaxLength = 254;

  /// `Clarity.setCustomTag` / `setCustomUserId` — max 255 characters per
  /// key and per value, non-blank.
  static const int customTagMaxLength = 255;

  /// `Clarity.setCurrentScreenName` — max 255 characters, non-blank.
  static const int screenNameMaxLength = 255;
}

/// ---------------------------------------------------------------------------
/// Turns a vendor-neutral [AnalyticsEvent] into the single string Clarity
/// accepts as a custom event.
///
/// ## Why parameters are encoded into the event name
///
/// Clarity has no per-event property bag. Its `setCustomTag` API is
/// **session-scoped**: a tag set once stays attached to the whole recording and
/// is overwritten by the next call with the same key. Pushing per-event
/// parameters through tags would therefore (a) lose all but the last value and
/// (b) leave the session tagged with an unrelated event's context.
///
/// So event context is folded into the event string instead, which Clarity logs
/// individually with a timestamp and exposes as a filterable dimension:
///
/// ```text
///   login_failure|reason=invalid_credentials
///   post_reacted|post=abc123|reaction=add
/// ```
///
/// Session-scoped dimensions that genuinely describe the *user or build*
/// (flavor, build variant, locale) still belong in `setCustomTag` — see
/// [AnalyticsTracker.setCustomTag].
/// ---------------------------------------------------------------------------
abstract final class ClarityEventEncoder {
  const ClarityEventEncoder._();

  /// Separates the event name from each `key=value` pair.
  static const String _pairSeparator = '|';

  /// Longest a single parameter value may be before it is clipped, so that one
  /// verbose value (e.g. a server error message) cannot consume the whole
  /// 254-character budget and crowd out the parameters after it.
  static const int _maxValueLength = 60;

  /// Encodes [event] into a Clarity custom-event string, or returns `null` when
  /// the event carries no usable name (nothing is sent in that case).
  static String? encode(AnalyticsEvent event) {
    final name = _sanitize(event.name);
    if (name.isEmpty) return null;

    final buffer = StringBuffer(name);

    for (final entry in event.parameters.entries) {
      final value = entry.value;
      if (value == null) continue;

      final key = _sanitize(entry.key);
      final encodedValue = _clip(_sanitize(value.toString()), _maxValueLength);
      if (key.isEmpty || encodedValue.isEmpty) continue;

      final pair = '$_pairSeparator$key=$encodedValue';

      // Append only while the whole string stays within Clarity's limit —
      // a truncated tail would produce a corrupt, unfilterable pair.
      if (buffer.length + pair.length > ClarityLimits.customEventMaxLength) {
        break;
      }
      buffer.write(pair);
    }

    return buffer.toString();
  }

  /// Normalises a screen name for `Clarity.setCurrentScreenName`, or returns
  /// `null` when it is blank (which the SDK rejects).
  static String? encodeScreenName(String screenName) {
    final sanitized = _clip(
      _sanitize(screenName),
      ClarityLimits.screenNameMaxLength,
    );
    return sanitized.isEmpty ? null : sanitized;
  }

  /// Normalises a custom-tag key or value, or returns `null` when it is blank.
  static String? encodeTag(String value) {
    final sanitized = _clip(
      _sanitize(value),
      ClarityLimits.customTagMaxLength,
    );
    return sanitized.isEmpty ? null : sanitized;
  }

  /// Collapses newlines/tabs and neutralises the delimiter characters, so a
  /// value can never forge an extra `key=value` pair or break dashboard
  /// grouping. Also trims — Clarity rejects whitespace-only strings.
  static String _sanitize(String raw) =>
      raw.replaceAll(RegExp(r'[\r\n\t]+'), ' ').replaceAll('|', '/').trim();

  /// Clips to [max] characters without leaving a trailing space.
  static String _clip(String value, int max) =>
      value.length <= max ? value : value.substring(0, max).trimRight();
}
