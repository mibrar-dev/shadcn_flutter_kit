// Error-system strings for [ShadcnLocalizations]: the `error_handling`
// primitive's default titles, messages and action labels, and the
// `error_system` component's dismissal affordance.
//
// None of these strings exist in Flutter's `flutter_localizations` ARB files,
// so they stay English fallbacks: a locale table may override any of them, but
// nothing is copied (or invented) here. `dialogDismiss` (the overlay mixin,
// Flutter's `modalBarrierDismissLabel`) is reused for dismiss actions.

/// Error text for [ShadcnLocalizations].
///
/// Applied by `ShadcnLocalizations`; every getter has an English default and
/// translated locale tables may override it.
mixin ShadcnLocalizationsError {
  /// Default title of an error with no more specific mapping.
  String get errorSomethingWentWrong => 'Something went wrong';

  /// Default message of an error with no more specific mapping.
  String get errorUnexpectedMessage =>
      'Please try again or contact support if the issue persists.';

  /// Label of a retry action.
  String get errorActionRetry => 'Retry';

  /// Label of a report action.
  String get errorActionReport => 'Report';

  /// Label of a navigate-back action.
  String get errorActionBack => 'Go Back';

  /// Label of a log-in action.
  String get errorActionLogin => 'Log In';

  /// Label of an open-settings action.
  String get errorActionSettings => 'Settings';

  /// Label of a contact-support action.
  String get errorActionContactSupport => 'Contact Support';

  /// Title for HTTP 400.
  String get errorBadRequest => 'Bad request';

  /// Message for HTTP 400.
  String get errorBadRequestMessage =>
      'The request was invalid. Please review and try again.';

  /// Title for HTTP 401.
  String get errorUnauthorized => 'Unauthorized';

  /// Message for HTTP 401 and for auth failures.
  String get errorLoginRequiredMessage => 'Please log in to continue.';

  /// Title for HTTP 403.
  String get errorAccessDenied => 'Access denied';

  /// Message for HTTP 403.
  String get errorAccessDeniedMessage =>
      'You do not have permission to perform this action.';

  /// Title for HTTP 404.
  String get errorNotFound => 'Not found';

  /// Message for HTTP 404.
  String get errorNotFoundMessage =>
      'We couldn\u2019t find what you were looking for.';

  /// Title for HTTP 409.
  String get errorConflict => 'Conflict';

  /// Message for HTTP 409.
  String get errorConflictMessage =>
      'This action conflicts with existing data.';

  /// Title for HTTP 422.
  String get errorInvalidData => 'Invalid data';

  /// Message for HTTP 422.
  String get errorInvalidDataMessage => 'Some fields need your attention.';

  /// Title for HTTP 429.
  String get errorTooManyRequests => 'Too many requests';

  /// Message for HTTP 429.
  String get errorTooManyRequestsMessage =>
      'Please wait a moment and try again.';

  /// Title for HTTP 5xx and other server failures.
  String get errorServerError => 'Server error';

  /// Message for HTTP 5xx and other server failures.
  String get errorServerErrorMessage =>
      'The server encountered a problem. Please try again.';

  /// Title of a timed-out request.
  String get errorRequestTimedOut => 'Request timed out';

  /// Message of a timed-out request.
  String get errorRequestTimedOutMessage =>
      'The server is taking too long to respond.';

  /// Title of an authentication failure.
  String get errorAuthenticationRequired => 'Authentication required';

  /// Title of a validation failure.
  String get errorInvalidInput => 'Invalid input';

  /// Message of a validation failure.
  String get errorReviewFieldsMessage =>
      'Please review the highlighted fields.';

  /// Title of a platform-channel failure.
  String get errorPlatformError => 'Platform error';

  /// Message of a platform-channel failure.
  String get errorDeviceErrorMessage => 'Something went wrong on this device.';

  /// Title of a connection failure.
  String get errorConnectionFailed => 'Connection failed';

  /// Message of a connection failure.
  String get errorConnectionFailedMessage =>
      'Check your internet connection and try again.';

  /// Title of a secure-connection failure.
  String get errorSecureConnectionFailed => 'Secure connection failed';

  /// Message of a secure-connection failure.
  String get errorSecureConnectionMessage =>
      'We could not establish a secure connection.';
}
