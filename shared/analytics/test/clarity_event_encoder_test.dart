import 'package:analytics/src/clarity_event_encoder.dart';
import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the one piece of the Clarity integration that carries real logic:
/// turning an [AnalyticsEvent] into a string the SDK will actually accept.
/// Clarity silently drops values that break its limits, so a regression here
/// would show up as quietly missing dashboard data rather than a failure.
void main() {
  group('ClarityEventEncoder.encode', () {
    test('encodes a bare event as its name', () {
      expect(
        ClarityEventEncoder.encode(const BusinessEvent('logout')),
        'logout',
      );
    });

    test('appends parameters as pipe-separated key=value pairs', () {
      final encoded = ClarityEventEncoder.encode(
        const BusinessEvent(
          'login_failure',
          parameters: {'reason': 'bad_credentials'},
        ),
      );

      expect(encoded, 'login_failure|reason=bad_credentials');
    });

    test('skips null parameter values', () {
      final encoded = ClarityEventEncoder.encode(
        const BusinessEvent(
          'post_create_success',
          parameters: {'mood': null, 'topic': 'work'},
        ),
      );

      expect(encoded, 'post_create_success|topic=work');
    });

    test('never exceeds the SDK custom-event limit', () {
      final encoded = ClarityEventEncoder.encode(
        BusinessEvent(
          'some_event',
          parameters: {
            for (var i = 0; i < 50; i++) 'key$i': 'value' * 20,
          },
        ),
      );

      expect(encoded, isNotNull);
      expect(
        encoded!.length,
        lessThanOrEqualTo(ClarityLimits.customEventMaxLength),
      );
      // Truncation drops whole pairs — a half-written pair would be unfilterable.
      expect(encoded.endsWith('='), isFalse);
    });

    test('neutralises delimiters and newlines so pairs cannot be forged', () {
      final encoded = ClarityEventEncoder.encode(
        const BusinessEvent(
          'login_failure',
          parameters: {'reason': 'line one\nline|two'},
        ),
      );

      // Newlines collapse to a space; the pipe delimiter becomes a slash.
      expect(encoded, 'login_failure|reason=line one line/two');
    });

    test('returns null for a blank event name', () {
      expect(ClarityEventEncoder.encode(const BusinessEvent('   ')), isNull);
    });
  });

  group('ClarityEventEncoder.encodeScreenName', () {
    test('passes a normal screen name through', () {
      expect(ClarityEventEncoder.encodeScreenName('homeScreen'), 'homeScreen');
    });

    test('returns null when blank, which the SDK would reject', () {
      expect(ClarityEventEncoder.encodeScreenName('   '), isNull);
    });

    test('clips to the SDK limit', () {
      final encoded = ClarityEventEncoder.encodeScreenName('a' * 400);

      expect(encoded, hasLength(ClarityLimits.screenNameMaxLength));
    });
  });

  group('ClarityEventEncoder.encodeTag', () {
    test('trims surrounding whitespace', () {
      expect(ClarityEventEncoder.encodeTag('  prod  '), 'prod');
    });

    test('returns null when blank', () {
      expect(ClarityEventEncoder.encodeTag(''), isNull);
    });

    test('clips to the SDK limit', () {
      expect(
        ClarityEventEncoder.encodeTag('x' * 500),
        hasLength(ClarityLimits.customTagMaxLength),
      );
    });
  });
}
