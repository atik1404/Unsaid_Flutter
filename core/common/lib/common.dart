export 'src/extensions/integer_extension.dart';
export 'src/extensions/number_extension.dart';
export 'src/extensions/string_extension.dart';
export 'src/utils/app_log.dart';
export 'src/constants/app_constants.dart';
export 'src/result/failure.dart';
export 'src/result/failure_message.dart';
export 'src/result/result.dart';
export 'src/enums/failure_key.dart';
export 'src/enums/mood_type.dart';
export 'src/extensions/date_time_extension.dart';

// Vendor-agnostic telemetry contracts (analytics + crash reporting). Features
// depend on these interfaces; the Clarity/Sentry implementations live in the
// `analytics` / `monitoring` packages.
export 'src/telemetry/analytics_event.dart';
export 'src/telemetry/analytics_tracker.dart';
export 'src/telemetry/analytics_session_extension.dart';
export 'src/telemetry/crash_reporter.dart';

export 'src/enums/validation_error.dart';
export 'src/validators/password_input_validator.dart';
export 'src/validators/phone_input_validator.dart';
export 'src/validators/email_input_validator.dart';
export 'src/validators/name_input_validator.dart';
export 'src/validators/bio_input_validator.dart';
