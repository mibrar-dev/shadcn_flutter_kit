// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// AppErrorCode: enum categorizing error types (network/auth/validation/etc.).
// Used by rules for mapping and by UI for severity styling (icons/borders/colors).

/// AppErrorCode enumerates fixed values used by this implementation.
enum AppErrorCode {
  network,
  timeout,
  noInternet,
  sslError,
  unauthorized,
  forbidden,
  sessionExpired,
  invalidCredentials,
  notFound,
  conflict,
  validation,
  rateLimited,
  server,
  badRequest,
  cancelled,
  invalidInput,
  platformError,
  permissionDenied,
  unknown,
}
