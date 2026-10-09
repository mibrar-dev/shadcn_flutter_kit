// Tests for the error-domain strings of `ShadcnLocalizations`.
//
// These getters are English fallbacks: no Flutter ARB file carries the
// strings, so nothing is copied (or invented) into the locale tables. The
// dismiss label is the one exception - it reuses `dialogDismiss`, Flutter's
// translated `modalBarrierDismissLabel`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/localizations_de.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ShadcnLocalizations english = ShadcnLocalizations.english;

  group('English defaults', () {
    test('default title and message', () {
      expect(english.errorSomethingWentWrong, 'Something went wrong');
      expect(
        english.errorUnexpectedMessage,
        'Please try again or contact support if the issue persists.',
      );
    });

    test('action labels', () {
      expect(english.errorActionRetry, 'Retry');
      expect(english.errorActionReport, 'Report');
      expect(english.errorActionBack, 'Go Back');
      expect(english.errorActionLogin, 'Log In');
      expect(english.errorActionSettings, 'Settings');
      expect(english.errorActionContactSupport, 'Contact Support');
      expect(english.dialogDismiss, 'Dismiss');
    });

    test('HTTP status titles and messages', () {
      expect(english.errorBadRequest, 'Bad request');
      expect(
        english.errorBadRequestMessage,
        'The request was invalid. Please review and try again.',
      );
      expect(english.errorUnauthorized, 'Unauthorized');
      expect(english.errorLoginRequiredMessage, 'Please log in to continue.');
      expect(english.errorAccessDenied, 'Access denied');
      expect(
        english.errorAccessDeniedMessage,
        'You do not have permission to perform this action.',
      );
      expect(english.errorNotFound, 'Not found');
      expect(
        english.errorNotFoundMessage,
        'We couldn\u2019t find what you were looking for.',
      );
      expect(english.errorConflict, 'Conflict');
      expect(
        english.errorConflictMessage,
        'This action conflicts with existing data.',
      );
      expect(english.errorInvalidData, 'Invalid data');
      expect(
        english.errorInvalidDataMessage,
        'Some fields need your attention.',
      );
      expect(english.errorTooManyRequests, 'Too many requests');
      expect(
        english.errorTooManyRequestsMessage,
        'Please wait a moment and try again.',
      );
      expect(english.errorServerError, 'Server error');
      expect(
        english.errorServerErrorMessage,
        'The server encountered a problem. Please try again.',
      );
    });

    test('auth, validation and platform titles and messages', () {
      expect(english.errorRequestTimedOut, 'Request timed out');
      expect(
        english.errorRequestTimedOutMessage,
        'The server is taking too long to respond.',
      );
      expect(english.errorAuthenticationRequired, 'Authentication required');
      expect(english.errorInvalidInput, 'Invalid input');
      expect(
        english.errorReviewFieldsMessage,
        'Please review the highlighted fields.',
      );
      expect(english.errorPlatformError, 'Platform error');
      expect(
        english.errorDeviceErrorMessage,
        'Something went wrong on this device.',
      );
    });

    test('network titles and messages', () {
      expect(english.errorConnectionFailed, 'Connection failed');
      expect(
        english.errorConnectionFailedMessage,
        'Check your internet connection and try again.',
      );
      expect(english.errorSecureConnectionFailed, 'Secure connection failed');
      expect(
        english.errorSecureConnectionMessage,
        'We could not establish a secure connection.',
      );
    });
  });

  group('translated tables', () {
    test('error strings fall back to English (no invented translations)', () {
      const ShadcnLocalizationsDe german = ShadcnLocalizationsDe();
      expect(german.errorSomethingWentWrong, 'Something went wrong');
      expect(german.errorActionRetry, 'Retry');
      expect(german.errorServerError, 'Server error');
      expect(
        german.errorServerErrorMessage,
        'The server encountered a problem. Please try again.',
      );
      // The dismiss label is Flutter's translated `modalBarrierDismissLabel`.
      expect(german.dialogDismiss, 'Schließen');
    });

    test('a locale table may override any error getter', () {
      const _Translated italian = _Translated();
      expect(italian.errorActionRetry, 'Riprova');
      expect(italian.errorSomethingWentWrong, 'Ops');
      expect(italian.dialogDismiss, 'Chiudi');
    });
  });
}

class _Translated extends ShadcnLocalizations {
  const _Translated() : super(const Locale('it'));

  @override
  String get errorActionRetry => 'Riprova';

  @override
  String get errorSomethingWentWrong => 'Ops';

  @override
  String get dialogDismiss => 'Chiudi';
}
